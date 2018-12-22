#!/bin/bash

tmp_conf=$(mktemp)
cat <<-EOF >"$tmp_conf"
	Create Slave
	Expunge Both
	SyncState *
	EOF

new_account () {
	cat<<-EOF

	IMAPAccount $1
	Host $2
	User $1
	PassCmd "pass mail/offline/$1"
	SSLType IMAPS
	AuthMechs LOGIN

	IMAPStore $1-remote
	Account $1

	MaildirStore $1-local
	Path ~/.cache/maildir/$1/
	Inbox ~/.cache/maildir/$1/Inbox
	EOF
}

map_subdir () {
	cat <<-EOF

	Channel $1-$3
	Master :$1-remote:"$2"
	Slave :$1-local:$3
	EOF
}

map_default () {
	cat <<-EOF

	Channel $1.default
	Master :$1-remote:
	Slave :$1-local:
	Patterns * $2
	EOF
}

mkgroup () {
	echo ""
	echo "Group $1-group"
	echo "Channel $1.default"
	for m in $2 ; do
		echo "Channel $1-$m"
	done
}

welcome_for () {
	printf 'Create mbsync directory for: %s\n' "$@"
	mkdir -p "$HOME/.cache/maildir/$@"
	printf 'Generate mbsync configuration for: %s\n' "$@"
}

gen_gmail () {
	welcome_for "$@"
	new_account "$@" "imap.gmail.com" >> "$tmp_conf"
	map_default "$@" '![Gmail]* !Trash !Sent !Spam !Drafts' >> "$tmp_conf"
	map_subdir "$@" "[Gmail]/Trash" Trash >> "$tmp_conf"
	map_subdir "$@" "[Gmail]/Sent Mail" Sent >> "$tmp_conf"
	map_subdir "$@" "[Gmail]/Spam" Spam >> "$tmp_conf"
	mkgroup "$@" "Trash Sent Spam" >> "$tmp_conf"
}

gen_outlook () {
	welcome_for "$@"
	read -p "IMAP Server: " -r server
	if test -z "$server" ; then
		server="outlook.office365.com"
	fi
	new_account "$@" "$server" >> "$tmp_conf"
	map_default "$@" '!Trash !Spam !Deleted !Junk !Drafts' >> "$tmp_conf"
	map_subdir "$@" "Deleted" Trash >> "$tmp_conf"
	map_subdir "$@" "Junk" Spam >> "$tmp_conf"
	mkgroup "$@" "Trash Spam" >> "$tmp_conf"
}

gen_default () {
	welcome_for "$@"
	read -p "IMAP Server: " -r server
	new_account "$@" "$server" >> "$tmp_conf"
	map_default "$@" "!Drafts" >> "$tmp_conf"
}

while read -p "Email (exit on empty): " -r email ; do
	case $email in
	*\ *)
		echo "Email has spaces?"
		;;
	*@gmail.com)
		gen_gmail "$email"
		;;
	'')
		echo "Applying the configuration..."
		/usr/bin/mv -i "$tmp_conf" ~/.mbsyncrc
		echo "That's all"
		exit 0
		;;
	*)
		read -p "Layout (gmail/outlook/*): " -r layout
		case $layout in
		gmail|Gmail|GMail)
			gen_gmail "$email"
			;;
		outlook)
			gen_outlook "$email"
			;;
		*)
			gen_default "$email"
			;;
		esac
		;;
	esac
done

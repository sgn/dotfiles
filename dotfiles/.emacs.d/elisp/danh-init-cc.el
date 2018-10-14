;;; C/C++ mode initialization

;;;; Variables
(setq c-default-style "linux")

(defvaralias 'c-basic-offset 'tab-width)

(defvar-local danh/cxxflags "-std=c++17 -pedantic -Wall -Wextra -Wshadow -DDEBUG=9 -g3 -O0")
(defvar-local danh/cflags "-pedantic -Wall -Wextra -Wshadow -DDEBUG=9 -g3 -O0")

(defvar-local danh/ldlibs "-lm -pthread"
  "Custom linker flags for C/C++ linkage.")

(defvar-local danh/ldflags ""
  "Custom linker libs for C/C++ linkage.")

;;;; Functions
(defun danh/cc-set-compiler (&optional nomakefile)
  "Set compile command to be nearest Makefile or a generic command.
The Makefile is looked up in parent folders. If no Makefile is
found (or if NOMAKEFILE is non-nil or if function was called with
universal argument), then a configurable commandline is
provided."
  (interactive "P")
  (when (buffer-file-name)
    (hack-local-variables)
    ;; Alternatively, if a Makefile is found, we could change default directory
    ;; and leave the compile command to "make".  Changing `default-directory'
    ;; could have side effects though.
    (let ((makefile-dir (locate-dominating-file "." "Makefile")))
      (if (and makefile-dir (not nomakefile))
          (setq compile-command
	        (concat "make -k -C "
		        (shell-quote-argument (file-name-directory makefile-dir))))
        (setq compile-command
              (let
                  ((c++-p (eq major-mode 'c++-mode))
                   (file (file-name-nondirectory buffer-file-name)))
                (format "%s %s -o '%s' %s %s %s"
                        (if c++-p
                            (or (getenv "CXX") "g++")
                          (or (getenv "CC") "gcc"))
                        (shell-quote-argument file)
                        (shell-quote-argument (file-name-sans-extension file))
                        (if c++-p
                          (or (getenv "CXXFLAGS") danh/cxxflags)
                          (or (getenv "CFLAGS") danh/cflags)
                          (or (getenv "LDFLAGS") danh/ldflags)
                          (or (getenv "LDLIBS") danh/ldlibs)))))))))

(defun danh/make-clean ()
  "Find Makefile and call the `clean' rule.
If no Makefile is found, no action is taken.
The previous `compile' command is restored."
  (interactive)
  (let (compile-command
        (makefile-dir (locate-dominating-file "." "Makefile")))
    (when makefile-dir
      (compile (format "make -k -C %s clean" (shell-quote-argument makefile-dir))))))

;;;; Install hooks and keymaps
(dolist (hook '(c-mode-hook c++-mode-hook))
  (when (require 'company nil t)
    (add-hook hook 'company-mode))
  (add-hook hook 'danh/cc-set-compiler))

(dolist (map (list c-mode-map c++-mode-map))
  (danh/define-keys map
                   "<f5>" 'danh/make-clean
                   "M-." 'semantic-ia-fast-jump
                   "C-c C-d" 'semantic-ia-show-summary
                   "M-<tab>" 'semantic-complete-analyze-inline)
  (when (require 'company nil t)
    (define-key map (kbd "M-<tab>")
      (if (require 'helm-company nil t)
	  'helm-company
	'company-complete))))

(define-key c-mode-map (kbd "C-c m") 'danh/c-main)
(define-key c++-mode-map (kbd "C-c m") 'danh/c++-main)

;;;; Skeletons
(define-skeleton cc-debug
  "Insert debug macros."
  nil
  > "#ifdef DEBUG
#define DEBUG_CMD(CMD) do {CMD;} while(0)
#else
#define DEBUG_CMD(CMD) do {} while(0)
#endif

"
  '(insert-and-indent
    "#define DEBUG_PRINT(...) DEBUG_CMD( \\
fprintf(stderr, \"%s:%d:\\t(%s)\\t\", __FILE__, __LINE__, __func__); \\
fprintf(stderr, __VA_ARGS__); \\
fprintf(stderr, \"\\n\"); \\
)"))

(define-skeleton danh/c-main
  "Insert main function with basic includes."
  nil
  > "#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv) {" \n
> @ _ \n
>	"return 0;
}" \n)

(define-skeleton danh/c++-main
  "Insert C++ main function with basic includes"
  nil
  > "#include <cinttypes>
#include <cstdint>

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

int main(int argc, char ** argv) {" \n
> @ _ \n
>	"return 0;
}" \n)

(define-skeleton danh/cc-usage-version
  "Insert usage() and version() functions."
  "Synopsis: "
  > "static void usage(const char *executable) {" \n
  "printf(\"Usage: %s [OPTIONS]\\n\\n\", executable);" \n
  "puts(\"" str "\\n\");" "\n" \n

  "puts(\"Options:\");" \n
  "puts(\"  -h        Print this help.\");" \n
  "puts(\"  -V        Print version information.\");" "\n" \n

  "puts(\"\");" \n
  "printf(\"See %s for more information.\\n\", MANPAGE);" \n
  "}" > "\n" \n

  "static void version() {" \n
  "printf(\"%s %s\\n\", APPNAME, VERSION);" \n
  "printf(\"Copyright © %s %s\\n\", YEAR, AUTHOR);" \n
  "}" > \n)

(provide 'danh-init-cc)

; danh-init-cc.el ends here

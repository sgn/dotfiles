;;; C/C++ mode initialization

(eval-when-compile (require 'subr-x))

;;;; Variables
(setq c-default-style "linux")

;; (defvaralias 'c-basic-offset 'tab-width)

(defvar-local sgn/common-flags
  '("-fstack-protector-strong"
    "-pedantic"
    "-Wall" "-Wextra" "-Wshadow"
    "-pipe" "-pthread"
    "-O2" "-g" "-D_FORTIFY_SOURCE=2")
  "List of common flags for compiling C and C++")
(defvar-local sgn/cflags nil "Custom flags to compile C source files.")
(defvar-local sgn/cxxflags nil "Custom flags to compile C++ source files.")
(defvar-local sgn/ldflags nil "Custom flags for linker.")
(defvar-local sgn/ldlibs nil "Libraries to be linked against.")
(defun sgn/guess-cflags ()
    "Guess the flags required to compile C source files."
    (or sgn/cflags
	getenv("CFLAGS")
	(string-join (append sgn/common-flags '("-std=c11")) " ")))
(defun sgn/guess-cxxflags ()
    "Guess the flags required to compile C++ source files."
    (or sgn/cxxflags
	getenv("CXXFLAGS")
	(string-join (append sgn/common-flags '("-std=c++17")) " ")))
(defun sgn/guess-compiler ()
    "Guess the compiler to compile C or C++ source files."
  (if (eq major-mode 'c++-mode)
      (or (getenv "CXX") "g++")
    (or (getenv "CC") "gcc")))
(defun sgn/guess-compile-flags ()
    "Guess the flags to compile C or C++ source files."
  (if (eq major-mode 'c++-mode)
      (sgn/guess-cxxflags)
    (sgn/guess-cflags)))
(defun sgn/guess-ldlibs ()
    "Guess required LDLIBS to link."
    (or sgn/ldlibs
	"-pthread -lm"))

(defun sgn/guess-ldflags ()
    "Guess the flags required for linker."
    (or sgn/ldflags
	getenv("LDFLAGS")
	"-Wl,-z,relro,-z,now,--as-needed"))

;;;; Functions
(defun sgn/cc-set-compiler (&optional nomakefile)
  "Set compile command to be nearest Makefile or a generic command.
The Makefile is looked up in parent folders. If no Makefile is
found (or if `nomakefile' is non-nil or if function was called with
universal argument), then a configurable commandline is provided."
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
              (let ((file (file-name-nondirectory buffer-file-name)))
		(format "%s %s -o '%s' %s %s %s"
			(sgn/guess-compiler)
                        (shell-quote-argument file)
                        (shell-quote-argument (file-name-sans-extension file))
			(sgn/guess-compile-flags)
			(sgn/guess-ldflags)
			(sgn/guess-ldlibs))))))))

(defun sgn/make-clean ()
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
  (add-hook hook 'sgn/cc-set-compiler))

(dolist (map (list c-mode-map c++-mode-map))
  (sgn/define-keys map
                   "<f5>" 'sgn/make-clean
                   "M-." 'semantic-ia-fast-jump
                   "C-c C-d" 'semantic-ia-show-summary
                   "M-<tab>" 'semantic-complete-analyze-inline)
  (when (require 'company nil t)
    (define-key map (kbd "M-<tab>") 'company-complete)))

(define-key c-mode-map (kbd "C-c m") 'sgn/c-main)
(define-key c++-mode-map (kbd "C-c m") 'sgn/c++-main)

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

(define-skeleton sgn/c-main
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
>       "return 0;
}" \n)

(define-skeleton sgn/c++-main
  "Insert C++ main function with basic includes"
  nil
  > "#include <cinttypes>
#include <cstdint>

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

int main(int argc, char **argv) {" \n
> @ _ \n
>       "return 0;
}" \n)

(provide 'sgn-init-cc)

; sgn-init-cc.el ends here

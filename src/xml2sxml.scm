(use-modules
  (sxml simple))

(define (get-0th-argument)
  (list-ref (command-line) 0))
(define (get-1st-argument)
  (list-ref (command-line) 1))
(define (get-2nd-argument)
  (list-ref (command-line) 2))

(define %program-name
  (basename (get-0th-argument)))

(when (or (= (length (command-line)) 1)
          (equal? (get-1st-argument) "--help")
          (equal? (get-1st-argument) "-h"))
  (display
    (string-append
      "Usage: " %program-name " [options] [file]\n"
      "\n"
      "options: \n"
      "  -h, --help  show this help message and exit\n"))
  (exit))

(when (and (string-prefix? "-" (get-1st-argument))
           (not (equal? (get-1st-argument) "--")))
  (display
    (string-append
      "Unrecognized option: '" (get-1st-argument) "'\n"
      "Try '" %program-name " --help' for more information.\n")
    (current-error-port))
  (exit))

(let ((input-file (if (equal? (get-1st-argument) "--")
                    (get-2nd-argument)
                    (get-1st-argument))))
  (if (access? input-file R_OK)
    (begin
      (display (xml->sxml (open-input-file input-file) #:trim-whitespace? #t))
      (display "\n"))
    (display
      (string-append
        "Can't get access to the specified file: '" input-file "'\n")
      (current-error-port))))

(use-modules
  (srfi srfi-1)
  (sxml simple))

(define %program-name
  (basename (list-ref (command-line) 0)))

(define (get-1st-argument)
  (list-ref (command-line) 1))

(define (get-2nd-argument)
  (list-ref (command-line) 2))

(define (parse-command-line-options)
  (when (or (= (length (command-line)) 1)
            (equal? (get-1st-argument) "--help")
            (equal? (get-1st-argument) "-h"))
    (display
      (string-append
        "Usage: " %program-name " [options] [file]\n"
        "\n"
        "options: \n"
        "  -h, --help  show this help message and exit\n"))
    (exit 0))
  (when (and (string-prefix? "-" (get-1st-argument))
             (not (equal? (get-1st-argument) "--")))
    (display
      (string-append
        "Unrecognized option: '" (get-1st-argument) "'\n"
        "Try '" %program-name " --help' for more information.\n")
      (current-error-port))
    (exit 1)))

(define (get-input-file)
  (if (equal? (get-1st-argument) "--")
    (get-2nd-argument)
    (get-1st-argument)))

(define (sxml-remove-special-tags tree)
  (remove
    (lambda (element)
      (or (eq? element '*TOP*)
          (eq? (car element) '*PI*)))
    tree))

(define (xml-file->sxml-output file)
  (if (access? file R_OK)
    (begin
      (display (car (sxml-remove-special-tags
                     (xml->sxml
                      (open-input-file file)
                      #:trim-whitespace? #t))))
      (display "\n"))
    (begin
      (display
        (string-append
          "Can't get access to the specified file: '" file "'\n")
        (current-error-port))
      (exit 2))))

(parse-command-line-options)
(let ((input-file (get-input-file)))
  (xml-file->sxml-output input-file))

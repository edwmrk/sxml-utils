;;;; Copyright © 2022 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>
;;;;
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

(use-modules
  (srfi srfi-1)
  (sxml simple)
  (ice-9 pretty-print)
  (ice-9 getopt-long))

(define %program-name
  (basename (list-ref (command-line) 0)))

(define %command-line-options
  (getopt-long (command-line)
    '((help (single-char #\h) (value #f)))))

(define %command-line-arguments
  (option-ref %command-line-options '() '()))

(define %help-wanted?
  (option-ref %command-line-options 'help #f))

(define %help-message
  (string-append
    "Usage: " %program-name " [options] [file]\n"
    "\n"
    "options:\n"
    "  -h, --help  show this help message and exit\n"))

(define (get-input-file)
  (car %command-line-arguments))

(define (sxml-remove-special-tags tree)
  (remove
    (λ (element)
      (or (eq? element '*TOP*)
          (eq? (car element) '*PI*)))
    tree))

(define (xml-file->sxml-output file)
  (if (access? file R_OK)
    (begin
      (pretty-print (car (sxml-remove-special-tags
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

(if %help-wanted?
  (display %help-message)
  (if (not (null? %command-line-arguments))
    (xml-file->sxml-output (get-input-file))
    (display %help-message)))

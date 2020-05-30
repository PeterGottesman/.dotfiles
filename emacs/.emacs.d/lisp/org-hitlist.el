;; Emacs extension to help keep track of issues in a repo
;; Currently doesn't cache repository locations
;; or search for them other than checking for vc

;; Properties:
;; date
;; hash
;; added-hash
;; loc
;; GHIssue
;; brief

(require 'vc)
(require 'org)

(defgroup hitlist nil
  "Repository issue tracking" ; TODO: with github integration
  :group 'tools)

(defcustom hitlist-file-name "hl.org"
  "Name of hitlist file"
  :type 'string
  :group 'hitlist)

(defcustom hitlist-search-back-limit 3
  "Number of directories to search backwards for the hitlist"
  :type 'integer
  :group 'hitlist)

(defcustom hitlist-subheadings
  '("Description of problem"
    "Possible solutions"
    "Temporary Workarounds")
  "Subheadings to create"
  :type '(repeat string)
  :group 'hitlist)

;; TODO: document formatting format
(defcustom hitlist-heading-format "%m%d, %y: %B"
  "Format of each header"
  :type 'string
  :group 'hitlist)

(defun --find-root ()
  (interactive)
  (let ((vc-root
	 (ignore-errors (vc-call-backend
			 (vc-responsible-backend default-directory)
			 'root default-directory))))
    (or vc-root (read-directory-name "Enter project root: "))))

(defun hitlist-open ()
  (let ((root (--find-root)))
    (find-file
     (expand-file-name hitlist-file-name root))))

(defun hitlist-add-entry ()
  "Function to add a hitlist entry"
  (interactive)
  (let (hitlist-get-properties)
    (hitlist-open)
    (goto-char (point-max))
    (insert "* " brief)))

(hitlist-open)
(hitlist-add-entry)
(hitlist-get-properties)

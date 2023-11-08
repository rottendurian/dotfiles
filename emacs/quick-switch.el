(defvar quick-switch-array (make-vector 10 nil)
  "Array to store buffer names for quick switching")

(defun quick-switch-to-buffer (index)
  "Switch to the buffer at the given index in quick-switch-array"
  (interactive "nIndex: ")
  (let ((buffer-name (aref quick-switch-array index)))
    (if (bufferp buffer-name)
        (switch-to-buffer buffer-name)
      (message "No buffer at index %d" index))))

(defun quick-switch-add-buffer (index)
  "Add the current buffer to the quick-switch-array at the given index"
  (interactive "nIndex: ")
  (unless (and (integerp index) (>= index 0) (< index 10))
    (error "Invalid index"))
  (aset quick-switch-array index (current-buffer))
  (message "Buffer added to index %d" index))

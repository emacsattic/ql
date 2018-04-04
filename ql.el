;;; ql.el --- Control Quod Libet                         -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Ian Eure

;; Author: Ian Eure <ian.eure@gmail.com>
;; Keywords: multimedia
;; URL: https://github.com/ieure/ql-el
;; Package-Requires: ((emacs "24"))
;; Version: 1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Interface to Quod Libet

;;; Code:

(require 'dbus)

(defconst ql-service "net.sacredchao.QuodLibet")
(defconst ql-path "/net/sacredchao/QuodLibet")
(defconst ql-interface "net.sacredchao.QuodLibet")

(defun ql-call* (method &rest args)
  (apply #'dbus-call-method :session ql-service ql-path ql-interface
         method args))

(defun ql-status ()
  (let ((song (ql-call* "CurrentSong")))
    (message (format "%s - %s"
                     (cadr (assoc "artist" song))
                     (cadr (assoc "title" song))))))

(defun ql-playingp* ()
  (ql-call* "IsPlaying"))

(defun ql-play-pause ()
  (interactive)
  (ql-call* "PlayPause")
  (when (ql-playingp*)
    (ql-status)))

(defun ql-pause ()
  (interactive)
  (ql-call* "Pause"))

(defun ql-play ()
  (interactive)
  (ql-call* "Play")
  (ql-status))

(defun ql-next ()
  (interactive)
  (ql-call* "Next")
  (ql-status))

(defun ql-next ()
  (interactive)
  (ql-call* "Previous")
  (ql-status))

(define-minor-mode ql-minor-mode
  "Minor mode for controlling Quod Libet"
  t nil (make-sparse-keymap))

(define-key ql-minor-mode-map (kbd "<XF86AudioPlay>") #'ql-play-pause)
(define-key ql-minor-mode-map (kbd "<XF86AudioNext>") #'ql-next)
(define-key ql-minor-mode-map (kbd "<XF86AudioPrev>") #'ql-previous)

(provide 'ql)
;;; ql.el ends here

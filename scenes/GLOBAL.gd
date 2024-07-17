extends Node
# script for global variables

# constants
## paths
const SAVE_PATH = "res://"
## ResultUI
const DEFAULT_DELAY = 10
const DEFAULT_POINTS = 100000

# variables
## sample
var random_seed = 0
var sample_size = 0
var image_size = 0
var points = 0
## ifs
var delay_min = 0
var delay_max = 0
var p_centered = 0.0
var nb_contractions_min = 0
var nb_contractions_max = 0
var delay = DEFAULT_DELAY
## contractions
var translation_min = 0.0
var translation_max = 0.0
var contr_min = 0.0
var contr_max = 0.0
var mirroring_allowed = true
var rotation_allowed = true
var greyscale_allowed = true
var bgcolor_allowed = true

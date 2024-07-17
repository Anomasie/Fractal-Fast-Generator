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
## ifs
var p_centered = 0.5
var nb_contractions_min = 1
var nb_contractions_max = 5
var delay = DEFAULT_DELAY
## contractions
var translation_min = -1
var translation_max = 1.9
var contr_min = 0
var contr_max = 1
var mirroring_allowed = true
var rotation_allowed = true
var greyscale_allowed = true

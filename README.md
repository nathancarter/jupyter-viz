<!--
Removing these lines for now because this package is not yet
integrated into GAP or its build system.

[![Build Status](https://travis-ci.org/gap-packages/jupyter-viz.svg?branch=master)](https://travis-ci.org/gap-packages/jupyter-viz)
[![Code Coverage](https://codecov.io/github/gap-packages/jupyter-viz/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/jupyter-viz)
-->

# The Jupyter Notebook Visualization Package

## Purpose

This package adds visualization tools to GAP for use in Jupyter notebooks.
These include standard line and bar graphs, pie charts, scatter plots, and
graphs in the vertices-and-edges sense.

## Implementation

These are implemented by importing existing JavaScript visualization
libraries into the notebook as needed, based on the kind of visualization
requested by the GAP code.

The architecture of the package is such that additional JavaScript
visualization libraries can be added easily.

## Usage

The package does not need to be compiled.

See the manual on [the package website](http://nathancarter.github.io/jupyter-viz)

Or check out an example notebook:
 * Live on Binder: [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/nathancarter/jupyter-viz/master?filepath=inst%2Fgap-4.9.3%2Fpkg%2Fjupyter-viz%2Ftst%2Fin-notebook-test.ipynb)
 * [Get PDF version](tst/in-notebook-test.pdf) - all visualizations
   shown, but content is static (and print-to-PDF not very attractive)
 * [Get .ipynb version](tst/in-notebook-test.ipynb) - no visualizations
   render live on GitHub because they are JavaScript-based, but if you
   download this you can run it yourself and get a bit of interactivity.
   Some cells load external `.json` files, which are included in the
   `tst/` folder of this repository.

## Maintainer

 * Nathan Carter

This GAP package is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

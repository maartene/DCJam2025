# TECHDEBT

## ⚠️ TODO
- missing tests in Floor
- there is duplication in `World` where multiple functions do the same check: see if player already won. Abstraction needed to conform to DRY

## 🚧 DOING

## ✅ DONE
- no test coverage for conversion of coordinate spaces, while this might be valuable. Maybe property based testing?
- a lot of the minimap code could be tested, in particular the conversion of units and determining of correct tile names
- missing test for color multiplication in Conversions.swift
- should not be able to rotate when goal is reached
- minX, minY, maxX and maxY are constants, so can be generated only once

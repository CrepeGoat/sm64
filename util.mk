# util.mk - Miscellaneous utility functions for use in Makefiles

# Throws an error if the value of the variable named by $(1) is not in the list given by $(2)
define validate-option
  # value must be part of the list
  ifeq ($$(filter $($(1)),$(2)),)
    $$(error Value of $(1) must be one of the following: $(2))
  endif
  # value must be a single word (no whitespace)
  ifneq ($$(words $($(1))),1)
    $$(error Value of $(1) must be one of the following: $(2))
  endif
endef

# Returns the path to the command $(1) if exists. Otherwise returns an empty string.
find-command = $(shell which $(1) 2>/dev/null)

CROSS_TARGET := mips-linux-gnu
# CROSS_TARGET := mips64-linux-gnu
# CROSS_TARGET := mips64-freestanding-elf

GCC_ALIAS := zig cc
G++_ALIAS := zig c++
MIPS_GCC_ALIAS := zig cc --target=$(CROSS_TARGET)
MIPS_G++_ALIAS := zig c++ --target=$(CROSS_TARGET)

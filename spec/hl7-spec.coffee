{TextEditor} = require "atom"
fs = require "fs"
path = require "path"

describe "HL7 grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-hl7")

    runs ->
      grammar = atom.grammars.grammarForScopeName("text.hl7")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.hl7"

  it "determines the segment type", ->
    lines = grammar.tokenizeLines """
      NK1||ROE^MARIE^^^^|SPO||(216)123-4567||EC|||||||||||||||||||||||||||
    """

    expect(lines[1]).toEqual value: "NK1", scopes: ["text.hl7", "entity.name.type"]

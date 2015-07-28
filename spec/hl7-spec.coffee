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

    expect(lines[0][0]).toEqual value: "NK1", scopes: ["text.hl7", "entity.name.type.hl7.segment"]

  it "determines the social security number", ->
    lines = grammar.tokenizeLines """
      PID||0493575^^^2^ID 1|454721||DOE^JOHN^^^^|DOE^JOHN^^^^|19480203|M||B|254 MYSTREET AVE^^MYTOWN^OH^44123^USA||(216)123-4567|||M|NON|400003403~1129086|333-33-3333|
    """

    expect(lines[0][61]).toEqual value: "333-33-3333", scopes: ["text.hl7", "support.variable.hl7.ssn"]

  it "determines the patient id", ->
    lines = grammar.tokenizeLines """
      PID|1333|5M5-389423.4^^^&2.16.840.1.113883.3.779.1&ISO|454721||DOE^JOHN^^^^|DOE^JOHN^^^^|19480203|M||B|254 MYSTREET AVE^^MYTOWN^OH^44123^USA||(216)123-4567|||M|NON|400003403~1129086|333-33-3333|
    """

    expect(lines[0][4]).toEqual value: "5M5-389423.4^^^&2.16.840.1.113883.3.779.1&ISO", scopes: ["text.hl7", "support.function.hl7.patientId"]

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

  it "determines the accession Number", ->
    lines = grammar.tokenizeLines """
    OBR|1|ACC123456789|004174|300295^ABDOMEN 1 VIEW^XR||201606130901|201606130901||||L||ABDOMEN; 1 VIEW~{REASON FOR ABDOMEN: ABDOMINAL PAIN~{TRANSPORTATION:   IV?  N  O2?  N  IV PUMP?  N|||123456^LAST^FIRST||123456|XR|||||RAD|P||001^^^20160613090100^^R|123456~008100||||||||||||||||74000|
    """

    expect(lines[0][4]).toEqual value: "ACC123456789", scopes: ["text.hl7", "support.function.hl7.accessionNum"]

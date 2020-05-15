local my_schema = [[
    {
        "properties": {
          "riders": {
            "type": "array",
            "items": {
              "properties": {
                "featureCode": {
        "type": "string"
                },
                "riderType": {
        "type": "string",
        "enum": [
          "GLWB",
          "GWLB",
          "Enhanced           Death Benefit"
        ]
                },
                "isOptional": {
        "type": "boolean"
                },
                "riderOptions": {
        "type": "array",
        "items": {
          "properties": {
            "lifetimeAnnualBonusPayments": {
              "type": "object",
              "properties": {
                "rateBasis": {
                  "type": "string",
                  "enum": [
                    "Year",
                    "Age"
                  ]
                },
                "rates": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "yearFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "singleRate": {
                        "type": "number",
                        "format": "double"
                      },
                      "yearTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "jointRate": {
                        "type": "number",
                        "format": "double"
                      }
                    }
                  }
                }
              }
            },
            "activation": {
              "type": "object",
              "properties": {
                "maxYear": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds"
                },
                "minAge": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                },
                "maxAge": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                },
                "minYear": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds"
                }
              }
            },
            "bonus": {
              "type": "object",
              "properties": {
                "rateBasis": {
                  "type": "string",
                  "enum": [
                    "Year",
                    "Age"
                  ]
                },
                "rates": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "yearFrom": {
                        "type": "integer",
                        "format": "int32"
                      },
                      "bonusRate": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "incomeActivationOverride": {
                        "type": "object",
                        "properties": {
                          "bonusRate": {
                            "type": "number",
                            "format": "double"
                          }
                        }
                      },
                      "ageFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "yearTo": {
                        "type": "integer",
                        "format": "int32"
                      }
                    }
                  }
                }
              }
            },
            "optionName": {
              "type": "string"
            },
            "optionId": {
              "pattern": "^[\\w           ]{0,32}",
              "type": "string"
            },
            "lifetimeAnnualPayments": {
              "type": "object",
              "properties": {
                "rateBasis": {
                  "type": "string",
                  "enum": [
                    "Year",
                    "Age"
                  ]
                },
                "rates": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "yearFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "singleRate": {
                        "type": "number",
                        "format": "double"
                      },
                      "yearTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "jointRate": {
                        "type": "number",
                        "format": "double"
                      }
                    }
                  }
                }
              }
            },
            "riderCharge": {
              "properties": {
                "chargeBasis": {
                  "description": "Accepted           Charge Basis options",
                  "enum": [
                    "Benefit Base",
                    "Account Value"
                  ],
                  "type": "string"
                },
                "rateBasis": {
                  "type": "string",
                  "enum": [
                    "Year",
                    "Age"
                  ]
                },
                "rateFrequency": {
                  "description": "Accepted           Frequency options",
                  "enum": [
                    "Annual",
                    "Quarterly",
                    "Monthly",
                    "Semiannual"
                  ],
                  "type": "string"
                },
                "rates": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "yearFrom": {
                        "maximum": 1000000000,
                        "minimum": -1000000000,
                        "type": "number",
                        "description": "Number           with wide lower and upper bounds"
                      },
                      "ageTo": {
                        "maximum": 1000000000,
                        "minimum": -1000000000,
                        "type": "number",
                        "description": "Number           with wide lower and upper bounds",
                        "format": "double"
                      },
                      "yearTo": {
                        "maximum": 1000000000,
                        "minimum": -1000000000,
                        "type": "number",
                        "description": "Number           with wide lower and upper bounds"
                      },
                      "incomeActivationOverride": {
                        "properties": {
                          "riderChargeRate": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds",
                            "format": "double"
                          }
                        },
                        "type": "object",
                        "required": [
                          "riderChargeRate"
                        ]
                      },
                      "ageFrom": {
                        "maximum": 1000000000,
                        "minimum": -1000000000,
                        "type": "number",
                        "description": "Number           with wide lower and upper bounds",
                        "format": "double"
                      },
                      "riderChargeRate": {
                        "maximum": 1000000000,
                        "minimum": -1000000000,
                        "type": "number",
                        "description": "Number           with wide lower and upper bounds",
                        "format": "double"
                      }
                    }
                  },
                  "minItems": 1
                }
              },
              "type": "object",
              "required": [
                "chargeBasis",
                "rateBasis",
                "rateFrequency",
                "rates"
              ]
            },
            "rollUp": {
              "type": "object",
              "properties": {
                "rollUpMaxAmount": {
                  "type": "number",
                  "format": "double"
                },
                "addStrategyCredit": {
                  "type": "boolean"
                },
                "rollUpMaxYear": {
                  "type": "integer",
                  "format": "int32"
                },
                "rollUpMaxAge": {
                  "type": "number",
                  "format": "double"
                },
                "rateCompounded": {
                  "type": "boolean"
                },
                "rateBasis": {
                  "type": "string",
                  "enum": [
                    "Year",
                    "Age"
                  ]
                },
                "rateFrequency": {
                  "type": "string",
                  "enum": [
                    "Annual",
                    "Quarterly",
                    "Monthly",
                    "Semiannual"
                  ]
                },
                "rates": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "yearFrom": {
                        "type": "integer",
                        "format": "int32"
                      },
                      "rollUpRate": {
                        "type": "number",
                        "format": "double"
                      },
                      "ageTo": {
                        "type": "number",
                        "format": "double"
                      },
                      "strategyMultiplier": {
                        "type": "number",
                        "format": "double"
                      },
                      "incomeActivationOverride": {
                        "type": "object",
                        "properties": {
                          "rollUpRate": {
                            "type": "number",
                            "format": "double"
                          },
                          "strategyMultiplier": {
                            "type": "number",
                            "format": "double"
                          }
                        }
                      },
                      "ageFrom": {
                        "type": "number",
                        "format": "double"
                      },
                      "yearTo": {
                        "type": "integer",
                        "format": "int32"
                      }
                    }
                  }
                }
              }
            },
            "issueAge": {
              "type": "object",
              "properties": {
                "minAge": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                },
                "maxAge": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                }
              }
            },
            "nonIssueStates": {
              "type": "array",
              "items": {
                "type": "string",
                "enum": [
                  "AL",
                  "AK",
                  "AZ",
                  "AR",
                  "CA",
                  "CO",
                  "CT",
                  "DE",
                  "DC",
                  "FL",
                  "GA",
                  "GU",
                  "HI",
                  "ID",
                  "IL",
                  "IN",
                  "IA",
                  "KS",
                  "KY",
                  "LA",
                  "ME",
                  "MD",
                  "MA",
                  "MI",
                  "MN",
                  "MS",
                  "MO",
                  "MT",
                  "NE",
                  "NV",
                  "NH",
                  "NJ",
                  "NM",
                  "NY",
                  "NC",
                  "ND",
                  "OH",
                  "OK",
                  "OR",
                  "PA",
                  "PR",
                  "RI",
                  "SC",
                  "SD",
                  "TN",
                  "TX",
                  "UT",
                  "VT",
                  "VI",
                  "VA",
                  "WA",
                  "WV",
                  "WI",
                  "WY"
                ]
              },
              "minItems": 1
            }
          },
          "type": "object",
          "required": [
            "optionId"
          ]
        },
        "minItems": 1
                },
                "riderTypeCode": {
        "type": "string"
                },
                "riderName": {
        "pattern": "^[\\w           ]{0,32}",
        "type": "string"
                }
              },
              "type": "object",
              "required": [
                "isOptional",
                "riderName",
                "riderOptions",
                "riderType"
              ]
            },
            "minItems": 1
          },
          "illustration": {
            "properties": {
              "illustrationServiceProvider": {
                "type": "object",
                "properties": {}
              },
              "indexStrategyTags": {
                "type": "array",
                "items": {
        "properties": {
          "indexStrategyId": {
            "pattern": "^[\\w           ]{0,32}",
            "type": "string"
          },
          "tag": {
            "pattern": "^[\\w ]{0,32}",
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "indexStrategyId",
          "tag"
        ]
                }
              },
              "illustrationAge": {
                "type": "object",
                "properties": {
        "maximum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        },
        "minimum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        }
                }
              },
              "allocation": {
                "type": "object",
                "properties": {
        "maximum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        },
        "minimum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        }
                }
              },
              "illustrationYear": {
                "type": "object",
                "properties": {
        "maximum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        },
        "minimum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        }
                }
              },
              "illustrationPremium": {
                "type": "object",
                "properties": {
        "maximum": {
          "maximum": 100000000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        },
        "minimum": {
          "maximum": 100000000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        }
                }
              },
              "strategiesNum": {
                "type": "object",
                "properties": {
        "maximum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        },
        "minimum": {
          "maximum": 10000,
          "minimum": 0,
          "type": "number",
          "format": "double"
        }
                }
              }
            },
            "type": "object",
            "required": [
              "indexStrategyTags"
            ]
          },
          "applicableNetwork": {
            "type": "object",
            "properties": {}
          },
          "effectiveDateFrom": {
            "maxLength": 10,
            "description": "Date in a format yyyy-mm-dd",
            "minLength": 10,
            "pattern": "^\\d{4}-\\d{2}-\\d{2}$",
            "type": "string"
          },
          "surrenderOptions": {
            "type": "array",
            "items": {
              "properties": {
                "surrenderPeriod": {
        "pattern": "^[\\w           ]{0,32}",
        "type": "string"
                },
                "strategyOptions": {
        "type": "array",
        "items": {
          "properties": {
            "premiumRange": {
              "properties": {
                "premiumFrom": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                },
                "premiumTo": {
                  "maximum": 1000000000,
                  "minimum": -1000000000,
                  "type": "number",
                  "description": "Number           with wide lower and upper bounds",
                  "format": "double"
                }
              },
              "type": "object",
              "required": [
                "premiumFrom"
              ]
            },
            "strategies": {
              "type": "array",
              "items": {
                "properties": {
                  "fixedRate": {
                    "maximum": 1,
                    "minimum": 0,
                    "type": "number"
                  },
                  "strategyId": {
                    "pattern": "^[\\w           ]{0,32}",
                    "type": "string"
                  },
                  "protectionLevelStrike": {
                    "maximum": 1000000000,
                    "minimum": -1000000000,
                    "type": "number",
                    "description": "Number           with wide lower and upper bounds"
                  },
                  "renewable": {
                    "type": "boolean"
                  },
                  "rangedParams": {
                    "type": "object",
                    "properties": {
                      "fixedRate": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpLevel": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpTouchBreak": {
                        "type": "string",
                        "enum": [
                          "Touch",
                          "Break"
                        ]
                      },
                      "upsideCap": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideParticipationStrike": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpStrike": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideParticipation": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      }
                    }
                  },
                  "hasLockIn": {
                    "type": "boolean"
                  },
                  "upsideJumpLevel": {
                    "maximum": 1,
                    "minimum": 0,
                    "type": "number"
                  },
                  "upsideParticipationStrike": {
                    "maximum": 5,
                    "minimum": 0,
                    "type": "number"
                  },
                  "rateType": {
                    "type": "string",
                    "enum": [
                      "Cap",
                      "Spread",
                      "Fixed",
                      "Performance           Trigger",
                      "Participation"
                    ]
                  },
                  "upsideParticipation": {
                    "maximum": 5,
                    "minimum": 0,
                    "type": "number"
                  },
                  "upsideJumpTouchBreak": {
                    "maximum": 1000000000,
                    "minimum": -1000000000,
                    "type": "number",
                    "description": "Number           with wide lower and upper bounds"
                  },
                  "stateOverrides": {
                    "minItems": 1,
                    "maxItems": 100,
                    "type": "array",
                    "items": {
                      "properties": {
                        "fixedRate": {
                          "maximum": 1,
                          "minimum": 0,
                          "type": "number"
                        },
                        "states": {
                          "maxItems": 100,
                          "type": "array",
                          "items": {
                            "type": "string",
                            "enum": [
                              "AL",
                              "AK",
                              "AZ",
                              "AR",
                              "CA",
                              "CO",
                              "CT",
                              "DE",
                              "DC",
                              "FL",
                              "GA",
                              "GU",
                              "HI",
                              "ID",
                              "IL",
                              "IN",
                              "IA",
                              "KS",
                              "KY",
                              "LA",
                              "ME",
                              "MD",
                              "MA",
                              "MI",
                              "MN",
                              "MS",
                              "MO",
                              "MT",
                              "NE",
                              "NV",
                              "NH",
                              "NJ",
                              "NM",
                              "NY",
                              "NC",
                              "ND",
                              "OH",
                              "OK",
                              "OR",
                              "PA",
                              "PR",
                              "RI",
                              "SC",
                              "SD",
                              "TN",
                              "TX",
                              "UT",
                              "VT",
                              "VI",
                              "VA",
                              "WA",
                              "WV",
                              "WI",
                              "WY"
                            ]
                          }
                        },
                        "upsideJumpLevel": {
                          "maximum": 1,
                          "minimum": 0,
                          "type": "number"
                        },
                        "upsideCap": {
                          "maximum": 1000000000,
                          "minimum": -1000000000,
                          "type": "number",
                          "description": "Number           with wide lower and upper bounds"
                        },
                        "upsideJumpStrike": {
                          "maximum": 4,
                          "minimum": 0,
                          "type": "number"
                        },
                        "upsideParticipationStrike": {
                          "maximum": 5,
                          "minimum": 0,
                          "type": "number"
                        },
                        "upsideJumpTouchBreak": {
                          "type": "string",
                          "enum": [
                            "Touch",
                            "Break"
                          ]
                        },
                        "upsideParticipation": {
                          "maximum": 5,
                          "minimum": 0,
                          "type": "number"
                        }
                      },
                      "type": "object",
                      "required": [
                        "states"
                      ]
                    }
                  },
                  "underlierType": {
                    "type": "string",
                    "enum": [
                      "Single           Asset",
                      "Share Weighted",
                      "Worst Of",
                      "Fixed"
                    ]
                  },
                  "maturity": {
                    "type": "integer",
                    "format": "int32"
                  },
                  "upsideCap": {
                    "maximum": 1000000000,
                    "minimum": -1000000000,
                    "type": "number",
                    "description": "Number           with wide lower and upper bounds",
                    "format": "double"
                  },
                  "underlier": {
                    "type": "array",
                    "items": {
                      "properties": {
                        "assetId": {
                          "type": "string",
                          "description": "generic entity ID. Sanitized string with maximum length of 64 symbols.",
                          "pattern": "^[\\w-.]{1,64}$"
                        },
                        "assetWeight": {
                          "maximum": 1000000000,
                          "minimum": -1000000000,
                          "type": "number",
                          "description": "Number           with wide lower and upper bounds",
                          "format": "double"
                        }
                      },
                      "type": "object",
                      "required": [
                        "assetId"
                      ]
                    },
                    "minItems": 1
                  },
                  "upsideJumpStrike": {
                    "maximum": 4,
                    "minimum": 0,
                    "type": "number"
                  },
                  "bailoutParams": {
                    "type": "object",
                    "properties": {
                      "fixedRate": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpLevel": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpTouchBreak": {
                        "type": "string",
                        "enum": [
                          "Touch",
                          "Break"
                        ]
                      },
                      "upsideCap": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideParticipationStrike": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideJumpStrike": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      },
                      "upsideParticipation": {
                        "type": "object",
                        "properties": {
                          "low": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          },
                          "high": {
                            "maximum": 1000000000,
                            "minimum": -1000000000,
                            "type": "number",
                            "description": "Number           with wide lower and upper bounds"
                          }
                        }
                      }
                    }
                  },
                  "downsideCap": {
                    "maximum": 1000000000,
                    "minimum": -1000000000,
                    "type": "number",
                    "description": "Number           with wide lower and upper bounds"
                  },
                  "protectionType": {
                    "type": "string",
                    "enum": [
                      "Hard",
                      "Floor"
                    ]
                  }
                },
                "type": "object",
                "required": [
                  "maturity",
                  "rateType",
                  "renewable",
                  "strategyId"
                ]
              }
            }
          },
          "type": "object",
          "required": [
            "premiumRange",
            "strategies"
          ]
        },
        "minItems": 1
                }
              },
              "type": "object",
              "required": [
                "strategyOptions",
                "surrenderPeriod"
              ]
            }
          },
          "cohortId": {
            "maximum": 1000000000,
            "minimum": -1000000000,
            "type": "number",
            "description": "Number with wide lower and upper bounds",
            "format": "double"
          },
          "stateOverrides": {
            "type": "array",
            "items": {
              "properties": {
                "states": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": [
            "AL",
            "AK",
            "AZ",
            "AR",
            "CA",
            "CO",
            "CT",
            "DE",
            "DC",
            "FL",
            "GA",
            "GU",
            "HI",
            "ID",
            "IL",
            "IN",
            "IA",
            "KS",
            "KY",
            "LA",
            "ME",
            "MD",
            "MA",
            "MI",
            "MN",
            "MS",
            "MO",
            "MT",
            "NE",
            "NV",
            "NH",
            "NJ",
            "NM",
            "NY",
            "NC",
            "ND",
            "OH",
            "OK",
            "OR",
            "PA",
            "PR",
            "RI",
            "SC",
            "SD",
            "TN",
            "TX",
            "UT",
            "VT",
            "VI",
            "VA",
            "WA",
            "WV",
            "WI",
            "WY"
          ]
        }
                },
                "marketValueAdjustment": {
        "type": "boolean"
                },
                "illustration": {
        "properties": {
          "illustrationServiceProvider": {
            "type": "object",
            "properties": {}
          },
          "indexStrategyTags": {
            "type": "array",
            "items": {
              "properties": {
                "indexStrategyId": {
                  "pattern": "^[\\w           ]{0,32}",
                  "type": "string"
                },
                "tag": {
                  "pattern": "^[\\w ]{0,32}",
                  "type": "string"
                }
              },
              "type": "object",
              "required": [
                "indexStrategyId",
                "tag"
              ]
            }
          },
          "illustrationAge": {
            "type": "object",
            "properties": {
              "maximum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              },
              "minimum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              }
            }
          },
          "allocation": {
            "type": "object",
            "properties": {
              "maximum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              },
              "minimum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              }
            }
          },
          "illustrationYear": {
            "type": "object",
            "properties": {
              "maximum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              },
              "minimum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              }
            }
          },
          "illustrationPremium": {
            "type": "object",
            "properties": {
              "maximum": {
                "maximum": 100000000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              },
              "minimum": {
                "maximum": 100000000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              }
            }
          },
          "strategiesNum": {
            "type": "object",
            "properties": {
              "maximum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              },
              "minimum": {
                "maximum": 10000,
                "minimum": 0,
                "type": "number",
                "format": "double"
              }
            }
          }
        },
        "type": "object",
        "required": [
          "indexStrategyTags"
        ]
                }
              },
              "type": "object",
              "required": [
                "states"
              ]
            }
          },
          "marketValueAdjustment": {
            "type": "boolean"
          },
          "cusip": {
            "pattern": "^[\\w ]{0,32}",
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "cohortId",
          "cusip",
          "effectiveDateFrom",
          "illustration",
          "marketValueAdjustment",
          "surrenderOptions"
        ]
      }
]]


local jsonschema = require 'resty.ljsonschema'
local cjson = require('cjson')


describe("[code generator]", function()

  it("generates valid code with more than 200 local variables", function()
    assert.has.no.error(function()
      jsonschema.generate_validator(cjson.decode(my_schema))
    end)
  end)

  it("generates valid code numbers as strings", function()
    -- not that "0" is a string-key containing a number
    local test_schema = [[{
      "type":"object",
      "properties":{
        "0":{
          "anyOf":[
            {
              "maximum":1000000000000,
              "minimum":-1000000000000,
              "type":"number"
            },
            {
              "type":"array",
              "items":{
                "maximum":1000000000000,
                "minimum":-1000000000000,
                "type":"number"
              }
            }
          ]
        }
      }
    }]]
    assert.has.no.error(function()
      jsonschema.generate_validator(cjson.decode(test_schema))
    end)
  end)

end)



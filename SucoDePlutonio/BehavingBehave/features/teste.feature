Feature: testing reg ex match

    Scenario Outline: Testing reg ex with print
        When I select correct <URI>
        Then I Print correct the URL
    Examples:
    |URI                |
    |/endpoint/{id}/secondvariable/|
    |/endpoint/{id}|
    |/endpoint/secondvariable/{id}|
    |/endpoiintz/post|
    |/endpoints/secondvariable|
    |endpoint/shouldnotbevalid/|
    |/endpoiintz/{rla_id}/asdasd/{id}|
    |/endpoiintz/{rla_id}/asdasd|

    
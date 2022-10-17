import requests
import re
import behave

from behave import when, then

get_id = "/[a-z]{1,20}{rla_id}{0}/{id}/*[a-z]*/*"
post = "/[a-z]{1,20}/[a-z]{1,20}"
get_id_rla = "{rla_id}{1}/[a-z]{1,20}/{id}/*[a-z]*/*"

@When("I select correct {URI}")
def URI_select(context, URI):
    if re.search(get_id, URI):
        context.uri = URI.format(id="02394871024938")
    elif re.search(post, URI):
        context.uri = URI
    elif re.search(get_id_rla, URI):
        context.uri = URI.format(rla_id="1981237102937", id="02394871024938")
    else:
        context.uri = "/wrongstring"
        
@Then("I Print correct the URL")
def print_url(context):
    URL = "http://www.website.com/v1"
    print(URL + context.uri)

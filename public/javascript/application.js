

function displayOpenIdSignUp() {
	
	openIdSignInForm = "<div id='open_id_signin'>"
	openIdSignInForm +=  "<form action='/submit_open_id'>"    
  openIdSignInForm +=      "<label>"
  openIdSignInForm +=      "  Your OpenID"
  openIdSignInForm +=      "</label>"
  openIdSignInForm +=      "<input class='openid' name='open_id_input' type='text' />"
  openIdSignInForm +=      "<input type='submit' value='submit' />"
  openIdSignInForm +=    "</form>"
  openIdSignInForm +=    "<a href='#' onclick='displayRegularSignUp()'>"
  openIdSignInForm +=    "  Regular Sign In"
  openIdSignInForm +=    "</a>"
  openIdSignInForm +=  "</div>"
	
	
	
	$("#regular_signin").replaceWith(openIdSignInForm);
}

function displayRegularSignUp() {
	
	regularSignInForm = "<div id='regular_signin'>"
	regularSignInForm +=  "<form action='/authenticate' method='POST'>"          
  regularSignInForm +=     "<label>"
  regularSignInForm +=       "Your Email"
  regularSignInForm +=     "</label>"
  regularSignInForm +=     "<input name='email' type='text' />"
  regularSignInForm +=     "<br />"
  regularSignInForm +=     "<label>"
  regularSignInForm +=     "  Your Password"
  regularSignInForm +=     "</label>"
  regularSignInForm +=     "<input name='password' type='password' />"
  regularSignInForm +=     "<input type='submit' value='submit' />"
  regularSignInForm +=   "</form>"
  regularSignInForm +=   "<a href='#' onclick='displayOpenIdSignUp()'>"
  regularSignInForm +=   "  Sign In With Open ID"
  regularSignInForm +=   "</a>"
  regularSignInForm += "</div>"
	
	$("#open_id_signin").replaceWith(regularSignInForm);
}
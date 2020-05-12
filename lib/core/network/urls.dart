class Urls {
  static const bool Debug = true;
  static String getBaseURL() => Debug ? "http://127.0.0.1:8000/" : "https://api.tracery.us/";
  static String LOGIN_URL = getBaseURL() + "api/auth/token/login/";
  static String USER_URL = getBaseURL() + "api/me/";
  static String GET_VENUES = getBaseURL() + "api/venues/";
  static String getVenueForId(int id) {
    return getBaseURL() + "api/venues/" + id.toString() + "/";
  }
  static String getTimeSlotsForId(int id) {
    return getBaseURL() + "api/venues/" + id.toString() + "/timeslots/";
  }
  static String registerForTimeSlotURL(int venueId, int slotId) {
    return getBaseURL() + "api/venues/" + venueId.toString() + "/register/" + slotId.toString() + "/";
  }
  static String SEARCH_URL = getBaseURL() + "api/venues/search/";
  static String TOGGLE_LOCK_STATE = getBaseURL() + "api/me/toogle-lock/";
  static String CHECK_FOR_VENUE_SCAN = getBaseURL() + "api/me/scan/";
  static String REGISTRATIONS_URL = getBaseURL() + "api/me/registrations/";
  

  //static String MEDIA_BASE_URL = getBaseURL().substring(0, getBaseURL().length - 1);
  static String SIGNUP_URL = getBaseURL() + "api/auth/users/";
  static String PASSWORD_RESET_URL = getBaseURL() + "passwordreset/";
  static String USER_CONFIRM_ENTRY = getBaseURL() + "api/person-confirm-entry/";
  static String GET_PV_HANDSHAKES = getBaseURL() + "api/person-get-handshakes-with-venue/";
  static String SCAN_VENUE = getBaseURL() + "api/person-scan-venue/";
  static String ANON_SIGNUP = getBaseURL() + "api/open-account/";
  static String GET_ANON_USER = getBaseURL() + "api/get-privateaccount-info/";
  static String SCAN_PERSON = getBaseURL() + "api/venue-scan-person/";
  static String VENUE_CONFIRM_ENTRY = getBaseURL() + "api/venue-confirm-entry/";
  static String CHECK_FOR_PERSON_SCAN = getBaseURL() + "api/check-for-person-scan/";
}
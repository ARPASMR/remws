note
	description: "Summary description for {REMWS_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMWS_CONSTANTS

feature -- Constants

	remws_port:       INTEGER = 80
			-- remws listening port

	remws_uri:        STRING = "http://tempuri.org"
			-- remws URI

	remws_test_url:   STRING = "http://remwstest.arpa.local"
			-- remwstest URL

	remws_url:        STRING = "http://remws.arpa.local"
			-- remws URL

	authws_service_url: STRING = "Autenticazione.svc"
			-- authentication service url

	anaws_service_url:  STRING = "Anagrafica.svc"
			-- anagraphic service url

	dataws_service_url: STRING = "Dati.svc"
			-- data service url

	authws_interface: STRING = "IAutenticazione"
			-- authentication wcf interface

	anaws_interface:  STRING = "IAnagrafica"
			-- anagraphic wcf interface

	dataws_interface: STRING = "IDati"
			-- data wcf interface

	authws_url:       STRING
			-- authentication ws url
		once
			Result := remws_url + "/" + authws_service_url
		end

	anaws_url:        STRING
			-- anagraphic ws url
		once
			Result := remws_url + "/" + anaws_service_url
		end

	dataws_url:       STRING
			-- data ws url
		once
			Result := remws_url + "/" + dataws_service_url
		end

	authws_test_url:       STRING
			-- authentication testing ws url
		once
			Result := remws_test_url + "/" + authws_service_url
		end

	anaws_test_url:        STRING
			-- anagraphic testing ws url
		once
			Result := remws_test_url + "/" + anaws_service_url
		end

	dataws_test_url:       STRING
			-- data testing ws url
		once
			Result := remws_test_url + "/" + dataws_service_url
		end

end

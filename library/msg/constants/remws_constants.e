note
	description: "Summary description for {REMWS_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMWS_CONSTANTS

inherit
	INTERNAL_XML_CONSTANTS

feature -- Constants

	null:               STRING = ""
			-- NULL char / NULL string
	url_path_separator: STRING = "/"
			-- URL path separator

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
		do
			Result := remws_url + url_path_separator + authws_service_url
		end

	anaws_url:        STRING
			-- anagraphic ws url
		do
			Result := remws_url + url_path_separator + anaws_service_url
		end

	dataws_url:       STRING
			-- data ws url
		do
			Result := remws_url + url_path_separator + dataws_service_url
		end

	authws_test_url:       STRING
			-- authentication testing ws url
		do
			Result := remws_test_url + url_path_separator + authws_service_url
		end

	anaws_test_url:        STRING
			-- anagraphic testing ws url
		do
			Result := remws_test_url + url_path_separator + anaws_service_url
		end

	dataws_test_url:       STRING
			-- data testing ws url
		do
			Result := remws_test_url + url_path_separator + dataws_service_url
		end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--| REMWS endpoint names
--------------------------------------------------------------------------------

	login_endpoint_name:               STRING = "Login"
			-- REMWS Login endpoint name
	logout_endpoint_name:              STRING = "Logout"
			-- REMWS Logout endpoint name
	municipality_list_endpoint_name:   STRING = "ElencoComuni"
			-- Municipality list endpoint name
	provinces_list_endpoint_name:      STRING = "ElencoProvince"
			-- REMWS Provinces List endpoint name
	sensors_list_endpoint_name:        STRING = "ElencoSensori"
			-- REMWS Sensors List endpoint name
	sensor_types_list_endpoint_name:   STRING = "ElencoTipologieSensore"
			-- REMWS Sensor Types List endpoint name
	stations_list_endpoint_name:       STRING = "ElencoStazioni"
			-- REMWS Stations List endpoint name
	station_status_list_endpoint_name: STRING = "ElencoStatiStazione"
			-- REMWS Station Status List endpoint name
	station_types_list_endpoint_name:  STRING = "ElencoTipiStazione"
			-- REMWS Station Types List endpoint name
	standard_data_endpoint_name:       STRING = "RendiDati"
			-- REMWS Standard data endpoint name
	realtime_data_endpoint_name:       STRING = "RendiDatiTempoReale"
			-- REMWS Realtime data endpoint name
end

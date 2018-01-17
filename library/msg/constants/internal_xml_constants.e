note
	description : "Summary description for {INTERNAL_XML_CONSTANTS}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	INTERNAL_XML_CONSTANTS

inherit
	XML_MARKUP_CONSTANTS
	XML_XMLNS_CONSTANTS

feature -- Internal xml tags constants

	it_xml_id:                                STRING = "Id"
			-- Internal id xml tag constant
	it_xml_password:                          STRING = "Password"
			-- Internal Password xml tag constant
	it_xml_token_expiry:                      STRING = "Scadenza"
			-- Internal expiry tag constant
	it_xml_outcome:                           STRING = "Esito"
			-- Internal outcome tag constant
	it_xml_message:                           STRING = "Messaggio"
			-- Internal message tag constant
	it_xml_token:                             STRING = "Token"
			-- Internal Token tag constant
	it_xml_province:                          STRING = "Provincia"
			-- Internal Province tag constant
	it_xml_provinces:                         STRING = "Province"
			-- Internal Provinces tag constant
	it_xml_provinces_list:                    STRING = "ElencoProvince"
			-- Internal Provinces list tag constant
	it_xml_municipality:                      STRING = "Comune"
			-- Internal Municipality tag constant
	it_xml_municipality_name:                 STRING = "NomeComune"
			-- Internal Municipality Name tag constant
	it_xml_municipality_id:                   STRING = "IdComune"
			-- Internal Municipality iId tag constant
	it_xml_municipalities:                    STRING = "Comuni"
			-- Internal Municipalities tag constant
	it_xml_istat_code:                        STRING = "CodIstat"
			-- Internal Istat Code tag constant
	it_xml_name:                              STRING = "Nome"
			-- Internal Name tag constant
	it_xml_abbreviation:                      STRING = "Sigla"
			-- Internal Abbreviation tag constant
	it_xml_sensor:                            STRING = "Sensore"
			-- Internal Sensor tag constant
	it_xml_sensors:                           STRING = "Sensori"
			-- Internal Sensors tag constant
	it_xml_sensor_id:                         STRING = "IdSensore"
			-- Internal Sensor Id tag constant
	it_xml_sensor_name:                       STRING = "NomeSensore"
			-- Internal Sensor Name tag constant
	it_xml_function_id:                       STRING = "IdFunzione"
			-- Internal Function Id tag constat
	it_xml_operator_id:                       STRING = "IdOperatore"
			-- Internal Operator Id tag constant
	it_xml_granularity_id:                    STRING = "IdPeriodo"
			-- Internal Granularity Id tag constant
	it_xml_start_date:                        STRING = "DataInizio"
			-- Internal Start Date tag constant
	it_xml_end_date:                          STRING = "DataFine"
			-- Internal End Date tag constant
	it_xml_measure_unit:                      STRING = "UnitaMisura"
			-- Internal Measure Unit tag constant
	it_xml_data:                              STRING = "Dati"
			-- Internal Data tag constant
	it_xml_function:                          STRING = "Funzione"
			-- Internal Function data tag
	it_xml_operator:                          STRING = "Operatore"
			-- Internal Operator tag constant
	it_xml_granularity:                       STRING = "Periodo"
			-- Internal Period tag constant
	it_xml_station_id:                        STRING = "IdStazione"
			-- Internal Station Id tag constant
	it_xml_station:                           STRING = "Stazione"
			-- Internal Station tag constant
	it_xml_station_name:                      STRING = "NomeStazione"
			-- Internal Station Name tag constant
	it_xml_stations:                          STRING = "Stazioni"
			-- Internal Stations tag constant
	it_xml_address:                           STRING = "Indirizzo"
			-- Internal Address tag constant
	it_xml_altitude:                          STRING = "Quota"
			-- Internal Altitude tag constant
	it_xml_cgb_nord:                          STRING = "CGB_nord"
			-- Internal Coordinae Gauss Boaga tag constant
	it_xml_cgb_est:                           STRING = "CGB_est"
			-- Internal Coordinate Gauss Boaga tag constant
	it_xml_latitude:                          STRING = "Lat_dec"
			-- Internal Latitude decimal tag constant
	it_xml_longitude:                         STRING = "Long_dec"
			-- Internal Longitude decimal tag contant
	it_xml_sensor_type_id:                    STRING = "IdTipoSensore"
			-- Internal Sensor Type Id tag constant
	it_xml_sensor_type:                       STRING = "TipoSensore"
			-- Internal Sensor type tag constant
	it_xml_sensor_type_name:                  STRING = "NomeTipoSensore"
			-- Internal Sensor type Name tag constant
	it_xml_sensor_types_list:                 STRING = "ElencoTipologieSensore"
			-- Internal Sensore types list tag constant
	it_xml_status:                            STRING = "Stato"
			-- Internal Status tag constant
	it_xml_status_id:                         STRING = "IdStato"
			-- Internal Status Id tag constant
	it_xml_status_name:                       STRING = "NomeStato"
			-- Internal Status Name tag constant
	it_xml_station_type:                      STRING = "TipoStazione"
			-- Internal Station Type tag constant
	it_xml_station_types:                     STRING = "TipiStazione"
			-- Internal Statione types tag constant
	it_xml_station_types_list:                STRING = "ElencoTipiStazione"
			-- Internal Station types list tag constant
	it_xml_station_status:                    STRING = "StatoStazione"
			-- Internal Station Status tag constant
	it_xml_station_statuss:                   STRING = "StatiStazione"
			-- Internal Station Statuss tag constant
	it_xml_station_statuss_list:              STRING = "ElencoStatiStazione"
			-- Internal Station statuss list tag constant
	it_xml_station_type_id:                   STRING = "idTipoStazione"
			-- Internal Station Type Id tag constant
	it_xml_station_type_name:                 STRING = "NomeTipoStazione"
			-- Internal Station Type Name tag constant
	it_xml_R:                                 STRING = "R"
			-- Internal R tag constant
	it_xml_D:                                 STRING = "D"
			-- Internal D tag constant
	it_xml_V:                                 STRING = "V"
			-- Internal V tag constant
	it_xml_S:                                 STRING = "S"
			-- Internal S tag constant
	it_xml_type_id:                           STRING = "IdTipo"
			-- Internal Type Id tag constant

	-- XMLNS
	xmlns_s:                                  STRING = "s"
			-- Soap xmlns alias
	xmlns_xsi:                                STRING = "xsi"
			-- XMLSchema instance alias
	xmlns_xsd:                                STRING = "xsd"
			-- XMLSchema alias
	soap_envelope:                            STRING = "Envelope"
			-- SOAP Envelope tag
	xmlsoap:                                  STRING = "http://schemas.xmlsoap.org/soap/envelope/"
			-- SOAP Envelope schema URI
	xml_schema_instance:                      STRING = "http://www.w3.org/2001/XMLSchema-instance"
			-- XML Schema instance URI
	xml_schema:                               STRING = "http://www.w3.org/2001/XMLSchema"
			-- XML Schema URI
	body:                                     STRING = "Body"
			-- Body tag
	xelinput:                                 STRING = "xElInput"
			-- xElInput tag
	xinput:                                   STRING = "xInput"
			-- xInput

end

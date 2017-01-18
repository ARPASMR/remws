note
	description: "Summary description for {STANDARD_RESPONSES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STANDARD_RESPONSES

feature -- Standard responses xml messages

	standard_login_response: STRING = "[
		<s:Envelope xmlns:s=%"http://schemas.xmlsoap.org/soap/envelope/%">
		  <s:Body>
		    <LoginResponse xmlns=%"http://tempuri.org/%">
		      <LoginResult>
			    <LoginResponse xmlns=%"%">
			      <LoginResult>
				    <Token>
				      <Id>2DA80E3A-ED6D-424C-A047-46637A7CA4D0</Id>
					  <Scadenza>2015-10-30 15:00:00</Scadenza>
				    </Token>
				    <Esito>0</Esito>
				    <Messaggio>OK</Messaggio>
				  </LoginResult>
			    </LoginResponse>
			  </LoginResult>
		    </LoginResponse>
		  </s:Body>
		</s:Envelope>
	]"

	standard_logout_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <LogoutResponse xmlns="http://tempuri.org/">
		      <LogoutResult>
		        <LogoutResponse xmlns="">
		          <LogoutResult>
		            <Esito>0</Esito>
		            <Messaggio>Sessione chiusa con successo</Messaggio>
		          </LogoutResult>
		        </LogoutResponse>
		      </LogoutResult>
		    </LogoutResponse>
		  </s:Body>
		</s:Envelope>
	]"

	standard_station_status_list_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoStatiStazioneResponse xmlns="http://tempuri.org/">
		      <ElencoStatiStazioneResult>
		        <ElencoStatiStazioneResponse xmlns="">
		          <ElencoStatiStazioneResult>
		            <Esito>0</Esito>
		            <StatoStazione Id="1" Nome="Dismesso"/>
		            <StatoStazione Id="2" Nome="Attivo"/>
		          </ElencoStatiStazioneResult>
		        </ElencoStatiStazioneResponse>
		      </ElencoStatiStazioneResult>
		    </ElencoStatiStazioneResponse>
		  </s:Body>
		</s:Envelope>
	]"

	standard_station_types_list_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoTipiStazioneResponse xmlns="http://tempuri.org/">
		      <ElencoTipiStazioneResult>
		        <ElencoTipiStazioneResponse xmlns="">
		          <ElencoTipiStazioneResult>
		            <Esito>0</Esito>
		              <TipoStazione Id="3" Nome="Nivo"/>
		              <TipoStazione Id="1" Nome="Meteo"/>
		              <TipoStazione Id="4" Nome="Geo"/>
		              <TipoStazione Id="2" Nome="Idro"/>
		            </ElencoTipiStazioneResult>
		          </ElencoTipiStazioneResponse>
		        </ElencoTipiStazioneResult>
		      </ElencoTipiStazioneResponse>
		    </s:Body>
		  </s:Envelope>
	]"

	standard_province_list_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoProvinceResponse xmlns="http://tempuri.org/">
		      <ElencoProvinceResult>
		        <ElencoProvinceResponse xmlns="">
		          <ElencoProvinceResult>
		            <Esito>0</Esito>
		              <Provincia Sigla="CO" Nome="Como"/>
		              <Provincia Sigla="LC" Nome="Lecco"/>
		              <Provincia Sigla="SO" Nome="Sondrio"/>
		              <Provincia Sigla="BG" Nome="Bergamo"/>
		              <Provincia Sigla="BS" Nome="Brescia"/>
		            </ElencoProvinceResult>
		          </ElencoProvinceResponse>
		        </ElencoProvinceResult>
		      </ElencoProvinceResponse>
		    </s:Body>
		  </s:Envelope>
	]"

	standard_municipalities_list_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoComuniResponse xmlns="http://tempuri.org/">
		      <ElencoComuniResult>
		        <ElencoComuniResponse xmlns="">
		          <ElencoComuniResult>
		            <Esito>0</Esito>
		            <Comune Id="245" CodIstat="13155" Nome="Montemezzo" Provincia="CO"/>
		            <Comune Id="314" CodIstat="14013" Nome="Caspoggio" Provincia="SO"/>
		            <Comune Id="320" CodIstat="14019" Nome="Chiesa in Valmalenco" Provincia="SO"/>
		            <Comune Id="334" CodIstat="14033" Nome="Grosio" Provincia="SO"/>
		            <Comune Id="337" CodIstat="14036" Nome="Lanzada" Provincia="SO"/>
		            <Comune Id="346" CodIstat="14045" Nome="Morbegno" Provincia="SO"/>
		            <Comune Id="359" CodIstat="14058" Nome="San Giacomo Filippo" Provincia="SO"/>
		            <Comune Id="361" CodIstat="14060" Nome="Sondalo" Provincia="SO"/>
		            <Comune Id="362" CodIstat="14061" Nome="Sondrio" Provincia="SO"/>
		            <Comune Id="363" CodIstat="14062" Nome="Spriana" Provincia="SO"/>
		            <Comune Id="364" CodIstat="14063" Nome="Talamona" Provincia="SO"/>
		            <Comune Id="367" CodIstat="14066" Nome="Tirano" Provincia="SO"/>
		            <Comune Id="368" CodIstat="14067" Nome="Torre di Santa Maria" Provincia="SO"/>
		            <Comune Id="372" CodIstat="14071" Nome="Valdidentro" Provincia="SO"/>
		            <Comune Id="373" CodIstat="14072" Nome="Valdisotto" Provincia="SO"/>
		            <Comune Id="374" CodIstat="14073" Nome="Valfurva" Provincia="SO"/>
		            <Comune Id="378" CodIstat="14077" Nome="Villa di Chiavenna" Provincia="SO"/>
		            <Comune Id="549" CodIstat="16036" Nome="Branzi" Provincia="BG"/>
		            <Comune Id="567" CodIstat="16056" Nome="Carona" Provincia="BG"/>
		            <Comune Id="635" CodIstat="16125" Nome="Lenna" Provincia="BG"/>
		            <Comune Id="673" CodIstat="16164" Nome="Piazza Brembana" Provincia="BG"/>
		            <Comune Id="825" CodIstat="17068" Nome="Edolo" Provincia="BS"/>
		            <Comune Id="833" CodIstat="17076" Nome="Gargnano" Provincia="BS"/>
		            <Comune Id="839" CodIstat="17082" Nome="Idro" Provincia="BS"/>
		            <Comune Id="905" CodIstat="17148" Nome="Ponte di Legno" Provincia="BS"/>
		            <Comune Id="932" CodIstat="17175" Nome="Saviore dell'Adamello" Provincia="BS"/>
		            <Comune Id="938" CodIstat="17181" Nome="Sonico" Provincia="BS"/>
		            <Comune Id="1415" CodIstat="97077" Nome="Sueglio" Provincia="LC"/>
		          </ElencoComuniResult>
		        </ElencoComuniResponse>
		      </ElencoComuniResult>
		    </ElencoComuniResponse>
		  </s:Body>
		</s:Envelope>
	]"

	standard_stations_list_response: STRING
		once
			Result :=
	"[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoStazioniResponse xmlns="http://tempuri.org/">
		      <ElencoStazioniResult>
		        <ElencoStazioniResponse xmlns="">
		          <ElencoStazioniResult>
		            <Esito>0</Esito>
		            <Stazione>
		              <IdStazione>1</IdStazione>
		              <NomeStazione>Cepina</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="373" NomeComune="Valdisotto"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Cepina - Ponte  sull' Adda</Indirizzo>
		              <Quota>1125</Quota>
		              <CGB_nord>5142100</CGB_nord>
		              <CGB_est>1604150</CGB_est>
		              <Lat_dec>46.42424003</Lat_dec>
		              <Long_dec>10.35509322</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>25</Lat_min>
		              <Lat_sec>27.26410800</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>21</Long_min>
		              <Long_sec>18.33559200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>3</IdStazione>
		              <NomeStazione>Le Prese *</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="361" NomeComune="Sondalo"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Le Prese - Ponte sull' Adda</Indirizzo>
		              <Quota>950</Quota>
		              <CGB_nord>5133870</CGB_nord>
		              <CGB_est>1604270</CGB_est>
		              <Lat_dec>46.35017631</Lat_dec>
		              <Long_dec>10.35482014</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>21</Lat_min>
		              <Lat_sec>0.63471600</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>21</Long_min>
		              <Long_sec>17.35250400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>5</IdStazione>
		              <NomeStazione>Prese Adda $</NomeStazione>
		              <Stato IdStato="1" NomeStato="Dismesso"/>
		              <Comune IdComune="372" NomeComune="Valdidentro"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Premadio - Valdidentro</Indirizzo>
		              <Quota>1245</Quota>
		              <CGB_nord>5148750</CGB_nord>
		              <CGB_est>1603900</CGB_est>
		              <Lat_dec>46.48410733</Lat_dec>
		              <Long_dec>10.35332228</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>29</Lat_min>
		              <Lat_sec>2.78638800</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>21</Long_min>
		              <Long_sec>11.96020800</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>6</IdStazione>
		              <NomeStazione>Frodolfo *</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="374" NomeComune="Valfurva"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Bormio -  Ponte sul  Frodolfo</Indirizzo>
		              <Quota>1250</Quota>
		              <CGB_nord>5146669</CGB_nord>
		              <CGB_est>1605422</CGB_est>
		              <Lat_dec>46.46473208</Lat_dec>
		              <Long_dec>10.39295500</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>27</Lat_min>
		              <Lat_sec>53.03548800</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>23</Long_min>
		              <Long_sec>34.63800000</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>7</IdStazione>
		              <NomeStazione>Viola</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="372" NomeComune="Valdidentro"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Premadio</Indirizzo>
		              <Quota>1247</Quota>
		              <CGB_nord>5148550</CGB_nord>
		              <CGB_est>1603900</CGB_est>
		              <Lat_dec>46.48230797</Lat_dec>
		              <Long_dec>10.35327764</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>28</Lat_min>
		              <Lat_sec>56.30869200</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>21</Long_min>
		              <Long_sec>11.79950400</Long_sec>
		            </Stazione>
		              <Stazione>
		              <IdStazione>8</IdStazione>
		              <NomeStazione>Spriana</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="363" NomeComune="Spriana"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <TipoStazione idTipoStazione="4" NomeTipoStazione="Geo"/>
		              <Indirizzo>Spriana - Ponte sul Mallero</Indirizzo>
		              <Quota>645</Quota>
		              <CGB_nord>5118510</CGB_nord>
		              <CGB_est>1566620</CGB_est>
		              <Lat_dec>46.21671208</Lat_dec>
		              <Long_dec>9.86339675</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>13</Lat_min>
		              <Lat_sec>0.16348800</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>51</Long_min>
		              <Long_sec>48.22830000</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>9</IdStazione>
		              <NomeStazione>Sondrio  *</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="362" NomeComune="Sondrio"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo> Sondrio - Ponte Eifell</Indirizzo>
		              <Quota>300</Quota>
		              <CGB_nord>5113150</CGB_nord>
		              <CGB_est>1566730</CGB_est>
		              <Lat_dec>46.16846717</Lat_dec>
		              <Long_dec>9.86406531</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>10</Lat_min>
		              <Lat_sec>6.48181200</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>51</Long_min>
		              <Long_sec>50.63511600</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>10</IdStazione>
		              <NomeStazione>Aquilone</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="373" NomeComune="Valdisotto"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Valdisotto</Indirizzo>
		              <Quota>1078</Quota>
		              <CGB_nord>5138800</CGB_nord>
		              <CGB_est>1604160</CGB_est>
		              <Lat_dec>46.40085567</Lat_dec>
		              <Long_dec>10.35386336</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>24</Lat_min>
		              <Lat_sec>3.08041200</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>21</Long_min>
		              <Long_sec>13.90809600</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>12</IdStazione>
		              <NomeStazione>Arnoga</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="372" NomeComune="Valdidentro"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <Indirizzo>Arnoga </Indirizzo>
		              <Quota>1880</Quota>
		              <CGB_nord>5145762</CGB_nord>
		              <CGB_est>1595301</CGB_est>
		              <Lat_dec>46.45882331</Lat_dec>
		              <Long_dec>10.24200594</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>27</Lat_min>
		              <Lat_sec>31.76391600</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>14</Long_min>
		              <Long_sec>31.22138400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>13</IdStazione>
		              <NomeStazione>Cancano *</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="372" NomeComune="Valdidentro"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Cancano  </Indirizzo>
		              <Quota>1948</Quota>
		              <CGB_nord>5152074</CGB_nord>
		              <CGB_est>1601043</CGB_est>
		              <Lat_dec>46.51444775</Lat_dec>
		              <Long_dec>10.31683275</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>30</Lat_min>
		              <Lat_sec>52.01190000</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>19</Long_min>
		              <Long_sec>0.59790000</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>14</IdStazione>
		              <NomeStazione>S.Caterina Valfurva</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="374" NomeComune="Valfurva"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>S. Caterina Valfurva</Indirizzo>
		              <Quota>1730</Quota>
		              <CGB_nord>5140950</CGB_nord>
		              <CGB_est>1614900</CGB_est>
		              <Lat_dec>46.41214997</Lat_dec>
		              <Long_dec>10.49466533</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>24</Lat_min>
		              <Lat_sec>43.73989200</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>29</Long_min>
		              <Long_sec>40.79518800</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>16</IdStazione>
		              <NomeStazione>Forni *</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="374" NomeComune="Valfurva"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Ghiacciaio dei Forni</Indirizzo>
		              <Quota>2180</Quota>
		              <CGB_nord>5142000</CGB_nord>
		              <CGB_est>1619550</CGB_est>
		              <Lat_dec>46.42078875</Lat_dec>
		              <Long_dec>10.55541386</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>25</Lat_min>
		              <Lat_sec>14.83950000</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>33</Long_min>
		              <Long_sec>19.48989600</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>23</IdStazione>
		              <NomeStazione>S.Giuseppe</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="320" NomeComune="Chiesa in Valmalenco"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <Indirizzo>Sabbionaccio - S.Giuseppe</Indirizzo>
		              <Quota>1428</Quota>
		              <CGB_nord>5128550</CGB_nord>
		              <CGB_est>1563870</CGB_est>
		              <Lat_dec>46.30732511</Lat_dec>
		              <Long_dec>9.82910964</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>18</Lat_min>
		              <Lat_sec>26.37039600</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>49</Long_min>
		              <Long_sec>44.79470400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>26</IdStazione>
		              <NomeStazione>Torreggio 1/B</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="368" NomeComune="Torre di Santa Maria"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <TipoStazione idTipoStazione="4" NomeTipoStazione="Geo"/>
		              <Indirizzo>Val  Torreggio - Zona B</Indirizzo>
		              <Quota>1350</Quota>
		              <CGB_nord>5120853</CGB_nord>
		              <CGB_est>1564154</CGB_est>
		              <Lat_dec>46.23747700</Lat_dec>
		              <Long_dec>9.82666836</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>14</Lat_min>
		              <Lat_sec>14.91720000</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>49</Long_min>
		              <Long_sec>36.00609600</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>27</IdStazione>
		              <NomeStazione>Alpe dell' Oro</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="320" NomeComune="Chiesa in Valmalenco"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Alpe dell'Oro - Chiesa Valmalenco</Indirizzo>
		              <Quota>2040</Quota>
		              <CGB_nord>5130070</CGB_nord>
		              <CGB_est>1558770</CGB_est>
		              <Lat_dec>46.32146572</Lat_dec>
		              <Long_dec>9.76307569</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>19</Lat_min>
		              <Lat_sec>17.27659200</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>45</Long_min>
		              <Long_sec>47.07248400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>28</IdStazione>
		              <NomeStazione>Alpe Entova</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="320" NomeComune="Chiesa in Valmalenco"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <Indirizzo>Alpe Entova - Chiesa Valmalenco</Indirizzo>
		              <Quota>1905</Quota>
		              <CGB_nord>5130120</CGB_nord>
		              <CGB_est>1564240</CGB_est>
		              <Lat_dec>46.32141817</Lat_dec>
		              <Long_dec>9.83412892</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>19</Lat_min>
		              <Lat_sec>17.10541200</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>50</Long_min>
		              <Long_sec>2.86411200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>29</IdStazione>
		              <NomeStazione>Funivia Bernina</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="320" NomeComune="Chiesa in Valmalenco"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Alpe Palù</Indirizzo>
		              <Quota>2014</Quota>
		              <CGB_nord>5126820</CGB_nord>
		              <CGB_est>1566580</CGB_est>
		              <Lat_dec>46.29149606</Lat_dec>
		              <Long_dec>9.86405350</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>17</Lat_min>
		              <Lat_sec>29.38581600</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>51</Long_min>
		              <Long_sec>50.59260000</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>30</IdStazione>
		              <NomeStazione>Campo Moro</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="337" NomeComune="Lanzada"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Diga Campo Moro </Indirizzo>
		              <Quota>1970</Quota>
		              <CGB_nord>5128460</CGB_nord
		              ><CGB_est>1571450</CGB_est>
		              <Lat_dec>46.30575733</Lat_dec>
		              <Long_dec>9.92752017</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>18</Lat_min>
		              <Lat_sec>20.72638800</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>55</Long_min>
		              <Long_sec>39.07261200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>33</IdStazione>
		              <NomeStazione>Ganda</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="337" NomeComune="Lanzada"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Ganda di Lanzada</Indirizzo>
		              <Quota>988</Quota>
		              <CGB_nord>5124482</CGB_nord>
		              <CGB_est>1568329</CGB_est>
		              <Lat_dec>46.27199375</Lat_dec>
		              <Long_dec>9.88399247</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>16</Lat_min>
		              <Lat_sec>19.17750000</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>53</Long_min>
		              <Long_sec>2.37289200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>35</IdStazione>
		              <NomeStazione>Piazzo Cavalli</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="314" NomeComune="Caspoggio"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Piazzo Cavalli </Indirizzo
		              ><Quota>1719</Quota>
		              <CGB_nord>5122202</CGB_nord>
		              <CGB_est>1567167</CGB_est>
		              <Lat_dec>46.25003919</Lat_dec>
		              <Long_dec>9.87163947</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>15</Lat_min>
		              <Lat_sec>0.14108400</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>52</Long_min>
		              <Long_sec>17.90209200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>45</IdStazione>
		              <NomeStazione>Ruinon - Valfurva - RTU 206</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="374" NomeComune="Valfurva"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="4" NomeTipoStazione="Geo"/>
		              <Indirizzo>Ruinon </Indirizzo>
		              <Quota>2140</Quota>
		              <CGB_nord>5144362</CGB_nord>
		              <CGB_est>1612362</CGB_est>
		              <Lat_dec>46.44327281</Lat_dec>
		              <Long_dec>10.46247483</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>26</Lat_min>
		              <Lat_sec>35.78211600</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>27</Long_min>
		              <Long_sec>44.90938800</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>46</IdStazione>
		              <NomeStazione>Monte Trela </NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="372" NomeComune="Valdidentro"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Valdidentro</Indirizzo>
		              <Quota>2300</Quota>
		              <CGB_nord>5150281</CGB_nord>
		              <CGB_est>1597244</CGB_est>
		              <Lat_dec>46.50284200</Lat_dec>
		              <Long_dec>10.26736600</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>29</Lat_min>
		              <Lat_sec>55.95421200</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>16</Long_min>
		              <Long_sec>1.01539200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>49</IdStazione>
		              <NomeStazione>Morbegno</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="346" NomeComune="Morbegno"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Morbegno - Ponte ferroviario</Indirizzo>
		              <Quota>242</Quota>
		              <CGB_nord>5109392</CGB_nord>
		              <CGB_est>1543456</CGB_est>
		              <Lat_dec>46.13781903</Lat_dec>
		              <Long_dec>9.55109633</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>8</Lat_min>
		              <Lat_sec>16.14850800</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>33</Long_min>
		              <Long_sec>3.94678800</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>51</IdStazione>
		              <NomeStazione>Tirano</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="367" NomeComune="Tirano"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Madonna di Tirano</Indirizzo>
		              <Quota>438</Quota>
		              <CGB_nord>5118836</CGB_nord>
		              <CGB_est>1588971</CGB_est>
		              <Lat_dec>46.21708825</Lat_dec>
		              <Long_dec>10.15318792</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>13</Lat_min>
		              <Lat_sec>1.51770000</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>9</Long_min>
		              <Long_sec>11.47651200</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>52</IdStazione>
		              <NomeStazione>Grosio</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="334" NomeComune="Grosio"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		              <Indirizzo>Eita- Diga  AEM</Indirizzo>
		              <Quota>1220</Quota>
		              <CGB_nord>5131164</CGB_nord>
		              <CGB_est>1595936</CGB_est>
		              <Lat_dec>46.32706200</Lat_dec>
		              <Long_dec>10.24598119</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>19</Lat_min>
		              <Lat_sec>37.42320000</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>14</Long_min>
		              <Long_sec>45.53228400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>53</IdStazione>
		              <NomeStazione>Piazza Brembana</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="673" NomeComune="Piazza Brembana"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Ponte dei Fondi - Brembo di Mezzoldo</Indirizzo>
		              <Quota>485</Quota>
		              <CGB_nord>5088360</CGB_nord>
		              <CGB_est>1551742</CGB_est>
		              <Lat_dec>45.94667586</Lat_dec>
		              <Long_dec>9.66723664</Long_dec>
		              <Lat_gradi>45</Lat_gradi>
		              <Lat_min>56</Lat_min>
		              <Lat_sec>48.03309600</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>40</Long_min>
		              <Long_sec>2.05190400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>54</IdStazione>
		              <NomeStazione>Lenna</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="635" NomeComune="Lenna"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Pontechiarello - Brembo di Carona</Indirizzo>
		              <Quota>485</Quota>
		              <CGB_nord>5088248</CGB_nord>
		              <CGB_est>1553840</CGB_est>
		              <Lat_dec>45.94550661</Lat_dec>
		              <Long_dec>9.69429044</Long_dec>
		              <Lat_gradi>45</Lat_gradi>
		              <Lat_min>56</Lat_min>
		              <Lat_sec>43.82379600</Lat_sec>
		              <Long_gradi>9</Long_gradi>
		              <Long_min>41</Long_min>
		              <Long_sec>39.44558400</Long_sec>
		            </Stazione>
		            <Stazione>
		              <IdStazione>55</IdStazione>
		              <NomeStazione>Edolo</NomeStazione>
		              <Stato IdStato="2" NomeStato="Attivo"/>
		              <Comune IdComune="825" NomeComune="Edolo"/>
		              <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		              <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		              <Indirizzo>Parnigò</Indirizzo>
		              <Quota>655</Quota>
		              <CGB_nord>5114270</CGB_nord>
		              <CGB_est>1601543</CGB_est>
		              <Lat_dec>46.17424525</Lat_dec>
		              <Long_dec>10.31516333</Long_dec>
		              <Lat_gradi>46</Lat_gradi>
		              <Lat_min>10</Lat_min>
		              <Lat_sec>27.28290000</Lat_sec>
		              <Long_gradi>10</Long_gradi>
		              <Long_min>18</Long_min>
		              <Long_sec>54.58798800</Long_sec>
		            </Stazione>
		            <Stazione>
		             <IdStazione>56</IdStazione>
		             <NomeStazione>Ponte di Legno</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="905" NomeComune="Ponte di Legno"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		             <Indirizzo>Centro paese -Corso Trieste</Indirizzo>
		             <Quota>1265</Quota>
		             <CGB_nord>5124214</CGB_nord>
		             <CGB_est>1616466</CGB_est>
		             <Lat_dec>46.26228019</Lat_dec>
		             <Long_dec>10.51018114</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>15</Lat_min>
		             <Lat_sec>44.20868400</Lat_sec>
		             <Long_gradi>10</Long_gradi>
		             <Long_min>30</Long_min>
		             <Long_sec>36.65210400</Long_sec>
		           </Stazione>
		           <Stazione>
		             <IdStazione>57</IdStazione>
		             <NomeStazione>Branzi</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="549" NomeComune="Branzi"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		             <Indirizzo>Branzi</Indirizzo>
		             <Quota>830</Quota>
		             <CGB_nord>5094555</CGB_nord>
		             <CGB_est>1558806</CGB_est>
		             <Lat_dec>46.00185828</Lat_dec>
		             <Long_dec>9.75913061</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>0</Lat_min>
		             <Lat_sec>6.68980800</Lat_sec>
		             <Long_gradi>9</Long_gradi>
		             <Long_min>45</Long_min>
		             <Long_sec>32.87019600</Long_sec>
		           </Stazione>
		           <Stazione>
		             <IdStazione>58</IdStazione>
		             <NomeStazione>Carona</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="567" NomeComune="Carona"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		             <Indirizzo>Lago Fregabolgia</Indirizzo>
		             <Quota>1955</Quota>
		             <CGB_nord>5097147</CGB_nord>
		             <CGB_est>1566826</CGB_est>
		             <Lat_dec>46.02444861</Lat_dec>
		             <Long_dec>9.86305936</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>1</Lat_min>
		             <Lat_sec>28.01499600</Lat_sec>
		             <Long_gradi>9</Long_gradi>
		             <Long_min>51</Long_min>
		             <Long_sec>47.01369600</Long_sec>
		           </Stazione>
		           <Stazione>
		             <IdStazione>59</IdStazione>
		             <NomeStazione>Rifugio Lissone</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="932" NomeComune="Saviore dell'Adamello"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		             <Indirizzo>Rifugio Lissone -Saviore dell' Adamello</Indirizzo>
		             <Quota>2017</Quota>
		             <CGB_nord>5104429</CGB_nord>
		             <CGB_est>1615710</CGB_est>
		             <Lat_dec>46.08344458</Lat_dec>
		             <Long_dec>10.49623769</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>5</Lat_min>
		             <Lat_sec>0.40048800</Lat_sec>
		             <Long_gradi>10</Long_gradi>
		             <Long_min>29</Long_min>
		             <Long_sec>46.45568400</Long_sec>
		           </Stazione>
		           <Stazione>
		             <IdStazione>60</IdStazione>
		             <NomeStazione>Villa di Chiavenna</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="378" NomeComune="Villa di Chiavenna"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="2" NomeTipoStazione="Idro"/>
		             <Indirizzo>Dogana - Fiume Mera</Indirizzo>
		             <Quota>665</Quota>
		             <CGB_nord>5131084</CGB_nord>
		             <CGB_est>1539437</CGB_est>
		             <Lat_dec>46.33199472</Lat_dec>
		             <Long_dec>9.51204364</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>19</Lat_min>
		             <Lat_sec>55.18099200</Lat_sec>
		             <Long_gradi>9</Long_gradi>
		             <Long_min>30</Long_min>
		             <Long_sec>43.35710400</Long_sec>
		           </Stazione>
		           <Stazione>
		             <IdStazione>61</IdStazione>
		             <NomeStazione>Arginone</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="373" NomeComune="Valdisotto"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="3" NomeTipoStazione="Nivo"/>
		             <Indirizzo>Arginone -Val Pola</Indirizzo>
		             <Quota>1050</Quota>
		             <CGB_nord>5137670</CGB_nord>
		             <CGB_est>1604141</CGB_est>
		             <Lat_dec>46.38438486</Lat_dec>
		             <Long_dec>10.35398908</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>23</Lat_min>
		             <Lat_sec>3.78549600</Lat_sec>
		             <Long_gradi>10</Long_gradi>
		             <Long_min>21</Long_min>
		             <Long_sec>14.36068800</Long_sec>
		           </Stazione>
	]" -- Avoid manifest string limit of 32767 characters.
	+ "[		           
		           <Stazione>
		             <IdStazione>63</IdStazione>
		             <NomeStazione>Gera Lario</NomeStazione>
		             <Stato IdStato="2" NomeStato="Attivo"/>
		             <Comune IdComune="245" NomeComune="Montemezzo"/>
		             <TipoStazione idTipoStazione="1" NomeTipoStazione="Meteo"/>
		             <TipoStazione idTipoStazione="4" NomeTipoStazione="Geo"/>
		             <Indirizzo>Madonnina Macialli - Montemezzo</Indirizzo>
		             <Quota>680</Quota>
		             <CGB_nord>5114243</CGB_nord>
		             <CGB_est>1527770</CGB_est>
		             <Lat_dec>46.17606386</Lat_dec>
		             <Long_dec>9.31966697</Long_dec>
		             <Lat_gradi>46</Lat_gradi>
		             <Lat_min>10</Lat_min>
		             <Lat_sec>33.82989600</Lat_sec>
		             <Long_gradi>9</Long_gradi>
		             <Long_min>19</Long_min>
		             <Long_sec>10.80109200</Long_sec>
		           </Stazione>
		         </ElencoStazioniResult>
		       </ElencoStazioniResponse>
		     </ElencoStazioniResult>
		   </ElencoStazioniResponse>
	     </s:Body>
	   </s:Envelope>
	]"
	end

	standard_sensor_types_list_response: STRING = "[
		<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
		  <s:Body>
		    <ElencoTipologieSensoreResponse xmlns="http://tempuri.org/">
		      <ElencoTipologieSensoreResult>
		        <ElencoTipologieSensoreResponse xmlns="">
		          <ElencoTipologieSensoreResult>
		            <Esito>0</Esito>
		            <TipoSensore IdTipoSensore="4" NomeTipoSensore="Altezza Neve"/>
		            <TipoSensore IdTipoSensore="72" NomeTipoSensore="Coordinate UTM Est."/>
		            <TipoSensore IdTipoSensore="73" NomeTipoSensore="Coordinate UTM Nord"/>
		            <TipoSensore IdTipoSensore="74" NomeTipoSensore="Coordinate UTM Quota"/>
		            <TipoSensore IdTipoSensore="10" NomeTipoSensore="Direzione Vento"/>
		            <TipoSensore IdTipoSensore="71" NomeTipoSensore="Distometri"/>
		            <TipoSensore IdTipoSensore="7" NomeTipoSensore="Estensimetro"/>
		            <TipoSensore IdTipoSensore="1" NomeTipoSensore="Livello Idrometrico"/>
		            <TipoSensore IdTipoSensore="8" NomeTipoSensore="Piezometro"/>
		            <TipoSensore IdTipoSensore="2" NomeTipoSensore="Precipitazione"/>
		            <TipoSensore IdTipoSensore="3" NomeTipoSensore="Temperatura"/>
		            <TipoSensore IdTipoSensore="11" NomeTipoSensore="Umidità Relativa"/>
		            <TipoSensore IdTipoSensore="9" NomeTipoSensore="Velocità Vento"/>
		          </ElencoTipologieSensoreResult>
		        </ElencoTipologieSensoreResponse>
		      </ElencoTipologieSensoreResult>
		    </ElencoTipologieSensoreResponse>
		  </s:Body>
		</s:Envelope>
	]"

end

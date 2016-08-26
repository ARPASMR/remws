SELECT s.IDstazione,
       s.Nomestazione,
       s.IDrete,
       r.NOMErete,
       se.* 
FROM `A_Stazioni` s inner join A_Reti r 
on s.IDrete = r.IDrete
  inner join A_Sensori se
    on s.IDstazione = se.IDstazione
where s.IDrete = 1 or s.IDrete = 2 or s.IDrete = 4

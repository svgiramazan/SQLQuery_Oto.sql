CREATE TABLE arc (
    aracno INT PRIMARY KEY IDENTITY(1,1),
    model VARCHAR(50),
    marka VARCHAR(50),
    plaka VARCHAR(20),
    fiyat DECIMAL(10,2),
	yil date
);

CREATE TABLE musteri (
    mno INT PRIMARY KEY IDENTITY(1,1),
    madi VARCHAR(50),
    msoyadi VARCHAR(50),
    madres VARCHAR(100),
    mtelefon VARCHAR(20)
);

CREATE TABLE satis (
    satno INT PRIMARY KEY IDENTITY(1,1),
    mno INT,
    aracno INT,
    sat_tarih DATE,
    sfiyat DECIMAL(10,2),
    FOREIGN KEY (mno) REFERENCES musteri(mno),
    FOREIGN KEY (aracno) REFERENCES arc(aracno)
);

CREATE TABLE alim (
    alimno INT PRIMARY KEY IDENTITY(1,1),
    mno INT,
    aracno INT,
    alim_tarih DATE,
    afiyat DECIMAL(10,2),
    FOREIGN KEY (mno) REFERENCES musteri(mno),
    FOREIGN KEY (aracno) REFERENCES arc(aracno)
);
INSERT INTO arc (model, marka, plaka, fiyat, yil) VALUES
('Marea', 'Fiat', '60 TT 6060', 16000, '2006'),
('Megane', 'Renault', '60 TT 6061', 14000, '2012'),
('Focus', 'Ford', '60 TT 6062', 28000, '2014'),
('Golf', 'Volkswagen', '60 TT 6063', 26000, '1999'),
('Astra', 'Opel', '60 TT 6064', 9000, '2014'),
('Marea', 'Fiat', '60 TT 6065', 50000, '2020');

-- Müþteri Tablosu
INSERT INTO musteri (madi, msoyadi, madres, mtelefon) VALUES
('Turgut', 'Özseven', 'Turhal/Tokat', '03562222222'),
('Mustafa', 'Çaðlayan', 'Meram/Konya', '05112111111'),
('Ahmet', 'Kara', 'Zile/Tokat', '03563333333'),
('Murat', 'Beyaz', NULL, '03565555555'),
('Elif', 'Kurt', 'Beþiktaþ/Ýstanbul', '05781471414'),
('Ayþe', 'Uçar', NULL, '03586666666'),
('Bülent', 'Ayar', 'Selçuklu/Konya', '03568888888');

-- Satýþ Tablosu
INSERT INTO satis (mno, aracno, sat_tarih, sfiyat) VALUES
(1, 1, '2010-05-04', 17000),
(4, 5, '2010-06-01', 11500),
(7, 4, '2010-06-15', 27000),
(2, 1, '2010-07-02', 17500);

-- Alým Tablosu
INSERT INTO alim (mno, aracno, alim_tarih, afiyat) VALUES
(1, 3, '2010-02-08', 15000),
(6, 1, '2010-04-12', 15500),
(2, 5, '2010-04-15', 9500),
(1, 2, '2010-05-15', 14000),
(5, 3, '2010-08-22', 26000);
-- a) Modeli Megane olan araçlarýn model, marka ve fiyat bilgilerini bulunuz.
SELECT model, marka, fiyat
FROM arc
WHERE model = 'Megane';

-- b) 01.05.2010 tarihinden sonra 10,000 TL'den daha fazla fiyata yapýlan satýþlarý listeleyiniz.
SELECT *
FROM satis
WHERE sat_tarih > '2010-05-01' AND sfiyat > 10000;

-- c) Adýnýn içerisinde "I" karakteri geçen ve adresi "Turhal ilçesi olan müþterileri listeleyiniz.
SELECT *
FROM musteri
WHERE madi LIKE '%L%' AND madres LIKE '%Turhal%';

-- d) Fiat veya Opel marka ve liste fiyatý 10000'den az olan araçlarýn aracno, marka, model, plaka ve fiyat bilgilerini listeleyiniz.
SELECT aracno, marka, model, plaka, fiyat
FROM arc
WHERE (marka = 'Fiat' OR marka = 'Opel') AND fiyat < 10000;

-- e) Alýþ fiyatý 15000 TL'den fazla olan araçlarý yýlýna göre azalan sýrada sýralayýnýz.
SELECT *
FROM alim
INNER JOIN arc ON alim.aracno = arc.aracno
WHERE afiyat > 15000
ORDER BY alim_tarih DESC;

-- f) 7 yaþýndan büyük olan araçlarý en pahalýdan ucuza doðru listeleyiniz.
SELECT *
FROM arc
WHERE DATEDIFF(YEAR,yil, GETDATE()) > 7
ORDER BY fiyat DESC;


-- g) Liste fiyatý 5000 TL ilfghe 10000 TL arasýnda olan araçlarý fiyatlarýna göre küçükten büyüðe sýralayýnýz.
SELECT *
FROM arc
WHERE fiyat BETWEEN 5000 AND 10000
ORDER BY fiyat;

-- h) Müþteri ili "T" ile baþlayan müþterilerin illerini büyükten küçüðe doðru sýralayýnýz.
SELECT *
FROM musteri
WHERE LEFT(madres, 1) = 'T'
ORDER BY madres DESC;

-- i) "K" harfi ile baþlayan ve "a" harfi ile biten þehirlerde ikamet eden müþterilerin isimlerini ve telefon numaralarýný listeleyiniz.
SELECT madi, mtelefon
FROM musteri
WHERE madres LIKE 'K%a';

-- j) Tüm arabalarýn satýþ fiyatýna %10 KDV ekleyip KDV dahil fiyatýný bulan sorguyu yazýnýz.
SELECT aracno, (sfiyat * 1.1) AS kdv_dahil_fiyat
FROM satis;

-- k) Adresi girilmemiþ müsterilerin adýna göre artan sýrada sýralayan sorguyu yazýnýz.
SELECT *
FROM musteri
WHERE madres IS NULL
ORDER BY madi ASC;
--1.	Turgut Özseven'e satýlan aracýn aynýsýndan baþka hangi müþterilere satýldýðýný bulmak için 
SELECT musteri.madi, musteri.msoyadi
FROM satis
JOIN musteri ON satis.mno = musteri.mno
WHERE satis.aracno = (SELECT aracno FROM satis WHERE mno = (SELECT mno FROM musteri WHERE madi = 'Turgut' AND msoyadi = 'Özseven'));
--2.	Satýþý yapýlan araçlarýn bilgilerini listelemek için 
SELECT arc.*
FROM satis
JOIN arc ON satis.aracno = arc.aracno;

--3.	Satýþ tutarý alým tutarýndan düþük olan araçlarý listelemek için 
SELECT arc.*
FROM satis
JOIN arc ON satis.aracno = arc.aracno
WHERE satis.sfiyat < (SELECT afiyat FROM alim WHERE alim.aracno = arc.aracno);

--4.	Opel marka araç için yapýlan satýþlarýn ve alýmlarýn hangi müþterilerle yapýldýðýný bulmak için 
SELECT madi, msoyadi
FROM musteri
WHERE mno IN (SELECT mno FROM satis WHERE aracno IN (SELECT aracno FROM arc WHERE marka = 'Opel'))
OR mno IN (SELECT mno FROM alim WHERE aracno IN (SELECT aracno FROM arc WHERE marka = 'Opel'));

--5.	Fiyatý 20.000'den yüksek olan araçlarýn hangi fiyata satýldýðýný bulmak için 
SELECT sfiyat
FROM satis
WHERE aracno IN (SELECT aracno FROM arc WHERE fiyat > 20000);

--6.	Turhal ve Amasya'ya yapýlan satýþlarýn toplam tutarýný azalan sýrada listelemek için 
SELECT madres, SUM(sfiyat) AS toplam_tutar
FROM satis
JOIN musteri ON satis.mno = musteri.mno
WHERE madres IN ('Turhal', 'Amasya')
GROUP BY madres
ORDER BY toplam_tutar DESC;

--7.	Satýþ veya alým yapýlmayan müþterilerin bilgilerini listelemek için 
SELECT *
FROM musteri
WHERE mno NOT IN (SELECT DISTINCT mno FROM satis)
AND mno NOT IN (SELECT DISTINCT mno FROM alim);

--8.	5 ve 6. ayda yapýlan satýþlarýn kimlere yapýldýðýný bulmak için 
SELECT madi, msoyadi
FROM musteri
WHERE mno IN (SELECT mno FROM satis WHERE MONTH(sat_tarih) IN (5, 6));

--9.	Alýmý yapýlan fakat satýþý yapýlmayan araçlarý listelemek için 
SELECT arc.*
FROM alim
JOIN arc ON alim.aracno = arc.aracno
WHERE alim.aracno NOT IN (SELECT aracno FROM satis);

--10.	Ayný marka araç alan müþterileri ve aldýðý araç markasýný listelemek için 
SELECT musteri.madi, musteri.msoyadi, arc.marka
FROM alim
JOIN musteri ON alim.mno = musteri.mno
JOIN arc ON alim.aracno = arc.aracno
WHERE arc.marka = (SELECT marka FROM arc WHERE aracno = alim.aracno);

--11.	En yüksek fiyata satýlan aracýn marka, fiyat ve kime satýldýðý bilgisini listelemek için 
SELECT arc.marka, MAX(satis.sfiyat) AS en_yuksek_fiyat, musteri.madi, musteri.msoyadi
FROM satis
JOIN arc ON satis.aracno = arc.aracno
JOIN musteri ON satis.mno = musteri.mno
WHERE satis.sfiyat = (SELECT MAX(sfiyat) FROM satis)
GROUP BY arc.marka, musteri.madi, musteri.msoyadi;

--12.	Araçlarýn ortalama satýþ tutarýndan daha yüksek fiyata satýlan araçlarý listelemek için 
SELECT arc.*
FROM satis
JOIN arc ON satis.aracno = arc.aracno
WHERE satis.sfiyat > (SELECT AVG(sfiyat) FROM satis);

create database virtual_art_gallery

--CREATION OF ARTISTS TABLE
CREATE TABLE Artists (
 ArtistID INT IDENTITY PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

 --INSERT THE VALUES IN ARTISTS TABLE
 INSERT INTO Artists ( Name, Biography, Nationality) VALUES
 ( 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 ( 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 ( 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

 SELECT *FROM ARTISTS


 --CREATION OF CATEGORIES TABLE
 CREATE TABLE Categories (
 CategoryID INT IDENTITY PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

 --INSERTION OF CATEGORIES TABLE
 INSERT INTO Categories ( Name) VALUES
 ( 'Painting'),
 ( 'Sculpture'),
 ( 'Photography');

 SELECT*FROM CATEGORIES


 --CREATION OF ARTWORKS TABLE
 CREATE TABLE Artworks (
 ArtworkID INT IDENTITY PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

-- INSERTION OF ARTWORKS TABLE
INSERT INTO Artworks (Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 ('Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 ('Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 ('Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');




 --CREATION OF EXHIBITIONS TABLE
 CREATE TABLE Exhibitions (
 ExhibitionID INT IDENTITY PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);
-- INSERTION OF EXHIBITIONS TABLE
INSERT INTO Exhibitions (Title, StartDate, EndDate, Description) VALUES
 ('Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 ('Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

 --CREATION OF EXHIBITION ARTWORKS
 CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

 --INSERT THE VALUES IN EXHIBITION ARTWORKS
 INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

 SELECT *FROM Artists
  SELECT *FROM Artworks
   SELECT *FROM Categories
    SELECT *FROM ExhibitionArtworks
	 SELECT *FROM Exhibitions
----------------------------------------------------------
--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and
--list them in descending order of the number of artworks.SELECT a.Name AS ArtistName, COUNT(ar.ArtworkID) AS ArtworkCount
FROM Artists as a
JOIN Artworks  as ar ON a.ArtistID = ar.ArtistID
GROUP BY a.Name
ORDER BY ArtworkCount DESC;


--2.List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order
--them by the year in ascending order.SELECT *FROM Artists
  SELECT *FROM Artworksselect a. title,a.year
from artworks as a
join Artists as ar on ar.ArtistID=a.ArtistID
where ar.Nationality in ('spanish','dutch')
order by a.Year asc;

--3.Find the names of all artists who have artworks in the 'Painting' category, and the number of
--artworks they have in this category.
SELECT a.Name AS ArtistName, COUNT(ar.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks ar ON a.ArtistID = ar.ArtistID
JOIN Categories c ON ar.CategoryID = c.CategoryID
WHERE c.Name = 'Painting'
GROUP BY a.Name


--4.List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their
--artists and categories. select 
 ar.Title,a.Name,c.Name
 from ExhibitionArtworks ea
 join Artworks ar on ea.ArtworkID=ar.ArtworkID
 join artists a on ar.artistId=a.artistId
 join Categories c on ar.CategoryID=c.CategoryID
 join Exhibitions e on e.ExhibitionID=e.ExhibitionID
 where e.title='Modern Art Masterpieces'

--5.Find the artists who have more than two artworks in the gallery select a.Name 
 from artists a
 join Artworks ar
 on a.ArtistID=ar.ArtistID
 group by a.Name
 having count(ar.artworkId)>2;


--6.Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and
--'Renaissance Art' exhibitions
SELECT ar.Title AS ArtworkTitle
FROM Artworks ar
JOIN Artists a ON ar.ArtistID = a.ArtistID
JOIN Categories c ON ar.CategoryID = c.CategoryID
WHERE EXISTS (
    SELECT 1
    FROM ExhibitionArtworks ea
    JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
    WHERE ea.ArtworkID = ar.ArtworkID
    AND e.Title = 'Modern Art Masterpieces'
);


--7.. Find the total number of artworks in each category
SELECT c.Name AS CategoryName, COUNT(ar.ArtworkID) AS ArtworkCount
FROM Categories c
JOIN Artworks ar ON c.CategoryID = ar.CategoryID
GROUP BY c.Name;

--8.List artists who have more than 3 artworks in the gallery
select a.Name as ArtistName
from Artists a
join Artworks ar
on a.ArtistID=ar.ArtistID
group by
a.Name 
having count(ar.ArtworkID)>3

--9.Find the artworks created by artists from a specific nationality (e.g., Spanish).select ar.title from Artworks arjoin Artists as a on ar.ArtistID=a.ArtistIDjoin Categories as c on ar.CategoryID=c.CategoryIDwhere a.Nationality='spanish'--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.select e.Title
from Exhibitions e
join ExhibitionArtworks ea on e.ExhibitionID=ea.ExhibitionID
join Artworks ar on ea.ArtworkID=ar.ArtworkID
join Artists a on ar.artistId =a.ArtistID
where a.Name='Vincent van Gogh' or a.Name='Leonardo da Vinci'
group by e.title 
having count(distinct a.Name)=2;


--11. Find all the artworks that have not been included in any exhibition.select ar.Title
from Artworks ar
left join ExhibitionArtworks ea on ar.ArtworkID=ea.ArtworkID
where ea.ExhibitionID is null;
--12.List artists who have created artworks in all available categories.select a.name as artistname
from artists as a
join artworks as ar on a.artistid=ar.ArtistID
join Categories as c on ar.CategoryID=c.CategoryID
group by a.name
having count(ar.categoryID)=(select count(*)from Categories)

--13.List the total number of artworks in each category.
select c.name as categoryName,count(ar.artworkID)as artworkcount
from Categories as c
join Artworks as ar on c.CategoryID=ar.CategoryID
group by c.name

--14.Find the artists who have more than 2 artworks in the gallery.

select a.Name
from Artists a
join Artworks ar on a.artistId=ar.ArtistID
group by a.Name
having count(ar.artworkId)>2;

--15.List the categories with the average year of artworks they contain, only for categories with more
--than 1 artwork.select c.Name,avg(ar.year) as [Year]
from categories c
join Artworks ar
on c.CategoryID=ar.CategoryID
group by c.Name
having count(ar.artWorkId)>1;--16.Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.select ar.Title
from ExhibitionArtworks ea
join Artworks ar
on ea.ArtworkID=ar.ArtworkID
join Exhibitions e on e.ExhibitionID=e.ExhibitionID
where e.Title='Modern Art Masterpieces'

--17.Find the categories where the average year of artworks is greater than the average year of all
--artworks.select c.Name
from Categories c
join Artworks ar on c.CategoryID=ar.CategoryID
group by c.Name
having avg(ar.year)>(select avg(year) from Artworks);--18.. List the artworks that were not exhibited in any exhibition.select ar.Title
from Artworks ar
left join ExhibitionArtworks ea
on ea.ArtworkID=ar.ArtworkID
where ea.ExhibitionID is null;--19.Show artists who have artworks in the same category as "Mona Lisa."
select a.Name
from artists a
join Artworks ar on a.ArtistID =ar.ArtistID
where ar.CategoryID=(select CategoryID from Artworks where title = 'Mona Lisa');



--20.List the names of artists and the number of artworks they have in the gallery.
select a.Name,count(ar.ArtistID) as ArtWorks
from Artists a
left join 
Artists ar on a.ArtistID=ar.ArtistID
group by a.Name





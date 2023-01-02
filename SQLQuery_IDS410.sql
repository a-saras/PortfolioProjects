
CREATE TABLE CreditCard (
	CC_No		  varchar(16) not null primary key,
	FirstName	  varchar(30) not null,
	MiddleInitial varchar(1),
	LastName	  varchar(30) not null,
	Expiration	  datetime not null,
	CC_Type		  varchar(30) not null,
	CVC		      numeric(4,0) not null,
	IsDefault	  bit,
	UserID		  nvarchar(128) not null references AspNetUsers(Id)
)

CREATE TABLE OrderHeader (
	OrderID		int identity (1001,1) primary key not null,
	OrderDate	datetime default getdate() not null,
	CC_No		varchar(16) not null references CreditCard(CC_No),
	UserID		nvarchar(128) not null references AspNetUsers(Id)
)

CREATE TABLE Song (
	SongID		varchar(13) not null primary key,
	Title		varchar(30) not null,
	Album		varchar(30),
	Artist		varchar(30),
	Genre		varchar(30),
	ReleaseDate	datetime,
	ListPrice	money not null,
	FileName	varchar(255) not null,
	ClipName	varchar(30)
)

CREATE TABLE OrderLine (
	OrderID		int not null references OrderHeader(OrderID),
	SongID		varchar(13) not null references Song(SongID),
	Quantity	int not null,
	constraint  OrderLine_PK primary key(OrderID, SongID)
)

CREATE TABLE ShopCart (
    ShopCartID     INT  IDENTITY (101, 1) Primary Key NOT NULL,
    ExpirationDate DATETIME  DEFAULT (getdate()+3) NULL,
	UserID		   nvarchar(128) null
);


CREATE TABLE ShopCartLine (
    ShopCartID  INT          NOT NULL,
    SongID      VARCHAR (13) NOT NULL,
    Quantity    INT          NOT NULL,
    CONSTRAINT  ShopCartLine_PK PRIMARY KEY (ShopCartID, SongID),
    FOREIGN KEY (ShopCartID) REFERENCES ShopCart(ShopCartID),
    FOREIGN KEY (SongID) REFERENCES Song (SongID)
);

--execute the above create table statements as a batch
GO


--sample data

Insert into Song Values ('1001', 'Joel Beat Box', 'Album1', 'Joe Publique', 'Rock',
                         'November 9, 2008', 0.99, 'BeatBox.mp3', 'BeatBox.mp3');

Insert into Song Values ('1002', 'Breaky Heart', 'Album1', 'Joe Publique', 'Rock',
                         'November 9, 2008', 0.99, 'BreakyHeart.mp3', 'BreakyHeart.mp3');

Insert into Song Values ('1003', 'Welcome', 'Album2', 'Java Sound', 'HipHop',
                         'November 9, 2006', 0.99, '1-welcome.wav', '1-welcome.wav');

Insert into Song Values ('1004', 'Craig1', 'Album3', 'Craig', 'Classic',
                         'November 9, 2005', 0.99, 'Craig1.wav', 'Craig1.wav');

Insert into Song Values ('1005', 'Of a Memory', 'Album1', 'Joe Publique', 'Blues',
                         'November 9, 2008', 0.99, 'OfMemory.mp3', 'OfMemory.mp3');

Insert into Song Values ('1006', 'Dracula', 'Album1', 'Joe Publique', 'Jazz',
                         'November 9, 2008', 0.99, 'Dracula.mp3', 'Dracula.mp3');

Insert into Song Values ('1007', 'cool', 'Album1', 'Joe Publique', 'Rock',
                         'November 9, 2008', 0.99, 'cool.m4a', 'cool.m4a');
Insert into Song Values ('1008', 'ran', 'Album1', 'Joe Publique', 'Rock',
                         'November 9, 2008', 0.99, 'ran.m4a', 'ran.m4a');

Insert into Song Values ('1009', 'beat', 'Album2', 'Java Sound', 'HipHop',
                         'November 9, 2006', 0.99, 'beat.m4a', 'beat.m4a');

Insert into Song Values ('1010', 'sun', 'Album3', 'Craig', 'Classic',
                         'November 9, 2005', 0.99, 'sun.m4a', 'sun.m4a');

Insert into Song Values ('1011', 'boon', 'Album1', 'Joe Publique', 'Blues',
                         'November 9, 2008', 0.99, 'boon.m4a', 'boon.m4a');

Insert into Song Values ('1012', 'corp', 'Album1', 'Joe Publique', 'Jazz',
                         'November 9, 2008', 0.99, 'corp.m4a', 'corp.m4a');
Insert into Song Values ('1013', 'fan', 'Album1', 'Joe Publique', 'Rock',
                         'November 9, 2008', 0.99, 'fan.m4a', 'fan.m4a');

Insert into Song Values ('1014', 'hip', 'Album2', 'Java Sound', 'HipHop',
                         'November 9, 2006', 0.99, 'hip.m4a', 'hip.m4a');

Insert into Song Values ('1015', 'piano', 'Album3', 'Craig', 'Classic',
                         'November 9, 2005', 0.99, 'piano.m4a', 'piano.m4a');

Insert into Song Values ('1016', 'fun', 'Album1', 'Joe Publique', 'Blues',
                         'November 9, 2008', 0.99, 'fun.m4a', 'fun.m4a');

Insert into Song Values ('1017', 'pop', 'Album1', 'Joe Publique', 'Jazz',
                         'November 9, 2008', 0.99, 'pop.m4a', 'pop.m4a');



-- execute the above insert statements as a batch
GO


CREATE PROCEDURE pNewOrder
 (@outOrderID int OUT,
  @inCC_No    Varchar(16),
  @inUserID   Varchar(128))
AS
begin
  insert into OrderHeader (OrderDate, CC_No, UserID)
    values (default, @inCC_No, @inUserID);
  
  --return the newly generated orderid to the calling function.
  Select @outOrderID = SCOPE_IDENTITY();
end;

-- execute the create procedure statement one at a time
Go

CREATE PROCEDURE pNewShopCart (@ShopcartID int OUT, @UserID Varchar(128)) as
begin
      insert into shopcart (expirationdate, UserID) values (default, @UserID);
      Select @ShopcartID = SCOPE_IDENTITY();
end;

-- execute the create procedure statement one at a time
Go

CREATE VIEW vShopcart
as
  select shopcartid, s.SongID, quantity, title, Artist,
         listprice, clipname, quantity*listprice as subtotal
  from shopcartline shl inner join Song s on shl.SongID = s.SongID

-- execute the create procedure statement one at a time
Go

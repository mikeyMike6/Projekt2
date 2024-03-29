USE [master]
GO
/****** Object:  Database [Ewidencja_plyt_z_filmami]    Script Date: 20.07.2021 19:30:23 ******/
CREATE DATABASE [Ewidencja_plyt_z_filmami]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Ewidencja_plyt_z_filmami', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\Ewidencja_plyt_z_filmami.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Ewidencja_plyt_z_filmami_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\Ewidencja_plyt_z_filmami_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Ewidencja_plyt_z_filmami].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ARITHABORT OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET  MULTI_USER 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET QUERY_STORE = OFF
GO
USE [Ewidencja_plyt_z_filmami]
GO
/****** Object:  User [user1]    Script Date: 20.07.2021 19:30:23 ******/
CREATE USER [user1] FOR LOGIN [regular_user] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [user]    Script Date: 20.07.2021 19:30:23 ******/
CREATE USER [user] FOR LOGIN [testuser3] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [user1]
GO
/****** Object:  UserDefinedFunction [dbo].[LiczbaPozycjiFilmowych]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[LiczbaPozycjiFilmowych] (@idFilmu INT)
RETURNS @result TABLE (id int, tytul nvarchar(50), stan int)
AS
BEGIN
	IF @idFilmu IS NULL
	insert into @result
		select f.id_filmu, f.Tytul_filmu, tab.stan
		from (
		select p.id_filmu, count(id_plyty) as stan
		from plyty p
		join filmy f on p.id_filmu = f.id_filmu
		where Status = 1
		group by p.id_filmu) as tab
		join filmy f on tab.id_filmu = f.id_filmu
	else 
	insert into @result
		select f.id_filmu, f.Tytul_filmu, tab.stan
		from (
		select p.id_filmu, count(id_plyty) as stan
		from plyty p
		join filmy f on p.id_filmu = f.id_filmu
		where Status = 1
		group by p.id_filmu) as tab
		join filmy f on tab.id_filmu = f.id_filmu
		where f.id_filmu = @idFilmu
	return
END


GO
/****** Object:  Table [dbo].[Filmy]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Filmy](
	[id_filmu] [int] IDENTITY(1,1) NOT NULL,
	[Tytul_filmu] [nvarchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_filmu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Artysci]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Artysci](
	[id_artysty] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [nvarchar](20) NOT NULL,
	[Nazwisko] [nvarchar](20) NOT NULL,
	[Data_urodzenia] [date] NULL,
	[Kraj_pochodzenia] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_artysty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Obsada]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Obsada](
	[id_artysty] [int] NOT NULL,
	[id_filmu] [int] NOT NULL,
	[Rola] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_artysty] ASC,
	[id_filmu] ASC,
	[Rola] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[PelnaObsadaFilmu]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[PelnaObsadaFilmu] (@idFilmu INT)
RETURNS TABLE
AS 
RETURN 
select f.Tytul_filmu, a.Imie, a.Nazwisko, o.Rola
from obsada o
join artysci a on o.id_artysty = a.id_artysty
join filmy f on f.id_filmu = o.id_filmu
where f.id_filmu = @idFilmu
GO
/****** Object:  Table [dbo].[Klienci]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Klienci](
	[id_klienta] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [nvarchar](20) NOT NULL,
	[Nazwisko] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_klienta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Plyty]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Plyty](
	[id_plyty] [int] IDENTITY(1,1) NOT NULL,
	[id_filmu] [int] NOT NULL,
	[Status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_plyty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wypozyczenia]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wypozyczenia](
	[id_plyty] [int] NOT NULL,
	[id_klienta] [int] NOT NULL,
	[Data_wypozyczenia] [date] NOT NULL,
	[Data_zwrotu] [date] NULL,
	[id_wypozyczenia] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_wypozyczenia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[KlienciWypozyczenia]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[KlienciWypozyczenia] AS
	select k.Imie, k.Nazwisko, W.id_plyty, f.Tytul_filmu
	from Wypozyczenia W
	join Klienci K on w.id_klienta = k.id_klienta
	join Plyty P on p.id_plyty = w.id_plyty
	join Filmy F on f.id_filmu = p.id_filmu
	where W.Data_zwrotu is null
GO
/****** Object:  Table [dbo].[PlakatyFilmowe]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlakatyFilmowe](
	[id_filmu] [int] NOT NULL,
	[Plakat] [nvarchar](300) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_filmu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PytaniaIOdpowiedzi]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PytaniaIOdpowiedzi](
	[id_klienta] [int] NOT NULL,
	[id_pytania] [int] NOT NULL,
	[odpowiedz] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_klienta] ASC,
	[id_pytania] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PytaniaWeryfikujace]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PytaniaWeryfikujace](
	[id_pytania] [int] NOT NULL,
	[pytanie] [nvarchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_pytania] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Szczegoly_Filmu]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Szczegoly_Filmu](
	[id_filmu] [int] NOT NULL,
	[Gatunek] [nvarchar](20) NOT NULL,
	[Kraj_produkcji] [nvarchar](20) NOT NULL,
	[Jezyk] [nvarchar](20) NOT NULL,
	[Czas_trwania] [int] NOT NULL,
	[Wytwornia] [nvarchar](20) NULL,
	[Budzet] [money] NULL,
	[Prequel] [int] NULL,
	[Sequel] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_filmu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Uzytkownicy]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Uzytkownicy](
	[id_klienta] [int] NOT NULL,
	[LoginName] [nvarchar](30) NOT NULL,
	[PasswordHash] [binary](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Artysci] ON 
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (32, N'Micheal', N'Fox', CAST(N'1961-06-09' AS Date), N'Kanada')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (33, N'Christopher', N'Lloyd', CAST(N'1938-10-22' AS Date), N'USA')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (34, N'Lea', N'Thompson', CAST(N'1961-05-31' AS Date), N'USA')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (35, N'Sigourney', N'Weaver', CAST(N'1949-10-08' AS Date), N'USA')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (36, N'Tom', N'Skerritt', CAST(N'1933-08-25' AS Date), N'USA')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (37, N'Ian', N'Holm', CAST(N'1931-09-12' AS Date), N'Wielka Brytania')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (38, N'Robb', N'Wells', NULL, N'Kanada')
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (39, N'John', N'Tremblay', NULL, NULL)
GO
INSERT [dbo].[Artysci] ([id_artysty], [Imie], [Nazwisko], [Data_urodzenia], [Kraj_pochodzenia]) VALUES (40, N'Mike', N'Smith', NULL, N'Kanada')
GO
SET IDENTITY_INSERT [dbo].[Artysci] OFF
GO
SET IDENTITY_INSERT [dbo].[Filmy] ON 
GO
INSERT [dbo].[Filmy] ([id_filmu], [Tytul_filmu]) VALUES (15, N'Powrót do przyszłości')
GO
INSERT [dbo].[Filmy] ([id_filmu], [Tytul_filmu]) VALUES (16, N'Obcy - ósmy pasażer Nostromo')
GO
INSERT [dbo].[Filmy] ([id_filmu], [Tytul_filmu]) VALUES (18, N'Trailer Park Boys: The Movie')
GO
INSERT [dbo].[Filmy] ([id_filmu], [Tytul_filmu]) VALUES (19, N'shrek')
GO
SET IDENTITY_INSERT [dbo].[Filmy] OFF
GO
SET IDENTITY_INSERT [dbo].[Klienci] ON 
GO
INSERT [dbo].[Klienci] ([id_klienta], [Imie], [Nazwisko]) VALUES (1041, N'John', N'Doe')
GO
INSERT [dbo].[Klienci] ([id_klienta], [Imie], [Nazwisko]) VALUES (1042, N'imie', N'naz')
GO
SET IDENTITY_INSERT [dbo].[Klienci] OFF
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (32, 15, N'Marty McFly')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (33, 15, N'Dr. Emmett')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (34, 15, N'Lorrain McFly')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (35, 16, N'Ripley')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (36, 16, N'Kapitan Dallas')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (37, 16, N'Ash')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (38, 18, N'Ricky')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (39, 18, N'Sexy Bastard Julian')
GO
INSERT [dbo].[Obsada] ([id_artysty], [id_filmu], [Rola]) VALUES (40, 18, N'Bubbles')
GO
INSERT [dbo].[PlakatyFilmowe] ([id_filmu], [Plakat]) VALUES (15, N'https://dyn1.heritagestatic.com/lf?set=path%5B2%2F3%2F5%2F5%2F7%2F23557425%5D%2Csizedata%5B850x600%5D&call=url%5Bfile%3Aproduct.chain%5D')
GO
INSERT [dbo].[PlakatyFilmowe] ([id_filmu], [Plakat]) VALUES (16, N'https://ih1.redbubble.net/image.422316713.4583/raf,128x128,075,f,101010:01c5ca27c6.u2.jpg')
GO
INSERT [dbo].[PlakatyFilmowe] ([id_filmu], [Plakat]) VALUES (18, N'https://ih1.redbubble.net/image.2051649818.3499/flat,128x,075,f-pad,128x128,f8f8f8.jpg')
GO
INSERT [dbo].[PlakatyFilmowe] ([id_filmu], [Plakat]) VALUES (19, N'https://ih1.redbubble.net/image.1517954869.5851/flat,128x,075,f-pad,128x128,f8f8f8.jpg')
GO
SET IDENTITY_INSERT [dbo].[Plyty] ON 
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (4, 15, 1)
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (5, 16, 1)
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (7, 18, 1)
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (8, 15, 1)
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (9, 18, 1)
GO
INSERT [dbo].[Plyty] ([id_plyty], [id_filmu], [Status]) VALUES (10, 15, 1)
GO
SET IDENTITY_INSERT [dbo].[Plyty] OFF
GO
INSERT [dbo].[PytaniaIOdpowiedzi] ([id_klienta], [id_pytania], [odpowiedz]) VALUES (1041, 4, N'do lasu')
GO
INSERT [dbo].[PytaniaIOdpowiedzi] ([id_klienta], [id_pytania], [odpowiedz]) VALUES (1042, 3, N'5')
GO
INSERT [dbo].[PytaniaWeryfikujace] ([id_pytania], [pytanie]) VALUES (1, N'Jak się nazywa twój pies?')
GO
INSERT [dbo].[PytaniaWeryfikujace] ([id_pytania], [pytanie]) VALUES (2, N'Jak masz na drugie imię?')
GO
INSERT [dbo].[PytaniaWeryfikujace] ([id_pytania], [pytanie]) VALUES (3, N'Ile masz palców w prawiej stopie?')
GO
INSERT [dbo].[PytaniaWeryfikujace] ([id_pytania], [pytanie]) VALUES (4, N'Dokąd nocą tupta jeż?')
GO
INSERT [dbo].[Szczegoly_Filmu] ([id_filmu], [Gatunek], [Kraj_produkcji], [Jezyk], [Czas_trwania], [Wytwornia], [Budzet], [Prequel], [Sequel]) VALUES (15, N'Sci-Fi', N'USA', N'Angielski', 111, N'Universal Pictures', 19000000.0000, NULL, NULL)
GO
INSERT [dbo].[Szczegoly_Filmu] ([id_filmu], [Gatunek], [Kraj_produkcji], [Jezyk], [Czas_trwania], [Wytwornia], [Budzet], [Prequel], [Sequel]) VALUES (16, N'Horror ', N'USA', N'Angielski', 117, N'20th Century Fox', 11000000.0000, NULL, NULL)
GO
INSERT [dbo].[Szczegoly_Filmu] ([id_filmu], [Gatunek], [Kraj_produkcji], [Jezyk], [Czas_trwania], [Wytwornia], [Budzet], [Prequel], [Sequel]) VALUES (18, N'Mockument', N'Kanada', N'Angielski', 95, N'', 5000000.0000, NULL, NULL)
GO
INSERT [dbo].[Szczegoly_Filmu] ([id_filmu], [Gatunek], [Kraj_produkcji], [Jezyk], [Czas_trwania], [Wytwornia], [Budzet], [Prequel], [Sequel]) VALUES (19, N'komedia', N'USA', N'Angielski', 150, N'', 99999.0000, NULL, NULL)
GO
INSERT [dbo].[Uzytkownicy] ([id_klienta], [LoginName], [PasswordHash]) VALUES (1041, N'user1', 0xCD8C29B8DEED323FE1538CFBDB46FC2A2EA61CFD67807F0629708EA2A6E13A2919DEF3C837C4E7F2C8E0067568E3236827DEFB05C9346E476B6E954440A908A7)
GO
INSERT [dbo].[Uzytkownicy] ([id_klienta], [LoginName], [PasswordHash]) VALUES (1042, N'user2', 0xCD8C29B8DEED323FE1538CFBDB46FC2A2EA61CFD67807F0629708EA2A6E13A2919DEF3C837C4E7F2C8E0067568E3236827DEFB05C9346E476B6E954440A908A7)
GO
SET IDENTITY_INSERT [dbo].[Wypozyczenia] ON 
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 57)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 58)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (8, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 59)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (10, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 60)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (7, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 61)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (9, 1041, CAST(N'2021-07-18' AS Date), CAST(N'2021-07-20' AS Date), 62)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 63)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 64)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 65)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 66)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 67)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 68)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 69)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (8, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 70)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (10, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 71)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (7, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 72)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (9, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 73)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 74)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (8, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 75)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 76)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (4, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 77)
GO
INSERT [dbo].[Wypozyczenia] ([id_plyty], [id_klienta], [Data_wypozyczenia], [Data_zwrotu], [id_wypozyczenia]) VALUES (5, 1041, CAST(N'2021-07-20' AS Date), CAST(N'2021-07-20' AS Date), 78)
GO
SET IDENTITY_INSERT [dbo].[Wypozyczenia] OFF
GO
ALTER TABLE [dbo].[Obsada]  WITH CHECK ADD FOREIGN KEY([id_artysty])
REFERENCES [dbo].[Artysci] ([id_artysty])
GO
ALTER TABLE [dbo].[Obsada]  WITH CHECK ADD FOREIGN KEY([id_filmu])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[PlakatyFilmowe]  WITH CHECK ADD FOREIGN KEY([id_filmu])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[Plyty]  WITH CHECK ADD FOREIGN KEY([id_filmu])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[PytaniaIOdpowiedzi]  WITH CHECK ADD FOREIGN KEY([id_klienta])
REFERENCES [dbo].[Klienci] ([id_klienta])
GO
ALTER TABLE [dbo].[PytaniaIOdpowiedzi]  WITH CHECK ADD FOREIGN KEY([id_pytania])
REFERENCES [dbo].[PytaniaWeryfikujace] ([id_pytania])
GO
ALTER TABLE [dbo].[Szczegoly_Filmu]  WITH CHECK ADD FOREIGN KEY([id_filmu])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[Szczegoly_Filmu]  WITH CHECK ADD FOREIGN KEY([Prequel])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[Szczegoly_Filmu]  WITH CHECK ADD FOREIGN KEY([Sequel])
REFERENCES [dbo].[Filmy] ([id_filmu])
GO
ALTER TABLE [dbo].[Uzytkownicy]  WITH CHECK ADD FOREIGN KEY([id_klienta])
REFERENCES [dbo].[Klienci] ([id_klienta])
GO
ALTER TABLE [dbo].[Wypozyczenia]  WITH CHECK ADD FOREIGN KEY([id_klienta])
REFERENCES [dbo].[Klienci] ([id_klienta])
GO
ALTER TABLE [dbo].[Wypozyczenia]  WITH CHECK ADD FOREIGN KEY([id_plyty])
REFERENCES [dbo].[Plyty] ([id_plyty])
GO
ALTER TABLE [dbo].[Szczegoly_Filmu]  WITH CHECK ADD  CONSTRAINT [CHK_Budzet] CHECK  (([Budzet]>(1)))
GO
ALTER TABLE [dbo].[Szczegoly_Filmu] CHECK CONSTRAINT [CHK_Budzet]
GO
ALTER TABLE [dbo].[Szczegoly_Filmu]  WITH CHECK ADD  CONSTRAINT [CHK_czas_trwania] CHECK  (([Czas_trwania]>(1)))
GO
ALTER TABLE [dbo].[Szczegoly_Filmu] CHECK CONSTRAINT [CHK_czas_trwania]
GO
/****** Object:  StoredProcedure [dbo].[DodajNowyFilm]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DodajNowyFilm]
	@tFilmu nvarchar(50),
	@gFilmu nvarchar(20),
	@kProd nvarchar(30), 
	@jez nvarchar(20), 
	@czas int, 
	@wytw nvarchar(30),
	@budz money
AS	
	set nocount on;
	declare @newId int
	insert into filmy values (@tFilmu)
	select TOP 1 @newID = id_filmu from filmy order by id_filmu DESC

	insert into Szczegoly_Filmu values (@newId, @gFilmu, @kProd, @jez, @czas, @wytw, @budz, null, null)
GO
/****** Object:  StoredProcedure [dbo].[dodajUzytkownika]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dodajUzytkownika]
    @pLogin NVARCHAR(30), 
    @pPassword NVARCHAR(50), 
    @pFirstName NVARCHAR(20), 
    @pLastName NVARCHAR(20),
	@pQuestion INT,
	@pResponse NVARCHAR(50),
    @responseMessage BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
		INSERT INTO Klienci VALUES(@pFirstName, @pLastName)
		DECLARE @id AS INT
		SELECT TOP 1 @id = id_klienta 
		FROM Klienci 
		ORDER BY id_klienta DESC

        INSERT INTO dbo.Uzytkownicy 
        VALUES(@id, @pLogin, HASHBYTES('SHA2_512', @pPassword))

		INSERT INTO dbo.PytaniaIOdpowiedzi
		VALUES (@id, @pQuestion, @pResponse)

        SET @responseMessage=1

    END TRY
    BEGIN CATCH
        SET @responseMessage=0
		ROLLBACK TRANSACTION
    END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[LogowanieUzytkownika]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LogowanieUzytkownika]
    @pLoginName NVARCHAR(254),
    @pPassword NVARCHAR(50),
    @responseMessage BIT OUTPUT
AS
BEGIN

    SET NOCOUNT ON

    DECLARE @userID INT

    IF EXISTS (SELECT TOP 1 id_klienta FROM [dbo].Uzytkownicy WHERE LoginName=@pLoginName)
    BEGIN
        SET @userID=(SELECT id_klienta FROM [dbo].Uzytkownicy WHERE LoginName=@pLoginName AND PasswordHash=HASHBYTES('SHA2_512', @pPassword))

       IF(@userID IS NULL)
           SET @responseMessage=NULL
       ELSE 
           SET @responseMessage=1
    END
    ELSE
       SET @responseMessage=0

END
GO
/****** Object:  StoredProcedure [dbo].[usuwanieArtysty]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usuwanieArtysty] @id INT
AS
	DELETE FROM Obsada WHERE id_artysty = @id
	DELETE FROM Artysci WHERE id_artysty = @id
GO
/****** Object:  StoredProcedure [dbo].[usuwanieFilmu]    Script Date: 20.07.2021 19:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usuwanieFilmu] @id_filmu INT
AS
	DELETE FROM Szczegoly_Filmu where id_filmu = @id_filmu
	DELETE FROM Obsada WHERE id_filmu = @id_filmu
	UPDATE Szczegoly_Filmu SET Sequel = null WHERE Sequel = @id_filmu
	UPDATE Szczegoly_Filmu SET Prequel = null WHERE Prequel = @id_filmu
	DELETE FROM Filmy WHERE id_filmu = @id_filmu
GO
USE [master]
GO
ALTER DATABASE [Ewidencja_plyt_z_filmami] SET  READ_WRITE 
GO

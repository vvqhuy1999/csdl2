create database QuanlyDayhoc;
use QuanlyDayhoc;
create table MonHoc(
	mamon char(4) primary key,
	tenmon nvarchar(50),
	sotinchi int,
	hocphi float
);

create table HocVien(
	mahv char(4) primary key,
	hoten nvarchar(50),
	ngaysinh date,
	phai nvarchar(3),
	diachi nvarchar(50)
);
-- DK = DangKy
create table DangKy (
	madk int primary key,
	mahv char(4),
	mamon char(4),
	ngaydk date,
	ghichu nvarchar(50)
);

-- cau 1
alter table DangKy
add constraint fk_DK_MonHoc foreign key (mamon) references MonHoc(mamon);

alter table DangKy
add constraint fk_DK_HocVien foreign key (mahv) references HocVien(mahv);

-- cau 2
go
create or alter procedure sp_InsertData
as begin
	insert into MonHoc values
	('mh01',N'cơ sở dữ liệu',2,1000),
	('mh02',N'lập trình c',2,400),
	('mh03',N'sql server',3,1200),
	('mh04',N'java cơ bản',3,2000),
	('mh05',N'java cơ bản',4,3000);

	insert into HocVien values
	('hv01',N'tuấn','2002-01-11', 'nam','q1'),
	('hv02',N'lan','2001-10-04', N'nữ','q1'),
	('hv03',N'nữ','2002-05-03', 'nam','qtb'),
	('hv04',N'dũng','2002-11-21', 'nam','q1'),
	('hv05',N'hiền','2001-10-13', N'nữ','q10');

	insert into DangKy values 
	(1,'hv01','mh01','2023-04-13',''),
	(2,'hv02','mh03','2023-05-14',N'giảm 10% học phí'),
	(3,'hv03','mh01','2023-05-23',''),
	(4,'hv05','mh01','2023-06-01',N'giảm 10% học phí'),
	(5,'hv03','mh03','2023-06-01',''),
	(6,'hv04','mh02','2023-04-30','');
end

exec sp_InsertData;
-- cau 3
go
create or alter view  v_XemThongTin
as
	select dk.madk,hv.hoten,mh.tenmon,hv.ngaysinh,mh.hocphi
	from DangKy dk
	join HocVien hv on hv.mahv = dk.mahv
	join MonHoc mh on mh.mamon = dk.mamon
go

select * from v_XemThongTin

-- cau 4
go
create or alter procedure sp_XemDSHVDk @mamh char(4)
as begin
	select hv.mahv, hv.hoten, dk.ngaydk,dk.mamon
	from DangKy dk
	join HocVien hv on dk.mahv = hv.mahv
	where dk.mamon = @mamh;
end 

exec sp_XemDSHVDk 'mh01';

-- cau 5
go
create or alter function f_TinhSoMonHoc( @mahv char(4))
returns int
as begin
	declare @slm int;
	select @slm = count(mahv)
	from DangKy
	where mahv = @mahv
	group by mahv;

	return @slm;
end
go

print N'Số môn học mà học viên hv02 đã đăng ký là: ' + cast(dbo.f_TinhSoMonHoc('hv03') as varchar(5));

-- Cau6
go
create or alter trigger trigg_XoaDuLieu on monhoc
instead of delete
as begin
    declare @dshv as table (mahv char(4));
	insert into @dshv
	select mahv from DangKy where mamon in (select mamon from deleted);

	alter table dangky
	drop constraint fk_DK_HocVien;
	alter table dangky
	drop constraint fk_DK_MonHoc;

	delete from HocVien
	where mahv in (select mahv from @dshv);

	delete from MonHoc
	where mamon in (select mamon from deleted)
end
go

delete from MonHoc where mamon = 'mh01';

-- select * from MonHoc;
-- select * from HocVien;
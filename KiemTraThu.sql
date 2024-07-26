
create database QLNSach;
use QLNSach;

create table NhaXuatBan(
	manxb char(5) primary key,
	tennxb nvarchar(50), 
	diachi nvarchar(50)
);

create table Sach(
	masach char(4) primary key,
	tensach nvarchar(50),
	gia float,
	ngayxb date,
	tacgia nvarchar(50),
	manxb char(5)
);
alter table Sach
add constraint fk_Sach_NhaXuatBan foreign key (manxb) references NhaXuatBan(manxb);


-- Cau1
go
create or alter procedure SP_Insert 
as begin
	insert into NhaXuatBan values
	('nxb01',N'Nhà xuất bản thanh niên', N'12 nguyễn trãi, q5, tphcm'),
	('nxb02',N'Nhà xuất bản trẻ', N'123 lý chính thắng, q3, tphcm'),
	('nxb03',N'Nhà xuất bản lao động', N'35 an dương vương, q10, tphcm');

	insert into Sach values
	('s01',N'hòn đất',45000,'2022-12-09',N'anh đức','nxb01'),
	('s02',N'dế mèn phiêu lưu ký',56000,'2023-05-19',N'tô hoài','nxb02'),
	('s03',N'bài tập java cơ bản',30000,'2022-10-01',N'lê hoài bắc','nxb02'),
	('s04',N'bài tập java nâng cao',100000,'2023-01-12',N'lê hoài bắc','nxb01'),
	('s05',N'nhạc trữ tình',45600,'2022-12-21',N'phan huỳnh điểu','nxb01');
end
go

exec SP_Insert;
select * from Sach
select * from NhaXuatBan

-- cau2
go
create or alter procedure SP_XemDanhmucSachTheoNhaXB @manxb char(5)
as begin
	select nxb.manxb,nxb.tennxb,s.tensach,s.gia,s.ngayxb
	from NhaXuatBan nxb join Sach s on nxb.manxb = s.manxb
	where nxb.manxb = @manxb;
end
go
exec SP_XemDanhmucSachTheoNhaXB 'nxb02';
-- cau3
go
create or alter procedure sp_InsertDuLieuNhaXuatBan  @manxb char(5), @tennxb nvarchar(50), @diachi nvarchar(50)
as begin
	
	Begin try
		insert into NhaXuatBan (manxb,tennxb,diachi)  values (@manxb,@tennxb,@diachi);
		print 'Them thanh cong';
	end try
	Begin catch
		print N'Thêm thất bại';	
	end catch
end
go
exec sp_InsertDuLieuNhaXuatBan 'nxb01','sjhfgd','dsuyfggdsu';
exec sp_InsertDuLieuNhaXuatBan 'nxb04','Nha xuat ban','Kinh Duong vuong,q5,tphcm';


-- cau 4
go
create or alter view v_xemDanhmucSach
as 
	select nxb.manxb,nxb.tennxb,s.tensach,s.gia,s.ngayxb
	from NhaXuatBan nxb join Sach s on nxb.manxb = s.manxb 
go

select year(ngayxb), count(ngayxb) 
from v_xemDanhmucSach
group by year(ngayxb) 

-- cau 5
go
create or alter function f_soSachXuatbanTheoTacgia (@tacgia nvarchar(50))
returns int
as begin
	declare @sl int;
	select @sl = count(*)
	from Sach
	where tacgia = @tacgia
	return @sl;
end
go
print 'So luong = ' + cast(dbo.f_soSachXuatbanTheoTacgia(N'lê hoài bắc') as varchar(5));

-- cau6
select * from Sach;
select * from NhaXuatBan;
go
create or alter trigger trigg_insertSach1 on Sach
instead of insert
as begin
	if(select gia from inserted) < 0
	begin
			print 'Them du lieu that  bai';
			rollback tran;
    end
	if(select manxb from inserted) not in (select manxb from NhaXuatBan)
		begin
			print 'Them du lieu that bai';
			rollback tran;
		end
	insert into Sach 
	select * from inserted;
end
go
insert into Sach values
	('s06',N'drfgdfbdfb',45000,'2022-12-09',N'anh đức','nxb04');

insert into Sach values
	('s07',N'drfgdfbdfb',45000,'2022-12-09',N'anh đức','nxb05');
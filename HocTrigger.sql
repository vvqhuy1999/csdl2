use QLDA;

go 
/* DDL trigger */
/*
create or alter tigger <ten Trigger>
on database
for		
	create_table/alter_table/drop_table
as begin
	-- thao tac se tu dong thuc hien khi
	-- user create/drop/alter table 
end
*/
go
create or alter trigger trig_ddl_create on database
for create_table
as begin
	print N'User tao table'
end
go
create or alter trigger trig_ddl_delete on database
for drop_table
as begin
	print N'User xoa table'
end

create table exam(
	ma int primary key
)

drop table exam;
--drop trigger trig_ddl_delete;
-- drop trigger trig_ddl_create;


go
-- Tạo Trigger after Insert cho phongban
create or alter trigger trig_insertPB on PHONGBAN
for insert --  for hay after
as begin
	select * from inserted
	select * from deleted
end
go
create or alter trigger trig_deletePB on PHONGBAN
for delete --  for hay after
as begin
	select * from inserted
	select * from deleted
end
go
create or alter trigger trig_updatePB on PHONGBAN
for update --  for hay after
as begin
	select * from inserted
	select * from deleted
end
go
insert into PHONGBAN values(N'Nhân sự',15,null,'2024-05-12');

delete from PHONGBAN where MAPHG =15;
select * from PHONGBAN

update PHONGBAN
set NG_NHANCHUC = GETDATE()
where MAPHG = 15;

drop trigger trig_insertPB;
drop trigger trig_deletePB;
drop trigger trig_updatePB;


-- tao trigger khi chen nv luong phai tren 10000
go
create or alter trigger trig_insertLuong on nhanvien
for insert
as begin
	--select * from inserted;
	--select * from deleted;
	declare @luong int
	set @luong = (select luong from inserted)
	if(@luong < 10000)
	begin
		print N'Lương phải trên 10000';
		rollback tran -- hủy thao tac chèn
	end
end
go

select * from NHANVIEN

insert into NHANVIEN values(N'Võ',N'Văn Quang',N'Huy','021','1999-09-14',N'Huế','Nam',20000,'006',4)


drop trigger trig_updateLuong

go
-- tao trigger khi  update phai tren 10000
create or alter trigger trig_updateLuong on nhanvien
for update
as begin
	if(select luong from inserted) < 10000
	begin
		print N'Lương phải trên 10000';
		rollback tran -- hủy thao tac chèn
	end
end
go

update NHANVIEN
set LUONG = 5000
where MANV = '021'
go
-- tao trigger delete tren table nhanvien k co xoa sep
create or alter trigger trig_delete on nhanvien
for delete
as begin
	-- if(select MA_NQL from deleted) = null
	if exists (select manv from deleted where MA_NQL is null)
	begin
		print N'Sep k the xoa'
		rollback tran
	end
	else 
	begin
		print 'Xoa nhan vien thanh cong'
	end
end
go
delete from NHANVIEN where MANV = '021'
-- Khong cho sua nhan vien o thanh pho ha noi
go
create or alter trigger trig_updateHN on nhanvien
for update
as begin
	if exists (select * from deleted where DCHI like'%Tp HCM')
	begin
		print N'doi k dc'
		rollback tran
	end
	else
	begin
		print N'doi dc'
	end
end
go
select * from NHANVIEN
update NHANVIEN
set DCHI = N'Hà Nội' 
where DCHI like 'hcm%'

go


/* Trigger thay thế thao tác dữ liệu
	
	Create [or alter] trigger on <Tên Table>
	instead of insert/delete/update
	as begin
		Câu lệnh SQL thay thế cho insert/delete/update
	end
*/
use qlda;
-- Tạo trigger khi xóa phòng ban phải xóa tất cả nv thuộc pb đó
/*
select * from nhanvien
insert into phongban values
(N'Tiếp Thị',8,'004','2023-03-12');
insert into nhanvien values
('A','B','C','300','2002-01-01','Q12','Nam',13000,'001',8);

delete from phongban where MAPHG=8
*/
go
create trigger trig_XoaPhongVaNhanVien on phongban
instead of delete 
as begin 
	-- trước khi xóa phòng thì xóa all nhân viên thuộc phòng muốn xóa
	delete from nhanvien 
	where phg in (select maphg from deleted)
	-- rồi mới xóa phòng
	delete from phongban
	where MAPHG in (select maphg from deleted)
end
select * from phongban
delete from phongban where maphg = 8
go
-- Không thực hiện thao tác xóa dữ liệu trên Table Dean
create or alter trigger trigg_koChoXoaDean on dean
instead of delete
as begin
	print N'Ko được xóa đề án!';
end

delete from DEAN where MADA =3;
go
-- Khi thêm nhân viên mới vào đề án số 10
go
create trigger trigg_ThemNVVaoDA10 on nhanvien
instead of insert
as begin
	
	-- chèn các dòng từ table inserted vào nhanvien
	insert into NHANVIEN 
		select * from inserted
	-- chèn các nv có trong inserted vào phancong với mã đề án 10
	declare @manv varchar(9);
	set @manv = (select MANV from inserted);
	insert into PHANCONG
	values(@manv,10,1,0);
		
end
go

insert into nhanvien values
('A','B','C','300','2002-01-01','Q12','Nam',13000,'005',4);

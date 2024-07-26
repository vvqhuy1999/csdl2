use QLDA;
-- Viết trigger DML:
-- Bai 1a)Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, 
-- nếu vi phạm thì xuất thông báo “luong phải >15000’
go
create or alter trigger trigg_AddNVCoLuong on nhanvien
for insert
as begin
	if(select luong from inserted ) < 15000
	begin 
		print N'Lương phải > 15000';
		rollback tran; -- hủy thao tac chèn
	end 
end
go
insert into NHANVIEN values('D','E','F','013','1999-09-14',N'Huế','Nam',10000,'006',4);


-- Bai 1b) Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.
go
create or alter trigger trigg_AddNVTuoi on nhanvien
for insert
as begin
	if(select year(GETDATE()) - YEAR(NGSINH) from inserted) <18 or (select  year(GETDATE()) - YEAR(NGSINH) from inserted) >65 
	begin 
		print N'Tuổi nằm phải nằm trong 18 - 65';
		rollback tran; -- hủy thao tac chèn
	end 
end
go
insert into NHANVIEN values('D','E','F','013','2021-09-14',N'Huế','Nam',15000,'006',4);
-- drop trigger trigg_ThemNVVaoDA10;
-- Bai 1c) Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM
go
create or alter trigger trigg_NoUpdateNVHCM on nhanvien
for update
as begin
	if exists (select dchi from inserted where DCHI like '%hcm') 
	begin
		print N'Ko được update nhân viên tp hcm';
		rollback tran; 
	end
end
go
update NHANVIEN
set LUONG = 25000
where DCHI like '%hcm%'

--Bài 2 a)Hiển thị tổng số lượng nhân viên nữ, 
-- tổng số lượng nhân viên nam mỗi khi có hành động thêm mới nhân viên.
go
create or alter trigger trigg_CountNVNamNu on nhanvien
after insert
as begin
	declare @nam int, @nu int;
	select @nu = COUNT(phai) from NHANVIEN where PHAI = N'Nữ';
	select @nam = COUNT(phai) from NHANVIEN where PHAI = N'Nam';
	print N'Số lượng nhan vien Nam = ' + cast(@nam as varchar(5)) + N', nhân viên Nữ = ' + cast(@nu as varchar(5))
end
go
insert into NHANVIEN values('Nguyen','Quoc','Thanh','014','2000-09-14',N'HCM',N'Nữ',15000,'006',4);
-- Test delete from NHANVIEN where MANV = '014'
-- Test select * from NHANVIEN

-- Bài 2 b) Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi 
-- khi có hành động cập nhật phần giới tính nhân viên
go
create or alter trigger trigg_CountUpdatePhaiNVNamNu on nhanvien
after update
as begin
	--select * from inserted
	--select * from deleted
	declare @nam int, @nu int;
	select @nu = COUNT(phai) from NHANVIEN where PHAI = N'Nữ';
	select @nam = COUNT(phai) from NHANVIEN where PHAI = N'Nam';
	print N'Số lượng nhan vien Nam = ' + cast(@nam as varchar(5)) + N', nhân viên Nữ = ' + cast(@nu as varchar(5))
end
go
update nhanvien
set PHAI = N'Nữ'
where MANV = '300';

--Bai2 c) Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN
go
create or alter trigger trigg_XoaDean on dean
after delete
as begin
	select pc.MADA, count(nv.MANV) as sl
	from NHANVIEN nv right join PHANCONG pc on nv.MANV = pc.MA_NVIEN
	group by pc.MADA	
end
go
insert into DEAN values ('Kinh Doanh',21,'TP HCM',4);

delete from DEAN where MADA =21;


-- Bài 3 a)Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện 
-- hành động xóa nhân viên trong bảng nhân viên.
go
	create or alter trigger trg_deleteNhanThanNV on NhanVien
	instead of delete 
	as begin
		delete from thannhan where Ma_NVien in (select MaNV from deleted)
		delete from nhanvien where MaNV in (select MaNV from deleted)
	end
	delete NHANVIEN where MANV = '013'
	insert into THANNHAN values ('013',N'Liên',N'Nữ','1978-01-01',N'Mẹ');
	/*
	select * from nhanvien
	select * from THANNHAN
	select * from phancong
	drop trigger trg_deleteNhanThanNV
	*/

-- Bài 3 b)Khi thêm một nhân viên mới thì tự động phân công cho 
-- nhân viên làm đề án có MADA là 1.
go
create or alter trigger trigg_ThemNVVaoDA1 on nhanvien
instead of insert
as begin
	
	-- chèn các dòng từ table inserted vào nhanvien
	insert into NHANVIEN 
		select * from inserted
	-- chèn các nv có trong inserted vào phancong với mã đề án 1
	declare @manv varchar(9);
	set @manv = (select MANV from inserted);
	insert into PHANCONG
	values(@manv,1,2,0);
		
end
go
insert into nhanvien values
('fgh','fgh','fdxc','213','2002-01-01','Q12','Nam',15000,'005',4);
-- Bài tập thêm 
/* Khi tăng lương cho nhân viên phòng nào thì trưởng phòng Phòng đó được tăng gấp đôi
Ví dụ
Update luong set luong = luong + 10000 where phg = 5
Thì trưởng phòng 5 tự động được tăng 20000
*/
go
create or alter trigger trigg_Increase 
on nhanvien
INSTEAD OF update 
as begin
	declare	@p int;
	select @p = phg from inserted;
	
	update NHANVIEN
	set luong = luong + 10000
	where MANV in (select MANV from PHONGBAN where MAPHG = @p);
	print N'Cập nhật lương thành công.';
end
go
Update NHANVIEN set luong = luong + 10000 where phg = 5

-- Cau kiem tra tăng lương chưa 
select MANV,LUONG,PHG from NHANVIEN  where PHG =5

use QLDuan;

-- 1. Tìm các nhân viên làm việc ở phòng số 4
select * from nhanvien where phg = 4;
-- 2. Tìm các nhân viên có mức lương trên 30000
select * from nhanvien where LUONG > 30000;
-- 3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
-- viên có mức lương trên 30,000 ở phòng 5
select * from nhanvien where (LUONG > 25000 and phg =4) or (LUONG > 30000 and phg =5);
-- 4. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
select CONCAT(Honv,' ',tenlot,' ',tennv) as 'Ho ten' from nhanvien where DCHI like '% Tp hcm' or DCHI like N'%Tp Hồ Chí Minh';
--5. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự 'N'
select CONCAT(Honv,' ',tenlot,' ',tennv) as 'Ho ten' from nhanvien where honv like 'N%';
-- 6. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien.
select CONCAT(Honv,' ',tenlot,' ',tennv) as 'Ho ten', NGSINH, DCHI from NHANVIEN 
where honv = N'Đinh' and TENLOT = N'Bá' and TENNV = N'Tiên';

-- select * from NHANVIEN where HONV = N'Đinh'


-- 1. Danh sách Các nhân viên có mã 001, 004, 006 , 017
select * from NHANVIEN where MANV in('001','004','006','007');
-- 2. Các nhân viên sinh tháng 1/1965, hiển thị cột Mã, Tên, Ngày Sinh
select manv,tennv,ngsinh from NHANVIEN where month(NGSINH) = 1 and YEAR(NGSINH) = 1965;
-- 3. Các nhân viên không ở TP HCM
select * from NHANVIEN where DCHI not like '%HCM' and DCHI not like N'%Tp Hồ Chí Minh';
-- 4. Số nhân viên của phòng 5 : Phòng, SỐ NV
select PHG, count(PHG) as 'So NV' from NHANVIEN where PHG = 5 group by phg;
-- 5. Danh sách các nhân viên Nữ : Mã, Tên NV, Tên Phòng, Phái
select manv, tennv, tenphg, phai from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG where PHAI = N'Nữ';
-- 6. Danh sách nhân viên Quản lý cấp cao nhất
select * from NHANVIEN where  MA_NQL is null


-- select * from NHANVIEN
/*
declare @a int, @b int, @c int; 
declare @diem float, @ngaysinh date;


set @a=12; -- cách 1
set @b =9;
set @c = @a + @b;
select @diem = 8.9; -- cách 2

--select @c;

print 'c = ' + convert(varchar,@c) ;


declare @r float, @Chuvi float

set @r = 3;
set @Chuvi = 2*@r*3.14;
print 'Chu vi cua Hinh tron = ' + cast(@Chuvi as varchar) --convert(varchar,@Chuvi);
go

-- tim nhan vien co luong lon nhat

declare @maxluong float;
select @maxluong = max(luong) from NHANVIEN;
print N'Luong lon nhat cua cong ty = ' + convert(varchar, @maxluong);

-- tim luong trung binh cua cong ty
declare @tbluong float;
select @tbluong = AVG(luong) from NHANVIEN;
print N'Luong trung binh cong ty = ' + convert(varchar, @tbluong);

-- cho biet ten cac nv co luong cao hon luong trung binh
select tennv from NHANVIEN
where LUONG > @tbluong;


-- cho biet ten nhan vien, va ten phong, cua nhan ven co luong thap nhat
declare @minluong float;
select @minluong = min(luong) from NHANVIEN
select tennv, tenphg, LUONG from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG 
where LUONG = @minluong
*/

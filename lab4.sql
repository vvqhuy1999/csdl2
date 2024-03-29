use QLDA;
-- Bai 1
/* Cau 1:
Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là
TenNV, cột thứ 2 nhận giá trị
o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
phòng mà nhân viên đó đang làm việc.
o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
trong phòng mà nhân viên đó đang làm việc.
*/
declare @KTTang table (phg int, luong float)
insert into @KTTang
select phg,AVG(luong) from NHANVIEN group by phg

select nv.TENNV, iif( nv.LUONG > ktt.luong,'Khong Tang Luong','Tang Luong') 
from NHANVIEN nv join @KTTang ktt on nv.PHG = ktt.phg
where nv.PHG = ktt.phg

/* Cau 2
Viết chương trình phân loại nhân viên dựa vào mức lương.
o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang 
làm việc thì xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
*/
declare @KT table (phg int, luong float)
insert into @KT
select phg,AVG(luong) from NHANVIEN group by phg

select nv.TENNV, iif( nv.LUONG > kt.luong,'Truong Phong','Nhan Vien') as 'Chuc vu' ,nv.luong
from NHANVIEN nv join @KT kt on nv.PHG = kt.phg
where nv.PHG = kt.phg

-- Câu 3: Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
select iif(PHAI = 'Nam','Mr. '+tennv,'Ms. '+tennv) TenNV
from nhanvien
/* Cau 4: 
Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
o 0<luong<25000 thì đóng 10% tiền lương
o 25000<luong<30000 thì đóng 12% tiền lương
o 30000<luong<40000 thì đóng 15% tiền lương
o 40000<luong<50000 thì đóng 20% tiền lương
o Luong>50000 đóng 25% tiền lương
*/

select tennv,luong, thue = case
	when luong < 25000 then luong *0.1
	when luong < 30000 then luong *0.12
	when luong < 40000 then luong *0.15
	when luong < 50000 then luong *0.2
	else luong * 0.25 
end
from NHANVIEN

-- Bai 2
-- Cau 1: Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.


SELECT TENNV, manv FROM NHANVIEN where CAST(manv AS INT) %2 =0;
-- Cau 2: Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng
-- không tính nhân viên có MaNV là 4.
if exists (SELECT * from NHANVIEN where CAST(MaNV AS INT) % 2 = 0)
begin
	SELECT TENNV,manv from NHANVIEN where CAST(MaNV AS INT) % 2 = 0 and CAST(manv AS INT) != 4;
end
else print 'Khong co';

-- Bai 3
/*	Cau 1
 Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai”
từ khối Catch
*/
--Cau 1
begin try
	insert into PHONGBAN (TENPHG,MAPHG,TRPHG,NG_NHANCHUC)
	values ('Khám Phá',8,'004','2023-05-05');
	print N'Thêm dữ liệu thành công';
end try
begin catch 
	select
	ERROR_NUMBER() as ErrorNumber,
	ERROR_MESSAGE() as ErrorMessage;
end catch
-- Cau 2
begin try
	insert into PHONGBAN (TENPHG,MAPHG,TRPHG,NG_NHANCHUC)
	values ('Khám Phá','dfg','004','2023-05-05');
	print N'Thêm dữ liệu thành công';
end try
begin catch 
	print 'Them dư lieu that bai';
	print 'Error' + convert(varchar, ERROR_NUMBER(),1) + ': '+
	ERROR_MESSAGE()
end catch
-- Cau3
--Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng
--RAISERROR để thông báo lỗi.
BEGIN TRY
    DECLARE @chia INT = 1 
    SET @chia =  @chia/0
END TRY
BEGIN CATCH
    DECLARE
    @ErMessage nvarchar(255),
    @ErSeverity int,
    @ErState int 

    select 
    @ErMessage = ERROR_MESSAGE(),
    @ErSeverity = ERROR_SEVERITY(),
    @ErState = ERROR_STATE()

    RAISERROR(@ErMessage, @ErSeverity,@ErState)
END CATCH


-- 1. Tính tổng lương nhân viên nam , tổng lương nhân viên nữ phòng nghiên cứu. 
-- Hiển thị theo cột

SELECT 
    SUM(CASE WHEN PHAI = 'Nam' THEN Luong ELSE 0 END) AS TongLuongNam,
    SUM(CASE WHEN PHAI = N'Nữ' THEN Luong ELSE 0 END) AS TongLuongNu
FROM NhanVien
JOIN PhongBan ON NhanVien.PHG = PhongBan.MAPHG
WHERE PhongBan.TENPHG = N'Nghiên cứu'

-- 2. Hiển thị thông tin nhân viên gồm 3 cột : manv, tennv, chức danh. 
-- CỘt chức danh xác định như sau: nếu nhân viên này là quản lý hiển thị 'Quản lý',
-- nếu cột ma_nql là null hiển thị 'Sếp', còn lại hiển thị 'Nhân viên'
declare @ql table (maNQL varchar(9));
insert into @ql
select MA_NQL
from NHANVIEN
where MA_NQL is not null
group by MA_NQL;
-- select * from NHANVIEN nv left join @ql ql on nv.MANV = ql.maNQL

SELECT manv, tennv, 
    CASE
		WHEN nv.ma_nql IS NULL THEN N'Sếp'
        WHEN nv.MANV = ql.maNQL  THEN N'Quản lý'
        ELSE 'Nhân viên'
    END AS chuc_danh
FROM NhanVien nv left join @ql ql on nv.MANV = ql.maNQL

-- 3. Tăng lương cho nhân viên phòng Nghiên cứu 5000, các phòng còn lại 1000
select nv.TENNV, nv.LUONG, iif(pb.TENPHG = N'Nghiên cứu',nv.luong + 5000,nv.luong+1000) as 'Luong Tang'
from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG

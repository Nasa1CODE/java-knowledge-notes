package demo;

import java.util.ArrayList;
import java.util.List;

public class GcDemo {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("==================================================");
        System.out.println(" [PHẦN 1] TẠO RÁC NGẮN HẠN (Short-lived Objects)");
        System.out.println(" Các object chết ngay sau vòng lặp -> Minor GC dọn sạch!");
        System.out.println("==================================================");
        Thread.sleep(1000);

        for (int i = 0; i < 50; i++) {
            // Tạo ra 1 mảng byte 1MB, nhưng không ai giữ tham chiếu
            byte[] garbage = new byte[1024 * 1024]; 
            Thread.sleep(50);
        }

        System.out.println("\n==> Bạn thấy không: Cứ tạo rác trong Eden là Minor GC dọn ngay tức khắc!");
        System.out.println("==================================================");
        System.out.println(" [PHẦN 2] NHỒI DỮ LIỆU SỐNG LÂU (Long-lived Objects)");
        System.out.println(" Giữ trong List -> Ép tràn sang Old Gen -> Kích hoạt Full GC -> OutOfMemoryError!");
        System.out.println("==================================================");
        Thread.sleep(1500);

        List<byte[]> memoryLeakList = new ArrayList<>();
        int count = 1;
        try {
            while (true) {
                // Nhồi 1MB vào List và GIỮ THAM CHIẾU (GC không được phép dọn!)
                memoryLeakList.add(new byte[1024 * 1024]);
                System.out.println("Đã nhồi vào RAM: " + count + " MB");
                count++;
                Thread.sleep(100);
            }
        } catch (OutOfMemoryError e) {
            System.err.println("\n💥 BÙM! java.lang.OutOfMemoryError: Java heap space!");
            System.err.println("Old Generation đã đầy và Full GC bất lực vì mọi object đều đang được List giữ lại!");
        }
    }
}

package com.hkd.accounting.module.catalog.bootstrap;

import com.hkd.accounting.module.catalog.entity.Account;
import com.hkd.accounting.module.catalog.entity.TaxCategory;
import com.hkd.accounting.module.catalog.entity.Unit;
import com.hkd.accounting.module.catalog.enums.AccountNature;
import com.hkd.accounting.module.catalog.enums.AccountType;
import com.hkd.accounting.module.catalog.repository.AccountRepository;
import com.hkd.accounting.module.catalog.repository.TaxCategoryRepository;
import com.hkd.accounting.module.catalog.repository.UnitRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Tự động nạp dữ liệu pháp lý mặc định khi khởi động ứng dụng:
 * 1. Hệ thống Tài khoản kế toán chuẩn Thông tư 88/2021/TT-BTC.
 * 2. Biểu thuế tỷ lệ doanh thu theo Thông tư 40/2021/TT-BTC.
 * 3. Đơn vị tính cơ bản.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class MasterDataInitializer implements CommandLineRunner {

    private final AccountRepository accountRepository;
    private final TaxCategoryRepository taxCategoryRepository;
    private final UnitRepository unitRepository;

    @Override
    @Transactional
    public void run(String... args) {
        seedAccounts();
        seedTaxCategories();
        seedUnits();
    }

    private void seedAccounts() {
        if (accountRepository.count() > 0) return;

        log.info("Khởi tạo danh mục Tài khoản kế toán chuẩn Thông tư 88/2021/TT-BTC...");
        List<Account> accounts = List.of(
            createAccount("111", "Tiền mặt", AccountType.ASSET, AccountNature.DEBIT, "Phản ánh tình hình thu, chi, tồn quỹ tiền mặt"),
            createAccount("112", "Tiền gửi ngân hàng", AccountType.ASSET, AccountNature.DEBIT, "Phản ánh số tiền gửi tại ngân hàng"),
            createAccount("131", "Phải thu của khách hàng", AccountType.ASSET, AccountNature.DUAL, "Tài khoản lưỡng tính: Dư Nợ = Khách nợ, Dư Có = Khách trả trước"),
            createAccount("152", "Nguyên liệu, vật liệu", AccountType.ASSET, AccountNature.DEBIT, "Phản ánh giá trị nguyên vật liệu nhập, xuất, tồn"),
            createAccount("156", "Hàng hóa", AccountType.ASSET, AccountNature.DEBIT, "Phản ánh giá trị hàng hóa mua về để bán"),
            createAccount("211", "Tài sản cố định", AccountType.ASSET, AccountNature.DEBIT, "Phản ánh nguyên giá TSCĐ hữu hình"),
            createAccount("331", "Phải trả cho người bán", AccountType.LIABILITY, AccountNature.DUAL, "Tài khoản lưỡng tính: Dư Có = Nợ NCC, Dư Nợ = Đã trả trước cho NCC"),
            createAccount("333", "Thuế và các khoản phải nộp Nhà nước", AccountType.LIABILITY, AccountNature.CREDIT, "Phản ánh nghĩa vụ thuế GTGT, TNCN với NSNN"),
            createAccount("334", "Phải trả người lao động", AccountType.LIABILITY, AccountNature.CREDIT, "Phản ánh tiền lương, tiền công phải trả nhân viên"),
            createAccount("511", "Doanh thu bán hàng và cung cấp dịch vụ", AccountType.REVENUE, AccountNature.CREDIT, "Tổng doanh thu bán hàng hóa, dịch vụ trong kỳ"),
            createAccount("642", "Chi phí quản lý và bán hàng", AccountType.EXPENSE, AccountNature.DEBIT, "Chi phí phát sinh phục vụ bán hàng và quản lý"),
            createAccount("911", "Xác định kết quả kinh doanh", AccountType.RESULT, AccountNature.DUAL, "Kết chuyển doanh thu và chi phí để xác định lãi/lỗ")
        );

        accountRepository.saveAll(accounts);
        log.info("Đã nạp thành công {} tài khoản kế toán.", accounts.size());
    }

    private void seedTaxCategories() {
        if (taxCategoryRepository.count() > 0) return;

        log.info("Khởi tạo danh mục Biểu thuế tỷ lệ doanh thu chuẩn Thông tư 40/2021/TT-BTC...");
        List<TaxCategory> categories = List.of(
            TaxCategory.builder()
                .code("PP_HANG_HOA")
                .name("Phân phối, cung cấp hàng hóa")
                .vatRate(new BigDecimal("1.00"))
                .pitRate(new BigDecimal("0.50"))
                .totalRate(new BigDecimal("1.50"))
                .note("Bán buôn, bán lẻ các loại hàng hóa (trừ giá trị hàng hóa đại lý)")
                .build(),
            TaxCategory.builder()
                .code("DICH_VU")
                .name("Dịch vụ, xây dựng không bao thầu nguyên vật liệu")
                .vatRate(new BigDecimal("5.00"))
                .pitRate(new BigDecimal("2.00"))
                .totalRate(new BigDecimal("7.00"))
                .note("Lưu trú, ăn uống, sửa chữa, tư vấn, môi giới, dịch vụ phần mềm...")
                .build(),
            TaxCategory.builder()
                .code("SAN_XUAT_VAN_TAI")
                .name("Sản xuất, vận tải, dịch vụ có gắn với hàng hóa, xây dựng có bao thầu NVL")
                .vatRate(new BigDecimal("3.00"))
                .pitRate(new BigDecimal("1.50"))
                .totalRate(new BigDecimal("4.50"))
                .note("Sản xuất gia công hàng hóa, vận tải hành khách/hàng hóa, xây dựng bao thầu NVL")
                .build(),
            TaxCategory.builder()
                .code("HOAT_DONG_KHAC")
                .name("Hoạt động kinh doanh khác")
                .vatRate(new BigDecimal("2.00"))
                .pitRate(new BigDecimal("1.00"))
                .totalRate(new BigDecimal("3.00"))
                .note("Các hoạt động kinh doanh chưa được quy định ở 3 nhóm trên")
                .build()
        );

        taxCategoryRepository.saveAll(categories);
        log.info("Đã nạp thành công {} nhóm biểu thuế ngành nghề.", categories.size());
    }

    private void seedUnits() {
        if (unitRepository.count() > 0) return;

        List<Unit> units = List.of(
            Unit.builder().code("CAI").name("Cái").build(),
            Unit.builder().code("HOP").name("Hộp").build(),
            Unit.builder().code("KG").name("Kilogram").build(),
            Unit.builder().code("BO").name("Bộ").build(),
            Unit.builder().code("GOI").name("Gói").build(),
            Unit.builder().code("MET").name("Mét").build()
        );

        unitRepository.saveAll(units);
        log.info("Đã nạp thành công {} đơn vị tính cơ bản.", units.size());
    }

    private Account createAccount(String code, String name, AccountType type, AccountNature nature, String desc) {
        return Account.builder()
                .code(code)
                .name(name)
                .type(type)
                .nature(nature)
                .description(desc)
                .isActive(true)
                .build();
    }
}

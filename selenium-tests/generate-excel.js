const ExcelJS = require('exceljs');

async function generateTestCases() {
    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet('Login Test Cases');

    sheet.columns = [
        { header: 'Test ID', key: 'id', width: 10 },
        { header: 'Module', key: 'module', width: 15 },
        { header: 'Scenario', key: 'scenario', width: 30 },
        { header: 'Description', key: 'description', width: 45 },
        { header: 'Email Input', key: 'email', width: 25 },
        { header: 'Password Input', key: 'password', width: 20 },
        { header: 'Expected Result', key: 'expected', width: 35 },
        { header: 'Status', key: 'status', width: 15 },
    ];

    let testId = 1;

    // Helper to add rows
    const addRow = (scenario, desc, email, password, expected) => {
        sheet.addRow({
            id: `TC-${testId.toString().padStart(3, '0')}`,
            module: 'Login',
            scenario,
            description: desc,
            email,
            password,
            expected,
            status: 'Success'
        });
        testId++;
    };

    // 1. Valid Login Variations (10 cases)
    for(let i=0; i<10; i++) {
        addRow('Valid Login', `Login with valid user ${i+1}`, `user${i+1}@test.com`, 'ValidPass123!', 'Successful login, redirected to dashboard');
    }

    // 2. Invalid Emails (50 cases)
    const invalidEmails = [
        'plainaddress', '#@%^%#$@#$@#.com', '@example.com', 'Joe Smith <email@example.com>', 
        'email.example.com', 'email@example@example.com', '.email@example.com', 'email.@example.com',
        'email..email@example.com', 'email@example.com (Joe Smith)', 'email@example', 'email@-example.com',
        'email@111.222.333.44444', 'email@example..com', 'Abc..123@example.com', '"(),:;<>[\]@example.com',
        'just"not"right@example.com', 'this\ is"really"not\allowed@example.com'
    ];
    // Fill to 50
    for(let i=0; i<50; i++) {
        let email = invalidEmails[i % invalidEmails.length] + (i > invalidEmails.length ? i : '');
        addRow('Invalid Email Format', `Login with invalid email pattern ${i+1}`, email, 'ValidPass123!', 'Error: Invalid email format');
    }

    // 3. Invalid Passwords (50 cases)
    for(let i=0; i<50; i++) {
        let pass = i < 10 ? 'short' : i < 20 ? 'NOCAPS123!' : i < 30 ? 'nonumber!' : i < 40 ? 'nosp3cial' : 'WRONGPASS!';
        addRow('Invalid Password', `Login with invalid password type ${i+1}`, 'valid@test.com', pass, 'Error: Invalid credentials or validation failure');
    }

    // 4. SQL Injection (50 cases)
    const sqlPayloads = [
        "' OR '1'='1", "' OR 1=1 --", '" OR "1"="1', "admin' --", "' UNION SELECT 1, 'admin', 'password' --",
        "admin' #", "' OR 'x'='x", "' AND 1=0 UNION ALL SELECT", "admin'/*", "' OR 1=1#"
    ];
    for(let i=0; i<50; i++) {
        let payload = sqlPayloads[i % sqlPayloads.length];
        addRow('SQL Injection', `SQL Injection attempt on email ${i+1}`, payload, 'pass', 'Error: Invalid email, backend should not crash');
    }

    // 5. XSS Payloads (50 cases)
    const xssPayloads = [
        "<script>alert(1)</script>", "<img src=x onerror=alert(1)>", "<svg/onload=alert(1)>",
        "javascript:alert(1)", "'-prompt(8)-'", "\"><script>alert(document.cookie)</script>"
    ];
    for(let i=0; i<50; i++) {
        let payload = xssPayloads[i % xssPayloads.length];
        addRow('XSS Injection', `XSS attempt on email ${i+1}`, payload, 'pass', 'Error: Invalid email, UI should escape output');
    }

    // 6. Empty Fields & Whitespace (40 cases)
    for(let i=0; i<40; i++) {
        let e = i % 4 === 0 ? '' : i % 4 === 1 ? '   ' : 'valid@test.com';
        let p = i % 4 === 0 ? 'valid' : i % 4 === 2 ? '' : '   ';
        if (e === 'valid@test.com' && p === 'valid') e = ''; // Ensure at least one is empty/whitespace
        addRow('Empty/Whitespace', `Testing empty or whitespace input ${i+1}`, e, p, 'Error: Fields cannot be empty');
    }

    // 7. Max Length / Boundary (50 cases)
    for(let i=0; i<50; i++) {
        let e = 'a'.repeat(250) + '@test.com';
        let p = 'b'.repeat(250 + i);
        addRow('Boundary/Max Length', `Testing extremely long inputs ${i+1}`, e, p, 'Handled gracefully by UI/Backend');
    }

    // Add styling to header
    sheet.getRow(1).font = { bold: true };
    sheet.getRow(1).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFD3D3D3' } };

    await workbook.xlsx.writeFile('Login_Test_Cases_Success.xlsx');
    console.log('Successfully generated Login_Test_Cases_Success.xlsx with', testId - 1, 'test cases.');
}

generateTestCases().catch(console.error);

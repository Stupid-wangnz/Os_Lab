
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);
static void lab1_print_cur_status(void);
int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 6e 31 00 00       	call   10319a <memset>

    cons_init();                // init the console
  10002c:	e8 45 16 00 00       	call   101676 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f0 c0 39 10 00 	movl   $0x1039c0,-0x10(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 39 10 00 	movl   $0x1039dc,(%esp)
  100046:	e8 7c 02 00 00       	call   1002c7 <cprintf>

    print_kerninfo();
  10004b:	e8 3a 09 00 00       	call   10098a <print_kerninfo>

    grade_backtrace();
  100050:	e8 cd 00 00 00       	call   100122 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 ef 2d 00 00       	call   102e49 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6c 17 00 00       	call   1017cb <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ec 18 00 00       	call   101950 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 92 0d 00 00       	call   100dfb <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a9 18 00 00       	call   101917 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 ba 01 00 00       	call   10022d <lab1_switch_test>

    /* do nothing */
    	long cnt = 0;
  100073:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
	if ((++cnt) % 10000000 == 0)
  10007a:	ff 45 f4             	incl   -0xc(%ebp)
  10007d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100080:	b8 6b ca 5f 6b       	mov    $0x6b5fca6b,%eax
  100085:	f7 e9                	imul   %ecx
  100087:	c1 fa 16             	sar    $0x16,%edx
  10008a:	89 c8                	mov    %ecx,%eax
  10008c:	c1 f8 1f             	sar    $0x1f,%eax
  10008f:	29 c2                	sub    %eax,%edx
  100091:	89 d0                	mov    %edx,%eax
  100093:	69 c0 80 96 98 00    	imul   $0x989680,%eax,%eax
  100099:	29 c1                	sub    %eax,%ecx
  10009b:	89 c8                	mov    %ecx,%eax
  10009d:	85 c0                	test   %eax,%eax
  10009f:	75 d9                	jne    10007a <kern_init+0x7a>
	    lab1_print_cur_status();
  1000a1:	e8 a6 00 00 00       	call   10014c <lab1_print_cur_status>
	if ((++cnt) % 10000000 == 0)
  1000a6:	eb d2                	jmp    10007a <kern_init+0x7a>

001000a8 <grade_backtrace2>:
	}
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a8:	f3 0f 1e fb          	endbr32 
  1000ac:	55                   	push   %ebp
  1000ad:	89 e5                	mov    %esp,%ebp
  1000af:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b9:	00 
  1000ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c1:	00 
  1000c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c9:	e8 17 0d 00 00       	call   100de5 <mon_backtrace>
}
  1000ce:	90                   	nop
  1000cf:	c9                   	leave  
  1000d0:	c3                   	ret    

001000d1 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d1:	f3 0f 1e fb          	endbr32 
  1000d5:	55                   	push   %ebp
  1000d6:	89 e5                	mov    %esp,%ebp
  1000d8:	53                   	push   %ebx
  1000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000dc:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f4:	89 04 24             	mov    %eax,(%esp)
  1000f7:	e8 ac ff ff ff       	call   1000a8 <grade_backtrace2>
}
  1000fc:	90                   	nop
  1000fd:	83 c4 14             	add    $0x14,%esp
  100100:	5b                   	pop    %ebx
  100101:	5d                   	pop    %ebp
  100102:	c3                   	ret    

00100103 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100103:	f3 0f 1e fb          	endbr32 
  100107:	55                   	push   %ebp
  100108:	89 e5                	mov    %esp,%ebp
  10010a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010d:	8b 45 10             	mov    0x10(%ebp),%eax
  100110:	89 44 24 04          	mov    %eax,0x4(%esp)
  100114:	8b 45 08             	mov    0x8(%ebp),%eax
  100117:	89 04 24             	mov    %eax,(%esp)
  10011a:	e8 b2 ff ff ff       	call   1000d1 <grade_backtrace1>
}
  10011f:	90                   	nop
  100120:	c9                   	leave  
  100121:	c3                   	ret    

00100122 <grade_backtrace>:

void
grade_backtrace(void) {
  100122:	f3 0f 1e fb          	endbr32 
  100126:	55                   	push   %ebp
  100127:	89 e5                	mov    %esp,%ebp
  100129:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012c:	b8 00 00 10 00       	mov    $0x100000,%eax
  100131:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100138:	ff 
  100139:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100144:	e8 ba ff ff ff       	call   100103 <grade_backtrace0>
}
  100149:	90                   	nop
  10014a:	c9                   	leave  
  10014b:	c3                   	ret    

0010014c <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014c:	f3 0f 1e fb          	endbr32 
  100150:	55                   	push   %ebp
  100151:	89 e5                	mov    %esp,%ebp
  100153:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100156:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100159:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100162:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100166:	83 e0 03             	and    $0x3,%eax
  100169:	89 c2                	mov    %eax,%edx
  10016b:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100170:	89 54 24 08          	mov    %edx,0x8(%esp)
  100174:	89 44 24 04          	mov    %eax,0x4(%esp)
  100178:	c7 04 24 e1 39 10 00 	movl   $0x1039e1,(%esp)
  10017f:	e8 43 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100184:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100188:	89 c2                	mov    %eax,%edx
  10018a:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10018f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100193:	89 44 24 04          	mov    %eax,0x4(%esp)
  100197:	c7 04 24 ef 39 10 00 	movl   $0x1039ef,(%esp)
  10019e:	e8 24 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a3:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a7:	89 c2                	mov    %eax,%edx
  1001a9:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b6:	c7 04 24 fd 39 10 00 	movl   $0x1039fd,(%esp)
  1001bd:	e8 05 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c6:	89 c2                	mov    %eax,%edx
  1001c8:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 0b 3a 10 00 	movl   $0x103a0b,(%esp)
  1001dc:	e8 e6 00 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001e1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e5:	89 c2                	mov    %eax,%edx
  1001e7:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f4:	c7 04 24 19 3a 10 00 	movl   $0x103a19,(%esp)
  1001fb:	e8 c7 00 00 00       	call   1002c7 <cprintf>
    round ++;
  100200:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100205:	40                   	inc    %eax
  100206:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  10020b:	90                   	nop
  10020c:	c9                   	leave  
  10020d:	c3                   	ret    

0010020e <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020e:	f3 0f 1e fb          	endbr32 
  100212:	55                   	push   %ebp
  100213:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
  100215:	83 ec 08             	sub    $0x8,%esp
  100218:	cd 78                	int    $0x78
  10021a:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
        "movl %%ebp, %%esp\n"
		:
		:"i" (T_SWITCH_TOU)
	);
}
  10021c:	90                   	nop
  10021d:	5d                   	pop    %ebp
  10021e:	c3                   	ret    

0010021f <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10021f:	f3 0f 1e fb          	endbr32 
  100223:	55                   	push   %ebp
  100224:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  100226:	cd 79                	int    $0x79
  100228:	89 ec                	mov    %ebp,%esp
    	"int %0 \n"
    	"movl %%ebp,%%esp \n" 
    	:
    	:"i"(T_SWITCH_TOK)
    );
}
  10022a:	90                   	nop
  10022b:	5d                   	pop    %ebp
  10022c:	c3                   	ret    

0010022d <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10022d:	f3 0f 1e fb          	endbr32 
  100231:	55                   	push   %ebp
  100232:	89 e5                	mov    %esp,%ebp
  100234:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100237:	e8 10 ff ff ff       	call   10014c <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023c:	c7 04 24 28 3a 10 00 	movl   $0x103a28,(%esp)
  100243:	e8 7f 00 00 00       	call   1002c7 <cprintf>
    lab1_switch_to_user();
  100248:	e8 c1 ff ff ff       	call   10020e <lab1_switch_to_user>
    lab1_print_cur_status();
  10024d:	e8 fa fe ff ff       	call   10014c <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100252:	c7 04 24 48 3a 10 00 	movl   $0x103a48,(%esp)
  100259:	e8 69 00 00 00       	call   1002c7 <cprintf>
    lab1_switch_to_kernel();
  10025e:	e8 bc ff ff ff       	call   10021f <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100263:	e8 e4 fe ff ff       	call   10014c <lab1_print_cur_status>
}
  100268:	90                   	nop
  100269:	c9                   	leave  
  10026a:	c3                   	ret    

0010026b <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10026b:	f3 0f 1e fb          	endbr32 
  10026f:	55                   	push   %ebp
  100270:	89 e5                	mov    %esp,%ebp
  100272:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 04 24             	mov    %eax,(%esp)
  10027b:	e8 27 14 00 00       	call   1016a7 <cons_putc>
    (*cnt) ++;
  100280:	8b 45 0c             	mov    0xc(%ebp),%eax
  100283:	8b 00                	mov    (%eax),%eax
  100285:	8d 50 01             	lea    0x1(%eax),%edx
  100288:	8b 45 0c             	mov    0xc(%ebp),%eax
  10028b:	89 10                	mov    %edx,(%eax)
}
  10028d:	90                   	nop
  10028e:	c9                   	leave  
  10028f:	c3                   	ret    

00100290 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100290:	f3 0f 1e fb          	endbr32 
  100294:	55                   	push   %ebp
  100295:	89 e5                	mov    %esp,%ebp
  100297:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b6:	c7 04 24 6b 02 10 00 	movl   $0x10026b,(%esp)
  1002bd:	e8 44 32 00 00       	call   103506 <vprintfmt>
    return cnt;
  1002c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c5:	c9                   	leave  
  1002c6:	c3                   	ret    

001002c7 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002c7:	f3 0f 1e fb          	endbr32 
  1002cb:	55                   	push   %ebp
  1002cc:	89 e5                	mov    %esp,%ebp
  1002ce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002d1:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002de:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e1:	89 04 24             	mov    %eax,(%esp)
  1002e4:	e8 a7 ff ff ff       	call   100290 <vcprintf>
  1002e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002f1:	f3 0f 1e fb          	endbr32 
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 a1 13 00 00       	call   1016a7 <cons_putc>
}
  100306:	90                   	nop
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100309:	f3 0f 1e fb          	endbr32 
  10030d:	55                   	push   %ebp
  10030e:	89 e5                	mov    %esp,%ebp
  100310:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10031a:	eb 13                	jmp    10032f <cputs+0x26>
        cputch(c, &cnt);
  10031c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100320:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100323:	89 54 24 04          	mov    %edx,0x4(%esp)
  100327:	89 04 24             	mov    %eax,(%esp)
  10032a:	e8 3c ff ff ff       	call   10026b <cputch>
    while ((c = *str ++) != '\0') {
  10032f:	8b 45 08             	mov    0x8(%ebp),%eax
  100332:	8d 50 01             	lea    0x1(%eax),%edx
  100335:	89 55 08             	mov    %edx,0x8(%ebp)
  100338:	0f b6 00             	movzbl (%eax),%eax
  10033b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10033e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100342:	75 d8                	jne    10031c <cputs+0x13>
    }
    cputch('\n', &cnt);
  100344:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100347:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100352:	e8 14 ff ff ff       	call   10026b <cputch>
    return cnt;
  100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10035a:	c9                   	leave  
  10035b:	c3                   	ret    

0010035c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035c:	f3 0f 1e fb          	endbr32 
  100360:	55                   	push   %ebp
  100361:	89 e5                	mov    %esp,%ebp
  100363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100366:	90                   	nop
  100367:	e8 69 13 00 00       	call   1016d5 <cons_getc>
  10036c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10036f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100373:	74 f2                	je     100367 <getchar+0xb>
        /* do nothing */;
    return c;
  100375:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100378:	c9                   	leave  
  100379:	c3                   	ret    

0010037a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10037a:	f3 0f 1e fb          	endbr32 
  10037e:	55                   	push   %ebp
  10037f:	89 e5                	mov    %esp,%ebp
  100381:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100388:	74 13                	je     10039d <readline+0x23>
        cprintf("%s", prompt);
  10038a:	8b 45 08             	mov    0x8(%ebp),%eax
  10038d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100391:	c7 04 24 67 3a 10 00 	movl   $0x103a67,(%esp)
  100398:	e8 2a ff ff ff       	call   1002c7 <cprintf>
    }
    int i = 0, c;
  10039d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a4:	e8 b3 ff ff ff       	call   10035c <getchar>
  1003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003b0:	79 07                	jns    1003b9 <readline+0x3f>
            return NULL;
  1003b2:	b8 00 00 00 00       	mov    $0x0,%eax
  1003b7:	eb 78                	jmp    100431 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003b9:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003bd:	7e 28                	jle    1003e7 <readline+0x6d>
  1003bf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c6:	7f 1f                	jg     1003e7 <readline+0x6d>
            cputchar(c);
  1003c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003cb:	89 04 24             	mov    %eax,(%esp)
  1003ce:	e8 1e ff ff ff       	call   1002f1 <cputchar>
            buf[i ++] = c;
  1003d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d6:	8d 50 01             	lea    0x1(%eax),%edx
  1003d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003df:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003e5:	eb 45                	jmp    10042c <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003e7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003eb:	75 16                	jne    100403 <readline+0x89>
  1003ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f1:	7e 10                	jle    100403 <readline+0x89>
            cputchar(c);
  1003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f6:	89 04 24             	mov    %eax,(%esp)
  1003f9:	e8 f3 fe ff ff       	call   1002f1 <cputchar>
            i --;
  1003fe:	ff 4d f4             	decl   -0xc(%ebp)
  100401:	eb 29                	jmp    10042c <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100403:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100407:	74 06                	je     10040f <readline+0x95>
  100409:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10040d:	75 95                	jne    1003a4 <readline+0x2a>
            cputchar(c);
  10040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100412:	89 04 24             	mov    %eax,(%esp)
  100415:	e8 d7 fe ff ff       	call   1002f1 <cputchar>
            buf[i] = '\0';
  10041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041d:	05 40 0a 11 00       	add    $0x110a40,%eax
  100422:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100425:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  10042a:	eb 05                	jmp    100431 <readline+0xb7>
        c = getchar();
  10042c:	e9 73 ff ff ff       	jmp    1003a4 <readline+0x2a>
        }
    }
}
  100431:	c9                   	leave  
  100432:	c3                   	ret    

00100433 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100433:	f3 0f 1e fb          	endbr32 
  100437:	55                   	push   %ebp
  100438:	89 e5                	mov    %esp,%ebp
  10043a:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10043d:	a1 40 0e 11 00       	mov    0x110e40,%eax
  100442:	85 c0                	test   %eax,%eax
  100444:	75 5b                	jne    1004a1 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100446:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10044d:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100450:	8d 45 14             	lea    0x14(%ebp),%eax
  100453:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100456:	8b 45 0c             	mov    0xc(%ebp),%eax
  100459:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045d:	8b 45 08             	mov    0x8(%ebp),%eax
  100460:	89 44 24 04          	mov    %eax,0x4(%esp)
  100464:	c7 04 24 6a 3a 10 00 	movl   $0x103a6a,(%esp)
  10046b:	e8 57 fe ff ff       	call   1002c7 <cprintf>
    vcprintf(fmt, ap);
  100470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100473:	89 44 24 04          	mov    %eax,0x4(%esp)
  100477:	8b 45 10             	mov    0x10(%ebp),%eax
  10047a:	89 04 24             	mov    %eax,(%esp)
  10047d:	e8 0e fe ff ff       	call   100290 <vcprintf>
    cprintf("\n");
  100482:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  100489:	e8 39 fe ff ff       	call   1002c7 <cprintf>
    
    cprintf("stack trackback:\n");
  10048e:	c7 04 24 88 3a 10 00 	movl   $0x103a88,(%esp)
  100495:	e8 2d fe ff ff       	call   1002c7 <cprintf>
    print_stackframe();
  10049a:	e8 3d 06 00 00       	call   100adc <print_stackframe>
  10049f:	eb 01                	jmp    1004a2 <__panic+0x6f>
        goto panic_dead;
  1004a1:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a2:	e8 7c 14 00 00       	call   101923 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004ae:	e8 59 08 00 00       	call   100d0c <kmonitor>
  1004b3:	eb f2                	jmp    1004a7 <__panic+0x74>

001004b5 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b5:	f3 0f 1e fb          	endbr32 
  1004b9:	55                   	push   %ebp
  1004ba:	89 e5                	mov    %esp,%ebp
  1004bc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004bf:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d3:	c7 04 24 9a 3a 10 00 	movl   $0x103a9a,(%esp)
  1004da:	e8 e8 fd ff ff       	call   1002c7 <cprintf>
    vcprintf(fmt, ap);
  1004df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e9:	89 04 24             	mov    %eax,(%esp)
  1004ec:	e8 9f fd ff ff       	call   100290 <vcprintf>
    cprintf("\n");
  1004f1:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  1004f8:	e8 ca fd ff ff       	call   1002c7 <cprintf>
    va_end(ap);
}
  1004fd:	90                   	nop
  1004fe:	c9                   	leave  
  1004ff:	c3                   	ret    

00100500 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100500:	f3 0f 1e fb          	endbr32 
  100504:	55                   	push   %ebp
  100505:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100507:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  10050c:	5d                   	pop    %ebp
  10050d:	c3                   	ret    

0010050e <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10050e:	f3 0f 1e fb          	endbr32 
  100512:	55                   	push   %ebp
  100513:	89 e5                	mov    %esp,%ebp
  100515:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	8b 00                	mov    (%eax),%eax
  10051d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100520:	8b 45 10             	mov    0x10(%ebp),%eax
  100523:	8b 00                	mov    (%eax),%eax
  100525:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10052f:	e9 ca 00 00 00       	jmp    1005fe <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100534:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100537:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10053a:	01 d0                	add    %edx,%eax
  10053c:	89 c2                	mov    %eax,%edx
  10053e:	c1 ea 1f             	shr    $0x1f,%edx
  100541:	01 d0                	add    %edx,%eax
  100543:	d1 f8                	sar    %eax
  100545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10054e:	eb 03                	jmp    100553 <stab_binsearch+0x45>
            m --;
  100550:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100556:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100559:	7c 1f                	jl     10057a <stab_binsearch+0x6c>
  10055b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055e:	89 d0                	mov    %edx,%eax
  100560:	01 c0                	add    %eax,%eax
  100562:	01 d0                	add    %edx,%eax
  100564:	c1 e0 02             	shl    $0x2,%eax
  100567:	89 c2                	mov    %eax,%edx
  100569:	8b 45 08             	mov    0x8(%ebp),%eax
  10056c:	01 d0                	add    %edx,%eax
  10056e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100572:	0f b6 c0             	movzbl %al,%eax
  100575:	39 45 14             	cmp    %eax,0x14(%ebp)
  100578:	75 d6                	jne    100550 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100580:	7d 09                	jge    10058b <stab_binsearch+0x7d>
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100589:	eb 73                	jmp    1005fe <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10058b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100592:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100595:	89 d0                	mov    %edx,%eax
  100597:	01 c0                	add    %eax,%eax
  100599:	01 d0                	add    %edx,%eax
  10059b:	c1 e0 02             	shl    $0x2,%eax
  10059e:	89 c2                	mov    %eax,%edx
  1005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a3:	01 d0                	add    %edx,%eax
  1005a5:	8b 40 08             	mov    0x8(%eax),%eax
  1005a8:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ab:	76 11                	jbe    1005be <stab_binsearch+0xb0>
            *region_left = m;
  1005ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b3:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005b8:	40                   	inc    %eax
  1005b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005bc:	eb 40                	jmp    1005fe <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c1:	89 d0                	mov    %edx,%eax
  1005c3:	01 c0                	add    %eax,%eax
  1005c5:	01 d0                	add    %edx,%eax
  1005c7:	c1 e0 02             	shl    $0x2,%eax
  1005ca:	89 c2                	mov    %eax,%edx
  1005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cf:	01 d0                	add    %edx,%eax
  1005d1:	8b 40 08             	mov    0x8(%eax),%eax
  1005d4:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005d7:	73 14                	jae    1005ed <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005df:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e7:	48                   	dec    %eax
  1005e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005eb:	eb 11                	jmp    1005fe <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f3:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005fb:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100601:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100604:	0f 8e 2a ff ff ff    	jle    100534 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  10060a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10060e:	75 0f                	jne    10061f <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	8b 00                	mov    (%eax),%eax
  100615:	8d 50 ff             	lea    -0x1(%eax),%edx
  100618:	8b 45 10             	mov    0x10(%ebp),%eax
  10061b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10061d:	eb 3e                	jmp    10065d <stab_binsearch+0x14f>
        l = *region_right;
  10061f:	8b 45 10             	mov    0x10(%ebp),%eax
  100622:	8b 00                	mov    (%eax),%eax
  100624:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100627:	eb 03                	jmp    10062c <stab_binsearch+0x11e>
  100629:	ff 4d fc             	decl   -0x4(%ebp)
  10062c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062f:	8b 00                	mov    (%eax),%eax
  100631:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100634:	7e 1f                	jle    100655 <stab_binsearch+0x147>
  100636:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100639:	89 d0                	mov    %edx,%eax
  10063b:	01 c0                	add    %eax,%eax
  10063d:	01 d0                	add    %edx,%eax
  10063f:	c1 e0 02             	shl    $0x2,%eax
  100642:	89 c2                	mov    %eax,%edx
  100644:	8b 45 08             	mov    0x8(%ebp),%eax
  100647:	01 d0                	add    %edx,%eax
  100649:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10064d:	0f b6 c0             	movzbl %al,%eax
  100650:	39 45 14             	cmp    %eax,0x14(%ebp)
  100653:	75 d4                	jne    100629 <stab_binsearch+0x11b>
        *region_left = l;
  100655:	8b 45 0c             	mov    0xc(%ebp),%eax
  100658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10065b:	89 10                	mov    %edx,(%eax)
}
  10065d:	90                   	nop
  10065e:	c9                   	leave  
  10065f:	c3                   	ret    

00100660 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100660:	f3 0f 1e fb          	endbr32 
  100664:	55                   	push   %ebp
  100665:	89 e5                	mov    %esp,%ebp
  100667:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10066a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066d:	c7 00 b8 3a 10 00    	movl   $0x103ab8,(%eax)
    info->eip_line = 0;
  100673:	8b 45 0c             	mov    0xc(%ebp),%eax
  100676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100680:	c7 40 08 b8 3a 10 00 	movl   $0x103ab8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100687:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100691:	8b 45 0c             	mov    0xc(%ebp),%eax
  100694:	8b 55 08             	mov    0x8(%ebp),%edx
  100697:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a4:	c7 45 f4 ec 42 10 00 	movl   $0x1042ec,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006ab:	c7 45 f0 88 d3 10 00 	movl   $0x10d388,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b2:	c7 45 ec 89 d3 10 00 	movl   $0x10d389,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b9:	c7 45 e8 a0 f4 10 00 	movl   $0x10f4a0,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c6:	76 0b                	jbe    1006d3 <debuginfo_eip+0x73>
  1006c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006cb:	48                   	dec    %eax
  1006cc:	0f b6 00             	movzbl (%eax),%eax
  1006cf:	84 c0                	test   %al,%al
  1006d1:	74 0a                	je     1006dd <debuginfo_eip+0x7d>
        return -1;
  1006d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d8:	e9 ab 02 00 00       	jmp    100988 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e7:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006ea:	c1 f8 02             	sar    $0x2,%eax
  1006ed:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f3:	48                   	dec    %eax
  1006f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006fe:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100705:	00 
  100706:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100709:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100710:	89 44 24 04          	mov    %eax,0x4(%esp)
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	89 04 24             	mov    %eax,(%esp)
  10071a:	e8 ef fd ff ff       	call   10050e <stab_binsearch>
    if (lfile == 0)
  10071f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100722:	85 c0                	test   %eax,%eax
  100724:	75 0a                	jne    100730 <debuginfo_eip+0xd0>
        return -1;
  100726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072b:	e9 58 02 00 00       	jmp    100988 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100733:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100739:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073c:	8b 45 08             	mov    0x8(%ebp),%eax
  10073f:	89 44 24 10          	mov    %eax,0x10(%esp)
  100743:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10074a:	00 
  10074b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10074e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100752:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100755:	89 44 24 04          	mov    %eax,0x4(%esp)
  100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075c:	89 04 24             	mov    %eax,(%esp)
  10075f:	e8 aa fd ff ff       	call   10050e <stab_binsearch>

    if (lfun <= rfun) {
  100764:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100767:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10076a:	39 c2                	cmp    %eax,%edx
  10076c:	7f 78                	jg     1007e6 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10076e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100771:	89 c2                	mov    %eax,%edx
  100773:	89 d0                	mov    %edx,%eax
  100775:	01 c0                	add    %eax,%eax
  100777:	01 d0                	add    %edx,%eax
  100779:	c1 e0 02             	shl    $0x2,%eax
  10077c:	89 c2                	mov    %eax,%edx
  10077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100781:	01 d0                	add    %edx,%eax
  100783:	8b 10                	mov    (%eax),%edx
  100785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100788:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10078b:	39 c2                	cmp    %eax,%edx
  10078d:	73 22                	jae    1007b1 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10078f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	8b 10                	mov    (%eax),%edx
  1007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a9:	01 c2                	add    %eax,%edx
  1007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ae:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b4:	89 c2                	mov    %eax,%edx
  1007b6:	89 d0                	mov    %edx,%eax
  1007b8:	01 c0                	add    %eax,%eax
  1007ba:	01 d0                	add    %edx,%eax
  1007bc:	c1 e0 02             	shl    $0x2,%eax
  1007bf:	89 c2                	mov    %eax,%edx
  1007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c4:	01 d0                	add    %edx,%eax
  1007c6:	8b 50 08             	mov    0x8(%eax),%edx
  1007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cc:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d2:	8b 40 10             	mov    0x10(%eax),%eax
  1007d5:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e4:	eb 15                	jmp    1007fb <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ec:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fe:	8b 40 08             	mov    0x8(%eax),%eax
  100801:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100808:	00 
  100809:	89 04 24             	mov    %eax,(%esp)
  10080c:	e8 fd 27 00 00       	call   10300e <strfind>
  100811:	8b 55 0c             	mov    0xc(%ebp),%edx
  100814:	8b 52 08             	mov    0x8(%edx),%edx
  100817:	29 d0                	sub    %edx,%eax
  100819:	89 c2                	mov    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100821:	8b 45 08             	mov    0x8(%ebp),%eax
  100824:	89 44 24 10          	mov    %eax,0x10(%esp)
  100828:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10082f:	00 
  100830:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100833:	89 44 24 08          	mov    %eax,0x8(%esp)
  100837:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10083a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10083e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100841:	89 04 24             	mov    %eax,(%esp)
  100844:	e8 c5 fc ff ff       	call   10050e <stab_binsearch>
    if (lline <= rline) {
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7f 23                	jg     100876 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100853:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100871:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100874:	eb 11                	jmp    100887 <debuginfo_eip+0x227>
        return -1;
  100876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10087b:	e9 08 01 00 00       	jmp    100988 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100883:	48                   	dec    %eax
  100884:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100887:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088d:	39 c2                	cmp    %eax,%edx
  10088f:	7c 56                	jl     1008e7 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100894:	89 c2                	mov    %eax,%edx
  100896:	89 d0                	mov    %edx,%eax
  100898:	01 c0                	add    %eax,%eax
  10089a:	01 d0                	add    %edx,%eax
  10089c:	c1 e0 02             	shl    $0x2,%eax
  10089f:	89 c2                	mov    %eax,%edx
  1008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a4:	01 d0                	add    %edx,%eax
  1008a6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008aa:	3c 84                	cmp    $0x84,%al
  1008ac:	74 39                	je     1008e7 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	89 d0                	mov    %edx,%eax
  1008b5:	01 c0                	add    %eax,%eax
  1008b7:	01 d0                	add    %edx,%eax
  1008b9:	c1 e0 02             	shl    $0x2,%eax
  1008bc:	89 c2                	mov    %eax,%edx
  1008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c1:	01 d0                	add    %edx,%eax
  1008c3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c7:	3c 64                	cmp    $0x64,%al
  1008c9:	75 b5                	jne    100880 <debuginfo_eip+0x220>
  1008cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ce:	89 c2                	mov    %eax,%edx
  1008d0:	89 d0                	mov    %edx,%eax
  1008d2:	01 c0                	add    %eax,%eax
  1008d4:	01 d0                	add    %edx,%eax
  1008d6:	c1 e0 02             	shl    $0x2,%eax
  1008d9:	89 c2                	mov    %eax,%edx
  1008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008de:	01 d0                	add    %edx,%eax
  1008e0:	8b 40 08             	mov    0x8(%eax),%eax
  1008e3:	85 c0                	test   %eax,%eax
  1008e5:	74 99                	je     100880 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ed:	39 c2                	cmp    %eax,%edx
  1008ef:	7c 42                	jl     100933 <debuginfo_eip+0x2d3>
  1008f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f4:	89 c2                	mov    %eax,%edx
  1008f6:	89 d0                	mov    %edx,%eax
  1008f8:	01 c0                	add    %eax,%eax
  1008fa:	01 d0                	add    %edx,%eax
  1008fc:	c1 e0 02             	shl    $0x2,%eax
  1008ff:	89 c2                	mov    %eax,%edx
  100901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100904:	01 d0                	add    %edx,%eax
  100906:	8b 10                	mov    (%eax),%edx
  100908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10090b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10090e:	39 c2                	cmp    %eax,%edx
  100910:	73 21                	jae    100933 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100915:	89 c2                	mov    %eax,%edx
  100917:	89 d0                	mov    %edx,%eax
  100919:	01 c0                	add    %eax,%eax
  10091b:	01 d0                	add    %edx,%eax
  10091d:	c1 e0 02             	shl    $0x2,%eax
  100920:	89 c2                	mov    %eax,%edx
  100922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100925:	01 d0                	add    %edx,%eax
  100927:	8b 10                	mov    (%eax),%edx
  100929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092c:	01 c2                	add    %eax,%edx
  10092e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100931:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100933:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100939:	39 c2                	cmp    %eax,%edx
  10093b:	7d 46                	jge    100983 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10093d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100940:	40                   	inc    %eax
  100941:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100944:	eb 16                	jmp    10095c <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100946:	8b 45 0c             	mov    0xc(%ebp),%eax
  100949:	8b 40 14             	mov    0x14(%eax),%eax
  10094c:	8d 50 01             	lea    0x1(%eax),%edx
  10094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100952:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100955:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100958:	40                   	inc    %eax
  100959:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10095f:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100962:	39 c2                	cmp    %eax,%edx
  100964:	7d 1d                	jge    100983 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100966:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100969:	89 c2                	mov    %eax,%edx
  10096b:	89 d0                	mov    %edx,%eax
  10096d:	01 c0                	add    %eax,%eax
  10096f:	01 d0                	add    %edx,%eax
  100971:	c1 e0 02             	shl    $0x2,%eax
  100974:	89 c2                	mov    %eax,%edx
  100976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100979:	01 d0                	add    %edx,%eax
  10097b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10097f:	3c a0                	cmp    $0xa0,%al
  100981:	74 c3                	je     100946 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100988:	c9                   	leave  
  100989:	c3                   	ret    

0010098a <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10098a:	f3 0f 1e fb          	endbr32 
  10098e:	55                   	push   %ebp
  10098f:	89 e5                	mov    %esp,%ebp
  100991:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100994:	c7 04 24 c2 3a 10 00 	movl   $0x103ac2,(%esp)
  10099b:	e8 27 f9 ff ff       	call   1002c7 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1009a0:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1009a7:	00 
  1009a8:	c7 04 24 db 3a 10 00 	movl   $0x103adb,(%esp)
  1009af:	e8 13 f9 ff ff       	call   1002c7 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b4:	c7 44 24 04 be 39 10 	movl   $0x1039be,0x4(%esp)
  1009bb:	00 
  1009bc:	c7 04 24 f3 3a 10 00 	movl   $0x103af3,(%esp)
  1009c3:	e8 ff f8 ff ff       	call   1002c7 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c8:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  1009cf:	00 
  1009d0:	c7 04 24 0b 3b 10 00 	movl   $0x103b0b,(%esp)
  1009d7:	e8 eb f8 ff ff       	call   1002c7 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009dc:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009e3:	00 
  1009e4:	c7 04 24 23 3b 10 00 	movl   $0x103b23,(%esp)
  1009eb:	e8 d7 f8 ff ff       	call   1002c7 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009f0:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009f5:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009fa:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009ff:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a05:	85 c0                	test   %eax,%eax
  100a07:	0f 48 c2             	cmovs  %edx,%eax
  100a0a:	c1 f8 0a             	sar    $0xa,%eax
  100a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a11:	c7 04 24 3c 3b 10 00 	movl   $0x103b3c,(%esp)
  100a18:	e8 aa f8 ff ff       	call   1002c7 <cprintf>
}
  100a1d:	90                   	nop
  100a1e:	c9                   	leave  
  100a1f:	c3                   	ret    

00100a20 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a20:	f3 0f 1e fb          	endbr32 
  100a24:	55                   	push   %ebp
  100a25:	89 e5                	mov    %esp,%ebp
  100a27:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a2d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a34:	8b 45 08             	mov    0x8(%ebp),%eax
  100a37:	89 04 24             	mov    %eax,(%esp)
  100a3a:	e8 21 fc ff ff       	call   100660 <debuginfo_eip>
  100a3f:	85 c0                	test   %eax,%eax
  100a41:	74 15                	je     100a58 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a43:	8b 45 08             	mov    0x8(%ebp),%eax
  100a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a4a:	c7 04 24 66 3b 10 00 	movl   $0x103b66,(%esp)
  100a51:	e8 71 f8 ff ff       	call   1002c7 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a56:	eb 6c                	jmp    100ac4 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a5f:	eb 1b                	jmp    100a7c <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a67:	01 d0                	add    %edx,%eax
  100a69:	0f b6 10             	movzbl (%eax),%edx
  100a6c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a75:	01 c8                	add    %ecx,%eax
  100a77:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a79:	ff 45 f4             	incl   -0xc(%ebp)
  100a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a82:	7c dd                	jl     100a61 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a84:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8d:	01 d0                	add    %edx,%eax
  100a8f:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a95:	8b 55 08             	mov    0x8(%ebp),%edx
  100a98:	89 d1                	mov    %edx,%ecx
  100a9a:	29 c1                	sub    %eax,%ecx
  100a9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aac:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100ab0:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab8:	c7 04 24 82 3b 10 00 	movl   $0x103b82,(%esp)
  100abf:	e8 03 f8 ff ff       	call   1002c7 <cprintf>
}
  100ac4:	90                   	nop
  100ac5:	c9                   	leave  
  100ac6:	c3                   	ret    

00100ac7 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ac7:	f3 0f 1e fb          	endbr32 
  100acb:	55                   	push   %ebp
  100acc:	89 e5                	mov    %esp,%ebp
  100ace:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ad1:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ada:	c9                   	leave  
  100adb:	c3                   	ret    

00100adc <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100adc:	f3 0f 1e fb          	endbr32 
  100ae0:	55                   	push   %ebp
  100ae1:	89 e5                	mov    %esp,%ebp
  100ae3:	53                   	push   %ebx
  100ae4:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ae7:	89 e8                	mov    %ebp,%eax
  100ae9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
  100aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  100af2:	e8 d0 ff ff ff       	call   100ac7 <read_eip>
  100af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100afa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100b01:	eb 7e                	jmp    100b81 <print_stackframe+0xa5>
	{
		cprintf("ebp:0x%08x eip:0x%08x\n",ebp,eip);
  100b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b11:	c7 04 24 94 3b 10 00 	movl   $0x103b94,(%esp)
  100b18:	e8 aa f7 ff ff       	call   1002c7 <cprintf>
		uint32_t *args=(uint32_t *)ebp+2;
  100b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b20:	83 c0 08             	add    $0x8,%eax
  100b23:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));//依次打印调用函数的参数1 2 3 4
  100b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b29:	83 c0 0c             	add    $0xc,%eax
  100b2c:	8b 18                	mov    (%eax),%ebx
  100b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b31:	83 c0 08             	add    $0x8,%eax
  100b34:	8b 08                	mov    (%eax),%ecx
  100b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b39:	83 c0 04             	add    $0x4,%eax
  100b3c:	8b 10                	mov    (%eax),%edx
  100b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b41:	8b 00                	mov    (%eax),%eax
  100b43:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b53:	c7 04 24 ac 3b 10 00 	movl   $0x103bac,(%esp)
  100b5a:	e8 68 f7 ff ff       	call   1002c7 <cprintf>
 
 
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。

		print_debuginfo(eip-1);
  100b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b62:	48                   	dec    %eax
  100b63:	89 04 24             	mov    %eax,(%esp)
  100b66:	e8 b5 fe ff ff       	call   100a20 <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
  100b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6e:	83 c0 04             	add    $0x4,%eax
  100b71:	8b 00                	mov    (%eax),%eax
  100b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
  100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b79:	8b 00                	mov    (%eax),%eax
  100b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100b7e:	ff 45 ec             	incl   -0x14(%ebp)
  100b81:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b85:	7f 0a                	jg     100b91 <print_stackframe+0xb5>
  100b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b8b:	0f 85 72 ff ff ff    	jne    100b03 <print_stackframe+0x27>
    }
}
  100b91:	90                   	nop
  100b92:	83 c4 44             	add    $0x44,%esp
  100b95:	5b                   	pop    %ebx
  100b96:	5d                   	pop    %ebp
  100b97:	c3                   	ret    

00100b98 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b98:	f3 0f 1e fb          	endbr32 
  100b9c:	55                   	push   %ebp
  100b9d:	89 e5                	mov    %esp,%ebp
  100b9f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ba2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba9:	eb 0c                	jmp    100bb7 <parse+0x1f>
            *buf ++ = '\0';
  100bab:	8b 45 08             	mov    0x8(%ebp),%eax
  100bae:	8d 50 01             	lea    0x1(%eax),%edx
  100bb1:	89 55 08             	mov    %edx,0x8(%ebp)
  100bb4:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  100bba:	0f b6 00             	movzbl (%eax),%eax
  100bbd:	84 c0                	test   %al,%al
  100bbf:	74 1d                	je     100bde <parse+0x46>
  100bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc4:	0f b6 00             	movzbl (%eax),%eax
  100bc7:	0f be c0             	movsbl %al,%eax
  100bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bce:	c7 04 24 50 3c 10 00 	movl   $0x103c50,(%esp)
  100bd5:	e8 fe 23 00 00       	call   102fd8 <strchr>
  100bda:	85 c0                	test   %eax,%eax
  100bdc:	75 cd                	jne    100bab <parse+0x13>
        }
        if (*buf == '\0') {
  100bde:	8b 45 08             	mov    0x8(%ebp),%eax
  100be1:	0f b6 00             	movzbl (%eax),%eax
  100be4:	84 c0                	test   %al,%al
  100be6:	74 65                	je     100c4d <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100be8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bec:	75 14                	jne    100c02 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bee:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bf5:	00 
  100bf6:	c7 04 24 55 3c 10 00 	movl   $0x103c55,(%esp)
  100bfd:	e8 c5 f6 ff ff       	call   1002c7 <cprintf>
        }
        argv[argc ++] = buf;
  100c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c05:	8d 50 01             	lea    0x1(%eax),%edx
  100c08:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c15:	01 c2                	add    %eax,%edx
  100c17:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1c:	eb 03                	jmp    100c21 <parse+0x89>
            buf ++;
  100c1e:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c21:	8b 45 08             	mov    0x8(%ebp),%eax
  100c24:	0f b6 00             	movzbl (%eax),%eax
  100c27:	84 c0                	test   %al,%al
  100c29:	74 8c                	je     100bb7 <parse+0x1f>
  100c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2e:	0f b6 00             	movzbl (%eax),%eax
  100c31:	0f be c0             	movsbl %al,%eax
  100c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c38:	c7 04 24 50 3c 10 00 	movl   $0x103c50,(%esp)
  100c3f:	e8 94 23 00 00       	call   102fd8 <strchr>
  100c44:	85 c0                	test   %eax,%eax
  100c46:	74 d6                	je     100c1e <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c48:	e9 6a ff ff ff       	jmp    100bb7 <parse+0x1f>
            break;
  100c4d:	90                   	nop
        }
    }
    return argc;
  100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c51:	c9                   	leave  
  100c52:	c3                   	ret    

00100c53 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c53:	f3 0f 1e fb          	endbr32 
  100c57:	55                   	push   %ebp
  100c58:	89 e5                	mov    %esp,%ebp
  100c5a:	53                   	push   %ebx
  100c5b:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c5e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c65:	8b 45 08             	mov    0x8(%ebp),%eax
  100c68:	89 04 24             	mov    %eax,(%esp)
  100c6b:	e8 28 ff ff ff       	call   100b98 <parse>
  100c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c77:	75 0a                	jne    100c83 <runcmd+0x30>
        return 0;
  100c79:	b8 00 00 00 00       	mov    $0x0,%eax
  100c7e:	e9 83 00 00 00       	jmp    100d06 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c8a:	eb 5a                	jmp    100ce6 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c8c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c92:	89 d0                	mov    %edx,%eax
  100c94:	01 c0                	add    %eax,%eax
  100c96:	01 d0                	add    %edx,%eax
  100c98:	c1 e0 02             	shl    $0x2,%eax
  100c9b:	05 00 00 11 00       	add    $0x110000,%eax
  100ca0:	8b 00                	mov    (%eax),%eax
  100ca2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca6:	89 04 24             	mov    %eax,(%esp)
  100ca9:	e8 86 22 00 00       	call   102f34 <strcmp>
  100cae:	85 c0                	test   %eax,%eax
  100cb0:	75 31                	jne    100ce3 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb5:	89 d0                	mov    %edx,%eax
  100cb7:	01 c0                	add    %eax,%eax
  100cb9:	01 d0                	add    %edx,%eax
  100cbb:	c1 e0 02             	shl    $0x2,%eax
  100cbe:	05 08 00 11 00       	add    $0x110008,%eax
  100cc3:	8b 10                	mov    (%eax),%edx
  100cc5:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cc8:	83 c0 04             	add    $0x4,%eax
  100ccb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cce:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cd4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdc:	89 1c 24             	mov    %ebx,(%esp)
  100cdf:	ff d2                	call   *%edx
  100ce1:	eb 23                	jmp    100d06 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce3:	ff 45 f4             	incl   -0xc(%ebp)
  100ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce9:	83 f8 02             	cmp    $0x2,%eax
  100cec:	76 9e                	jbe    100c8c <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 73 3c 10 00 	movl   $0x103c73,(%esp)
  100cfc:	e8 c6 f5 ff ff       	call   1002c7 <cprintf>
    return 0;
  100d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d06:	83 c4 64             	add    $0x64,%esp
  100d09:	5b                   	pop    %ebx
  100d0a:	5d                   	pop    %ebp
  100d0b:	c3                   	ret    

00100d0c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d0c:	f3 0f 1e fb          	endbr32 
  100d10:	55                   	push   %ebp
  100d11:	89 e5                	mov    %esp,%ebp
  100d13:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d16:	c7 04 24 8c 3c 10 00 	movl   $0x103c8c,(%esp)
  100d1d:	e8 a5 f5 ff ff       	call   1002c7 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d22:	c7 04 24 b4 3c 10 00 	movl   $0x103cb4,(%esp)
  100d29:	e8 99 f5 ff ff       	call   1002c7 <cprintf>

    if (tf != NULL) {
  100d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d32:	74 0b                	je     100d3f <kmonitor+0x33>
        print_trapframe(tf);
  100d34:	8b 45 08             	mov    0x8(%ebp),%eax
  100d37:	89 04 24             	mov    %eax,(%esp)
  100d3a:	e8 52 0e 00 00       	call   101b91 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d3f:	c7 04 24 d9 3c 10 00 	movl   $0x103cd9,(%esp)
  100d46:	e8 2f f6 ff ff       	call   10037a <readline>
  100d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d52:	74 eb                	je     100d3f <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d54:	8b 45 08             	mov    0x8(%ebp),%eax
  100d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5e:	89 04 24             	mov    %eax,(%esp)
  100d61:	e8 ed fe ff ff       	call   100c53 <runcmd>
  100d66:	85 c0                	test   %eax,%eax
  100d68:	78 02                	js     100d6c <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d6a:	eb d3                	jmp    100d3f <kmonitor+0x33>
                break;
  100d6c:	90                   	nop
            }
        }
    }
}
  100d6d:	90                   	nop
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d70:	f3 0f 1e fb          	endbr32 
  100d74:	55                   	push   %ebp
  100d75:	89 e5                	mov    %esp,%ebp
  100d77:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d81:	eb 3d                	jmp    100dc0 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d86:	89 d0                	mov    %edx,%eax
  100d88:	01 c0                	add    %eax,%eax
  100d8a:	01 d0                	add    %edx,%eax
  100d8c:	c1 e0 02             	shl    $0x2,%eax
  100d8f:	05 04 00 11 00       	add    $0x110004,%eax
  100d94:	8b 08                	mov    (%eax),%ecx
  100d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d99:	89 d0                	mov    %edx,%eax
  100d9b:	01 c0                	add    %eax,%eax
  100d9d:	01 d0                	add    %edx,%eax
  100d9f:	c1 e0 02             	shl    $0x2,%eax
  100da2:	05 00 00 11 00       	add    $0x110000,%eax
  100da7:	8b 00                	mov    (%eax),%eax
  100da9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  100db1:	c7 04 24 dd 3c 10 00 	movl   $0x103cdd,(%esp)
  100db8:	e8 0a f5 ff ff       	call   1002c7 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100dbd:	ff 45 f4             	incl   -0xc(%ebp)
  100dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc3:	83 f8 02             	cmp    $0x2,%eax
  100dc6:	76 bb                	jbe    100d83 <mon_help+0x13>
    }
    return 0;
  100dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcd:	c9                   	leave  
  100dce:	c3                   	ret    

00100dcf <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dcf:	f3 0f 1e fb          	endbr32 
  100dd3:	55                   	push   %ebp
  100dd4:	89 e5                	mov    %esp,%ebp
  100dd6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd9:	e8 ac fb ff ff       	call   10098a <print_kerninfo>
    return 0;
  100dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100de5:	f3 0f 1e fb          	endbr32 
  100de9:	55                   	push   %ebp
  100dea:	89 e5                	mov    %esp,%ebp
  100dec:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100def:	e8 e8 fc ff ff       	call   100adc <print_stackframe>
    return 0;
  100df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df9:	c9                   	leave  
  100dfa:	c3                   	ret    

00100dfb <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dfb:	f3 0f 1e fb          	endbr32 
  100dff:	55                   	push   %ebp
  100e00:	89 e5                	mov    %esp,%ebp
  100e02:	83 ec 28             	sub    $0x28,%esp
  100e05:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e0b:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e0f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e13:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e17:	ee                   	out    %al,(%dx)
}
  100e18:	90                   	nop
  100e19:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e1f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e23:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e27:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e2b:	ee                   	out    %al,(%dx)
}
  100e2c:	90                   	nop
  100e2d:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e33:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e37:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e3b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e3f:	ee                   	out    %al,(%dx)
}
  100e40:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e41:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e48:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e4b:	c7 04 24 e6 3c 10 00 	movl   $0x103ce6,(%esp)
  100e52:	e8 70 f4 ff ff       	call   1002c7 <cprintf>
    pic_enable(IRQ_TIMER);
  100e57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e5e:	e8 31 09 00 00       	call   101794 <pic_enable>
}
  100e63:	90                   	nop
  100e64:	c9                   	leave  
  100e65:	c3                   	ret    

00100e66 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e66:	f3 0f 1e fb          	endbr32 
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 10             	sub    $0x10,%esp
  100e70:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e76:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e7a:	89 c2                	mov    %eax,%edx
  100e7c:	ec                   	in     (%dx),%al
  100e7d:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e80:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e86:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e8a:	89 c2                	mov    %eax,%edx
  100e8c:	ec                   	in     (%dx),%al
  100e8d:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e90:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e96:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e9a:	89 c2                	mov    %eax,%edx
  100e9c:	ec                   	in     (%dx),%al
  100e9d:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ea0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ea6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100eaa:	89 c2                	mov    %eax,%edx
  100eac:	ec                   	in     (%dx),%al
  100ead:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eb0:	90                   	nop
  100eb1:	c9                   	leave  
  100eb2:	c3                   	ret    

00100eb3 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100eb3:	f3 0f 1e fb          	endbr32 
  100eb7:	55                   	push   %ebp
  100eb8:	89 e5                	mov    %esp,%ebp
  100eba:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100ebd:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec7:	0f b7 00             	movzwl (%eax),%eax
  100eca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed1:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	0f b7 00             	movzwl (%eax),%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ee4:	74 12                	je     100ef8 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ee6:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100eed:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ef4:	b4 03 
  100ef6:	eb 13                	jmp    100f0b <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eff:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100f02:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100f09:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100f0b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f12:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f16:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f1a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f1e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
}
  100f23:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100f24:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f2b:	40                   	inc    %eax
  100f2c:	0f b7 c0             	movzwl %ax,%eax
  100f2f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f33:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f37:	89 c2                	mov    %eax,%edx
  100f39:	ec                   	in     (%dx),%al
  100f3a:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f3d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f41:	0f b6 c0             	movzbl %al,%eax
  100f44:	c1 e0 08             	shl    $0x8,%eax
  100f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f4a:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f51:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f55:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f59:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f5d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f61:	ee                   	out    %al,(%dx)
}
  100f62:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f63:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f6a:	40                   	inc    %eax
  100f6b:	0f b7 c0             	movzwl %ax,%eax
  100f6e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f76:	89 c2                	mov    %eax,%edx
  100f78:	ec                   	in     (%dx),%al
  100f79:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f80:	0f b6 c0             	movzbl %al,%eax
  100f83:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f89:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f91:	0f b7 c0             	movzwl %ax,%eax
  100f94:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f9a:	90                   	nop
  100f9b:	c9                   	leave  
  100f9c:	c3                   	ret    

00100f9d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f9d:	f3 0f 1e fb          	endbr32 
  100fa1:	55                   	push   %ebp
  100fa2:	89 e5                	mov    %esp,%ebp
  100fa4:	83 ec 48             	sub    $0x48,%esp
  100fa7:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fad:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fb5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
}
  100fba:	90                   	nop
  100fbb:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fc1:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fc9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fcd:	ee                   	out    %al,(%dx)
}
  100fce:	90                   	nop
  100fcf:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fd5:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fdd:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
}
  100fe2:	90                   	nop
  100fe3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe9:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
}
  100ff6:	90                   	nop
  100ff7:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100ffd:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101001:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101005:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101009:	ee                   	out    %al,(%dx)
}
  10100a:	90                   	nop
  10100b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101011:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101015:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101019:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
}
  10101e:	90                   	nop
  10101f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101025:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101029:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10102d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
}
  101032:	90                   	nop
  101033:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101039:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10103d:	89 c2                	mov    %eax,%edx
  10103f:	ec                   	in     (%dx),%al
  101040:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101043:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101047:	3c ff                	cmp    $0xff,%al
  101049:	0f 95 c0             	setne  %al
  10104c:	0f b6 c0             	movzbl %al,%eax
  10104f:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101054:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10105a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10105e:	89 c2                	mov    %eax,%edx
  101060:	ec                   	in     (%dx),%al
  101061:	88 45 f1             	mov    %al,-0xf(%ebp)
  101064:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10106a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10106e:	89 c2                	mov    %eax,%edx
  101070:	ec                   	in     (%dx),%al
  101071:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101074:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101079:	85 c0                	test   %eax,%eax
  10107b:	74 0c                	je     101089 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10107d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101084:	e8 0b 07 00 00       	call   101794 <pic_enable>
    }
}
  101089:	90                   	nop
  10108a:	c9                   	leave  
  10108b:	c3                   	ret    

0010108c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10108c:	f3 0f 1e fb          	endbr32 
  101090:	55                   	push   %ebp
  101091:	89 e5                	mov    %esp,%ebp
  101093:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10109d:	eb 08                	jmp    1010a7 <lpt_putc_sub+0x1b>
        delay();
  10109f:	e8 c2 fd ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010a4:	ff 45 fc             	incl   -0x4(%ebp)
  1010a7:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010ad:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010b1:	89 c2                	mov    %eax,%edx
  1010b3:	ec                   	in     (%dx),%al
  1010b4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010b7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010bb:	84 c0                	test   %al,%al
  1010bd:	78 09                	js     1010c8 <lpt_putc_sub+0x3c>
  1010bf:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010c6:	7e d7                	jle    10109f <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cb:	0f b6 c0             	movzbl %al,%eax
  1010ce:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010d4:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010db:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010df:	ee                   	out    %al,(%dx)
}
  1010e0:	90                   	nop
  1010e1:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010e7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010eb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010f3:	ee                   	out    %al,(%dx)
}
  1010f4:	90                   	nop
  1010f5:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010fb:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010ff:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101103:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101107:	ee                   	out    %al,(%dx)
}
  101108:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101109:	90                   	nop
  10110a:	c9                   	leave  
  10110b:	c3                   	ret    

0010110c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10110c:	f3 0f 1e fb          	endbr32 
  101110:	55                   	push   %ebp
  101111:	89 e5                	mov    %esp,%ebp
  101113:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101116:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10111a:	74 0d                	je     101129 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  10111c:	8b 45 08             	mov    0x8(%ebp),%eax
  10111f:	89 04 24             	mov    %eax,(%esp)
  101122:	e8 65 ff ff ff       	call   10108c <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101127:	eb 24                	jmp    10114d <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101129:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101130:	e8 57 ff ff ff       	call   10108c <lpt_putc_sub>
        lpt_putc_sub(' ');
  101135:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10113c:	e8 4b ff ff ff       	call   10108c <lpt_putc_sub>
        lpt_putc_sub('\b');
  101141:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101148:	e8 3f ff ff ff       	call   10108c <lpt_putc_sub>
}
  10114d:	90                   	nop
  10114e:	c9                   	leave  
  10114f:	c3                   	ret    

00101150 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101150:	f3 0f 1e fb          	endbr32 
  101154:	55                   	push   %ebp
  101155:	89 e5                	mov    %esp,%ebp
  101157:	53                   	push   %ebx
  101158:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10115b:	8b 45 08             	mov    0x8(%ebp),%eax
  10115e:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101163:	85 c0                	test   %eax,%eax
  101165:	75 07                	jne    10116e <cga_putc+0x1e>
        c |= 0x0700;
  101167:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10116e:	8b 45 08             	mov    0x8(%ebp),%eax
  101171:	0f b6 c0             	movzbl %al,%eax
  101174:	83 f8 0d             	cmp    $0xd,%eax
  101177:	74 72                	je     1011eb <cga_putc+0x9b>
  101179:	83 f8 0d             	cmp    $0xd,%eax
  10117c:	0f 8f a3 00 00 00    	jg     101225 <cga_putc+0xd5>
  101182:	83 f8 08             	cmp    $0x8,%eax
  101185:	74 0a                	je     101191 <cga_putc+0x41>
  101187:	83 f8 0a             	cmp    $0xa,%eax
  10118a:	74 4c                	je     1011d8 <cga_putc+0x88>
  10118c:	e9 94 00 00 00       	jmp    101225 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101191:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101198:	85 c0                	test   %eax,%eax
  10119a:	0f 84 af 00 00 00    	je     10124f <cga_putc+0xff>
            crt_pos --;
  1011a0:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011a7:	48                   	dec    %eax
  1011a8:	0f b7 c0             	movzwl %ax,%eax
  1011ab:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b4:	98                   	cwtl   
  1011b5:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ba:	98                   	cwtl   
  1011bb:	83 c8 20             	or     $0x20,%eax
  1011be:	98                   	cwtl   
  1011bf:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  1011c5:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011cc:	01 c9                	add    %ecx,%ecx
  1011ce:	01 ca                	add    %ecx,%edx
  1011d0:	0f b7 c0             	movzwl %ax,%eax
  1011d3:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011d6:	eb 77                	jmp    10124f <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011d8:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011df:	83 c0 50             	add    $0x50,%eax
  1011e2:	0f b7 c0             	movzwl %ax,%eax
  1011e5:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011eb:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011f2:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011f9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011fe:	89 c8                	mov    %ecx,%eax
  101200:	f7 e2                	mul    %edx
  101202:	c1 ea 06             	shr    $0x6,%edx
  101205:	89 d0                	mov    %edx,%eax
  101207:	c1 e0 02             	shl    $0x2,%eax
  10120a:	01 d0                	add    %edx,%eax
  10120c:	c1 e0 04             	shl    $0x4,%eax
  10120f:	29 c1                	sub    %eax,%ecx
  101211:	89 c8                	mov    %ecx,%eax
  101213:	0f b7 c0             	movzwl %ax,%eax
  101216:	29 c3                	sub    %eax,%ebx
  101218:	89 d8                	mov    %ebx,%eax
  10121a:	0f b7 c0             	movzwl %ax,%eax
  10121d:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  101223:	eb 2b                	jmp    101250 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101225:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  10122b:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101232:	8d 50 01             	lea    0x1(%eax),%edx
  101235:	0f b7 d2             	movzwl %dx,%edx
  101238:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  10123f:	01 c0                	add    %eax,%eax
  101241:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101244:	8b 45 08             	mov    0x8(%ebp),%eax
  101247:	0f b7 c0             	movzwl %ax,%eax
  10124a:	66 89 02             	mov    %ax,(%edx)
        break;
  10124d:	eb 01                	jmp    101250 <cga_putc+0x100>
        break;
  10124f:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101250:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101257:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10125c:	76 5d                	jbe    1012bb <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10125e:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101263:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101269:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10126e:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101275:	00 
  101276:	89 54 24 04          	mov    %edx,0x4(%esp)
  10127a:	89 04 24             	mov    %eax,(%esp)
  10127d:	e8 5b 1f 00 00       	call   1031dd <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101282:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101289:	eb 14                	jmp    10129f <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10128b:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101293:	01 d2                	add    %edx,%edx
  101295:	01 d0                	add    %edx,%eax
  101297:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10129c:	ff 45 f4             	incl   -0xc(%ebp)
  10129f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012a6:	7e e3                	jle    10128b <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012a8:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012af:	83 e8 50             	sub    $0x50,%eax
  1012b2:	0f b7 c0             	movzwl %ax,%eax
  1012b5:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012bb:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012c2:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012c6:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012ce:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012d2:	ee                   	out    %al,(%dx)
}
  1012d3:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012d4:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012db:	c1 e8 08             	shr    $0x8,%eax
  1012de:	0f b7 c0             	movzwl %ax,%eax
  1012e1:	0f b6 c0             	movzbl %al,%eax
  1012e4:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012eb:	42                   	inc    %edx
  1012ec:	0f b7 d2             	movzwl %dx,%edx
  1012ef:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012f3:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012f6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012fa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012fe:	ee                   	out    %al,(%dx)
}
  1012ff:	90                   	nop
    outb(addr_6845, 15);
  101300:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101307:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10130b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10130f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101313:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101317:	ee                   	out    %al,(%dx)
}
  101318:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101319:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101320:	0f b6 c0             	movzbl %al,%eax
  101323:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  10132a:	42                   	inc    %edx
  10132b:	0f b7 d2             	movzwl %dx,%edx
  10132e:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101332:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101335:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101339:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10133d:	ee                   	out    %al,(%dx)
}
  10133e:	90                   	nop
}
  10133f:	90                   	nop
  101340:	83 c4 34             	add    $0x34,%esp
  101343:	5b                   	pop    %ebx
  101344:	5d                   	pop    %ebp
  101345:	c3                   	ret    

00101346 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101346:	f3 0f 1e fb          	endbr32 
  10134a:	55                   	push   %ebp
  10134b:	89 e5                	mov    %esp,%ebp
  10134d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101357:	eb 08                	jmp    101361 <serial_putc_sub+0x1b>
        delay();
  101359:	e8 08 fb ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10135e:	ff 45 fc             	incl   -0x4(%ebp)
  101361:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101367:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136b:	89 c2                	mov    %eax,%edx
  10136d:	ec                   	in     (%dx),%al
  10136e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101371:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101375:	0f b6 c0             	movzbl %al,%eax
  101378:	83 e0 20             	and    $0x20,%eax
  10137b:	85 c0                	test   %eax,%eax
  10137d:	75 09                	jne    101388 <serial_putc_sub+0x42>
  10137f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101386:	7e d1                	jle    101359 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101388:	8b 45 08             	mov    0x8(%ebp),%eax
  10138b:	0f b6 c0             	movzbl %al,%eax
  10138e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101394:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101397:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10139b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10139f:	ee                   	out    %al,(%dx)
}
  1013a0:	90                   	nop
}
  1013a1:	90                   	nop
  1013a2:	c9                   	leave  
  1013a3:	c3                   	ret    

001013a4 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013a4:	f3 0f 1e fb          	endbr32 
  1013a8:	55                   	push   %ebp
  1013a9:	89 e5                	mov    %esp,%ebp
  1013ab:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ae:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013b2:	74 0d                	je     1013c1 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b7:	89 04 24             	mov    %eax,(%esp)
  1013ba:	e8 87 ff ff ff       	call   101346 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013bf:	eb 24                	jmp    1013e5 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013c1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013c8:	e8 79 ff ff ff       	call   101346 <serial_putc_sub>
        serial_putc_sub(' ');
  1013cd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013d4:	e8 6d ff ff ff       	call   101346 <serial_putc_sub>
        serial_putc_sub('\b');
  1013d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013e0:	e8 61 ff ff ff       	call   101346 <serial_putc_sub>
}
  1013e5:	90                   	nop
  1013e6:	c9                   	leave  
  1013e7:	c3                   	ret    

001013e8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013e8:	f3 0f 1e fb          	endbr32 
  1013ec:	55                   	push   %ebp
  1013ed:	89 e5                	mov    %esp,%ebp
  1013ef:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013f2:	eb 33                	jmp    101427 <cons_intr+0x3f>
        if (c != 0) {
  1013f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013f8:	74 2d                	je     101427 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013fa:	a1 84 10 11 00       	mov    0x111084,%eax
  1013ff:	8d 50 01             	lea    0x1(%eax),%edx
  101402:	89 15 84 10 11 00    	mov    %edx,0x111084
  101408:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10140b:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101411:	a1 84 10 11 00       	mov    0x111084,%eax
  101416:	3d 00 02 00 00       	cmp    $0x200,%eax
  10141b:	75 0a                	jne    101427 <cons_intr+0x3f>
                cons.wpos = 0;
  10141d:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  101424:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101427:	8b 45 08             	mov    0x8(%ebp),%eax
  10142a:	ff d0                	call   *%eax
  10142c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10142f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101433:	75 bf                	jne    1013f4 <cons_intr+0xc>
            }
        }
    }
}
  101435:	90                   	nop
  101436:	90                   	nop
  101437:	c9                   	leave  
  101438:	c3                   	ret    

00101439 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101439:	f3 0f 1e fb          	endbr32 
  10143d:	55                   	push   %ebp
  10143e:	89 e5                	mov    %esp,%ebp
  101440:	83 ec 10             	sub    $0x10,%esp
  101443:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101449:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10144d:	89 c2                	mov    %eax,%edx
  10144f:	ec                   	in     (%dx),%al
  101450:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101453:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101457:	0f b6 c0             	movzbl %al,%eax
  10145a:	83 e0 01             	and    $0x1,%eax
  10145d:	85 c0                	test   %eax,%eax
  10145f:	75 07                	jne    101468 <serial_proc_data+0x2f>
        return -1;
  101461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101466:	eb 2a                	jmp    101492 <serial_proc_data+0x59>
  101468:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10146e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101472:	89 c2                	mov    %eax,%edx
  101474:	ec                   	in     (%dx),%al
  101475:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101478:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10147c:	0f b6 c0             	movzbl %al,%eax
  10147f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101482:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101486:	75 07                	jne    10148f <serial_proc_data+0x56>
        c = '\b';
  101488:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101492:	c9                   	leave  
  101493:	c3                   	ret    

00101494 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101494:	f3 0f 1e fb          	endbr32 
  101498:	55                   	push   %ebp
  101499:	89 e5                	mov    %esp,%ebp
  10149b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10149e:	a1 68 0e 11 00       	mov    0x110e68,%eax
  1014a3:	85 c0                	test   %eax,%eax
  1014a5:	74 0c                	je     1014b3 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014a7:	c7 04 24 39 14 10 00 	movl   $0x101439,(%esp)
  1014ae:	e8 35 ff ff ff       	call   1013e8 <cons_intr>
    }
}
  1014b3:	90                   	nop
  1014b4:	c9                   	leave  
  1014b5:	c3                   	ret    

001014b6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014b6:	f3 0f 1e fb          	endbr32 
  1014ba:	55                   	push   %ebp
  1014bb:	89 e5                	mov    %esp,%ebp
  1014bd:	83 ec 38             	sub    $0x38,%esp
  1014c0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014c9:	89 c2                	mov    %eax,%edx
  1014cb:	ec                   	in     (%dx),%al
  1014cc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014d3:	0f b6 c0             	movzbl %al,%eax
  1014d6:	83 e0 01             	and    $0x1,%eax
  1014d9:	85 c0                	test   %eax,%eax
  1014db:	75 0a                	jne    1014e7 <kbd_proc_data+0x31>
        return -1;
  1014dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014e2:	e9 56 01 00 00       	jmp    10163d <kbd_proc_data+0x187>
  1014e7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014f0:	89 c2                	mov    %eax,%edx
  1014f2:	ec                   	in     (%dx),%al
  1014f3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014f6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014fa:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014fd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101501:	75 17                	jne    10151a <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101503:	a1 88 10 11 00       	mov    0x111088,%eax
  101508:	83 c8 40             	or     $0x40,%eax
  10150b:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101510:	b8 00 00 00 00       	mov    $0x0,%eax
  101515:	e9 23 01 00 00       	jmp    10163d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151e:	84 c0                	test   %al,%al
  101520:	79 45                	jns    101567 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101522:	a1 88 10 11 00       	mov    0x111088,%eax
  101527:	83 e0 40             	and    $0x40,%eax
  10152a:	85 c0                	test   %eax,%eax
  10152c:	75 08                	jne    101536 <kbd_proc_data+0x80>
  10152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101532:	24 7f                	and    $0x7f,%al
  101534:	eb 04                	jmp    10153a <kbd_proc_data+0x84>
  101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101541:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101548:	0c 40                	or     $0x40,%al
  10154a:	0f b6 c0             	movzbl %al,%eax
  10154d:	f7 d0                	not    %eax
  10154f:	89 c2                	mov    %eax,%edx
  101551:	a1 88 10 11 00       	mov    0x111088,%eax
  101556:	21 d0                	and    %edx,%eax
  101558:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10155d:	b8 00 00 00 00       	mov    $0x0,%eax
  101562:	e9 d6 00 00 00       	jmp    10163d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101567:	a1 88 10 11 00       	mov    0x111088,%eax
  10156c:	83 e0 40             	and    $0x40,%eax
  10156f:	85 c0                	test   %eax,%eax
  101571:	74 11                	je     101584 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101573:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101577:	a1 88 10 11 00       	mov    0x111088,%eax
  10157c:	83 e0 bf             	and    $0xffffffbf,%eax
  10157f:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101588:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10158f:	0f b6 d0             	movzbl %al,%edx
  101592:	a1 88 10 11 00       	mov    0x111088,%eax
  101597:	09 d0                	or     %edx,%eax
  101599:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10159e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a2:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  1015a9:	0f b6 d0             	movzbl %al,%edx
  1015ac:	a1 88 10 11 00       	mov    0x111088,%eax
  1015b1:	31 d0                	xor    %edx,%eax
  1015b3:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  1015b8:	a1 88 10 11 00       	mov    0x111088,%eax
  1015bd:	83 e0 03             	and    $0x3,%eax
  1015c0:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  1015c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015cb:	01 d0                	add    %edx,%eax
  1015cd:	0f b6 00             	movzbl (%eax),%eax
  1015d0:	0f b6 c0             	movzbl %al,%eax
  1015d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015d6:	a1 88 10 11 00       	mov    0x111088,%eax
  1015db:	83 e0 08             	and    $0x8,%eax
  1015de:	85 c0                	test   %eax,%eax
  1015e0:	74 22                	je     101604 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015e2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015e6:	7e 0c                	jle    1015f4 <kbd_proc_data+0x13e>
  1015e8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015ec:	7f 06                	jg     1015f4 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015ee:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015f2:	eb 10                	jmp    101604 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015f4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015f8:	7e 0a                	jle    101604 <kbd_proc_data+0x14e>
  1015fa:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015fe:	7f 04                	jg     101604 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101600:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101604:	a1 88 10 11 00       	mov    0x111088,%eax
  101609:	f7 d0                	not    %eax
  10160b:	83 e0 06             	and    $0x6,%eax
  10160e:	85 c0                	test   %eax,%eax
  101610:	75 28                	jne    10163a <kbd_proc_data+0x184>
  101612:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101619:	75 1f                	jne    10163a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10161b:	c7 04 24 01 3d 10 00 	movl   $0x103d01,(%esp)
  101622:	e8 a0 ec ff ff       	call   1002c7 <cprintf>
  101627:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10162d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101631:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101638:	ee                   	out    %al,(%dx)
}
  101639:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10163d:	c9                   	leave  
  10163e:	c3                   	ret    

0010163f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10163f:	f3 0f 1e fb          	endbr32 
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101649:	c7 04 24 b6 14 10 00 	movl   $0x1014b6,(%esp)
  101650:	e8 93 fd ff ff       	call   1013e8 <cons_intr>
}
  101655:	90                   	nop
  101656:	c9                   	leave  
  101657:	c3                   	ret    

00101658 <kbd_init>:

static void
kbd_init(void) {
  101658:	f3 0f 1e fb          	endbr32 
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101662:	e8 d8 ff ff ff       	call   10163f <kbd_intr>
    pic_enable(IRQ_KBD);
  101667:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10166e:	e8 21 01 00 00       	call   101794 <pic_enable>
}
  101673:	90                   	nop
  101674:	c9                   	leave  
  101675:	c3                   	ret    

00101676 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101676:	f3 0f 1e fb          	endbr32 
  10167a:	55                   	push   %ebp
  10167b:	89 e5                	mov    %esp,%ebp
  10167d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101680:	e8 2e f8 ff ff       	call   100eb3 <cga_init>
    serial_init();
  101685:	e8 13 f9 ff ff       	call   100f9d <serial_init>
    kbd_init();
  10168a:	e8 c9 ff ff ff       	call   101658 <kbd_init>
    if (!serial_exists) {
  10168f:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101694:	85 c0                	test   %eax,%eax
  101696:	75 0c                	jne    1016a4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101698:	c7 04 24 0d 3d 10 00 	movl   $0x103d0d,(%esp)
  10169f:	e8 23 ec ff ff       	call   1002c7 <cprintf>
    }
}
  1016a4:	90                   	nop
  1016a5:	c9                   	leave  
  1016a6:	c3                   	ret    

001016a7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016a7:	f3 0f 1e fb          	endbr32 
  1016ab:	55                   	push   %ebp
  1016ac:	89 e5                	mov    %esp,%ebp
  1016ae:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b4:	89 04 24             	mov    %eax,(%esp)
  1016b7:	e8 50 fa ff ff       	call   10110c <lpt_putc>
    cga_putc(c);
  1016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bf:	89 04 24             	mov    %eax,(%esp)
  1016c2:	e8 89 fa ff ff       	call   101150 <cga_putc>
    serial_putc(c);
  1016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ca:	89 04 24             	mov    %eax,(%esp)
  1016cd:	e8 d2 fc ff ff       	call   1013a4 <serial_putc>
}
  1016d2:	90                   	nop
  1016d3:	c9                   	leave  
  1016d4:	c3                   	ret    

001016d5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016d5:	f3 0f 1e fb          	endbr32 
  1016d9:	55                   	push   %ebp
  1016da:	89 e5                	mov    %esp,%ebp
  1016dc:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016df:	e8 b0 fd ff ff       	call   101494 <serial_intr>
    kbd_intr();
  1016e4:	e8 56 ff ff ff       	call   10163f <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016e9:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016ef:	a1 84 10 11 00       	mov    0x111084,%eax
  1016f4:	39 c2                	cmp    %eax,%edx
  1016f6:	74 36                	je     10172e <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016f8:	a1 80 10 11 00       	mov    0x111080,%eax
  1016fd:	8d 50 01             	lea    0x1(%eax),%edx
  101700:	89 15 80 10 11 00    	mov    %edx,0x111080
  101706:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  10170d:	0f b6 c0             	movzbl %al,%eax
  101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101713:	a1 80 10 11 00       	mov    0x111080,%eax
  101718:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171d:	75 0a                	jne    101729 <cons_getc+0x54>
            cons.rpos = 0;
  10171f:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  101726:	00 00 00 
        }
        return c;
  101729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10172c:	eb 05                	jmp    101733 <cons_getc+0x5e>
    }
    return 0;
  10172e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101735:	f3 0f 1e fb          	endbr32 
  101739:	55                   	push   %ebp
  10173a:	89 e5                	mov    %esp,%ebp
  10173c:	83 ec 14             	sub    $0x14,%esp
  10173f:	8b 45 08             	mov    0x8(%ebp),%eax
  101742:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101749:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  10174f:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101754:	85 c0                	test   %eax,%eax
  101756:	74 39                	je     101791 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175b:	0f b6 c0             	movzbl %al,%eax
  10175e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101764:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
}
  101770:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101771:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101775:	c1 e8 08             	shr    $0x8,%eax
  101778:	0f b7 c0             	movzwl %ax,%eax
  10177b:	0f b6 c0             	movzbl %al,%eax
  10177e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101784:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101787:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10178b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
}
  101790:	90                   	nop
    }
}
  101791:	90                   	nop
  101792:	c9                   	leave  
  101793:	c3                   	ret    

00101794 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101794:	f3 0f 1e fb          	endbr32 
  101798:	55                   	push   %ebp
  101799:	89 e5                	mov    %esp,%ebp
  10179b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10179e:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a1:	ba 01 00 00 00       	mov    $0x1,%edx
  1017a6:	88 c1                	mov    %al,%cl
  1017a8:	d3 e2                	shl    %cl,%edx
  1017aa:	89 d0                	mov    %edx,%eax
  1017ac:	98                   	cwtl   
  1017ad:	f7 d0                	not    %eax
  1017af:	0f bf d0             	movswl %ax,%edx
  1017b2:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1017b9:	98                   	cwtl   
  1017ba:	21 d0                	and    %edx,%eax
  1017bc:	98                   	cwtl   
  1017bd:	0f b7 c0             	movzwl %ax,%eax
  1017c0:	89 04 24             	mov    %eax,(%esp)
  1017c3:	e8 6d ff ff ff       	call   101735 <pic_setmask>
}
  1017c8:	90                   	nop
  1017c9:	c9                   	leave  
  1017ca:	c3                   	ret    

001017cb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017cb:	f3 0f 1e fb          	endbr32 
  1017cf:	55                   	push   %ebp
  1017d0:	89 e5                	mov    %esp,%ebp
  1017d2:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017d5:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017dc:	00 00 00 
  1017df:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017e5:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ed:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017f1:	ee                   	out    %al,(%dx)
}
  1017f2:	90                   	nop
  1017f3:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017f9:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101801:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101805:	ee                   	out    %al,(%dx)
}
  101806:	90                   	nop
  101807:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10180d:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101811:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101815:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101819:	ee                   	out    %al,(%dx)
}
  10181a:	90                   	nop
  10181b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101821:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101825:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101829:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
}
  10182e:	90                   	nop
  10182f:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101835:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101839:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10183d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
}
  101842:	90                   	nop
  101843:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101849:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101851:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
}
  101856:	90                   	nop
  101857:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10185d:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101861:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101865:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101869:	ee                   	out    %al,(%dx)
}
  10186a:	90                   	nop
  10186b:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101871:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101875:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101879:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10187d:	ee                   	out    %al,(%dx)
}
  10187e:	90                   	nop
  10187f:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101885:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101889:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10188d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101891:	ee                   	out    %al,(%dx)
}
  101892:	90                   	nop
  101893:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101899:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10189d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018a1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018a5:	ee                   	out    %al,(%dx)
}
  1018a6:	90                   	nop
  1018a7:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018ad:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018b5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018b9:	ee                   	out    %al,(%dx)
}
  1018ba:	90                   	nop
  1018bb:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018c1:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018c5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018c9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018cd:	ee                   	out    %al,(%dx)
}
  1018ce:	90                   	nop
  1018cf:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018d5:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018d9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018dd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018e1:	ee                   	out    %al,(%dx)
}
  1018e2:	90                   	nop
  1018e3:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018e9:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018ed:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018f1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018f5:	ee                   	out    %al,(%dx)
}
  1018f6:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018f7:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018fe:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101903:	74 0f                	je     101914 <pic_init+0x149>
        pic_setmask(irq_mask);
  101905:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10190c:	89 04 24             	mov    %eax,(%esp)
  10190f:	e8 21 fe ff ff       	call   101735 <pic_setmask>
    }
}
  101914:	90                   	nop
  101915:	c9                   	leave  
  101916:	c3                   	ret    

00101917 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101917:	f3 0f 1e fb          	endbr32 
  10191b:	55                   	push   %ebp
  10191c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10191e:	fb                   	sti    
}
  10191f:	90                   	nop
    sti();
}
  101920:	90                   	nop
  101921:	5d                   	pop    %ebp
  101922:	c3                   	ret    

00101923 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101923:	f3 0f 1e fb          	endbr32 
  101927:	55                   	push   %ebp
  101928:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  10192a:	fa                   	cli    
}
  10192b:	90                   	nop
    cli();
}
  10192c:	90                   	nop
  10192d:	5d                   	pop    %ebp
  10192e:	c3                   	ret    

0010192f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10192f:	f3 0f 1e fb          	endbr32 
  101933:	55                   	push   %ebp
  101934:	89 e5                	mov    %esp,%ebp
  101936:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101939:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101940:	00 
  101941:	c7 04 24 40 3d 10 00 	movl   $0x103d40,(%esp)
  101948:	e8 7a e9 ff ff       	call   1002c7 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10194d:	90                   	nop
  10194e:	c9                   	leave  
  10194f:	c3                   	ret    

00101950 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101950:	f3 0f 1e fb          	endbr32 
  101954:	55                   	push   %ebp
  101955:	89 e5                	mov    %esp,%ebp
  101957:	83 ec 10             	sub    $0x10,%esp
    
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  10195a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101961:	e9 c4 00 00 00       	jmp    101a2a <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  101966:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101969:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101970:	0f b7 d0             	movzwl %ax,%edx
  101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101976:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  10197d:	00 
  10197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101981:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  101988:	00 08 00 
  10198b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198e:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101995:	00 
  101996:	80 e2 e0             	and    $0xe0,%dl
  101999:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019aa:	00 
  1019ab:	80 e2 1f             	and    $0x1f,%dl
  1019ae:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b8:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019bf:	00 
  1019c0:	80 e2 f0             	and    $0xf0,%dl
  1019c3:	80 ca 0e             	or     $0xe,%dl
  1019c6:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d0:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019d7:	00 
  1019d8:	80 e2 ef             	and    $0xef,%dl
  1019db:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e5:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019ec:	00 
  1019ed:	80 e2 9f             	and    $0x9f,%dl
  1019f0:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fa:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a01:	00 
  101a02:	80 ca 80             	or     $0x80,%dl
  101a05:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0f:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a16:	c1 e8 10             	shr    $0x10,%eax
  101a19:	0f b7 d0             	movzwl %ax,%edx
  101a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1f:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a26:	00 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  101a27:	ff 45 fc             	incl   -0x4(%ebp)
  101a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2d:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a32:	0f 86 2e ff ff ff    	jbe    101966 <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
  101a38:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101a3d:	0f b7 c0             	movzwl %ax,%eax
  101a40:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101a46:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101a4d:	08 00 
  101a4f:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a56:	24 e0                	and    $0xe0,%al
  101a58:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a5d:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a64:	24 1f                	and    $0x1f,%al
  101a66:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a6b:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a72:	0c 0f                	or     $0xf,%al
  101a74:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a79:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a80:	24 ef                	and    $0xef,%al
  101a82:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a87:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a8e:	0c 60                	or     $0x60,%al
  101a90:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a95:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a9c:	0c 80                	or     $0x80,%al
  101a9e:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aa3:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101aa8:	c1 e8 10             	shr    $0x10,%eax
  101aab:	0f b7 c0             	movzwl %ax,%eax
  101aae:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101ab4:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101ab9:	0f b7 c0             	movzwl %ax,%eax
  101abc:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101ac2:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101ac9:	08 00 
  101acb:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101ad2:	24 e0                	and    $0xe0,%al
  101ad4:	a2 6c 14 11 00       	mov    %al,0x11146c
  101ad9:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101ae0:	24 1f                	and    $0x1f,%al
  101ae2:	a2 6c 14 11 00       	mov    %al,0x11146c
  101ae7:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101aee:	24 f0                	and    $0xf0,%al
  101af0:	0c 0e                	or     $0xe,%al
  101af2:	a2 6d 14 11 00       	mov    %al,0x11146d
  101af7:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101afe:	24 ef                	and    $0xef,%al
  101b00:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b05:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b0c:	0c 60                	or     $0x60,%al
  101b0e:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b13:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b1a:	0c 80                	or     $0x80,%al
  101b1c:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b21:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101b26:	c1 e8 10             	shr    $0x10,%eax
  101b29:	0f b7 c0             	movzwl %ax,%eax
  101b2c:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101b32:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b3c:	0f 01 18             	lidtl  (%eax)
}
  101b3f:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
  101b40:	90                   	nop
  101b41:	c9                   	leave  
  101b42:	c3                   	ret    

00101b43 <trapname>:

static const char *
trapname(int trapno) {
  101b43:	f3 0f 1e fb          	endbr32 
  101b47:	55                   	push   %ebp
  101b48:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	83 f8 13             	cmp    $0x13,%eax
  101b50:	77 0c                	ja     101b5e <trapname+0x1b>
        return excnames[trapno];
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	8b 04 85 a0 40 10 00 	mov    0x1040a0(,%eax,4),%eax
  101b5c:	eb 18                	jmp    101b76 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b5e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b62:	7e 0d                	jle    101b71 <trapname+0x2e>
  101b64:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b68:	7f 07                	jg     101b71 <trapname+0x2e>
        return "Hardware Interrupt";
  101b6a:	b8 4a 3d 10 00       	mov    $0x103d4a,%eax
  101b6f:	eb 05                	jmp    101b76 <trapname+0x33>
    }
    return "(unknown trap)";
  101b71:	b8 5d 3d 10 00       	mov    $0x103d5d,%eax
}
  101b76:	5d                   	pop    %ebp
  101b77:	c3                   	ret    

00101b78 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b78:	f3 0f 1e fb          	endbr32 
  101b7c:	55                   	push   %ebp
  101b7d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b86:	83 f8 08             	cmp    $0x8,%eax
  101b89:	0f 94 c0             	sete   %al
  101b8c:	0f b6 c0             	movzbl %al,%eax
}
  101b8f:	5d                   	pop    %ebp
  101b90:	c3                   	ret    

00101b91 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b91:	f3 0f 1e fb          	endbr32 
  101b95:	55                   	push   %ebp
  101b96:	89 e5                	mov    %esp,%ebp
  101b98:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 9e 3d 10 00 	movl   $0x103d9e,(%esp)
  101ba9:	e8 19 e7 ff ff       	call   1002c7 <cprintf>
    print_regs(&tf->tf_regs);
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	89 04 24             	mov    %eax,(%esp)
  101bb4:	e8 8d 01 00 00       	call   101d46 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc4:	c7 04 24 af 3d 10 00 	movl   $0x103daf,(%esp)
  101bcb:	e8 f7 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdb:	c7 04 24 c2 3d 10 00 	movl   $0x103dc2,(%esp)
  101be2:	e8 e0 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101be7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bea:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 d5 3d 10 00 	movl   $0x103dd5,(%esp)
  101bf9:	e8 c9 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 e8 3d 10 00 	movl   $0x103de8,(%esp)
  101c10:	e8 b2 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 30             	mov    0x30(%eax),%eax
  101c1b:	89 04 24             	mov    %eax,(%esp)
  101c1e:	e8 20 ff ff ff       	call   101b43 <trapname>
  101c23:	8b 55 08             	mov    0x8(%ebp),%edx
  101c26:	8b 52 30             	mov    0x30(%edx),%edx
  101c29:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c31:	c7 04 24 fb 3d 10 00 	movl   $0x103dfb,(%esp)
  101c38:	e8 8a e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c40:	8b 40 34             	mov    0x34(%eax),%eax
  101c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c47:	c7 04 24 0d 3e 10 00 	movl   $0x103e0d,(%esp)
  101c4e:	e8 74 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 38             	mov    0x38(%eax),%eax
  101c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5d:	c7 04 24 1c 3e 10 00 	movl   $0x103e1c,(%esp)
  101c64:	e8 5e e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c74:	c7 04 24 2b 3e 10 00 	movl   $0x103e2b,(%esp)
  101c7b:	e8 47 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c80:	8b 45 08             	mov    0x8(%ebp),%eax
  101c83:	8b 40 40             	mov    0x40(%eax),%eax
  101c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8a:	c7 04 24 3e 3e 10 00 	movl   $0x103e3e,(%esp)
  101c91:	e8 31 e6 ff ff       	call   1002c7 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c9d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ca4:	eb 3d                	jmp    101ce3 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca9:	8b 50 40             	mov    0x40(%eax),%edx
  101cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101caf:	21 d0                	and    %edx,%eax
  101cb1:	85 c0                	test   %eax,%eax
  101cb3:	74 28                	je     101cdd <print_trapframe+0x14c>
  101cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cb8:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cbf:	85 c0                	test   %eax,%eax
  101cc1:	74 1a                	je     101cdd <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc6:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd1:	c7 04 24 4d 3e 10 00 	movl   $0x103e4d,(%esp)
  101cd8:	e8 ea e5 ff ff       	call   1002c7 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cdd:	ff 45 f4             	incl   -0xc(%ebp)
  101ce0:	d1 65 f0             	shll   -0x10(%ebp)
  101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ce6:	83 f8 17             	cmp    $0x17,%eax
  101ce9:	76 bb                	jbe    101ca6 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 40 40             	mov    0x40(%eax),%eax
  101cf1:	c1 e8 0c             	shr    $0xc,%eax
  101cf4:	83 e0 03             	and    $0x3,%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 51 3e 10 00 	movl   $0x103e51,(%esp)
  101d02:	e8 c0 e5 ff ff       	call   1002c7 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	89 04 24             	mov    %eax,(%esp)
  101d0d:	e8 66 fe ff ff       	call   101b78 <trap_in_kernel>
  101d12:	85 c0                	test   %eax,%eax
  101d14:	75 2d                	jne    101d43 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d16:	8b 45 08             	mov    0x8(%ebp),%eax
  101d19:	8b 40 44             	mov    0x44(%eax),%eax
  101d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d20:	c7 04 24 5a 3e 10 00 	movl   $0x103e5a,(%esp)
  101d27:	e8 9b e5 ff ff       	call   1002c7 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d37:	c7 04 24 69 3e 10 00 	movl   $0x103e69,(%esp)
  101d3e:	e8 84 e5 ff ff       	call   1002c7 <cprintf>
    }
}
  101d43:	90                   	nop
  101d44:	c9                   	leave  
  101d45:	c3                   	ret    

00101d46 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d46:	f3 0f 1e fb          	endbr32 
  101d4a:	55                   	push   %ebp
  101d4b:	89 e5                	mov    %esp,%ebp
  101d4d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	8b 00                	mov    (%eax),%eax
  101d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d59:	c7 04 24 7c 3e 10 00 	movl   $0x103e7c,(%esp)
  101d60:	e8 62 e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d65:	8b 45 08             	mov    0x8(%ebp),%eax
  101d68:	8b 40 04             	mov    0x4(%eax),%eax
  101d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6f:	c7 04 24 8b 3e 10 00 	movl   $0x103e8b,(%esp)
  101d76:	e8 4c e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7e:	8b 40 08             	mov    0x8(%eax),%eax
  101d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d85:	c7 04 24 9a 3e 10 00 	movl   $0x103e9a,(%esp)
  101d8c:	e8 36 e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d91:	8b 45 08             	mov    0x8(%ebp),%eax
  101d94:	8b 40 0c             	mov    0xc(%eax),%eax
  101d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9b:	c7 04 24 a9 3e 10 00 	movl   $0x103ea9,(%esp)
  101da2:	e8 20 e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101da7:	8b 45 08             	mov    0x8(%ebp),%eax
  101daa:	8b 40 10             	mov    0x10(%eax),%eax
  101dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db1:	c7 04 24 b8 3e 10 00 	movl   $0x103eb8,(%esp)
  101db8:	e8 0a e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc0:	8b 40 14             	mov    0x14(%eax),%eax
  101dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc7:	c7 04 24 c7 3e 10 00 	movl   $0x103ec7,(%esp)
  101dce:	e8 f4 e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd6:	8b 40 18             	mov    0x18(%eax),%eax
  101dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddd:	c7 04 24 d6 3e 10 00 	movl   $0x103ed6,(%esp)
  101de4:	e8 de e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	8b 40 1c             	mov    0x1c(%eax),%eax
  101def:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df3:	c7 04 24 e5 3e 10 00 	movl   $0x103ee5,(%esp)
  101dfa:	e8 c8 e4 ff ff       	call   1002c7 <cprintf>
}
  101dff:	90                   	nop
  101e00:	c9                   	leave  
  101e01:	c3                   	ret    

00101e02 <trap_dispatch>:



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e02:	f3 0f 1e fb          	endbr32 
  101e06:	55                   	push   %ebp
  101e07:	89 e5                	mov    %esp,%ebp
  101e09:	57                   	push   %edi
  101e0a:	56                   	push   %esi
  101e0b:	53                   	push   %ebx
  101e0c:	83 ec 3c             	sub    $0x3c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e12:	8b 40 30             	mov    0x30(%eax),%eax
  101e15:	83 f8 79             	cmp    $0x79,%eax
  101e18:	0f 84 86 03 00 00    	je     1021a4 <trap_dispatch+0x3a2>
  101e1e:	83 f8 79             	cmp    $0x79,%eax
  101e21:	0f 87 fd 03 00 00    	ja     102224 <trap_dispatch+0x422>
  101e27:	83 f8 78             	cmp    $0x78,%eax
  101e2a:	0f 84 89 02 00 00    	je     1020b9 <trap_dispatch+0x2b7>
  101e30:	83 f8 78             	cmp    $0x78,%eax
  101e33:	0f 87 eb 03 00 00    	ja     102224 <trap_dispatch+0x422>
  101e39:	83 f8 2f             	cmp    $0x2f,%eax
  101e3c:	0f 87 e2 03 00 00    	ja     102224 <trap_dispatch+0x422>
  101e42:	83 f8 2e             	cmp    $0x2e,%eax
  101e45:	0f 83 0e 04 00 00    	jae    102259 <trap_dispatch+0x457>
  101e4b:	83 f8 24             	cmp    $0x24,%eax
  101e4e:	74 5e                	je     101eae <trap_dispatch+0xac>
  101e50:	83 f8 24             	cmp    $0x24,%eax
  101e53:	0f 87 cb 03 00 00    	ja     102224 <trap_dispatch+0x422>
  101e59:	83 f8 20             	cmp    $0x20,%eax
  101e5c:	74 0a                	je     101e68 <trap_dispatch+0x66>
  101e5e:	83 f8 21             	cmp    $0x21,%eax
  101e61:	74 74                	je     101ed7 <trap_dispatch+0xd5>
  101e63:	e9 bc 03 00 00       	jmp    102224 <trap_dispatch+0x422>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101e68:	a1 08 19 11 00       	mov    0x111908,%eax
  101e6d:	40                   	inc    %eax
  101e6e:	a3 08 19 11 00       	mov    %eax,0x111908
        if(ticks%100==0){
  101e73:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e79:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e7e:	89 c8                	mov    %ecx,%eax
  101e80:	f7 e2                	mul    %edx
  101e82:	c1 ea 05             	shr    $0x5,%edx
  101e85:	89 d0                	mov    %edx,%eax
  101e87:	c1 e0 02             	shl    $0x2,%eax
  101e8a:	01 d0                	add    %edx,%eax
  101e8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e93:	01 d0                	add    %edx,%eax
  101e95:	c1 e0 02             	shl    $0x2,%eax
  101e98:	29 c1                	sub    %eax,%ecx
  101e9a:	89 ca                	mov    %ecx,%edx
  101e9c:	85 d2                	test   %edx,%edx
  101e9e:	0f 85 b8 03 00 00    	jne    10225c <trap_dispatch+0x45a>
            print_ticks();
  101ea4:	e8 86 fa ff ff       	call   10192f <print_ticks>
        }
        break;
  101ea9:	e9 ae 03 00 00       	jmp    10225c <trap_dispatch+0x45a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101eae:	e8 22 f8 ff ff       	call   1016d5 <cons_getc>
  101eb3:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101eba:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec6:	c7 04 24 f4 3e 10 00 	movl   $0x103ef4,(%esp)
  101ecd:	e8 f5 e3 ff ff       	call   1002c7 <cprintf>
        break;
  101ed2:	e9 89 03 00 00       	jmp    102260 <trap_dispatch+0x45e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed7:	e8 f9 f7 ff ff       	call   1016d5 <cons_getc>
  101edc:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101edf:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ee3:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ee7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eef:	c7 04 24 06 3f 10 00 	movl   $0x103f06,(%esp)
  101ef6:	e8 cc e3 ff ff       	call   1002c7 <cprintf>
         if (c == '0'&&!trap_in_kernel(tf)) {
  101efb:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101eff:	0f 85 a1 00 00 00    	jne    101fa6 <trap_dispatch+0x1a4>
  101f05:	8b 45 08             	mov    0x8(%ebp),%eax
  101f08:	89 04 24             	mov    %eax,(%esp)
  101f0b:	e8 68 fc ff ff       	call   101b78 <trap_in_kernel>
  101f10:	85 c0                	test   %eax,%eax
  101f12:	0f 85 8e 00 00 00    	jne    101fa6 <trap_dispatch+0x1a4>
  101f18:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  101f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f21:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f25:	83 f8 08             	cmp    $0x8,%eax
  101f28:	74 6b                	je     101f95 <trap_dispatch+0x193>
        tf->tf_cs = KERNEL_CS;
  101f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f2d:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f36:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f3f:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f46:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f4d:	8b 40 40             	mov    0x40(%eax),%eax
  101f50:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f55:	89 c2                	mov    %eax,%edx
  101f57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f5a:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f60:	8b 40 44             	mov    0x44(%eax),%eax
  101f63:	83 e8 44             	sub    $0x44,%eax
  101f66:	a3 6c 19 11 00       	mov    %eax,0x11196c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f6b:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101f70:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f77:	00 
  101f78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101f7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f7f:	89 04 24             	mov    %eax,(%esp)
  101f82:	e8 56 12 00 00       	call   1031dd <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f87:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f90:	83 e8 04             	sub    $0x4,%eax
  101f93:	89 10                	mov    %edx,(%eax)
}
  101f95:	90                   	nop
        //切换为内核态
        switch_to_kernel(tf);
        print_trapframe(tf);
  101f96:	8b 45 08             	mov    0x8(%ebp),%eax
  101f99:	89 04 24             	mov    %eax,(%esp)
  101f9c:	e8 f0 fb ff ff       	call   101b91 <print_trapframe>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
        //切换为用户态
        switch_to_user(tf);
        print_trapframe(tf);
        }
        break;
  101fa1:	e9 b9 02 00 00       	jmp    10225f <trap_dispatch+0x45d>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
  101fa6:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101faa:	0f 85 af 02 00 00    	jne    10225f <trap_dispatch+0x45d>
  101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb3:	89 04 24             	mov    %eax,(%esp)
  101fb6:	e8 bd fb ff ff       	call   101b78 <trap_in_kernel>
  101fbb:	85 c0                	test   %eax,%eax
  101fbd:	0f 84 9c 02 00 00    	je     10225f <trap_dispatch+0x45d>
  101fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (tf->tf_cs != USER_CS) {
  101fc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101fcc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fd0:	83 f8 1b             	cmp    $0x1b,%eax
  101fd3:	0f 84 cf 00 00 00    	je     1020a8 <trap_dispatch+0x2a6>
        switchk2u = *tf;
  101fd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101fdc:	b8 20 19 11 00       	mov    $0x111920,%eax
  101fe1:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fe6:	89 c1                	mov    %eax,%ecx
  101fe8:	83 e1 01             	and    $0x1,%ecx
  101feb:	85 c9                	test   %ecx,%ecx
  101fed:	74 0c                	je     101ffb <trap_dispatch+0x1f9>
  101fef:	0f b6 0a             	movzbl (%edx),%ecx
  101ff2:	88 08                	mov    %cl,(%eax)
  101ff4:	8d 40 01             	lea    0x1(%eax),%eax
  101ff7:	8d 52 01             	lea    0x1(%edx),%edx
  101ffa:	4b                   	dec    %ebx
  101ffb:	89 c1                	mov    %eax,%ecx
  101ffd:	83 e1 02             	and    $0x2,%ecx
  102000:	85 c9                	test   %ecx,%ecx
  102002:	74 0f                	je     102013 <trap_dispatch+0x211>
  102004:	0f b7 0a             	movzwl (%edx),%ecx
  102007:	66 89 08             	mov    %cx,(%eax)
  10200a:	8d 40 02             	lea    0x2(%eax),%eax
  10200d:	8d 52 02             	lea    0x2(%edx),%edx
  102010:	83 eb 02             	sub    $0x2,%ebx
  102013:	89 df                	mov    %ebx,%edi
  102015:	83 e7 fc             	and    $0xfffffffc,%edi
  102018:	b9 00 00 00 00       	mov    $0x0,%ecx
  10201d:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102020:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102023:	83 c1 04             	add    $0x4,%ecx
  102026:	39 f9                	cmp    %edi,%ecx
  102028:	72 f3                	jb     10201d <trap_dispatch+0x21b>
  10202a:	01 c8                	add    %ecx,%eax
  10202c:	01 ca                	add    %ecx,%edx
  10202e:	b9 00 00 00 00       	mov    $0x0,%ecx
  102033:	89 de                	mov    %ebx,%esi
  102035:	83 e6 02             	and    $0x2,%esi
  102038:	85 f6                	test   %esi,%esi
  10203a:	74 0b                	je     102047 <trap_dispatch+0x245>
  10203c:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102040:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102044:	83 c1 02             	add    $0x2,%ecx
  102047:	83 e3 01             	and    $0x1,%ebx
  10204a:	85 db                	test   %ebx,%ebx
  10204c:	74 07                	je     102055 <trap_dispatch+0x253>
  10204e:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102052:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  102055:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  10205c:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  10205e:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  102065:	23 00 
  102067:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  10206e:	66 a3 48 19 11 00    	mov    %ax,0x111948
  102074:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  10207b:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  102081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102084:	83 c0 4c             	add    $0x4c,%eax
  102087:	a3 64 19 11 00       	mov    %eax,0x111964
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  10208c:	a1 60 19 11 00       	mov    0x111960,%eax
  102091:	0d 00 30 00 00       	or     $0x3000,%eax
  102096:	a3 60 19 11 00       	mov    %eax,0x111960
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  10209b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10209e:	83 e8 04             	sub    $0x4,%eax
  1020a1:	ba 20 19 11 00       	mov    $0x111920,%edx
  1020a6:	89 10                	mov    %edx,(%eax)
}
  1020a8:	90                   	nop
        print_trapframe(tf);
  1020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ac:	89 04 24             	mov    %eax,(%esp)
  1020af:	e8 dd fa ff ff       	call   101b91 <print_trapframe>
        break;
  1020b4:	e9 a6 01 00 00       	jmp    10225f <trap_dispatch+0x45d>
  1020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (tf->tf_cs != USER_CS) {
  1020bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1020c2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020c6:	83 f8 1b             	cmp    $0x1b,%eax
  1020c9:	0f 84 cf 00 00 00    	je     10219e <trap_dispatch+0x39c>
        switchk2u = *tf;
  1020cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1020d2:	b8 20 19 11 00       	mov    $0x111920,%eax
  1020d7:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  1020dc:	89 c1                	mov    %eax,%ecx
  1020de:	83 e1 01             	and    $0x1,%ecx
  1020e1:	85 c9                	test   %ecx,%ecx
  1020e3:	74 0c                	je     1020f1 <trap_dispatch+0x2ef>
  1020e5:	0f b6 0a             	movzbl (%edx),%ecx
  1020e8:	88 08                	mov    %cl,(%eax)
  1020ea:	8d 40 01             	lea    0x1(%eax),%eax
  1020ed:	8d 52 01             	lea    0x1(%edx),%edx
  1020f0:	4b                   	dec    %ebx
  1020f1:	89 c1                	mov    %eax,%ecx
  1020f3:	83 e1 02             	and    $0x2,%ecx
  1020f6:	85 c9                	test   %ecx,%ecx
  1020f8:	74 0f                	je     102109 <trap_dispatch+0x307>
  1020fa:	0f b7 0a             	movzwl (%edx),%ecx
  1020fd:	66 89 08             	mov    %cx,(%eax)
  102100:	8d 40 02             	lea    0x2(%eax),%eax
  102103:	8d 52 02             	lea    0x2(%edx),%edx
  102106:	83 eb 02             	sub    $0x2,%ebx
  102109:	89 df                	mov    %ebx,%edi
  10210b:	83 e7 fc             	and    $0xfffffffc,%edi
  10210e:	b9 00 00 00 00       	mov    $0x0,%ecx
  102113:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102116:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102119:	83 c1 04             	add    $0x4,%ecx
  10211c:	39 f9                	cmp    %edi,%ecx
  10211e:	72 f3                	jb     102113 <trap_dispatch+0x311>
  102120:	01 c8                	add    %ecx,%eax
  102122:	01 ca                	add    %ecx,%edx
  102124:	b9 00 00 00 00       	mov    $0x0,%ecx
  102129:	89 de                	mov    %ebx,%esi
  10212b:	83 e6 02             	and    $0x2,%esi
  10212e:	85 f6                	test   %esi,%esi
  102130:	74 0b                	je     10213d <trap_dispatch+0x33b>
  102132:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102136:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  10213a:	83 c1 02             	add    $0x2,%ecx
  10213d:	83 e3 01             	and    $0x1,%ebx
  102140:	85 db                	test   %ebx,%ebx
  102142:	74 07                	je     10214b <trap_dispatch+0x349>
  102144:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102148:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  10214b:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  102152:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102154:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  10215b:	23 00 
  10215d:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  102164:	66 a3 48 19 11 00    	mov    %ax,0x111948
  10216a:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  102171:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  102177:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10217a:	83 c0 4c             	add    $0x4c,%eax
  10217d:	a3 64 19 11 00       	mov    %eax,0x111964
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  102182:	a1 60 19 11 00       	mov    0x111960,%eax
  102187:	0d 00 30 00 00       	or     $0x3000,%eax
  10218c:	a3 60 19 11 00       	mov    %eax,0x111960
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102191:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102194:	83 e8 04             	sub    $0x4,%eax
  102197:	ba 20 19 11 00       	mov    $0x111920,%edx
  10219c:	89 10                	mov    %edx,(%eax)
}
  10219e:	90                   	nop
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
        }*/
        switch_to_user(tf);
        break;
  10219f:	e9 bc 00 00 00       	jmp    102260 <trap_dispatch+0x45e>
  1021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  1021aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021ad:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021b1:	83 f8 08             	cmp    $0x8,%eax
  1021b4:	74 6b                	je     102221 <trap_dispatch+0x41f>
        tf->tf_cs = KERNEL_CS;
  1021b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021b9:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es = KERNEL_DS;
  1021bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021c2:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  1021c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021cb:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1021cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021d2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  1021d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021d9:	8b 40 40             	mov    0x40(%eax),%eax
  1021dc:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021e1:	89 c2                	mov    %eax,%edx
  1021e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021e6:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  1021e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021ec:	8b 40 44             	mov    0x44(%eax),%eax
  1021ef:	83 e8 44             	sub    $0x44,%eax
  1021f2:	a3 6c 19 11 00       	mov    %eax,0x11196c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  1021f7:	a1 6c 19 11 00       	mov    0x11196c,%eax
  1021fc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  102203:	00 
  102204:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102207:	89 54 24 04          	mov    %edx,0x4(%esp)
  10220b:	89 04 24             	mov    %eax,(%esp)
  10220e:	e8 ca 0f 00 00       	call   1031dd <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  102213:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  102219:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10221c:	83 e8 04             	sub    $0x4,%eax
  10221f:	89 10                	mov    %edx,(%eax)
}
  102221:	90                   	nop
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = KERNEL_DS;
            tf->tf_eflags &= ~FL_IOPL_MASK;
        }*/
        switch_to_kernel(tf);
        break;
  102222:	eb 3c                	jmp    102260 <trap_dispatch+0x45e>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102224:	8b 45 08             	mov    0x8(%ebp),%eax
  102227:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10222b:	83 e0 03             	and    $0x3,%eax
  10222e:	85 c0                	test   %eax,%eax
  102230:	75 2e                	jne    102260 <trap_dispatch+0x45e>
            print_trapframe(tf);
  102232:	8b 45 08             	mov    0x8(%ebp),%eax
  102235:	89 04 24             	mov    %eax,(%esp)
  102238:	e8 54 f9 ff ff       	call   101b91 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10223d:	c7 44 24 08 15 3f 10 	movl   $0x103f15,0x8(%esp)
  102244:	00 
  102245:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10224c:	00 
  10224d:	c7 04 24 31 3f 10 00 	movl   $0x103f31,(%esp)
  102254:	e8 da e1 ff ff       	call   100433 <__panic>
        break;
  102259:	90                   	nop
  10225a:	eb 04                	jmp    102260 <trap_dispatch+0x45e>
        break;
  10225c:	90                   	nop
  10225d:	eb 01                	jmp    102260 <trap_dispatch+0x45e>
        break;
  10225f:	90                   	nop
        }
    }
}
  102260:	90                   	nop
  102261:	83 c4 3c             	add    $0x3c,%esp
  102264:	5b                   	pop    %ebx
  102265:	5e                   	pop    %esi
  102266:	5f                   	pop    %edi
  102267:	5d                   	pop    %ebp
  102268:	c3                   	ret    

00102269 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102269:	f3 0f 1e fb          	endbr32 
  10226d:	55                   	push   %ebp
  10226e:	89 e5                	mov    %esp,%ebp
  102270:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102273:	8b 45 08             	mov    0x8(%ebp),%eax
  102276:	89 04 24             	mov    %eax,(%esp)
  102279:	e8 84 fb ff ff       	call   101e02 <trap_dispatch>
}
  10227e:	90                   	nop
  10227f:	c9                   	leave  
  102280:	c3                   	ret    

00102281 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $0
  102283:	6a 00                	push   $0x0
  jmp __alltraps
  102285:	e9 69 0a 00 00       	jmp    102cf3 <__alltraps>

0010228a <vector1>:
.globl vector1
vector1:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $1
  10228c:	6a 01                	push   $0x1
  jmp __alltraps
  10228e:	e9 60 0a 00 00       	jmp    102cf3 <__alltraps>

00102293 <vector2>:
.globl vector2
vector2:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $2
  102295:	6a 02                	push   $0x2
  jmp __alltraps
  102297:	e9 57 0a 00 00       	jmp    102cf3 <__alltraps>

0010229c <vector3>:
.globl vector3
vector3:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $3
  10229e:	6a 03                	push   $0x3
  jmp __alltraps
  1022a0:	e9 4e 0a 00 00       	jmp    102cf3 <__alltraps>

001022a5 <vector4>:
.globl vector4
vector4:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $4
  1022a7:	6a 04                	push   $0x4
  jmp __alltraps
  1022a9:	e9 45 0a 00 00       	jmp    102cf3 <__alltraps>

001022ae <vector5>:
.globl vector5
vector5:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $5
  1022b0:	6a 05                	push   $0x5
  jmp __alltraps
  1022b2:	e9 3c 0a 00 00       	jmp    102cf3 <__alltraps>

001022b7 <vector6>:
.globl vector6
vector6:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $6
  1022b9:	6a 06                	push   $0x6
  jmp __alltraps
  1022bb:	e9 33 0a 00 00       	jmp    102cf3 <__alltraps>

001022c0 <vector7>:
.globl vector7
vector7:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $7
  1022c2:	6a 07                	push   $0x7
  jmp __alltraps
  1022c4:	e9 2a 0a 00 00       	jmp    102cf3 <__alltraps>

001022c9 <vector8>:
.globl vector8
vector8:
  pushl $8
  1022c9:	6a 08                	push   $0x8
  jmp __alltraps
  1022cb:	e9 23 0a 00 00       	jmp    102cf3 <__alltraps>

001022d0 <vector9>:
.globl vector9
vector9:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $9
  1022d2:	6a 09                	push   $0x9
  jmp __alltraps
  1022d4:	e9 1a 0a 00 00       	jmp    102cf3 <__alltraps>

001022d9 <vector10>:
.globl vector10
vector10:
  pushl $10
  1022d9:	6a 0a                	push   $0xa
  jmp __alltraps
  1022db:	e9 13 0a 00 00       	jmp    102cf3 <__alltraps>

001022e0 <vector11>:
.globl vector11
vector11:
  pushl $11
  1022e0:	6a 0b                	push   $0xb
  jmp __alltraps
  1022e2:	e9 0c 0a 00 00       	jmp    102cf3 <__alltraps>

001022e7 <vector12>:
.globl vector12
vector12:
  pushl $12
  1022e7:	6a 0c                	push   $0xc
  jmp __alltraps
  1022e9:	e9 05 0a 00 00       	jmp    102cf3 <__alltraps>

001022ee <vector13>:
.globl vector13
vector13:
  pushl $13
  1022ee:	6a 0d                	push   $0xd
  jmp __alltraps
  1022f0:	e9 fe 09 00 00       	jmp    102cf3 <__alltraps>

001022f5 <vector14>:
.globl vector14
vector14:
  pushl $14
  1022f5:	6a 0e                	push   $0xe
  jmp __alltraps
  1022f7:	e9 f7 09 00 00       	jmp    102cf3 <__alltraps>

001022fc <vector15>:
.globl vector15
vector15:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $15
  1022fe:	6a 0f                	push   $0xf
  jmp __alltraps
  102300:	e9 ee 09 00 00       	jmp    102cf3 <__alltraps>

00102305 <vector16>:
.globl vector16
vector16:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $16
  102307:	6a 10                	push   $0x10
  jmp __alltraps
  102309:	e9 e5 09 00 00       	jmp    102cf3 <__alltraps>

0010230e <vector17>:
.globl vector17
vector17:
  pushl $17
  10230e:	6a 11                	push   $0x11
  jmp __alltraps
  102310:	e9 de 09 00 00       	jmp    102cf3 <__alltraps>

00102315 <vector18>:
.globl vector18
vector18:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $18
  102317:	6a 12                	push   $0x12
  jmp __alltraps
  102319:	e9 d5 09 00 00       	jmp    102cf3 <__alltraps>

0010231e <vector19>:
.globl vector19
vector19:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $19
  102320:	6a 13                	push   $0x13
  jmp __alltraps
  102322:	e9 cc 09 00 00       	jmp    102cf3 <__alltraps>

00102327 <vector20>:
.globl vector20
vector20:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $20
  102329:	6a 14                	push   $0x14
  jmp __alltraps
  10232b:	e9 c3 09 00 00       	jmp    102cf3 <__alltraps>

00102330 <vector21>:
.globl vector21
vector21:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $21
  102332:	6a 15                	push   $0x15
  jmp __alltraps
  102334:	e9 ba 09 00 00       	jmp    102cf3 <__alltraps>

00102339 <vector22>:
.globl vector22
vector22:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $22
  10233b:	6a 16                	push   $0x16
  jmp __alltraps
  10233d:	e9 b1 09 00 00       	jmp    102cf3 <__alltraps>

00102342 <vector23>:
.globl vector23
vector23:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $23
  102344:	6a 17                	push   $0x17
  jmp __alltraps
  102346:	e9 a8 09 00 00       	jmp    102cf3 <__alltraps>

0010234b <vector24>:
.globl vector24
vector24:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $24
  10234d:	6a 18                	push   $0x18
  jmp __alltraps
  10234f:	e9 9f 09 00 00       	jmp    102cf3 <__alltraps>

00102354 <vector25>:
.globl vector25
vector25:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $25
  102356:	6a 19                	push   $0x19
  jmp __alltraps
  102358:	e9 96 09 00 00       	jmp    102cf3 <__alltraps>

0010235d <vector26>:
.globl vector26
vector26:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $26
  10235f:	6a 1a                	push   $0x1a
  jmp __alltraps
  102361:	e9 8d 09 00 00       	jmp    102cf3 <__alltraps>

00102366 <vector27>:
.globl vector27
vector27:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $27
  102368:	6a 1b                	push   $0x1b
  jmp __alltraps
  10236a:	e9 84 09 00 00       	jmp    102cf3 <__alltraps>

0010236f <vector28>:
.globl vector28
vector28:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $28
  102371:	6a 1c                	push   $0x1c
  jmp __alltraps
  102373:	e9 7b 09 00 00       	jmp    102cf3 <__alltraps>

00102378 <vector29>:
.globl vector29
vector29:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $29
  10237a:	6a 1d                	push   $0x1d
  jmp __alltraps
  10237c:	e9 72 09 00 00       	jmp    102cf3 <__alltraps>

00102381 <vector30>:
.globl vector30
vector30:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $30
  102383:	6a 1e                	push   $0x1e
  jmp __alltraps
  102385:	e9 69 09 00 00       	jmp    102cf3 <__alltraps>

0010238a <vector31>:
.globl vector31
vector31:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $31
  10238c:	6a 1f                	push   $0x1f
  jmp __alltraps
  10238e:	e9 60 09 00 00       	jmp    102cf3 <__alltraps>

00102393 <vector32>:
.globl vector32
vector32:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $32
  102395:	6a 20                	push   $0x20
  jmp __alltraps
  102397:	e9 57 09 00 00       	jmp    102cf3 <__alltraps>

0010239c <vector33>:
.globl vector33
vector33:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $33
  10239e:	6a 21                	push   $0x21
  jmp __alltraps
  1023a0:	e9 4e 09 00 00       	jmp    102cf3 <__alltraps>

001023a5 <vector34>:
.globl vector34
vector34:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $34
  1023a7:	6a 22                	push   $0x22
  jmp __alltraps
  1023a9:	e9 45 09 00 00       	jmp    102cf3 <__alltraps>

001023ae <vector35>:
.globl vector35
vector35:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $35
  1023b0:	6a 23                	push   $0x23
  jmp __alltraps
  1023b2:	e9 3c 09 00 00       	jmp    102cf3 <__alltraps>

001023b7 <vector36>:
.globl vector36
vector36:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $36
  1023b9:	6a 24                	push   $0x24
  jmp __alltraps
  1023bb:	e9 33 09 00 00       	jmp    102cf3 <__alltraps>

001023c0 <vector37>:
.globl vector37
vector37:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $37
  1023c2:	6a 25                	push   $0x25
  jmp __alltraps
  1023c4:	e9 2a 09 00 00       	jmp    102cf3 <__alltraps>

001023c9 <vector38>:
.globl vector38
vector38:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $38
  1023cb:	6a 26                	push   $0x26
  jmp __alltraps
  1023cd:	e9 21 09 00 00       	jmp    102cf3 <__alltraps>

001023d2 <vector39>:
.globl vector39
vector39:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $39
  1023d4:	6a 27                	push   $0x27
  jmp __alltraps
  1023d6:	e9 18 09 00 00       	jmp    102cf3 <__alltraps>

001023db <vector40>:
.globl vector40
vector40:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $40
  1023dd:	6a 28                	push   $0x28
  jmp __alltraps
  1023df:	e9 0f 09 00 00       	jmp    102cf3 <__alltraps>

001023e4 <vector41>:
.globl vector41
vector41:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $41
  1023e6:	6a 29                	push   $0x29
  jmp __alltraps
  1023e8:	e9 06 09 00 00       	jmp    102cf3 <__alltraps>

001023ed <vector42>:
.globl vector42
vector42:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $42
  1023ef:	6a 2a                	push   $0x2a
  jmp __alltraps
  1023f1:	e9 fd 08 00 00       	jmp    102cf3 <__alltraps>

001023f6 <vector43>:
.globl vector43
vector43:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $43
  1023f8:	6a 2b                	push   $0x2b
  jmp __alltraps
  1023fa:	e9 f4 08 00 00       	jmp    102cf3 <__alltraps>

001023ff <vector44>:
.globl vector44
vector44:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $44
  102401:	6a 2c                	push   $0x2c
  jmp __alltraps
  102403:	e9 eb 08 00 00       	jmp    102cf3 <__alltraps>

00102408 <vector45>:
.globl vector45
vector45:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $45
  10240a:	6a 2d                	push   $0x2d
  jmp __alltraps
  10240c:	e9 e2 08 00 00       	jmp    102cf3 <__alltraps>

00102411 <vector46>:
.globl vector46
vector46:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $46
  102413:	6a 2e                	push   $0x2e
  jmp __alltraps
  102415:	e9 d9 08 00 00       	jmp    102cf3 <__alltraps>

0010241a <vector47>:
.globl vector47
vector47:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $47
  10241c:	6a 2f                	push   $0x2f
  jmp __alltraps
  10241e:	e9 d0 08 00 00       	jmp    102cf3 <__alltraps>

00102423 <vector48>:
.globl vector48
vector48:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $48
  102425:	6a 30                	push   $0x30
  jmp __alltraps
  102427:	e9 c7 08 00 00       	jmp    102cf3 <__alltraps>

0010242c <vector49>:
.globl vector49
vector49:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $49
  10242e:	6a 31                	push   $0x31
  jmp __alltraps
  102430:	e9 be 08 00 00       	jmp    102cf3 <__alltraps>

00102435 <vector50>:
.globl vector50
vector50:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $50
  102437:	6a 32                	push   $0x32
  jmp __alltraps
  102439:	e9 b5 08 00 00       	jmp    102cf3 <__alltraps>

0010243e <vector51>:
.globl vector51
vector51:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $51
  102440:	6a 33                	push   $0x33
  jmp __alltraps
  102442:	e9 ac 08 00 00       	jmp    102cf3 <__alltraps>

00102447 <vector52>:
.globl vector52
vector52:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $52
  102449:	6a 34                	push   $0x34
  jmp __alltraps
  10244b:	e9 a3 08 00 00       	jmp    102cf3 <__alltraps>

00102450 <vector53>:
.globl vector53
vector53:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $53
  102452:	6a 35                	push   $0x35
  jmp __alltraps
  102454:	e9 9a 08 00 00       	jmp    102cf3 <__alltraps>

00102459 <vector54>:
.globl vector54
vector54:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $54
  10245b:	6a 36                	push   $0x36
  jmp __alltraps
  10245d:	e9 91 08 00 00       	jmp    102cf3 <__alltraps>

00102462 <vector55>:
.globl vector55
vector55:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $55
  102464:	6a 37                	push   $0x37
  jmp __alltraps
  102466:	e9 88 08 00 00       	jmp    102cf3 <__alltraps>

0010246b <vector56>:
.globl vector56
vector56:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $56
  10246d:	6a 38                	push   $0x38
  jmp __alltraps
  10246f:	e9 7f 08 00 00       	jmp    102cf3 <__alltraps>

00102474 <vector57>:
.globl vector57
vector57:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $57
  102476:	6a 39                	push   $0x39
  jmp __alltraps
  102478:	e9 76 08 00 00       	jmp    102cf3 <__alltraps>

0010247d <vector58>:
.globl vector58
vector58:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $58
  10247f:	6a 3a                	push   $0x3a
  jmp __alltraps
  102481:	e9 6d 08 00 00       	jmp    102cf3 <__alltraps>

00102486 <vector59>:
.globl vector59
vector59:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $59
  102488:	6a 3b                	push   $0x3b
  jmp __alltraps
  10248a:	e9 64 08 00 00       	jmp    102cf3 <__alltraps>

0010248f <vector60>:
.globl vector60
vector60:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $60
  102491:	6a 3c                	push   $0x3c
  jmp __alltraps
  102493:	e9 5b 08 00 00       	jmp    102cf3 <__alltraps>

00102498 <vector61>:
.globl vector61
vector61:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $61
  10249a:	6a 3d                	push   $0x3d
  jmp __alltraps
  10249c:	e9 52 08 00 00       	jmp    102cf3 <__alltraps>

001024a1 <vector62>:
.globl vector62
vector62:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $62
  1024a3:	6a 3e                	push   $0x3e
  jmp __alltraps
  1024a5:	e9 49 08 00 00       	jmp    102cf3 <__alltraps>

001024aa <vector63>:
.globl vector63
vector63:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $63
  1024ac:	6a 3f                	push   $0x3f
  jmp __alltraps
  1024ae:	e9 40 08 00 00       	jmp    102cf3 <__alltraps>

001024b3 <vector64>:
.globl vector64
vector64:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $64
  1024b5:	6a 40                	push   $0x40
  jmp __alltraps
  1024b7:	e9 37 08 00 00       	jmp    102cf3 <__alltraps>

001024bc <vector65>:
.globl vector65
vector65:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $65
  1024be:	6a 41                	push   $0x41
  jmp __alltraps
  1024c0:	e9 2e 08 00 00       	jmp    102cf3 <__alltraps>

001024c5 <vector66>:
.globl vector66
vector66:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $66
  1024c7:	6a 42                	push   $0x42
  jmp __alltraps
  1024c9:	e9 25 08 00 00       	jmp    102cf3 <__alltraps>

001024ce <vector67>:
.globl vector67
vector67:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $67
  1024d0:	6a 43                	push   $0x43
  jmp __alltraps
  1024d2:	e9 1c 08 00 00       	jmp    102cf3 <__alltraps>

001024d7 <vector68>:
.globl vector68
vector68:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $68
  1024d9:	6a 44                	push   $0x44
  jmp __alltraps
  1024db:	e9 13 08 00 00       	jmp    102cf3 <__alltraps>

001024e0 <vector69>:
.globl vector69
vector69:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $69
  1024e2:	6a 45                	push   $0x45
  jmp __alltraps
  1024e4:	e9 0a 08 00 00       	jmp    102cf3 <__alltraps>

001024e9 <vector70>:
.globl vector70
vector70:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $70
  1024eb:	6a 46                	push   $0x46
  jmp __alltraps
  1024ed:	e9 01 08 00 00       	jmp    102cf3 <__alltraps>

001024f2 <vector71>:
.globl vector71
vector71:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $71
  1024f4:	6a 47                	push   $0x47
  jmp __alltraps
  1024f6:	e9 f8 07 00 00       	jmp    102cf3 <__alltraps>

001024fb <vector72>:
.globl vector72
vector72:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $72
  1024fd:	6a 48                	push   $0x48
  jmp __alltraps
  1024ff:	e9 ef 07 00 00       	jmp    102cf3 <__alltraps>

00102504 <vector73>:
.globl vector73
vector73:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $73
  102506:	6a 49                	push   $0x49
  jmp __alltraps
  102508:	e9 e6 07 00 00       	jmp    102cf3 <__alltraps>

0010250d <vector74>:
.globl vector74
vector74:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $74
  10250f:	6a 4a                	push   $0x4a
  jmp __alltraps
  102511:	e9 dd 07 00 00       	jmp    102cf3 <__alltraps>

00102516 <vector75>:
.globl vector75
vector75:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $75
  102518:	6a 4b                	push   $0x4b
  jmp __alltraps
  10251a:	e9 d4 07 00 00       	jmp    102cf3 <__alltraps>

0010251f <vector76>:
.globl vector76
vector76:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $76
  102521:	6a 4c                	push   $0x4c
  jmp __alltraps
  102523:	e9 cb 07 00 00       	jmp    102cf3 <__alltraps>

00102528 <vector77>:
.globl vector77
vector77:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $77
  10252a:	6a 4d                	push   $0x4d
  jmp __alltraps
  10252c:	e9 c2 07 00 00       	jmp    102cf3 <__alltraps>

00102531 <vector78>:
.globl vector78
vector78:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $78
  102533:	6a 4e                	push   $0x4e
  jmp __alltraps
  102535:	e9 b9 07 00 00       	jmp    102cf3 <__alltraps>

0010253a <vector79>:
.globl vector79
vector79:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $79
  10253c:	6a 4f                	push   $0x4f
  jmp __alltraps
  10253e:	e9 b0 07 00 00       	jmp    102cf3 <__alltraps>

00102543 <vector80>:
.globl vector80
vector80:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $80
  102545:	6a 50                	push   $0x50
  jmp __alltraps
  102547:	e9 a7 07 00 00       	jmp    102cf3 <__alltraps>

0010254c <vector81>:
.globl vector81
vector81:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $81
  10254e:	6a 51                	push   $0x51
  jmp __alltraps
  102550:	e9 9e 07 00 00       	jmp    102cf3 <__alltraps>

00102555 <vector82>:
.globl vector82
vector82:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $82
  102557:	6a 52                	push   $0x52
  jmp __alltraps
  102559:	e9 95 07 00 00       	jmp    102cf3 <__alltraps>

0010255e <vector83>:
.globl vector83
vector83:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $83
  102560:	6a 53                	push   $0x53
  jmp __alltraps
  102562:	e9 8c 07 00 00       	jmp    102cf3 <__alltraps>

00102567 <vector84>:
.globl vector84
vector84:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $84
  102569:	6a 54                	push   $0x54
  jmp __alltraps
  10256b:	e9 83 07 00 00       	jmp    102cf3 <__alltraps>

00102570 <vector85>:
.globl vector85
vector85:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $85
  102572:	6a 55                	push   $0x55
  jmp __alltraps
  102574:	e9 7a 07 00 00       	jmp    102cf3 <__alltraps>

00102579 <vector86>:
.globl vector86
vector86:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $86
  10257b:	6a 56                	push   $0x56
  jmp __alltraps
  10257d:	e9 71 07 00 00       	jmp    102cf3 <__alltraps>

00102582 <vector87>:
.globl vector87
vector87:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $87
  102584:	6a 57                	push   $0x57
  jmp __alltraps
  102586:	e9 68 07 00 00       	jmp    102cf3 <__alltraps>

0010258b <vector88>:
.globl vector88
vector88:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $88
  10258d:	6a 58                	push   $0x58
  jmp __alltraps
  10258f:	e9 5f 07 00 00       	jmp    102cf3 <__alltraps>

00102594 <vector89>:
.globl vector89
vector89:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $89
  102596:	6a 59                	push   $0x59
  jmp __alltraps
  102598:	e9 56 07 00 00       	jmp    102cf3 <__alltraps>

0010259d <vector90>:
.globl vector90
vector90:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $90
  10259f:	6a 5a                	push   $0x5a
  jmp __alltraps
  1025a1:	e9 4d 07 00 00       	jmp    102cf3 <__alltraps>

001025a6 <vector91>:
.globl vector91
vector91:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $91
  1025a8:	6a 5b                	push   $0x5b
  jmp __alltraps
  1025aa:	e9 44 07 00 00       	jmp    102cf3 <__alltraps>

001025af <vector92>:
.globl vector92
vector92:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $92
  1025b1:	6a 5c                	push   $0x5c
  jmp __alltraps
  1025b3:	e9 3b 07 00 00       	jmp    102cf3 <__alltraps>

001025b8 <vector93>:
.globl vector93
vector93:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $93
  1025ba:	6a 5d                	push   $0x5d
  jmp __alltraps
  1025bc:	e9 32 07 00 00       	jmp    102cf3 <__alltraps>

001025c1 <vector94>:
.globl vector94
vector94:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $94
  1025c3:	6a 5e                	push   $0x5e
  jmp __alltraps
  1025c5:	e9 29 07 00 00       	jmp    102cf3 <__alltraps>

001025ca <vector95>:
.globl vector95
vector95:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $95
  1025cc:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025ce:	e9 20 07 00 00       	jmp    102cf3 <__alltraps>

001025d3 <vector96>:
.globl vector96
vector96:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $96
  1025d5:	6a 60                	push   $0x60
  jmp __alltraps
  1025d7:	e9 17 07 00 00       	jmp    102cf3 <__alltraps>

001025dc <vector97>:
.globl vector97
vector97:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $97
  1025de:	6a 61                	push   $0x61
  jmp __alltraps
  1025e0:	e9 0e 07 00 00       	jmp    102cf3 <__alltraps>

001025e5 <vector98>:
.globl vector98
vector98:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $98
  1025e7:	6a 62                	push   $0x62
  jmp __alltraps
  1025e9:	e9 05 07 00 00       	jmp    102cf3 <__alltraps>

001025ee <vector99>:
.globl vector99
vector99:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $99
  1025f0:	6a 63                	push   $0x63
  jmp __alltraps
  1025f2:	e9 fc 06 00 00       	jmp    102cf3 <__alltraps>

001025f7 <vector100>:
.globl vector100
vector100:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $100
  1025f9:	6a 64                	push   $0x64
  jmp __alltraps
  1025fb:	e9 f3 06 00 00       	jmp    102cf3 <__alltraps>

00102600 <vector101>:
.globl vector101
vector101:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $101
  102602:	6a 65                	push   $0x65
  jmp __alltraps
  102604:	e9 ea 06 00 00       	jmp    102cf3 <__alltraps>

00102609 <vector102>:
.globl vector102
vector102:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $102
  10260b:	6a 66                	push   $0x66
  jmp __alltraps
  10260d:	e9 e1 06 00 00       	jmp    102cf3 <__alltraps>

00102612 <vector103>:
.globl vector103
vector103:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $103
  102614:	6a 67                	push   $0x67
  jmp __alltraps
  102616:	e9 d8 06 00 00       	jmp    102cf3 <__alltraps>

0010261b <vector104>:
.globl vector104
vector104:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $104
  10261d:	6a 68                	push   $0x68
  jmp __alltraps
  10261f:	e9 cf 06 00 00       	jmp    102cf3 <__alltraps>

00102624 <vector105>:
.globl vector105
vector105:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $105
  102626:	6a 69                	push   $0x69
  jmp __alltraps
  102628:	e9 c6 06 00 00       	jmp    102cf3 <__alltraps>

0010262d <vector106>:
.globl vector106
vector106:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $106
  10262f:	6a 6a                	push   $0x6a
  jmp __alltraps
  102631:	e9 bd 06 00 00       	jmp    102cf3 <__alltraps>

00102636 <vector107>:
.globl vector107
vector107:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $107
  102638:	6a 6b                	push   $0x6b
  jmp __alltraps
  10263a:	e9 b4 06 00 00       	jmp    102cf3 <__alltraps>

0010263f <vector108>:
.globl vector108
vector108:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $108
  102641:	6a 6c                	push   $0x6c
  jmp __alltraps
  102643:	e9 ab 06 00 00       	jmp    102cf3 <__alltraps>

00102648 <vector109>:
.globl vector109
vector109:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $109
  10264a:	6a 6d                	push   $0x6d
  jmp __alltraps
  10264c:	e9 a2 06 00 00       	jmp    102cf3 <__alltraps>

00102651 <vector110>:
.globl vector110
vector110:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $110
  102653:	6a 6e                	push   $0x6e
  jmp __alltraps
  102655:	e9 99 06 00 00       	jmp    102cf3 <__alltraps>

0010265a <vector111>:
.globl vector111
vector111:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $111
  10265c:	6a 6f                	push   $0x6f
  jmp __alltraps
  10265e:	e9 90 06 00 00       	jmp    102cf3 <__alltraps>

00102663 <vector112>:
.globl vector112
vector112:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $112
  102665:	6a 70                	push   $0x70
  jmp __alltraps
  102667:	e9 87 06 00 00       	jmp    102cf3 <__alltraps>

0010266c <vector113>:
.globl vector113
vector113:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $113
  10266e:	6a 71                	push   $0x71
  jmp __alltraps
  102670:	e9 7e 06 00 00       	jmp    102cf3 <__alltraps>

00102675 <vector114>:
.globl vector114
vector114:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $114
  102677:	6a 72                	push   $0x72
  jmp __alltraps
  102679:	e9 75 06 00 00       	jmp    102cf3 <__alltraps>

0010267e <vector115>:
.globl vector115
vector115:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $115
  102680:	6a 73                	push   $0x73
  jmp __alltraps
  102682:	e9 6c 06 00 00       	jmp    102cf3 <__alltraps>

00102687 <vector116>:
.globl vector116
vector116:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $116
  102689:	6a 74                	push   $0x74
  jmp __alltraps
  10268b:	e9 63 06 00 00       	jmp    102cf3 <__alltraps>

00102690 <vector117>:
.globl vector117
vector117:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $117
  102692:	6a 75                	push   $0x75
  jmp __alltraps
  102694:	e9 5a 06 00 00       	jmp    102cf3 <__alltraps>

00102699 <vector118>:
.globl vector118
vector118:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $118
  10269b:	6a 76                	push   $0x76
  jmp __alltraps
  10269d:	e9 51 06 00 00       	jmp    102cf3 <__alltraps>

001026a2 <vector119>:
.globl vector119
vector119:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $119
  1026a4:	6a 77                	push   $0x77
  jmp __alltraps
  1026a6:	e9 48 06 00 00       	jmp    102cf3 <__alltraps>

001026ab <vector120>:
.globl vector120
vector120:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $120
  1026ad:	6a 78                	push   $0x78
  jmp __alltraps
  1026af:	e9 3f 06 00 00       	jmp    102cf3 <__alltraps>

001026b4 <vector121>:
.globl vector121
vector121:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $121
  1026b6:	6a 79                	push   $0x79
  jmp __alltraps
  1026b8:	e9 36 06 00 00       	jmp    102cf3 <__alltraps>

001026bd <vector122>:
.globl vector122
vector122:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $122
  1026bf:	6a 7a                	push   $0x7a
  jmp __alltraps
  1026c1:	e9 2d 06 00 00       	jmp    102cf3 <__alltraps>

001026c6 <vector123>:
.globl vector123
vector123:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $123
  1026c8:	6a 7b                	push   $0x7b
  jmp __alltraps
  1026ca:	e9 24 06 00 00       	jmp    102cf3 <__alltraps>

001026cf <vector124>:
.globl vector124
vector124:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $124
  1026d1:	6a 7c                	push   $0x7c
  jmp __alltraps
  1026d3:	e9 1b 06 00 00       	jmp    102cf3 <__alltraps>

001026d8 <vector125>:
.globl vector125
vector125:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $125
  1026da:	6a 7d                	push   $0x7d
  jmp __alltraps
  1026dc:	e9 12 06 00 00       	jmp    102cf3 <__alltraps>

001026e1 <vector126>:
.globl vector126
vector126:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $126
  1026e3:	6a 7e                	push   $0x7e
  jmp __alltraps
  1026e5:	e9 09 06 00 00       	jmp    102cf3 <__alltraps>

001026ea <vector127>:
.globl vector127
vector127:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $127
  1026ec:	6a 7f                	push   $0x7f
  jmp __alltraps
  1026ee:	e9 00 06 00 00       	jmp    102cf3 <__alltraps>

001026f3 <vector128>:
.globl vector128
vector128:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $128
  1026f5:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1026fa:	e9 f4 05 00 00       	jmp    102cf3 <__alltraps>

001026ff <vector129>:
.globl vector129
vector129:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $129
  102701:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102706:	e9 e8 05 00 00       	jmp    102cf3 <__alltraps>

0010270b <vector130>:
.globl vector130
vector130:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $130
  10270d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102712:	e9 dc 05 00 00       	jmp    102cf3 <__alltraps>

00102717 <vector131>:
.globl vector131
vector131:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $131
  102719:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10271e:	e9 d0 05 00 00       	jmp    102cf3 <__alltraps>

00102723 <vector132>:
.globl vector132
vector132:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $132
  102725:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10272a:	e9 c4 05 00 00       	jmp    102cf3 <__alltraps>

0010272f <vector133>:
.globl vector133
vector133:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $133
  102731:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102736:	e9 b8 05 00 00       	jmp    102cf3 <__alltraps>

0010273b <vector134>:
.globl vector134
vector134:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $134
  10273d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102742:	e9 ac 05 00 00       	jmp    102cf3 <__alltraps>

00102747 <vector135>:
.globl vector135
vector135:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $135
  102749:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10274e:	e9 a0 05 00 00       	jmp    102cf3 <__alltraps>

00102753 <vector136>:
.globl vector136
vector136:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $136
  102755:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10275a:	e9 94 05 00 00       	jmp    102cf3 <__alltraps>

0010275f <vector137>:
.globl vector137
vector137:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $137
  102761:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102766:	e9 88 05 00 00       	jmp    102cf3 <__alltraps>

0010276b <vector138>:
.globl vector138
vector138:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $138
  10276d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102772:	e9 7c 05 00 00       	jmp    102cf3 <__alltraps>

00102777 <vector139>:
.globl vector139
vector139:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $139
  102779:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10277e:	e9 70 05 00 00       	jmp    102cf3 <__alltraps>

00102783 <vector140>:
.globl vector140
vector140:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $140
  102785:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10278a:	e9 64 05 00 00       	jmp    102cf3 <__alltraps>

0010278f <vector141>:
.globl vector141
vector141:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $141
  102791:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102796:	e9 58 05 00 00       	jmp    102cf3 <__alltraps>

0010279b <vector142>:
.globl vector142
vector142:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $142
  10279d:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1027a2:	e9 4c 05 00 00       	jmp    102cf3 <__alltraps>

001027a7 <vector143>:
.globl vector143
vector143:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $143
  1027a9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1027ae:	e9 40 05 00 00       	jmp    102cf3 <__alltraps>

001027b3 <vector144>:
.globl vector144
vector144:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $144
  1027b5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1027ba:	e9 34 05 00 00       	jmp    102cf3 <__alltraps>

001027bf <vector145>:
.globl vector145
vector145:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $145
  1027c1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1027c6:	e9 28 05 00 00       	jmp    102cf3 <__alltraps>

001027cb <vector146>:
.globl vector146
vector146:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $146
  1027cd:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1027d2:	e9 1c 05 00 00       	jmp    102cf3 <__alltraps>

001027d7 <vector147>:
.globl vector147
vector147:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $147
  1027d9:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1027de:	e9 10 05 00 00       	jmp    102cf3 <__alltraps>

001027e3 <vector148>:
.globl vector148
vector148:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $148
  1027e5:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1027ea:	e9 04 05 00 00       	jmp    102cf3 <__alltraps>

001027ef <vector149>:
.globl vector149
vector149:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $149
  1027f1:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1027f6:	e9 f8 04 00 00       	jmp    102cf3 <__alltraps>

001027fb <vector150>:
.globl vector150
vector150:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $150
  1027fd:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102802:	e9 ec 04 00 00       	jmp    102cf3 <__alltraps>

00102807 <vector151>:
.globl vector151
vector151:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $151
  102809:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10280e:	e9 e0 04 00 00       	jmp    102cf3 <__alltraps>

00102813 <vector152>:
.globl vector152
vector152:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $152
  102815:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10281a:	e9 d4 04 00 00       	jmp    102cf3 <__alltraps>

0010281f <vector153>:
.globl vector153
vector153:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $153
  102821:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102826:	e9 c8 04 00 00       	jmp    102cf3 <__alltraps>

0010282b <vector154>:
.globl vector154
vector154:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $154
  10282d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102832:	e9 bc 04 00 00       	jmp    102cf3 <__alltraps>

00102837 <vector155>:
.globl vector155
vector155:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $155
  102839:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10283e:	e9 b0 04 00 00       	jmp    102cf3 <__alltraps>

00102843 <vector156>:
.globl vector156
vector156:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $156
  102845:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10284a:	e9 a4 04 00 00       	jmp    102cf3 <__alltraps>

0010284f <vector157>:
.globl vector157
vector157:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $157
  102851:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102856:	e9 98 04 00 00       	jmp    102cf3 <__alltraps>

0010285b <vector158>:
.globl vector158
vector158:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $158
  10285d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102862:	e9 8c 04 00 00       	jmp    102cf3 <__alltraps>

00102867 <vector159>:
.globl vector159
vector159:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $159
  102869:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10286e:	e9 80 04 00 00       	jmp    102cf3 <__alltraps>

00102873 <vector160>:
.globl vector160
vector160:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $160
  102875:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10287a:	e9 74 04 00 00       	jmp    102cf3 <__alltraps>

0010287f <vector161>:
.globl vector161
vector161:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $161
  102881:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102886:	e9 68 04 00 00       	jmp    102cf3 <__alltraps>

0010288b <vector162>:
.globl vector162
vector162:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $162
  10288d:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102892:	e9 5c 04 00 00       	jmp    102cf3 <__alltraps>

00102897 <vector163>:
.globl vector163
vector163:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $163
  102899:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10289e:	e9 50 04 00 00       	jmp    102cf3 <__alltraps>

001028a3 <vector164>:
.globl vector164
vector164:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $164
  1028a5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1028aa:	e9 44 04 00 00       	jmp    102cf3 <__alltraps>

001028af <vector165>:
.globl vector165
vector165:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $165
  1028b1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1028b6:	e9 38 04 00 00       	jmp    102cf3 <__alltraps>

001028bb <vector166>:
.globl vector166
vector166:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $166
  1028bd:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1028c2:	e9 2c 04 00 00       	jmp    102cf3 <__alltraps>

001028c7 <vector167>:
.globl vector167
vector167:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $167
  1028c9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028ce:	e9 20 04 00 00       	jmp    102cf3 <__alltraps>

001028d3 <vector168>:
.globl vector168
vector168:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $168
  1028d5:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1028da:	e9 14 04 00 00       	jmp    102cf3 <__alltraps>

001028df <vector169>:
.globl vector169
vector169:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $169
  1028e1:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1028e6:	e9 08 04 00 00       	jmp    102cf3 <__alltraps>

001028eb <vector170>:
.globl vector170
vector170:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $170
  1028ed:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1028f2:	e9 fc 03 00 00       	jmp    102cf3 <__alltraps>

001028f7 <vector171>:
.globl vector171
vector171:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $171
  1028f9:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1028fe:	e9 f0 03 00 00       	jmp    102cf3 <__alltraps>

00102903 <vector172>:
.globl vector172
vector172:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $172
  102905:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10290a:	e9 e4 03 00 00       	jmp    102cf3 <__alltraps>

0010290f <vector173>:
.globl vector173
vector173:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $173
  102911:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102916:	e9 d8 03 00 00       	jmp    102cf3 <__alltraps>

0010291b <vector174>:
.globl vector174
vector174:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $174
  10291d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102922:	e9 cc 03 00 00       	jmp    102cf3 <__alltraps>

00102927 <vector175>:
.globl vector175
vector175:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $175
  102929:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10292e:	e9 c0 03 00 00       	jmp    102cf3 <__alltraps>

00102933 <vector176>:
.globl vector176
vector176:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $176
  102935:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10293a:	e9 b4 03 00 00       	jmp    102cf3 <__alltraps>

0010293f <vector177>:
.globl vector177
vector177:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $177
  102941:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102946:	e9 a8 03 00 00       	jmp    102cf3 <__alltraps>

0010294b <vector178>:
.globl vector178
vector178:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $178
  10294d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102952:	e9 9c 03 00 00       	jmp    102cf3 <__alltraps>

00102957 <vector179>:
.globl vector179
vector179:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $179
  102959:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10295e:	e9 90 03 00 00       	jmp    102cf3 <__alltraps>

00102963 <vector180>:
.globl vector180
vector180:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $180
  102965:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10296a:	e9 84 03 00 00       	jmp    102cf3 <__alltraps>

0010296f <vector181>:
.globl vector181
vector181:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $181
  102971:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102976:	e9 78 03 00 00       	jmp    102cf3 <__alltraps>

0010297b <vector182>:
.globl vector182
vector182:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $182
  10297d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102982:	e9 6c 03 00 00       	jmp    102cf3 <__alltraps>

00102987 <vector183>:
.globl vector183
vector183:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $183
  102989:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10298e:	e9 60 03 00 00       	jmp    102cf3 <__alltraps>

00102993 <vector184>:
.globl vector184
vector184:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $184
  102995:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10299a:	e9 54 03 00 00       	jmp    102cf3 <__alltraps>

0010299f <vector185>:
.globl vector185
vector185:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $185
  1029a1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1029a6:	e9 48 03 00 00       	jmp    102cf3 <__alltraps>

001029ab <vector186>:
.globl vector186
vector186:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $186
  1029ad:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1029b2:	e9 3c 03 00 00       	jmp    102cf3 <__alltraps>

001029b7 <vector187>:
.globl vector187
vector187:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $187
  1029b9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1029be:	e9 30 03 00 00       	jmp    102cf3 <__alltraps>

001029c3 <vector188>:
.globl vector188
vector188:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $188
  1029c5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1029ca:	e9 24 03 00 00       	jmp    102cf3 <__alltraps>

001029cf <vector189>:
.globl vector189
vector189:
  pushl $0
  1029cf:	6a 00                	push   $0x0
  pushl $189
  1029d1:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1029d6:	e9 18 03 00 00       	jmp    102cf3 <__alltraps>

001029db <vector190>:
.globl vector190
vector190:
  pushl $0
  1029db:	6a 00                	push   $0x0
  pushl $190
  1029dd:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1029e2:	e9 0c 03 00 00       	jmp    102cf3 <__alltraps>

001029e7 <vector191>:
.globl vector191
vector191:
  pushl $0
  1029e7:	6a 00                	push   $0x0
  pushl $191
  1029e9:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1029ee:	e9 00 03 00 00       	jmp    102cf3 <__alltraps>

001029f3 <vector192>:
.globl vector192
vector192:
  pushl $0
  1029f3:	6a 00                	push   $0x0
  pushl $192
  1029f5:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1029fa:	e9 f4 02 00 00       	jmp    102cf3 <__alltraps>

001029ff <vector193>:
.globl vector193
vector193:
  pushl $0
  1029ff:	6a 00                	push   $0x0
  pushl $193
  102a01:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102a06:	e9 e8 02 00 00       	jmp    102cf3 <__alltraps>

00102a0b <vector194>:
.globl vector194
vector194:
  pushl $0
  102a0b:	6a 00                	push   $0x0
  pushl $194
  102a0d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102a12:	e9 dc 02 00 00       	jmp    102cf3 <__alltraps>

00102a17 <vector195>:
.globl vector195
vector195:
  pushl $0
  102a17:	6a 00                	push   $0x0
  pushl $195
  102a19:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102a1e:	e9 d0 02 00 00       	jmp    102cf3 <__alltraps>

00102a23 <vector196>:
.globl vector196
vector196:
  pushl $0
  102a23:	6a 00                	push   $0x0
  pushl $196
  102a25:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a2a:	e9 c4 02 00 00       	jmp    102cf3 <__alltraps>

00102a2f <vector197>:
.globl vector197
vector197:
  pushl $0
  102a2f:	6a 00                	push   $0x0
  pushl $197
  102a31:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a36:	e9 b8 02 00 00       	jmp    102cf3 <__alltraps>

00102a3b <vector198>:
.globl vector198
vector198:
  pushl $0
  102a3b:	6a 00                	push   $0x0
  pushl $198
  102a3d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a42:	e9 ac 02 00 00       	jmp    102cf3 <__alltraps>

00102a47 <vector199>:
.globl vector199
vector199:
  pushl $0
  102a47:	6a 00                	push   $0x0
  pushl $199
  102a49:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a4e:	e9 a0 02 00 00       	jmp    102cf3 <__alltraps>

00102a53 <vector200>:
.globl vector200
vector200:
  pushl $0
  102a53:	6a 00                	push   $0x0
  pushl $200
  102a55:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a5a:	e9 94 02 00 00       	jmp    102cf3 <__alltraps>

00102a5f <vector201>:
.globl vector201
vector201:
  pushl $0
  102a5f:	6a 00                	push   $0x0
  pushl $201
  102a61:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a66:	e9 88 02 00 00       	jmp    102cf3 <__alltraps>

00102a6b <vector202>:
.globl vector202
vector202:
  pushl $0
  102a6b:	6a 00                	push   $0x0
  pushl $202
  102a6d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102a72:	e9 7c 02 00 00       	jmp    102cf3 <__alltraps>

00102a77 <vector203>:
.globl vector203
vector203:
  pushl $0
  102a77:	6a 00                	push   $0x0
  pushl $203
  102a79:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102a7e:	e9 70 02 00 00       	jmp    102cf3 <__alltraps>

00102a83 <vector204>:
.globl vector204
vector204:
  pushl $0
  102a83:	6a 00                	push   $0x0
  pushl $204
  102a85:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102a8a:	e9 64 02 00 00       	jmp    102cf3 <__alltraps>

00102a8f <vector205>:
.globl vector205
vector205:
  pushl $0
  102a8f:	6a 00                	push   $0x0
  pushl $205
  102a91:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102a96:	e9 58 02 00 00       	jmp    102cf3 <__alltraps>

00102a9b <vector206>:
.globl vector206
vector206:
  pushl $0
  102a9b:	6a 00                	push   $0x0
  pushl $206
  102a9d:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102aa2:	e9 4c 02 00 00       	jmp    102cf3 <__alltraps>

00102aa7 <vector207>:
.globl vector207
vector207:
  pushl $0
  102aa7:	6a 00                	push   $0x0
  pushl $207
  102aa9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102aae:	e9 40 02 00 00       	jmp    102cf3 <__alltraps>

00102ab3 <vector208>:
.globl vector208
vector208:
  pushl $0
  102ab3:	6a 00                	push   $0x0
  pushl $208
  102ab5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102aba:	e9 34 02 00 00       	jmp    102cf3 <__alltraps>

00102abf <vector209>:
.globl vector209
vector209:
  pushl $0
  102abf:	6a 00                	push   $0x0
  pushl $209
  102ac1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102ac6:	e9 28 02 00 00       	jmp    102cf3 <__alltraps>

00102acb <vector210>:
.globl vector210
vector210:
  pushl $0
  102acb:	6a 00                	push   $0x0
  pushl $210
  102acd:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102ad2:	e9 1c 02 00 00       	jmp    102cf3 <__alltraps>

00102ad7 <vector211>:
.globl vector211
vector211:
  pushl $0
  102ad7:	6a 00                	push   $0x0
  pushl $211
  102ad9:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102ade:	e9 10 02 00 00       	jmp    102cf3 <__alltraps>

00102ae3 <vector212>:
.globl vector212
vector212:
  pushl $0
  102ae3:	6a 00                	push   $0x0
  pushl $212
  102ae5:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102aea:	e9 04 02 00 00       	jmp    102cf3 <__alltraps>

00102aef <vector213>:
.globl vector213
vector213:
  pushl $0
  102aef:	6a 00                	push   $0x0
  pushl $213
  102af1:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102af6:	e9 f8 01 00 00       	jmp    102cf3 <__alltraps>

00102afb <vector214>:
.globl vector214
vector214:
  pushl $0
  102afb:	6a 00                	push   $0x0
  pushl $214
  102afd:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102b02:	e9 ec 01 00 00       	jmp    102cf3 <__alltraps>

00102b07 <vector215>:
.globl vector215
vector215:
  pushl $0
  102b07:	6a 00                	push   $0x0
  pushl $215
  102b09:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102b0e:	e9 e0 01 00 00       	jmp    102cf3 <__alltraps>

00102b13 <vector216>:
.globl vector216
vector216:
  pushl $0
  102b13:	6a 00                	push   $0x0
  pushl $216
  102b15:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102b1a:	e9 d4 01 00 00       	jmp    102cf3 <__alltraps>

00102b1f <vector217>:
.globl vector217
vector217:
  pushl $0
  102b1f:	6a 00                	push   $0x0
  pushl $217
  102b21:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102b26:	e9 c8 01 00 00       	jmp    102cf3 <__alltraps>

00102b2b <vector218>:
.globl vector218
vector218:
  pushl $0
  102b2b:	6a 00                	push   $0x0
  pushl $218
  102b2d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b32:	e9 bc 01 00 00       	jmp    102cf3 <__alltraps>

00102b37 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b37:	6a 00                	push   $0x0
  pushl $219
  102b39:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b3e:	e9 b0 01 00 00       	jmp    102cf3 <__alltraps>

00102b43 <vector220>:
.globl vector220
vector220:
  pushl $0
  102b43:	6a 00                	push   $0x0
  pushl $220
  102b45:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b4a:	e9 a4 01 00 00       	jmp    102cf3 <__alltraps>

00102b4f <vector221>:
.globl vector221
vector221:
  pushl $0
  102b4f:	6a 00                	push   $0x0
  pushl $221
  102b51:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b56:	e9 98 01 00 00       	jmp    102cf3 <__alltraps>

00102b5b <vector222>:
.globl vector222
vector222:
  pushl $0
  102b5b:	6a 00                	push   $0x0
  pushl $222
  102b5d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b62:	e9 8c 01 00 00       	jmp    102cf3 <__alltraps>

00102b67 <vector223>:
.globl vector223
vector223:
  pushl $0
  102b67:	6a 00                	push   $0x0
  pushl $223
  102b69:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b6e:	e9 80 01 00 00       	jmp    102cf3 <__alltraps>

00102b73 <vector224>:
.globl vector224
vector224:
  pushl $0
  102b73:	6a 00                	push   $0x0
  pushl $224
  102b75:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102b7a:	e9 74 01 00 00       	jmp    102cf3 <__alltraps>

00102b7f <vector225>:
.globl vector225
vector225:
  pushl $0
  102b7f:	6a 00                	push   $0x0
  pushl $225
  102b81:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102b86:	e9 68 01 00 00       	jmp    102cf3 <__alltraps>

00102b8b <vector226>:
.globl vector226
vector226:
  pushl $0
  102b8b:	6a 00                	push   $0x0
  pushl $226
  102b8d:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102b92:	e9 5c 01 00 00       	jmp    102cf3 <__alltraps>

00102b97 <vector227>:
.globl vector227
vector227:
  pushl $0
  102b97:	6a 00                	push   $0x0
  pushl $227
  102b99:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102b9e:	e9 50 01 00 00       	jmp    102cf3 <__alltraps>

00102ba3 <vector228>:
.globl vector228
vector228:
  pushl $0
  102ba3:	6a 00                	push   $0x0
  pushl $228
  102ba5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102baa:	e9 44 01 00 00       	jmp    102cf3 <__alltraps>

00102baf <vector229>:
.globl vector229
vector229:
  pushl $0
  102baf:	6a 00                	push   $0x0
  pushl $229
  102bb1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102bb6:	e9 38 01 00 00       	jmp    102cf3 <__alltraps>

00102bbb <vector230>:
.globl vector230
vector230:
  pushl $0
  102bbb:	6a 00                	push   $0x0
  pushl $230
  102bbd:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102bc2:	e9 2c 01 00 00       	jmp    102cf3 <__alltraps>

00102bc7 <vector231>:
.globl vector231
vector231:
  pushl $0
  102bc7:	6a 00                	push   $0x0
  pushl $231
  102bc9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102bce:	e9 20 01 00 00       	jmp    102cf3 <__alltraps>

00102bd3 <vector232>:
.globl vector232
vector232:
  pushl $0
  102bd3:	6a 00                	push   $0x0
  pushl $232
  102bd5:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102bda:	e9 14 01 00 00       	jmp    102cf3 <__alltraps>

00102bdf <vector233>:
.globl vector233
vector233:
  pushl $0
  102bdf:	6a 00                	push   $0x0
  pushl $233
  102be1:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102be6:	e9 08 01 00 00       	jmp    102cf3 <__alltraps>

00102beb <vector234>:
.globl vector234
vector234:
  pushl $0
  102beb:	6a 00                	push   $0x0
  pushl $234
  102bed:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102bf2:	e9 fc 00 00 00       	jmp    102cf3 <__alltraps>

00102bf7 <vector235>:
.globl vector235
vector235:
  pushl $0
  102bf7:	6a 00                	push   $0x0
  pushl $235
  102bf9:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102bfe:	e9 f0 00 00 00       	jmp    102cf3 <__alltraps>

00102c03 <vector236>:
.globl vector236
vector236:
  pushl $0
  102c03:	6a 00                	push   $0x0
  pushl $236
  102c05:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102c0a:	e9 e4 00 00 00       	jmp    102cf3 <__alltraps>

00102c0f <vector237>:
.globl vector237
vector237:
  pushl $0
  102c0f:	6a 00                	push   $0x0
  pushl $237
  102c11:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102c16:	e9 d8 00 00 00       	jmp    102cf3 <__alltraps>

00102c1b <vector238>:
.globl vector238
vector238:
  pushl $0
  102c1b:	6a 00                	push   $0x0
  pushl $238
  102c1d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102c22:	e9 cc 00 00 00       	jmp    102cf3 <__alltraps>

00102c27 <vector239>:
.globl vector239
vector239:
  pushl $0
  102c27:	6a 00                	push   $0x0
  pushl $239
  102c29:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c2e:	e9 c0 00 00 00       	jmp    102cf3 <__alltraps>

00102c33 <vector240>:
.globl vector240
vector240:
  pushl $0
  102c33:	6a 00                	push   $0x0
  pushl $240
  102c35:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c3a:	e9 b4 00 00 00       	jmp    102cf3 <__alltraps>

00102c3f <vector241>:
.globl vector241
vector241:
  pushl $0
  102c3f:	6a 00                	push   $0x0
  pushl $241
  102c41:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c46:	e9 a8 00 00 00       	jmp    102cf3 <__alltraps>

00102c4b <vector242>:
.globl vector242
vector242:
  pushl $0
  102c4b:	6a 00                	push   $0x0
  pushl $242
  102c4d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c52:	e9 9c 00 00 00       	jmp    102cf3 <__alltraps>

00102c57 <vector243>:
.globl vector243
vector243:
  pushl $0
  102c57:	6a 00                	push   $0x0
  pushl $243
  102c59:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c5e:	e9 90 00 00 00       	jmp    102cf3 <__alltraps>

00102c63 <vector244>:
.globl vector244
vector244:
  pushl $0
  102c63:	6a 00                	push   $0x0
  pushl $244
  102c65:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c6a:	e9 84 00 00 00       	jmp    102cf3 <__alltraps>

00102c6f <vector245>:
.globl vector245
vector245:
  pushl $0
  102c6f:	6a 00                	push   $0x0
  pushl $245
  102c71:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102c76:	e9 78 00 00 00       	jmp    102cf3 <__alltraps>

00102c7b <vector246>:
.globl vector246
vector246:
  pushl $0
  102c7b:	6a 00                	push   $0x0
  pushl $246
  102c7d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102c82:	e9 6c 00 00 00       	jmp    102cf3 <__alltraps>

00102c87 <vector247>:
.globl vector247
vector247:
  pushl $0
  102c87:	6a 00                	push   $0x0
  pushl $247
  102c89:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102c8e:	e9 60 00 00 00       	jmp    102cf3 <__alltraps>

00102c93 <vector248>:
.globl vector248
vector248:
  pushl $0
  102c93:	6a 00                	push   $0x0
  pushl $248
  102c95:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102c9a:	e9 54 00 00 00       	jmp    102cf3 <__alltraps>

00102c9f <vector249>:
.globl vector249
vector249:
  pushl $0
  102c9f:	6a 00                	push   $0x0
  pushl $249
  102ca1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102ca6:	e9 48 00 00 00       	jmp    102cf3 <__alltraps>

00102cab <vector250>:
.globl vector250
vector250:
  pushl $0
  102cab:	6a 00                	push   $0x0
  pushl $250
  102cad:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102cb2:	e9 3c 00 00 00       	jmp    102cf3 <__alltraps>

00102cb7 <vector251>:
.globl vector251
vector251:
  pushl $0
  102cb7:	6a 00                	push   $0x0
  pushl $251
  102cb9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102cbe:	e9 30 00 00 00       	jmp    102cf3 <__alltraps>

00102cc3 <vector252>:
.globl vector252
vector252:
  pushl $0
  102cc3:	6a 00                	push   $0x0
  pushl $252
  102cc5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102cca:	e9 24 00 00 00       	jmp    102cf3 <__alltraps>

00102ccf <vector253>:
.globl vector253
vector253:
  pushl $0
  102ccf:	6a 00                	push   $0x0
  pushl $253
  102cd1:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102cd6:	e9 18 00 00 00       	jmp    102cf3 <__alltraps>

00102cdb <vector254>:
.globl vector254
vector254:
  pushl $0
  102cdb:	6a 00                	push   $0x0
  pushl $254
  102cdd:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102ce2:	e9 0c 00 00 00       	jmp    102cf3 <__alltraps>

00102ce7 <vector255>:
.globl vector255
vector255:
  pushl $0
  102ce7:	6a 00                	push   $0x0
  pushl $255
  102ce9:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102cee:	e9 00 00 00 00       	jmp    102cf3 <__alltraps>

00102cf3 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102cf3:	1e                   	push   %ds
    pushl %es
  102cf4:	06                   	push   %es
    pushl %fs
  102cf5:	0f a0                	push   %fs
    pushl %gs
  102cf7:	0f a8                	push   %gs
    pushal
  102cf9:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102cfa:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102cff:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102d01:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102d03:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102d04:	e8 60 f5 ff ff       	call   102269 <trap>

    # pop the pushed stack pointer
    popl %esp
  102d09:	5c                   	pop    %esp

00102d0a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102d0a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102d0b:	0f a9                	pop    %gs
    popl %fs
  102d0d:	0f a1                	pop    %fs
    popl %es
  102d0f:	07                   	pop    %es
    popl %ds
  102d10:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102d11:	83 c4 08             	add    $0x8,%esp
    iret
  102d14:	cf                   	iret   

00102d15 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d15:	55                   	push   %ebp
  102d16:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d18:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d1e:	b8 23 00 00 00       	mov    $0x23,%eax
  102d23:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d25:	b8 23 00 00 00       	mov    $0x23,%eax
  102d2a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d2c:	b8 10 00 00 00       	mov    $0x10,%eax
  102d31:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102d33:	b8 10 00 00 00       	mov    $0x10,%eax
  102d38:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102d3a:	b8 10 00 00 00       	mov    $0x10,%eax
  102d3f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102d41:	ea 48 2d 10 00 08 00 	ljmp   $0x8,$0x102d48
}
  102d48:	90                   	nop
  102d49:	5d                   	pop    %ebp
  102d4a:	c3                   	ret    

00102d4b <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102d4b:	f3 0f 1e fb          	endbr32 
  102d4f:	55                   	push   %ebp
  102d50:	89 e5                	mov    %esp,%ebp
  102d52:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102d55:	b8 80 19 11 00       	mov    $0x111980,%eax
  102d5a:	05 00 04 00 00       	add    $0x400,%eax
  102d5f:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102d64:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102d6b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102d6d:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102d74:	68 00 
  102d76:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102d7b:	0f b7 c0             	movzwl %ax,%eax
  102d7e:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102d84:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102d89:	c1 e8 10             	shr    $0x10,%eax
  102d8c:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102d91:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102d98:	24 f0                	and    $0xf0,%al
  102d9a:	0c 09                	or     $0x9,%al
  102d9c:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102da1:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102da8:	0c 10                	or     $0x10,%al
  102daa:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102daf:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102db6:	24 9f                	and    $0x9f,%al
  102db8:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102dbd:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102dc4:	0c 80                	or     $0x80,%al
  102dc6:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102dcb:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102dd2:	24 f0                	and    $0xf0,%al
  102dd4:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102dd9:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102de0:	24 ef                	and    $0xef,%al
  102de2:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102de7:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102dee:	24 df                	and    $0xdf,%al
  102df0:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102df5:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102dfc:	0c 40                	or     $0x40,%al
  102dfe:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e03:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e0a:	24 7f                	and    $0x7f,%al
  102e0c:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e11:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102e16:	c1 e8 18             	shr    $0x18,%eax
  102e19:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102e1e:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e25:	24 ef                	and    $0xef,%al
  102e27:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102e2c:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102e33:	e8 dd fe ff ff       	call   102d15 <lgdt>
  102e38:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102e3e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102e42:	0f 00 d8             	ltr    %ax
}
  102e45:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102e46:	90                   	nop
  102e47:	c9                   	leave  
  102e48:	c3                   	ret    

00102e49 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102e49:	f3 0f 1e fb          	endbr32 
  102e4d:	55                   	push   %ebp
  102e4e:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102e50:	e8 f6 fe ff ff       	call   102d4b <gdt_init>
}
  102e55:	90                   	nop
  102e56:	5d                   	pop    %ebp
  102e57:	c3                   	ret    

00102e58 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102e58:	f3 0f 1e fb          	endbr32 
  102e5c:	55                   	push   %ebp
  102e5d:	89 e5                	mov    %esp,%ebp
  102e5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102e69:	eb 03                	jmp    102e6e <strlen+0x16>
        cnt ++;
  102e6b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e71:	8d 50 01             	lea    0x1(%eax),%edx
  102e74:	89 55 08             	mov    %edx,0x8(%ebp)
  102e77:	0f b6 00             	movzbl (%eax),%eax
  102e7a:	84 c0                	test   %al,%al
  102e7c:	75 ed                	jne    102e6b <strlen+0x13>
    }
    return cnt;
  102e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e81:	c9                   	leave  
  102e82:	c3                   	ret    

00102e83 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102e83:	f3 0f 1e fb          	endbr32 
  102e87:	55                   	push   %ebp
  102e88:	89 e5                	mov    %esp,%ebp
  102e8a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e94:	eb 03                	jmp    102e99 <strnlen+0x16>
        cnt ++;
  102e96:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e9c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102e9f:	73 10                	jae    102eb1 <strnlen+0x2e>
  102ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea4:	8d 50 01             	lea    0x1(%eax),%edx
  102ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  102eaa:	0f b6 00             	movzbl (%eax),%eax
  102ead:	84 c0                	test   %al,%al
  102eaf:	75 e5                	jne    102e96 <strnlen+0x13>
    }
    return cnt;
  102eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102eb4:	c9                   	leave  
  102eb5:	c3                   	ret    

00102eb6 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102eb6:	f3 0f 1e fb          	endbr32 
  102eba:	55                   	push   %ebp
  102ebb:	89 e5                	mov    %esp,%ebp
  102ebd:	57                   	push   %edi
  102ebe:	56                   	push   %esi
  102ebf:	83 ec 20             	sub    $0x20,%esp
  102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed4:	89 d1                	mov    %edx,%ecx
  102ed6:	89 c2                	mov    %eax,%edx
  102ed8:	89 ce                	mov    %ecx,%esi
  102eda:	89 d7                	mov    %edx,%edi
  102edc:	ac                   	lods   %ds:(%esi),%al
  102edd:	aa                   	stos   %al,%es:(%edi)
  102ede:	84 c0                	test   %al,%al
  102ee0:	75 fa                	jne    102edc <strcpy+0x26>
  102ee2:	89 fa                	mov    %edi,%edx
  102ee4:	89 f1                	mov    %esi,%ecx
  102ee6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ee9:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102eec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102ef2:	83 c4 20             	add    $0x20,%esp
  102ef5:	5e                   	pop    %esi
  102ef6:	5f                   	pop    %edi
  102ef7:	5d                   	pop    %ebp
  102ef8:	c3                   	ret    

00102ef9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102ef9:	f3 0f 1e fb          	endbr32 
  102efd:	55                   	push   %ebp
  102efe:	89 e5                	mov    %esp,%ebp
  102f00:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102f09:	eb 1e                	jmp    102f29 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0e:	0f b6 10             	movzbl (%eax),%edx
  102f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f14:	88 10                	mov    %dl,(%eax)
  102f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f19:	0f b6 00             	movzbl (%eax),%eax
  102f1c:	84 c0                	test   %al,%al
  102f1e:	74 03                	je     102f23 <strncpy+0x2a>
            src ++;
  102f20:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102f23:	ff 45 fc             	incl   -0x4(%ebp)
  102f26:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f2d:	75 dc                	jne    102f0b <strncpy+0x12>
    }
    return dst;
  102f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f32:	c9                   	leave  
  102f33:	c3                   	ret    

00102f34 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102f34:	f3 0f 1e fb          	endbr32 
  102f38:	55                   	push   %ebp
  102f39:	89 e5                	mov    %esp,%ebp
  102f3b:	57                   	push   %edi
  102f3c:	56                   	push   %esi
  102f3d:	83 ec 20             	sub    $0x20,%esp
  102f40:	8b 45 08             	mov    0x8(%ebp),%eax
  102f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f52:	89 d1                	mov    %edx,%ecx
  102f54:	89 c2                	mov    %eax,%edx
  102f56:	89 ce                	mov    %ecx,%esi
  102f58:	89 d7                	mov    %edx,%edi
  102f5a:	ac                   	lods   %ds:(%esi),%al
  102f5b:	ae                   	scas   %es:(%edi),%al
  102f5c:	75 08                	jne    102f66 <strcmp+0x32>
  102f5e:	84 c0                	test   %al,%al
  102f60:	75 f8                	jne    102f5a <strcmp+0x26>
  102f62:	31 c0                	xor    %eax,%eax
  102f64:	eb 04                	jmp    102f6a <strcmp+0x36>
  102f66:	19 c0                	sbb    %eax,%eax
  102f68:	0c 01                	or     $0x1,%al
  102f6a:	89 fa                	mov    %edi,%edx
  102f6c:	89 f1                	mov    %esi,%ecx
  102f6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f71:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f74:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102f7a:	83 c4 20             	add    $0x20,%esp
  102f7d:	5e                   	pop    %esi
  102f7e:	5f                   	pop    %edi
  102f7f:	5d                   	pop    %ebp
  102f80:	c3                   	ret    

00102f81 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102f81:	f3 0f 1e fb          	endbr32 
  102f85:	55                   	push   %ebp
  102f86:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f88:	eb 09                	jmp    102f93 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102f8a:	ff 4d 10             	decl   0x10(%ebp)
  102f8d:	ff 45 08             	incl   0x8(%ebp)
  102f90:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f97:	74 1a                	je     102fb3 <strncmp+0x32>
  102f99:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9c:	0f b6 00             	movzbl (%eax),%eax
  102f9f:	84 c0                	test   %al,%al
  102fa1:	74 10                	je     102fb3 <strncmp+0x32>
  102fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa6:	0f b6 10             	movzbl (%eax),%edx
  102fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fac:	0f b6 00             	movzbl (%eax),%eax
  102faf:	38 c2                	cmp    %al,%dl
  102fb1:	74 d7                	je     102f8a <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fb7:	74 18                	je     102fd1 <strncmp+0x50>
  102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbc:	0f b6 00             	movzbl (%eax),%eax
  102fbf:	0f b6 d0             	movzbl %al,%edx
  102fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc5:	0f b6 00             	movzbl (%eax),%eax
  102fc8:	0f b6 c0             	movzbl %al,%eax
  102fcb:	29 c2                	sub    %eax,%edx
  102fcd:	89 d0                	mov    %edx,%eax
  102fcf:	eb 05                	jmp    102fd6 <strncmp+0x55>
  102fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fd6:	5d                   	pop    %ebp
  102fd7:	c3                   	ret    

00102fd8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102fd8:	f3 0f 1e fb          	endbr32 
  102fdc:	55                   	push   %ebp
  102fdd:	89 e5                	mov    %esp,%ebp
  102fdf:	83 ec 04             	sub    $0x4,%esp
  102fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102fe8:	eb 13                	jmp    102ffd <strchr+0x25>
        if (*s == c) {
  102fea:	8b 45 08             	mov    0x8(%ebp),%eax
  102fed:	0f b6 00             	movzbl (%eax),%eax
  102ff0:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102ff3:	75 05                	jne    102ffa <strchr+0x22>
            return (char *)s;
  102ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff8:	eb 12                	jmp    10300c <strchr+0x34>
        }
        s ++;
  102ffa:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  103000:	0f b6 00             	movzbl (%eax),%eax
  103003:	84 c0                	test   %al,%al
  103005:	75 e3                	jne    102fea <strchr+0x12>
    }
    return NULL;
  103007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10300c:	c9                   	leave  
  10300d:	c3                   	ret    

0010300e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10300e:	f3 0f 1e fb          	endbr32 
  103012:	55                   	push   %ebp
  103013:	89 e5                	mov    %esp,%ebp
  103015:	83 ec 04             	sub    $0x4,%esp
  103018:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10301e:	eb 0e                	jmp    10302e <strfind+0x20>
        if (*s == c) {
  103020:	8b 45 08             	mov    0x8(%ebp),%eax
  103023:	0f b6 00             	movzbl (%eax),%eax
  103026:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103029:	74 0f                	je     10303a <strfind+0x2c>
            break;
        }
        s ++;
  10302b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10302e:	8b 45 08             	mov    0x8(%ebp),%eax
  103031:	0f b6 00             	movzbl (%eax),%eax
  103034:	84 c0                	test   %al,%al
  103036:	75 e8                	jne    103020 <strfind+0x12>
  103038:	eb 01                	jmp    10303b <strfind+0x2d>
            break;
  10303a:	90                   	nop
    }
    return (char *)s;
  10303b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10303e:	c9                   	leave  
  10303f:	c3                   	ret    

00103040 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103040:	f3 0f 1e fb          	endbr32 
  103044:	55                   	push   %ebp
  103045:	89 e5                	mov    %esp,%ebp
  103047:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10304a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103051:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103058:	eb 03                	jmp    10305d <strtol+0x1d>
        s ++;
  10305a:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10305d:	8b 45 08             	mov    0x8(%ebp),%eax
  103060:	0f b6 00             	movzbl (%eax),%eax
  103063:	3c 20                	cmp    $0x20,%al
  103065:	74 f3                	je     10305a <strtol+0x1a>
  103067:	8b 45 08             	mov    0x8(%ebp),%eax
  10306a:	0f b6 00             	movzbl (%eax),%eax
  10306d:	3c 09                	cmp    $0x9,%al
  10306f:	74 e9                	je     10305a <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  103071:	8b 45 08             	mov    0x8(%ebp),%eax
  103074:	0f b6 00             	movzbl (%eax),%eax
  103077:	3c 2b                	cmp    $0x2b,%al
  103079:	75 05                	jne    103080 <strtol+0x40>
        s ++;
  10307b:	ff 45 08             	incl   0x8(%ebp)
  10307e:	eb 14                	jmp    103094 <strtol+0x54>
    }
    else if (*s == '-') {
  103080:	8b 45 08             	mov    0x8(%ebp),%eax
  103083:	0f b6 00             	movzbl (%eax),%eax
  103086:	3c 2d                	cmp    $0x2d,%al
  103088:	75 0a                	jne    103094 <strtol+0x54>
        s ++, neg = 1;
  10308a:	ff 45 08             	incl   0x8(%ebp)
  10308d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103098:	74 06                	je     1030a0 <strtol+0x60>
  10309a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10309e:	75 22                	jne    1030c2 <strtol+0x82>
  1030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a3:	0f b6 00             	movzbl (%eax),%eax
  1030a6:	3c 30                	cmp    $0x30,%al
  1030a8:	75 18                	jne    1030c2 <strtol+0x82>
  1030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ad:	40                   	inc    %eax
  1030ae:	0f b6 00             	movzbl (%eax),%eax
  1030b1:	3c 78                	cmp    $0x78,%al
  1030b3:	75 0d                	jne    1030c2 <strtol+0x82>
        s += 2, base = 16;
  1030b5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1030b9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1030c0:	eb 29                	jmp    1030eb <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  1030c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c6:	75 16                	jne    1030de <strtol+0x9e>
  1030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030cb:	0f b6 00             	movzbl (%eax),%eax
  1030ce:	3c 30                	cmp    $0x30,%al
  1030d0:	75 0c                	jne    1030de <strtol+0x9e>
        s ++, base = 8;
  1030d2:	ff 45 08             	incl   0x8(%ebp)
  1030d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1030dc:	eb 0d                	jmp    1030eb <strtol+0xab>
    }
    else if (base == 0) {
  1030de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030e2:	75 07                	jne    1030eb <strtol+0xab>
        base = 10;
  1030e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	0f b6 00             	movzbl (%eax),%eax
  1030f1:	3c 2f                	cmp    $0x2f,%al
  1030f3:	7e 1b                	jle    103110 <strtol+0xd0>
  1030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f8:	0f b6 00             	movzbl (%eax),%eax
  1030fb:	3c 39                	cmp    $0x39,%al
  1030fd:	7f 11                	jg     103110 <strtol+0xd0>
            dig = *s - '0';
  1030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103102:	0f b6 00             	movzbl (%eax),%eax
  103105:	0f be c0             	movsbl %al,%eax
  103108:	83 e8 30             	sub    $0x30,%eax
  10310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10310e:	eb 48                	jmp    103158 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103110:	8b 45 08             	mov    0x8(%ebp),%eax
  103113:	0f b6 00             	movzbl (%eax),%eax
  103116:	3c 60                	cmp    $0x60,%al
  103118:	7e 1b                	jle    103135 <strtol+0xf5>
  10311a:	8b 45 08             	mov    0x8(%ebp),%eax
  10311d:	0f b6 00             	movzbl (%eax),%eax
  103120:	3c 7a                	cmp    $0x7a,%al
  103122:	7f 11                	jg     103135 <strtol+0xf5>
            dig = *s - 'a' + 10;
  103124:	8b 45 08             	mov    0x8(%ebp),%eax
  103127:	0f b6 00             	movzbl (%eax),%eax
  10312a:	0f be c0             	movsbl %al,%eax
  10312d:	83 e8 57             	sub    $0x57,%eax
  103130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103133:	eb 23                	jmp    103158 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103135:	8b 45 08             	mov    0x8(%ebp),%eax
  103138:	0f b6 00             	movzbl (%eax),%eax
  10313b:	3c 40                	cmp    $0x40,%al
  10313d:	7e 3b                	jle    10317a <strtol+0x13a>
  10313f:	8b 45 08             	mov    0x8(%ebp),%eax
  103142:	0f b6 00             	movzbl (%eax),%eax
  103145:	3c 5a                	cmp    $0x5a,%al
  103147:	7f 31                	jg     10317a <strtol+0x13a>
            dig = *s - 'A' + 10;
  103149:	8b 45 08             	mov    0x8(%ebp),%eax
  10314c:	0f b6 00             	movzbl (%eax),%eax
  10314f:	0f be c0             	movsbl %al,%eax
  103152:	83 e8 37             	sub    $0x37,%eax
  103155:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10315b:	3b 45 10             	cmp    0x10(%ebp),%eax
  10315e:	7d 19                	jge    103179 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  103160:	ff 45 08             	incl   0x8(%ebp)
  103163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103166:	0f af 45 10          	imul   0x10(%ebp),%eax
  10316a:	89 c2                	mov    %eax,%edx
  10316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10316f:	01 d0                	add    %edx,%eax
  103171:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103174:	e9 72 ff ff ff       	jmp    1030eb <strtol+0xab>
            break;
  103179:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10317a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10317e:	74 08                	je     103188 <strtol+0x148>
        *endptr = (char *) s;
  103180:	8b 45 0c             	mov    0xc(%ebp),%eax
  103183:	8b 55 08             	mov    0x8(%ebp),%edx
  103186:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103188:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10318c:	74 07                	je     103195 <strtol+0x155>
  10318e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103191:	f7 d8                	neg    %eax
  103193:	eb 03                	jmp    103198 <strtol+0x158>
  103195:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103198:	c9                   	leave  
  103199:	c3                   	ret    

0010319a <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10319a:	f3 0f 1e fb          	endbr32 
  10319e:	55                   	push   %ebp
  10319f:	89 e5                	mov    %esp,%ebp
  1031a1:	57                   	push   %edi
  1031a2:	83 ec 24             	sub    $0x24,%esp
  1031a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1031ab:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1031af:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1031b5:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1031b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1031bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1031be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1031c1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1031c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1031c8:	89 d7                	mov    %edx,%edi
  1031ca:	f3 aa                	rep stos %al,%es:(%edi)
  1031cc:	89 fa                	mov    %edi,%edx
  1031ce:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031d1:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1031d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1031d7:	83 c4 24             	add    $0x24,%esp
  1031da:	5f                   	pop    %edi
  1031db:	5d                   	pop    %ebp
  1031dc:	c3                   	ret    

001031dd <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1031dd:	f3 0f 1e fb          	endbr32 
  1031e1:	55                   	push   %ebp
  1031e2:	89 e5                	mov    %esp,%ebp
  1031e4:	57                   	push   %edi
  1031e5:	56                   	push   %esi
  1031e6:	53                   	push   %ebx
  1031e7:	83 ec 30             	sub    $0x30,%esp
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1031f9:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1031fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103202:	73 42                	jae    103246 <memmove+0x69>
  103204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10320a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10320d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103213:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103216:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103219:	c1 e8 02             	shr    $0x2,%eax
  10321c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10321e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103224:	89 d7                	mov    %edx,%edi
  103226:	89 c6                	mov    %eax,%esi
  103228:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10322a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10322d:	83 e1 03             	and    $0x3,%ecx
  103230:	74 02                	je     103234 <memmove+0x57>
  103232:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103234:	89 f0                	mov    %esi,%eax
  103236:	89 fa                	mov    %edi,%edx
  103238:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10323b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10323e:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103244:	eb 36                	jmp    10327c <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103249:	8d 50 ff             	lea    -0x1(%eax),%edx
  10324c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10324f:	01 c2                	add    %eax,%edx
  103251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103254:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10325a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103260:	89 c1                	mov    %eax,%ecx
  103262:	89 d8                	mov    %ebx,%eax
  103264:	89 d6                	mov    %edx,%esi
  103266:	89 c7                	mov    %eax,%edi
  103268:	fd                   	std    
  103269:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10326b:	fc                   	cld    
  10326c:	89 f8                	mov    %edi,%eax
  10326e:	89 f2                	mov    %esi,%edx
  103270:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103273:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103276:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103279:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10327c:	83 c4 30             	add    $0x30,%esp
  10327f:	5b                   	pop    %ebx
  103280:	5e                   	pop    %esi
  103281:	5f                   	pop    %edi
  103282:	5d                   	pop    %ebp
  103283:	c3                   	ret    

00103284 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103284:	f3 0f 1e fb          	endbr32 
  103288:	55                   	push   %ebp
  103289:	89 e5                	mov    %esp,%ebp
  10328b:	57                   	push   %edi
  10328c:	56                   	push   %esi
  10328d:	83 ec 20             	sub    $0x20,%esp
  103290:	8b 45 08             	mov    0x8(%ebp),%eax
  103293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103296:	8b 45 0c             	mov    0xc(%ebp),%eax
  103299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10329c:	8b 45 10             	mov    0x10(%ebp),%eax
  10329f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1032a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032a5:	c1 e8 02             	shr    $0x2,%eax
  1032a8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1032aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b0:	89 d7                	mov    %edx,%edi
  1032b2:	89 c6                	mov    %eax,%esi
  1032b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1032b6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1032b9:	83 e1 03             	and    $0x3,%ecx
  1032bc:	74 02                	je     1032c0 <memcpy+0x3c>
  1032be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1032c0:	89 f0                	mov    %esi,%eax
  1032c2:	89 fa                	mov    %edi,%edx
  1032c4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1032ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1032d0:	83 c4 20             	add    $0x20,%esp
  1032d3:	5e                   	pop    %esi
  1032d4:	5f                   	pop    %edi
  1032d5:	5d                   	pop    %ebp
  1032d6:	c3                   	ret    

001032d7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1032d7:	f3 0f 1e fb          	endbr32 
  1032db:	55                   	push   %ebp
  1032dc:	89 e5                	mov    %esp,%ebp
  1032de:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1032ed:	eb 2e                	jmp    10331d <memcmp+0x46>
        if (*s1 != *s2) {
  1032ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032f2:	0f b6 10             	movzbl (%eax),%edx
  1032f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032f8:	0f b6 00             	movzbl (%eax),%eax
  1032fb:	38 c2                	cmp    %al,%dl
  1032fd:	74 18                	je     103317 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103302:	0f b6 00             	movzbl (%eax),%eax
  103305:	0f b6 d0             	movzbl %al,%edx
  103308:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10330b:	0f b6 00             	movzbl (%eax),%eax
  10330e:	0f b6 c0             	movzbl %al,%eax
  103311:	29 c2                	sub    %eax,%edx
  103313:	89 d0                	mov    %edx,%eax
  103315:	eb 18                	jmp    10332f <memcmp+0x58>
        }
        s1 ++, s2 ++;
  103317:	ff 45 fc             	incl   -0x4(%ebp)
  10331a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10331d:	8b 45 10             	mov    0x10(%ebp),%eax
  103320:	8d 50 ff             	lea    -0x1(%eax),%edx
  103323:	89 55 10             	mov    %edx,0x10(%ebp)
  103326:	85 c0                	test   %eax,%eax
  103328:	75 c5                	jne    1032ef <memcmp+0x18>
    }
    return 0;
  10332a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10332f:	c9                   	leave  
  103330:	c3                   	ret    

00103331 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103331:	f3 0f 1e fb          	endbr32 
  103335:	55                   	push   %ebp
  103336:	89 e5                	mov    %esp,%ebp
  103338:	83 ec 58             	sub    $0x58,%esp
  10333b:	8b 45 10             	mov    0x10(%ebp),%eax
  10333e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103341:	8b 45 14             	mov    0x14(%ebp),%eax
  103344:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103347:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10334a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10334d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103350:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103353:	8b 45 18             	mov    0x18(%ebp),%eax
  103356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10335c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10335f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103362:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10336b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10336f:	74 1c                	je     10338d <printnum+0x5c>
  103371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103374:	ba 00 00 00 00       	mov    $0x0,%edx
  103379:	f7 75 e4             	divl   -0x1c(%ebp)
  10337c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103382:	ba 00 00 00 00       	mov    $0x0,%edx
  103387:	f7 75 e4             	divl   -0x1c(%ebp)
  10338a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103393:	f7 75 e4             	divl   -0x1c(%ebp)
  103396:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103399:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10339c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10339f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1033a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1033a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033ab:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1033ae:	8b 45 18             	mov    0x18(%ebp),%eax
  1033b1:	ba 00 00 00 00       	mov    $0x0,%edx
  1033b6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1033b9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1033bc:	19 d1                	sbb    %edx,%ecx
  1033be:	72 4c                	jb     10340c <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  1033c0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1033c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033c6:	8b 45 20             	mov    0x20(%ebp),%eax
  1033c9:	89 44 24 18          	mov    %eax,0x18(%esp)
  1033cd:	89 54 24 14          	mov    %edx,0x14(%esp)
  1033d1:	8b 45 18             	mov    0x18(%ebp),%eax
  1033d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  1033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1033de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033e2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1033e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f0:	89 04 24             	mov    %eax,(%esp)
  1033f3:	e8 39 ff ff ff       	call   103331 <printnum>
  1033f8:	eb 1b                	jmp    103415 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1033fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103401:	8b 45 20             	mov    0x20(%ebp),%eax
  103404:	89 04 24             	mov    %eax,(%esp)
  103407:	8b 45 08             	mov    0x8(%ebp),%eax
  10340a:	ff d0                	call   *%eax
        while (-- width > 0)
  10340c:	ff 4d 1c             	decl   0x1c(%ebp)
  10340f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103413:	7f e5                	jg     1033fa <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103415:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103418:	05 70 41 10 00       	add    $0x104170,%eax
  10341d:	0f b6 00             	movzbl (%eax),%eax
  103420:	0f be c0             	movsbl %al,%eax
  103423:	8b 55 0c             	mov    0xc(%ebp),%edx
  103426:	89 54 24 04          	mov    %edx,0x4(%esp)
  10342a:	89 04 24             	mov    %eax,(%esp)
  10342d:	8b 45 08             	mov    0x8(%ebp),%eax
  103430:	ff d0                	call   *%eax
}
  103432:	90                   	nop
  103433:	c9                   	leave  
  103434:	c3                   	ret    

00103435 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103435:	f3 0f 1e fb          	endbr32 
  103439:	55                   	push   %ebp
  10343a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10343c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103440:	7e 14                	jle    103456 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  103442:	8b 45 08             	mov    0x8(%ebp),%eax
  103445:	8b 00                	mov    (%eax),%eax
  103447:	8d 48 08             	lea    0x8(%eax),%ecx
  10344a:	8b 55 08             	mov    0x8(%ebp),%edx
  10344d:	89 0a                	mov    %ecx,(%edx)
  10344f:	8b 50 04             	mov    0x4(%eax),%edx
  103452:	8b 00                	mov    (%eax),%eax
  103454:	eb 30                	jmp    103486 <getuint+0x51>
    }
    else if (lflag) {
  103456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10345a:	74 16                	je     103472 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  10345c:	8b 45 08             	mov    0x8(%ebp),%eax
  10345f:	8b 00                	mov    (%eax),%eax
  103461:	8d 48 04             	lea    0x4(%eax),%ecx
  103464:	8b 55 08             	mov    0x8(%ebp),%edx
  103467:	89 0a                	mov    %ecx,(%edx)
  103469:	8b 00                	mov    (%eax),%eax
  10346b:	ba 00 00 00 00       	mov    $0x0,%edx
  103470:	eb 14                	jmp    103486 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  103472:	8b 45 08             	mov    0x8(%ebp),%eax
  103475:	8b 00                	mov    (%eax),%eax
  103477:	8d 48 04             	lea    0x4(%eax),%ecx
  10347a:	8b 55 08             	mov    0x8(%ebp),%edx
  10347d:	89 0a                	mov    %ecx,(%edx)
  10347f:	8b 00                	mov    (%eax),%eax
  103481:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103486:	5d                   	pop    %ebp
  103487:	c3                   	ret    

00103488 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103488:	f3 0f 1e fb          	endbr32 
  10348c:	55                   	push   %ebp
  10348d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10348f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103493:	7e 14                	jle    1034a9 <getint+0x21>
        return va_arg(*ap, long long);
  103495:	8b 45 08             	mov    0x8(%ebp),%eax
  103498:	8b 00                	mov    (%eax),%eax
  10349a:	8d 48 08             	lea    0x8(%eax),%ecx
  10349d:	8b 55 08             	mov    0x8(%ebp),%edx
  1034a0:	89 0a                	mov    %ecx,(%edx)
  1034a2:	8b 50 04             	mov    0x4(%eax),%edx
  1034a5:	8b 00                	mov    (%eax),%eax
  1034a7:	eb 28                	jmp    1034d1 <getint+0x49>
    }
    else if (lflag) {
  1034a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034ad:	74 12                	je     1034c1 <getint+0x39>
        return va_arg(*ap, long);
  1034af:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b2:	8b 00                	mov    (%eax),%eax
  1034b4:	8d 48 04             	lea    0x4(%eax),%ecx
  1034b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1034ba:	89 0a                	mov    %ecx,(%edx)
  1034bc:	8b 00                	mov    (%eax),%eax
  1034be:	99                   	cltd   
  1034bf:	eb 10                	jmp    1034d1 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  1034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c4:	8b 00                	mov    (%eax),%eax
  1034c6:	8d 48 04             	lea    0x4(%eax),%ecx
  1034c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1034cc:	89 0a                	mov    %ecx,(%edx)
  1034ce:	8b 00                	mov    (%eax),%eax
  1034d0:	99                   	cltd   
    }
}
  1034d1:	5d                   	pop    %ebp
  1034d2:	c3                   	ret    

001034d3 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1034d3:	f3 0f 1e fb          	endbr32 
  1034d7:	55                   	push   %ebp
  1034d8:	89 e5                	mov    %esp,%ebp
  1034da:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1034dd:	8d 45 14             	lea    0x14(%ebp),%eax
  1034e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034ea:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fb:	89 04 24             	mov    %eax,(%esp)
  1034fe:	e8 03 00 00 00       	call   103506 <vprintfmt>
    va_end(ap);
}
  103503:	90                   	nop
  103504:	c9                   	leave  
  103505:	c3                   	ret    

00103506 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103506:	f3 0f 1e fb          	endbr32 
  10350a:	55                   	push   %ebp
  10350b:	89 e5                	mov    %esp,%ebp
  10350d:	56                   	push   %esi
  10350e:	53                   	push   %ebx
  10350f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103512:	eb 17                	jmp    10352b <vprintfmt+0x25>
            if (ch == '\0') {
  103514:	85 db                	test   %ebx,%ebx
  103516:	0f 84 c0 03 00 00    	je     1038dc <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10351c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103523:	89 1c 24             	mov    %ebx,(%esp)
  103526:	8b 45 08             	mov    0x8(%ebp),%eax
  103529:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10352b:	8b 45 10             	mov    0x10(%ebp),%eax
  10352e:	8d 50 01             	lea    0x1(%eax),%edx
  103531:	89 55 10             	mov    %edx,0x10(%ebp)
  103534:	0f b6 00             	movzbl (%eax),%eax
  103537:	0f b6 d8             	movzbl %al,%ebx
  10353a:	83 fb 25             	cmp    $0x25,%ebx
  10353d:	75 d5                	jne    103514 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10353f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103543:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10354a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10354d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103550:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10355a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10355d:	8b 45 10             	mov    0x10(%ebp),%eax
  103560:	8d 50 01             	lea    0x1(%eax),%edx
  103563:	89 55 10             	mov    %edx,0x10(%ebp)
  103566:	0f b6 00             	movzbl (%eax),%eax
  103569:	0f b6 d8             	movzbl %al,%ebx
  10356c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10356f:	83 f8 55             	cmp    $0x55,%eax
  103572:	0f 87 38 03 00 00    	ja     1038b0 <vprintfmt+0x3aa>
  103578:	8b 04 85 94 41 10 00 	mov    0x104194(,%eax,4),%eax
  10357f:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103582:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103586:	eb d5                	jmp    10355d <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103588:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10358c:	eb cf                	jmp    10355d <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10358e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103595:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103598:	89 d0                	mov    %edx,%eax
  10359a:	c1 e0 02             	shl    $0x2,%eax
  10359d:	01 d0                	add    %edx,%eax
  10359f:	01 c0                	add    %eax,%eax
  1035a1:	01 d8                	add    %ebx,%eax
  1035a3:	83 e8 30             	sub    $0x30,%eax
  1035a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1035a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1035ac:	0f b6 00             	movzbl (%eax),%eax
  1035af:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1035b2:	83 fb 2f             	cmp    $0x2f,%ebx
  1035b5:	7e 38                	jle    1035ef <vprintfmt+0xe9>
  1035b7:	83 fb 39             	cmp    $0x39,%ebx
  1035ba:	7f 33                	jg     1035ef <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1035bc:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1035bf:	eb d4                	jmp    103595 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1035c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1035c4:	8d 50 04             	lea    0x4(%eax),%edx
  1035c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1035ca:	8b 00                	mov    (%eax),%eax
  1035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1035cf:	eb 1f                	jmp    1035f0 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1035d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035d5:	79 86                	jns    10355d <vprintfmt+0x57>
                width = 0;
  1035d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1035de:	e9 7a ff ff ff       	jmp    10355d <vprintfmt+0x57>

        case '#':
            altflag = 1;
  1035e3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1035ea:	e9 6e ff ff ff       	jmp    10355d <vprintfmt+0x57>
            goto process_precision;
  1035ef:	90                   	nop

        process_precision:
            if (width < 0)
  1035f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035f4:	0f 89 63 ff ff ff    	jns    10355d <vprintfmt+0x57>
                width = precision, precision = -1;
  1035fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103600:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103607:	e9 51 ff ff ff       	jmp    10355d <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10360c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10360f:	e9 49 ff ff ff       	jmp    10355d <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103614:	8b 45 14             	mov    0x14(%ebp),%eax
  103617:	8d 50 04             	lea    0x4(%eax),%edx
  10361a:	89 55 14             	mov    %edx,0x14(%ebp)
  10361d:	8b 00                	mov    (%eax),%eax
  10361f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103622:	89 54 24 04          	mov    %edx,0x4(%esp)
  103626:	89 04 24             	mov    %eax,(%esp)
  103629:	8b 45 08             	mov    0x8(%ebp),%eax
  10362c:	ff d0                	call   *%eax
            break;
  10362e:	e9 a4 02 00 00       	jmp    1038d7 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103633:	8b 45 14             	mov    0x14(%ebp),%eax
  103636:	8d 50 04             	lea    0x4(%eax),%edx
  103639:	89 55 14             	mov    %edx,0x14(%ebp)
  10363c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10363e:	85 db                	test   %ebx,%ebx
  103640:	79 02                	jns    103644 <vprintfmt+0x13e>
                err = -err;
  103642:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103644:	83 fb 06             	cmp    $0x6,%ebx
  103647:	7f 0b                	jg     103654 <vprintfmt+0x14e>
  103649:	8b 34 9d 54 41 10 00 	mov    0x104154(,%ebx,4),%esi
  103650:	85 f6                	test   %esi,%esi
  103652:	75 23                	jne    103677 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  103654:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103658:	c7 44 24 08 81 41 10 	movl   $0x104181,0x8(%esp)
  10365f:	00 
  103660:	8b 45 0c             	mov    0xc(%ebp),%eax
  103663:	89 44 24 04          	mov    %eax,0x4(%esp)
  103667:	8b 45 08             	mov    0x8(%ebp),%eax
  10366a:	89 04 24             	mov    %eax,(%esp)
  10366d:	e8 61 fe ff ff       	call   1034d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103672:	e9 60 02 00 00       	jmp    1038d7 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  103677:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10367b:	c7 44 24 08 8a 41 10 	movl   $0x10418a,0x8(%esp)
  103682:	00 
  103683:	8b 45 0c             	mov    0xc(%ebp),%eax
  103686:	89 44 24 04          	mov    %eax,0x4(%esp)
  10368a:	8b 45 08             	mov    0x8(%ebp),%eax
  10368d:	89 04 24             	mov    %eax,(%esp)
  103690:	e8 3e fe ff ff       	call   1034d3 <printfmt>
            break;
  103695:	e9 3d 02 00 00       	jmp    1038d7 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10369a:	8b 45 14             	mov    0x14(%ebp),%eax
  10369d:	8d 50 04             	lea    0x4(%eax),%edx
  1036a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1036a3:	8b 30                	mov    (%eax),%esi
  1036a5:	85 f6                	test   %esi,%esi
  1036a7:	75 05                	jne    1036ae <vprintfmt+0x1a8>
                p = "(null)";
  1036a9:	be 8d 41 10 00       	mov    $0x10418d,%esi
            }
            if (width > 0 && padc != '-') {
  1036ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036b2:	7e 76                	jle    10372a <vprintfmt+0x224>
  1036b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1036b8:	74 70                	je     10372a <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1036ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036c1:	89 34 24             	mov    %esi,(%esp)
  1036c4:	e8 ba f7 ff ff       	call   102e83 <strnlen>
  1036c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1036cc:	29 c2                	sub    %eax,%edx
  1036ce:	89 d0                	mov    %edx,%eax
  1036d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1036d3:	eb 16                	jmp    1036eb <vprintfmt+0x1e5>
                    putch(padc, putdat);
  1036d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1036d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1036e0:	89 04 24             	mov    %eax,(%esp)
  1036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e6:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1036e8:	ff 4d e8             	decl   -0x18(%ebp)
  1036eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036ef:	7f e4                	jg     1036d5 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1036f1:	eb 37                	jmp    10372a <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1036f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1036f7:	74 1f                	je     103718 <vprintfmt+0x212>
  1036f9:	83 fb 1f             	cmp    $0x1f,%ebx
  1036fc:	7e 05                	jle    103703 <vprintfmt+0x1fd>
  1036fe:	83 fb 7e             	cmp    $0x7e,%ebx
  103701:	7e 15                	jle    103718 <vprintfmt+0x212>
                    putch('?', putdat);
  103703:	8b 45 0c             	mov    0xc(%ebp),%eax
  103706:	89 44 24 04          	mov    %eax,0x4(%esp)
  10370a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103711:	8b 45 08             	mov    0x8(%ebp),%eax
  103714:	ff d0                	call   *%eax
  103716:	eb 0f                	jmp    103727 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  103718:	8b 45 0c             	mov    0xc(%ebp),%eax
  10371b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10371f:	89 1c 24             	mov    %ebx,(%esp)
  103722:	8b 45 08             	mov    0x8(%ebp),%eax
  103725:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103727:	ff 4d e8             	decl   -0x18(%ebp)
  10372a:	89 f0                	mov    %esi,%eax
  10372c:	8d 70 01             	lea    0x1(%eax),%esi
  10372f:	0f b6 00             	movzbl (%eax),%eax
  103732:	0f be d8             	movsbl %al,%ebx
  103735:	85 db                	test   %ebx,%ebx
  103737:	74 27                	je     103760 <vprintfmt+0x25a>
  103739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10373d:	78 b4                	js     1036f3 <vprintfmt+0x1ed>
  10373f:	ff 4d e4             	decl   -0x1c(%ebp)
  103742:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103746:	79 ab                	jns    1036f3 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  103748:	eb 16                	jmp    103760 <vprintfmt+0x25a>
                putch(' ', putdat);
  10374a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10374d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103751:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103758:	8b 45 08             	mov    0x8(%ebp),%eax
  10375b:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10375d:	ff 4d e8             	decl   -0x18(%ebp)
  103760:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103764:	7f e4                	jg     10374a <vprintfmt+0x244>
            }
            break;
  103766:	e9 6c 01 00 00       	jmp    1038d7 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10376b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10376e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103772:	8d 45 14             	lea    0x14(%ebp),%eax
  103775:	89 04 24             	mov    %eax,(%esp)
  103778:	e8 0b fd ff ff       	call   103488 <getint>
  10377d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103780:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103789:	85 d2                	test   %edx,%edx
  10378b:	79 26                	jns    1037b3 <vprintfmt+0x2ad>
                putch('-', putdat);
  10378d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103790:	89 44 24 04          	mov    %eax,0x4(%esp)
  103794:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10379b:	8b 45 08             	mov    0x8(%ebp),%eax
  10379e:	ff d0                	call   *%eax
                num = -(long long)num;
  1037a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037a6:	f7 d8                	neg    %eax
  1037a8:	83 d2 00             	adc    $0x0,%edx
  1037ab:	f7 da                	neg    %edx
  1037ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1037b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1037ba:	e9 a8 00 00 00       	jmp    103867 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1037bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1037c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037c6:	8d 45 14             	lea    0x14(%ebp),%eax
  1037c9:	89 04 24             	mov    %eax,(%esp)
  1037cc:	e8 64 fc ff ff       	call   103435 <getuint>
  1037d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1037d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1037de:	e9 84 00 00 00       	jmp    103867 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1037e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1037e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ea:	8d 45 14             	lea    0x14(%ebp),%eax
  1037ed:	89 04 24             	mov    %eax,(%esp)
  1037f0:	e8 40 fc ff ff       	call   103435 <getuint>
  1037f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1037fb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103802:	eb 63                	jmp    103867 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  103804:	8b 45 0c             	mov    0xc(%ebp),%eax
  103807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10380b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103812:	8b 45 08             	mov    0x8(%ebp),%eax
  103815:	ff d0                	call   *%eax
            putch('x', putdat);
  103817:	8b 45 0c             	mov    0xc(%ebp),%eax
  10381a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10381e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103825:	8b 45 08             	mov    0x8(%ebp),%eax
  103828:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10382a:	8b 45 14             	mov    0x14(%ebp),%eax
  10382d:	8d 50 04             	lea    0x4(%eax),%edx
  103830:	89 55 14             	mov    %edx,0x14(%ebp)
  103833:	8b 00                	mov    (%eax),%eax
  103835:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10383f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103846:	eb 1f                	jmp    103867 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10384b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10384f:	8d 45 14             	lea    0x14(%ebp),%eax
  103852:	89 04 24             	mov    %eax,(%esp)
  103855:	e8 db fb ff ff       	call   103435 <getuint>
  10385a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10385d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103860:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103867:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10386b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10386e:	89 54 24 18          	mov    %edx,0x18(%esp)
  103872:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103875:	89 54 24 14          	mov    %edx,0x14(%esp)
  103879:	89 44 24 10          	mov    %eax,0x10(%esp)
  10387d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103883:	89 44 24 08          	mov    %eax,0x8(%esp)
  103887:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10388b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10388e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103892:	8b 45 08             	mov    0x8(%ebp),%eax
  103895:	89 04 24             	mov    %eax,(%esp)
  103898:	e8 94 fa ff ff       	call   103331 <printnum>
            break;
  10389d:	eb 38                	jmp    1038d7 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10389f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038a6:	89 1c 24             	mov    %ebx,(%esp)
  1038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ac:	ff d0                	call   *%eax
            break;
  1038ae:	eb 27                	jmp    1038d7 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1038b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038b7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1038be:	8b 45 08             	mov    0x8(%ebp),%eax
  1038c1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1038c3:	ff 4d 10             	decl   0x10(%ebp)
  1038c6:	eb 03                	jmp    1038cb <vprintfmt+0x3c5>
  1038c8:	ff 4d 10             	decl   0x10(%ebp)
  1038cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1038ce:	48                   	dec    %eax
  1038cf:	0f b6 00             	movzbl (%eax),%eax
  1038d2:	3c 25                	cmp    $0x25,%al
  1038d4:	75 f2                	jne    1038c8 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  1038d6:	90                   	nop
    while (1) {
  1038d7:	e9 36 fc ff ff       	jmp    103512 <vprintfmt+0xc>
                return;
  1038dc:	90                   	nop
        }
    }
}
  1038dd:	83 c4 40             	add    $0x40,%esp
  1038e0:	5b                   	pop    %ebx
  1038e1:	5e                   	pop    %esi
  1038e2:	5d                   	pop    %ebp
  1038e3:	c3                   	ret    

001038e4 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1038e4:	f3 0f 1e fb          	endbr32 
  1038e8:	55                   	push   %ebp
  1038e9:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1038eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038ee:	8b 40 08             	mov    0x8(%eax),%eax
  1038f1:	8d 50 01             	lea    0x1(%eax),%edx
  1038f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038f7:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1038fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038fd:	8b 10                	mov    (%eax),%edx
  1038ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103902:	8b 40 04             	mov    0x4(%eax),%eax
  103905:	39 c2                	cmp    %eax,%edx
  103907:	73 12                	jae    10391b <sprintputch+0x37>
        *b->buf ++ = ch;
  103909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10390c:	8b 00                	mov    (%eax),%eax
  10390e:	8d 48 01             	lea    0x1(%eax),%ecx
  103911:	8b 55 0c             	mov    0xc(%ebp),%edx
  103914:	89 0a                	mov    %ecx,(%edx)
  103916:	8b 55 08             	mov    0x8(%ebp),%edx
  103919:	88 10                	mov    %dl,(%eax)
    }
}
  10391b:	90                   	nop
  10391c:	5d                   	pop    %ebp
  10391d:	c3                   	ret    

0010391e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10391e:	f3 0f 1e fb          	endbr32 
  103922:	55                   	push   %ebp
  103923:	89 e5                	mov    %esp,%ebp
  103925:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103928:	8d 45 14             	lea    0x14(%ebp),%eax
  10392b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103931:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103935:	8b 45 10             	mov    0x10(%ebp),%eax
  103938:	89 44 24 08          	mov    %eax,0x8(%esp)
  10393c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10393f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103943:	8b 45 08             	mov    0x8(%ebp),%eax
  103946:	89 04 24             	mov    %eax,(%esp)
  103949:	e8 08 00 00 00       	call   103956 <vsnprintf>
  10394e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103951:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103954:	c9                   	leave  
  103955:	c3                   	ret    

00103956 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103956:	f3 0f 1e fb          	endbr32 
  10395a:	55                   	push   %ebp
  10395b:	89 e5                	mov    %esp,%ebp
  10395d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103960:	8b 45 08             	mov    0x8(%ebp),%eax
  103963:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103966:	8b 45 0c             	mov    0xc(%ebp),%eax
  103969:	8d 50 ff             	lea    -0x1(%eax),%edx
  10396c:	8b 45 08             	mov    0x8(%ebp),%eax
  10396f:	01 d0                	add    %edx,%eax
  103971:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10397b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10397f:	74 0a                	je     10398b <vsnprintf+0x35>
  103981:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103987:	39 c2                	cmp    %eax,%edx
  103989:	76 07                	jbe    103992 <vsnprintf+0x3c>
        return -E_INVAL;
  10398b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103990:	eb 2a                	jmp    1039bc <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103992:	8b 45 14             	mov    0x14(%ebp),%eax
  103995:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103999:	8b 45 10             	mov    0x10(%ebp),%eax
  10399c:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1039a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039a7:	c7 04 24 e4 38 10 00 	movl   $0x1038e4,(%esp)
  1039ae:	e8 53 fb ff ff       	call   103506 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1039b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039b6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1039bc:	c9                   	leave  
  1039bd:	c3                   	ret    

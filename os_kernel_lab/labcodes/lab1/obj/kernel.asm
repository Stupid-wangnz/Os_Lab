
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
  100027:	e8 c7 31 00 00       	call   1031f3 <memset>

    cons_init();                // init the console
  10002c:	e8 45 16 00 00       	call   101676 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f0 20 3a 10 00 	movl   $0x103a20,-0x10(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 3c 3a 10 00 	movl   $0x103a3c,(%esp)
  100046:	e8 7c 02 00 00       	call   1002c7 <cprintf>

    print_kerninfo();
  10004b:	e8 3a 09 00 00       	call   10098a <print_kerninfo>

    grade_backtrace();
  100050:	e8 cd 00 00 00       	call   100122 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 48 2e 00 00       	call   102ea2 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6c 17 00 00       	call   1017cb <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 11 19 00 00       	call   101975 <idt_init>

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
  100178:	c7 04 24 41 3a 10 00 	movl   $0x103a41,(%esp)
  10017f:	e8 43 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100184:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100188:	89 c2                	mov    %eax,%edx
  10018a:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10018f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100193:	89 44 24 04          	mov    %eax,0x4(%esp)
  100197:	c7 04 24 4f 3a 10 00 	movl   $0x103a4f,(%esp)
  10019e:	e8 24 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a3:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a7:	89 c2                	mov    %eax,%edx
  1001a9:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b6:	c7 04 24 5d 3a 10 00 	movl   $0x103a5d,(%esp)
  1001bd:	e8 05 01 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c6:	89 c2                	mov    %eax,%edx
  1001c8:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 6b 3a 10 00 	movl   $0x103a6b,(%esp)
  1001dc:	e8 e6 00 00 00       	call   1002c7 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001e1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e5:	89 c2                	mov    %eax,%edx
  1001e7:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f4:	c7 04 24 79 3a 10 00 	movl   $0x103a79,(%esp)
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
    __asm__ __volatile__(
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
  10023c:	c7 04 24 88 3a 10 00 	movl   $0x103a88,(%esp)
  100243:	e8 7f 00 00 00       	call   1002c7 <cprintf>
    lab1_switch_to_user();
  100248:	e8 c1 ff ff ff       	call   10020e <lab1_switch_to_user>
    lab1_print_cur_status();
  10024d:	e8 fa fe ff ff       	call   10014c <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100252:	c7 04 24 a8 3a 10 00 	movl   $0x103aa8,(%esp)
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
  1002bd:	e8 9d 32 00 00       	call   10355f <vprintfmt>
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
  100391:	c7 04 24 c7 3a 10 00 	movl   $0x103ac7,(%esp)
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
  100464:	c7 04 24 ca 3a 10 00 	movl   $0x103aca,(%esp)
  10046b:	e8 57 fe ff ff       	call   1002c7 <cprintf>
    vcprintf(fmt, ap);
  100470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100473:	89 44 24 04          	mov    %eax,0x4(%esp)
  100477:	8b 45 10             	mov    0x10(%ebp),%eax
  10047a:	89 04 24             	mov    %eax,(%esp)
  10047d:	e8 0e fe ff ff       	call   100290 <vcprintf>
    cprintf("\n");
  100482:	c7 04 24 e6 3a 10 00 	movl   $0x103ae6,(%esp)
  100489:	e8 39 fe ff ff       	call   1002c7 <cprintf>
    
    cprintf("stack trackback:\n");
  10048e:	c7 04 24 e8 3a 10 00 	movl   $0x103ae8,(%esp)
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
  1004d3:	c7 04 24 fa 3a 10 00 	movl   $0x103afa,(%esp)
  1004da:	e8 e8 fd ff ff       	call   1002c7 <cprintf>
    vcprintf(fmt, ap);
  1004df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e9:	89 04 24             	mov    %eax,(%esp)
  1004ec:	e8 9f fd ff ff       	call   100290 <vcprintf>
    cprintf("\n");
  1004f1:	c7 04 24 e6 3a 10 00 	movl   $0x103ae6,(%esp)
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
  10066d:	c7 00 18 3b 10 00    	movl   $0x103b18,(%eax)
    info->eip_line = 0;
  100673:	8b 45 0c             	mov    0xc(%ebp),%eax
  100676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100680:	c7 40 08 18 3b 10 00 	movl   $0x103b18,0x8(%eax)
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
  1006a4:	c7 45 f4 8c 43 10 00 	movl   $0x10438c,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006ab:	c7 45 f0 7c d4 10 00 	movl   $0x10d47c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b2:	c7 45 ec 7d d4 10 00 	movl   $0x10d47d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b9:	c7 45 e8 94 f5 10 00 	movl   $0x10f594,-0x18(%ebp)

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
  10080c:	e8 56 28 00 00       	call   103067 <strfind>
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
  100994:	c7 04 24 22 3b 10 00 	movl   $0x103b22,(%esp)
  10099b:	e8 27 f9 ff ff       	call   1002c7 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1009a0:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1009a7:	00 
  1009a8:	c7 04 24 3b 3b 10 00 	movl   $0x103b3b,(%esp)
  1009af:	e8 13 f9 ff ff       	call   1002c7 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b4:	c7 44 24 04 17 3a 10 	movl   $0x103a17,0x4(%esp)
  1009bb:	00 
  1009bc:	c7 04 24 53 3b 10 00 	movl   $0x103b53,(%esp)
  1009c3:	e8 ff f8 ff ff       	call   1002c7 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c8:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  1009cf:	00 
  1009d0:	c7 04 24 6b 3b 10 00 	movl   $0x103b6b,(%esp)
  1009d7:	e8 eb f8 ff ff       	call   1002c7 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009dc:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009e3:	00 
  1009e4:	c7 04 24 83 3b 10 00 	movl   $0x103b83,(%esp)
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
  100a11:	c7 04 24 9c 3b 10 00 	movl   $0x103b9c,(%esp)
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
  100a4a:	c7 04 24 c6 3b 10 00 	movl   $0x103bc6,(%esp)
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
  100ab8:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
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
  100b11:	c7 04 24 f4 3b 10 00 	movl   $0x103bf4,(%esp)
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
  100b53:	c7 04 24 0c 3c 10 00 	movl   $0x103c0c,(%esp)
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
  100bce:	c7 04 24 b0 3c 10 00 	movl   $0x103cb0,(%esp)
  100bd5:	e8 57 24 00 00       	call   103031 <strchr>
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
  100bf6:	c7 04 24 b5 3c 10 00 	movl   $0x103cb5,(%esp)
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
  100c38:	c7 04 24 b0 3c 10 00 	movl   $0x103cb0,(%esp)
  100c3f:	e8 ed 23 00 00       	call   103031 <strchr>
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
  100ca9:	e8 df 22 00 00       	call   102f8d <strcmp>
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
  100cf5:	c7 04 24 d3 3c 10 00 	movl   $0x103cd3,(%esp)
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
  100d16:	c7 04 24 ec 3c 10 00 	movl   $0x103cec,(%esp)
  100d1d:	e8 a5 f5 ff ff       	call   1002c7 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d22:	c7 04 24 14 3d 10 00 	movl   $0x103d14,(%esp)
  100d29:	e8 99 f5 ff ff       	call   1002c7 <cprintf>

    if (tf != NULL) {
  100d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d32:	74 0b                	je     100d3f <kmonitor+0x33>
        print_trapframe(tf);
  100d34:	8b 45 08             	mov    0x8(%ebp),%eax
  100d37:	89 04 24             	mov    %eax,(%esp)
  100d3a:	e8 77 0e 00 00       	call   101bb6 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d3f:	c7 04 24 39 3d 10 00 	movl   $0x103d39,(%esp)
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
  100db1:	c7 04 24 3d 3d 10 00 	movl   $0x103d3d,(%esp)
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
  100e4b:	c7 04 24 46 3d 10 00 	movl   $0x103d46,(%esp)
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
  10127d:	e8 b4 1f 00 00       	call   103236 <memmove>
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
  10161b:	c7 04 24 61 3d 10 00 	movl   $0x103d61,(%esp)
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
  101698:	c7 04 24 6d 3d 10 00 	movl   $0x103d6d,(%esp)
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
  101941:	c7 04 24 a0 3d 10 00 	movl   $0x103da0,(%esp)
  101948:	e8 7a e9 ff ff       	call   1002c7 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10194d:	c7 04 24 aa 3d 10 00 	movl   $0x103daa,(%esp)
  101954:	e8 6e e9 ff ff       	call   1002c7 <cprintf>
    panic("EOT: kernel seems ok.");
  101959:	c7 44 24 08 b8 3d 10 	movl   $0x103db8,0x8(%esp)
  101960:	00 
  101961:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101968:	00 
  101969:	c7 04 24 ce 3d 10 00 	movl   $0x103dce,(%esp)
  101970:	e8 be ea ff ff       	call   100433 <__panic>

00101975 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101975:	f3 0f 1e fb          	endbr32 
  101979:	55                   	push   %ebp
  10197a:	89 e5                	mov    %esp,%ebp
  10197c:	83 ec 10             	sub    $0x10,%esp
    
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  10197f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101986:	e9 c4 00 00 00       	jmp    101a4f <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  10198b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198e:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101995:	0f b7 d0             	movzwl %ax,%edx
  101998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199b:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  1019a2:	00 
  1019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a6:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  1019ad:	00 08 00 
  1019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b3:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019ba:	00 
  1019bb:	80 e2 e0             	and    $0xe0,%dl
  1019be:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c8:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019cf:	00 
  1019d0:	80 e2 1f             	and    $0x1f,%dl
  1019d3:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019dd:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019e4:	00 
  1019e5:	80 e2 f0             	and    $0xf0,%dl
  1019e8:	80 ca 0e             	or     $0xe,%dl
  1019eb:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f5:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019fc:	00 
  1019fd:	80 e2 ef             	and    $0xef,%dl
  101a00:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0a:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a11:	00 
  101a12:	80 e2 9f             	and    $0x9f,%dl
  101a15:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1f:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a26:	00 
  101a27:	80 ca 80             	or     $0x80,%dl
  101a2a:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a34:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a3b:	c1 e8 10             	shr    $0x10,%eax
  101a3e:	0f b7 d0             	movzwl %ax,%edx
  101a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a44:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a4b:	00 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  101a4c:	ff 45 fc             	incl   -0x4(%ebp)
  101a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a52:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a57:	0f 86 2e ff ff ff    	jbe    10198b <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
  101a5d:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101a62:	0f b7 c0             	movzwl %ax,%eax
  101a65:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101a6b:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101a72:	08 00 
  101a74:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a7b:	24 e0                	and    $0xe0,%al
  101a7d:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a82:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a89:	24 1f                	and    $0x1f,%al
  101a8b:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a90:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a97:	0c 0f                	or     $0xf,%al
  101a99:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a9e:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101aa5:	24 ef                	and    $0xef,%al
  101aa7:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aac:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101ab3:	0c 60                	or     $0x60,%al
  101ab5:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aba:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101ac1:	0c 80                	or     $0x80,%al
  101ac3:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101ac8:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101acd:	c1 e8 10             	shr    $0x10,%eax
  101ad0:	0f b7 c0             	movzwl %ax,%eax
  101ad3:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101ad9:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101ade:	0f b7 c0             	movzwl %ax,%eax
  101ae1:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101ae7:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101aee:	08 00 
  101af0:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101af7:	24 e0                	and    $0xe0,%al
  101af9:	a2 6c 14 11 00       	mov    %al,0x11146c
  101afe:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101b05:	24 1f                	and    $0x1f,%al
  101b07:	a2 6c 14 11 00       	mov    %al,0x11146c
  101b0c:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b13:	24 f0                	and    $0xf0,%al
  101b15:	0c 0e                	or     $0xe,%al
  101b17:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b1c:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b23:	24 ef                	and    $0xef,%al
  101b25:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b2a:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b31:	0c 60                	or     $0x60,%al
  101b33:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b38:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b3f:	0c 80                	or     $0x80,%al
  101b41:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b46:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101b4b:	c1 e8 10             	shr    $0x10,%eax
  101b4e:	0f b7 c0             	movzwl %ax,%eax
  101b51:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101b57:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b61:	0f 01 18             	lidtl  (%eax)
}
  101b64:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
  101b65:	90                   	nop
  101b66:	c9                   	leave  
  101b67:	c3                   	ret    

00101b68 <trapname>:

static const char *
trapname(int trapno) {
  101b68:	f3 0f 1e fb          	endbr32 
  101b6c:	55                   	push   %ebp
  101b6d:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	83 f8 13             	cmp    $0x13,%eax
  101b75:	77 0c                	ja     101b83 <trapname+0x1b>
        return excnames[trapno];
  101b77:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7a:	8b 04 85 40 41 10 00 	mov    0x104140(,%eax,4),%eax
  101b81:	eb 18                	jmp    101b9b <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b83:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b87:	7e 0d                	jle    101b96 <trapname+0x2e>
  101b89:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b8d:	7f 07                	jg     101b96 <trapname+0x2e>
        return "Hardware Interrupt";
  101b8f:	b8 df 3d 10 00       	mov    $0x103ddf,%eax
  101b94:	eb 05                	jmp    101b9b <trapname+0x33>
    }
    return "(unknown trap)";
  101b96:	b8 f2 3d 10 00       	mov    $0x103df2,%eax
}
  101b9b:	5d                   	pop    %ebp
  101b9c:	c3                   	ret    

00101b9d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b9d:	f3 0f 1e fb          	endbr32 
  101ba1:	55                   	push   %ebp
  101ba2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bab:	83 f8 08             	cmp    $0x8,%eax
  101bae:	0f 94 c0             	sete   %al
  101bb1:	0f b6 c0             	movzbl %al,%eax
}
  101bb4:	5d                   	pop    %ebp
  101bb5:	c3                   	ret    

00101bb6 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101bb6:	f3 0f 1e fb          	endbr32 
  101bba:	55                   	push   %ebp
  101bbb:	89 e5                	mov    %esp,%ebp
  101bbd:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 33 3e 10 00 	movl   $0x103e33,(%esp)
  101bce:	e8 f4 e6 ff ff       	call   1002c7 <cprintf>
    print_regs(&tf->tf_regs);
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	89 04 24             	mov    %eax,(%esp)
  101bd9:	e8 8d 01 00 00       	call   101d6b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bde:	8b 45 08             	mov    0x8(%ebp),%eax
  101be1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be9:	c7 04 24 44 3e 10 00 	movl   $0x103e44,(%esp)
  101bf0:	e8 d2 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c00:	c7 04 24 57 3e 10 00 	movl   $0x103e57,(%esp)
  101c07:	e8 bb e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 6a 3e 10 00 	movl   $0x103e6a,(%esp)
  101c1e:	e8 a4 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 7d 3e 10 00 	movl   $0x103e7d,(%esp)
  101c35:	e8 8d e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 30             	mov    0x30(%eax),%eax
  101c40:	89 04 24             	mov    %eax,(%esp)
  101c43:	e8 20 ff ff ff       	call   101b68 <trapname>
  101c48:	8b 55 08             	mov    0x8(%ebp),%edx
  101c4b:	8b 52 30             	mov    0x30(%edx),%edx
  101c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c52:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c56:	c7 04 24 90 3e 10 00 	movl   $0x103e90,(%esp)
  101c5d:	e8 65 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c62:	8b 45 08             	mov    0x8(%ebp),%eax
  101c65:	8b 40 34             	mov    0x34(%eax),%eax
  101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6c:	c7 04 24 a2 3e 10 00 	movl   $0x103ea2,(%esp)
  101c73:	e8 4f e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c78:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7b:	8b 40 38             	mov    0x38(%eax),%eax
  101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c82:	c7 04 24 b1 3e 10 00 	movl   $0x103eb1,(%esp)
  101c89:	e8 39 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c99:	c7 04 24 c0 3e 10 00 	movl   $0x103ec0,(%esp)
  101ca0:	e8 22 e6 ff ff       	call   1002c7 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 40 40             	mov    0x40(%eax),%eax
  101cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caf:	c7 04 24 d3 3e 10 00 	movl   $0x103ed3,(%esp)
  101cb6:	e8 0c e6 ff ff       	call   1002c7 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101cc2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101cc9:	eb 3d                	jmp    101d08 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	8b 50 40             	mov    0x40(%eax),%edx
  101cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cd4:	21 d0                	and    %edx,%eax
  101cd6:	85 c0                	test   %eax,%eax
  101cd8:	74 28                	je     101d02 <print_trapframe+0x14c>
  101cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cdd:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101ce4:	85 c0                	test   %eax,%eax
  101ce6:	74 1a                	je     101d02 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ceb:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf6:	c7 04 24 e2 3e 10 00 	movl   $0x103ee2,(%esp)
  101cfd:	e8 c5 e5 ff ff       	call   1002c7 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d02:	ff 45 f4             	incl   -0xc(%ebp)
  101d05:	d1 65 f0             	shll   -0x10(%ebp)
  101d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d0b:	83 f8 17             	cmp    $0x17,%eax
  101d0e:	76 bb                	jbe    101ccb <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d10:	8b 45 08             	mov    0x8(%ebp),%eax
  101d13:	8b 40 40             	mov    0x40(%eax),%eax
  101d16:	c1 e8 0c             	shr    $0xc,%eax
  101d19:	83 e0 03             	and    $0x3,%eax
  101d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d20:	c7 04 24 e6 3e 10 00 	movl   $0x103ee6,(%esp)
  101d27:	e8 9b e5 ff ff       	call   1002c7 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2f:	89 04 24             	mov    %eax,(%esp)
  101d32:	e8 66 fe ff ff       	call   101b9d <trap_in_kernel>
  101d37:	85 c0                	test   %eax,%eax
  101d39:	75 2d                	jne    101d68 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 40 44             	mov    0x44(%eax),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 ef 3e 10 00 	movl   $0x103eef,(%esp)
  101d4c:	e8 76 e5 ff ff       	call   1002c7 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5c:	c7 04 24 fe 3e 10 00 	movl   $0x103efe,(%esp)
  101d63:	e8 5f e5 ff ff       	call   1002c7 <cprintf>
    }
}
  101d68:	90                   	nop
  101d69:	c9                   	leave  
  101d6a:	c3                   	ret    

00101d6b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d6b:	f3 0f 1e fb          	endbr32 
  101d6f:	55                   	push   %ebp
  101d70:	89 e5                	mov    %esp,%ebp
  101d72:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	8b 00                	mov    (%eax),%eax
  101d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7e:	c7 04 24 11 3f 10 00 	movl   $0x103f11,(%esp)
  101d85:	e8 3d e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8d:	8b 40 04             	mov    0x4(%eax),%eax
  101d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d94:	c7 04 24 20 3f 10 00 	movl   $0x103f20,(%esp)
  101d9b:	e8 27 e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101da0:	8b 45 08             	mov    0x8(%ebp),%eax
  101da3:	8b 40 08             	mov    0x8(%eax),%eax
  101da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101daa:	c7 04 24 2f 3f 10 00 	movl   $0x103f2f,(%esp)
  101db1:	e8 11 e5 ff ff       	call   1002c7 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101db6:	8b 45 08             	mov    0x8(%ebp),%eax
  101db9:	8b 40 0c             	mov    0xc(%eax),%eax
  101dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc0:	c7 04 24 3e 3f 10 00 	movl   $0x103f3e,(%esp)
  101dc7:	e8 fb e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcf:	8b 40 10             	mov    0x10(%eax),%eax
  101dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd6:	c7 04 24 4d 3f 10 00 	movl   $0x103f4d,(%esp)
  101ddd:	e8 e5 e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101de2:	8b 45 08             	mov    0x8(%ebp),%eax
  101de5:	8b 40 14             	mov    0x14(%eax),%eax
  101de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dec:	c7 04 24 5c 3f 10 00 	movl   $0x103f5c,(%esp)
  101df3:	e8 cf e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	8b 40 18             	mov    0x18(%eax),%eax
  101dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e02:	c7 04 24 6b 3f 10 00 	movl   $0x103f6b,(%esp)
  101e09:	e8 b9 e4 ff ff       	call   1002c7 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e11:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e18:	c7 04 24 7a 3f 10 00 	movl   $0x103f7a,(%esp)
  101e1f:	e8 a3 e4 ff ff       	call   1002c7 <cprintf>
}
  101e24:	90                   	nop
  101e25:	c9                   	leave  
  101e26:	c3                   	ret    

00101e27 <trap_dispatch>:



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e27:	f3 0f 1e fb          	endbr32 
  101e2b:	55                   	push   %ebp
  101e2c:	89 e5                	mov    %esp,%ebp
  101e2e:	57                   	push   %edi
  101e2f:	56                   	push   %esi
  101e30:	53                   	push   %ebx
  101e31:	83 ec 3c             	sub    $0x3c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e34:	8b 45 08             	mov    0x8(%ebp),%eax
  101e37:	8b 40 30             	mov    0x30(%eax),%eax
  101e3a:	83 f8 79             	cmp    $0x79,%eax
  101e3d:	0f 84 ac 03 00 00    	je     1021ef <trap_dispatch+0x3c8>
  101e43:	83 f8 79             	cmp    $0x79,%eax
  101e46:	0f 87 31 04 00 00    	ja     10227d <trap_dispatch+0x456>
  101e4c:	83 f8 78             	cmp    $0x78,%eax
  101e4f:	0f 84 af 02 00 00    	je     102104 <trap_dispatch+0x2dd>
  101e55:	83 f8 78             	cmp    $0x78,%eax
  101e58:	0f 87 1f 04 00 00    	ja     10227d <trap_dispatch+0x456>
  101e5e:	83 f8 2f             	cmp    $0x2f,%eax
  101e61:	0f 87 16 04 00 00    	ja     10227d <trap_dispatch+0x456>
  101e67:	83 f8 2e             	cmp    $0x2e,%eax
  101e6a:	0f 83 42 04 00 00    	jae    1022b2 <trap_dispatch+0x48b>
  101e70:	83 f8 24             	cmp    $0x24,%eax
  101e73:	74 5e                	je     101ed3 <trap_dispatch+0xac>
  101e75:	83 f8 24             	cmp    $0x24,%eax
  101e78:	0f 87 ff 03 00 00    	ja     10227d <trap_dispatch+0x456>
  101e7e:	83 f8 20             	cmp    $0x20,%eax
  101e81:	74 0a                	je     101e8d <trap_dispatch+0x66>
  101e83:	83 f8 21             	cmp    $0x21,%eax
  101e86:	74 74                	je     101efc <trap_dispatch+0xd5>
  101e88:	e9 f0 03 00 00       	jmp    10227d <trap_dispatch+0x456>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101e8d:	a1 08 19 11 00       	mov    0x111908,%eax
  101e92:	40                   	inc    %eax
  101e93:	a3 08 19 11 00       	mov    %eax,0x111908
        if(ticks%100==0){
  101e98:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ea3:	89 c8                	mov    %ecx,%eax
  101ea5:	f7 e2                	mul    %edx
  101ea7:	c1 ea 05             	shr    $0x5,%edx
  101eaa:	89 d0                	mov    %edx,%eax
  101eac:	c1 e0 02             	shl    $0x2,%eax
  101eaf:	01 d0                	add    %edx,%eax
  101eb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101eb8:	01 d0                	add    %edx,%eax
  101eba:	c1 e0 02             	shl    $0x2,%eax
  101ebd:	29 c1                	sub    %eax,%ecx
  101ebf:	89 ca                	mov    %ecx,%edx
  101ec1:	85 d2                	test   %edx,%edx
  101ec3:	0f 85 ec 03 00 00    	jne    1022b5 <trap_dispatch+0x48e>
            print_ticks();
  101ec9:	e8 61 fa ff ff       	call   10192f <print_ticks>
        }
        break;
  101ece:	e9 e2 03 00 00       	jmp    1022b5 <trap_dispatch+0x48e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ed3:	e8 fd f7 ff ff       	call   1016d5 <cons_getc>
  101ed8:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101edb:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101edf:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ee3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eeb:	c7 04 24 89 3f 10 00 	movl   $0x103f89,(%esp)
  101ef2:	e8 d0 e3 ff ff       	call   1002c7 <cprintf>
        break;
  101ef7:	e9 bd 03 00 00       	jmp    1022b9 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101efc:	e8 d4 f7 ff ff       	call   1016d5 <cons_getc>
  101f01:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f04:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101f08:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f0c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f14:	c7 04 24 9b 3f 10 00 	movl   $0x103f9b,(%esp)
  101f1b:	e8 a7 e3 ff ff       	call   1002c7 <cprintf>
         if (c == '0'&&!trap_in_kernel(tf)) {
  101f20:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101f24:	0f 85 bb 00 00 00    	jne    101fe5 <trap_dispatch+0x1be>
  101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2d:	89 04 24             	mov    %eax,(%esp)
  101f30:	e8 68 fc ff ff       	call   101b9d <trap_in_kernel>
  101f35:	85 c0                	test   %eax,%eax
  101f37:	0f 85 a8 00 00 00    	jne    101fe5 <trap_dispatch+0x1be>
  101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f40:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  101f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f4a:	83 f8 08             	cmp    $0x8,%eax
  101f4d:	74 79                	je     101fc8 <trap_dispatch+0x1a1>
        tf->tf_cs = KERNEL_CS;
  101f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f52:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  101f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f5b:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f64:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f6b:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f72:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f79:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f80:	8b 40 40             	mov    0x40(%eax),%eax
  101f83:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f88:	89 c2                	mov    %eax,%edx
  101f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f8d:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f93:	8b 40 44             	mov    0x44(%eax),%eax
  101f96:	83 e8 44             	sub    $0x44,%eax
  101f99:	a3 6c 19 11 00       	mov    %eax,0x11196c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f9e:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101fa3:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101faa:	00 
  101fab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101fae:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fb2:	89 04 24             	mov    %eax,(%esp)
  101fb5:	e8 7c 12 00 00       	call   103236 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fba:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fc3:	83 e8 04             	sub    $0x4,%eax
  101fc6:	89 10                	mov    %edx,(%eax)
}
  101fc8:	90                   	nop
        //切换为内核态
        switch_to_kernel(tf);
        cprintf("user to kernel\n");
  101fc9:	c7 04 24 aa 3f 10 00 	movl   $0x103faa,(%esp)
  101fd0:	e8 f2 e2 ff ff       	call   1002c7 <cprintf>
        print_trapframe(tf);
  101fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd8:	89 04 24             	mov    %eax,(%esp)
  101fdb:	e8 d6 fb ff ff       	call   101bb6 <print_trapframe>
        //切换为用户态
        switch_to_user(tf);
        cprintf("kernel to user\n");
        print_trapframe(tf);
        }
        break;
  101fe0:	e9 d3 02 00 00       	jmp    1022b8 <trap_dispatch+0x491>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
  101fe5:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101fe9:	0f 85 c9 02 00 00    	jne    1022b8 <trap_dispatch+0x491>
  101fef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff2:	89 04 24             	mov    %eax,(%esp)
  101ff5:	e8 a3 fb ff ff       	call   101b9d <trap_in_kernel>
  101ffa:	85 c0                	test   %eax,%eax
  101ffc:	0f 84 b6 02 00 00    	je     1022b8 <trap_dispatch+0x491>
  102002:	8b 45 08             	mov    0x8(%ebp),%eax
  102005:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (tf->tf_cs != USER_CS) {
  102008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10200b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10200f:	83 f8 1b             	cmp    $0x1b,%eax
  102012:	0f 84 cf 00 00 00    	je     1020e7 <trap_dispatch+0x2c0>
        switchk2u = *tf;
  102018:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10201b:	b8 20 19 11 00       	mov    $0x111920,%eax
  102020:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102025:	89 c1                	mov    %eax,%ecx
  102027:	83 e1 01             	and    $0x1,%ecx
  10202a:	85 c9                	test   %ecx,%ecx
  10202c:	74 0c                	je     10203a <trap_dispatch+0x213>
  10202e:	0f b6 0a             	movzbl (%edx),%ecx
  102031:	88 08                	mov    %cl,(%eax)
  102033:	8d 40 01             	lea    0x1(%eax),%eax
  102036:	8d 52 01             	lea    0x1(%edx),%edx
  102039:	4b                   	dec    %ebx
  10203a:	89 c1                	mov    %eax,%ecx
  10203c:	83 e1 02             	and    $0x2,%ecx
  10203f:	85 c9                	test   %ecx,%ecx
  102041:	74 0f                	je     102052 <trap_dispatch+0x22b>
  102043:	0f b7 0a             	movzwl (%edx),%ecx
  102046:	66 89 08             	mov    %cx,(%eax)
  102049:	8d 40 02             	lea    0x2(%eax),%eax
  10204c:	8d 52 02             	lea    0x2(%edx),%edx
  10204f:	83 eb 02             	sub    $0x2,%ebx
  102052:	89 df                	mov    %ebx,%edi
  102054:	83 e7 fc             	and    $0xfffffffc,%edi
  102057:	b9 00 00 00 00       	mov    $0x0,%ecx
  10205c:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  10205f:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102062:	83 c1 04             	add    $0x4,%ecx
  102065:	39 f9                	cmp    %edi,%ecx
  102067:	72 f3                	jb     10205c <trap_dispatch+0x235>
  102069:	01 c8                	add    %ecx,%eax
  10206b:	01 ca                	add    %ecx,%edx
  10206d:	b9 00 00 00 00       	mov    $0x0,%ecx
  102072:	89 de                	mov    %ebx,%esi
  102074:	83 e6 02             	and    $0x2,%esi
  102077:	85 f6                	test   %esi,%esi
  102079:	74 0b                	je     102086 <trap_dispatch+0x25f>
  10207b:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  10207f:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102083:	83 c1 02             	add    $0x2,%ecx
  102086:	83 e3 01             	and    $0x1,%ebx
  102089:	85 db                	test   %ebx,%ebx
  10208b:	74 07                	je     102094 <trap_dispatch+0x26d>
  10208d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102091:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  102094:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  10209b:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  10209d:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  1020a4:	23 00 
  1020a6:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  1020ad:	66 a3 48 19 11 00    	mov    %ax,0x111948
  1020b3:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  1020ba:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  1020c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1020c3:	83 c0 4c             	add    $0x4c,%eax
  1020c6:	a3 64 19 11 00       	mov    %eax,0x111964
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  1020cb:	a1 60 19 11 00       	mov    0x111960,%eax
  1020d0:	0d 00 30 00 00       	or     $0x3000,%eax
  1020d5:	a3 60 19 11 00       	mov    %eax,0x111960
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  1020da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1020dd:	83 e8 04             	sub    $0x4,%eax
  1020e0:	ba 20 19 11 00       	mov    $0x111920,%edx
  1020e5:	89 10                	mov    %edx,(%eax)
}
  1020e7:	90                   	nop
        cprintf("kernel to user\n");
  1020e8:	c7 04 24 ba 3f 10 00 	movl   $0x103fba,(%esp)
  1020ef:	e8 d3 e1 ff ff       	call   1002c7 <cprintf>
        print_trapframe(tf);
  1020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f7:	89 04 24             	mov    %eax,(%esp)
  1020fa:	e8 b7 fa ff ff       	call   101bb6 <print_trapframe>
        break;
  1020ff:	e9 b4 01 00 00       	jmp    1022b8 <trap_dispatch+0x491>
  102104:	8b 45 08             	mov    0x8(%ebp),%eax
  102107:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (tf->tf_cs != USER_CS) {
  10210a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10210d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102111:	83 f8 1b             	cmp    $0x1b,%eax
  102114:	0f 84 cf 00 00 00    	je     1021e9 <trap_dispatch+0x3c2>
        switchk2u = *tf;
  10211a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10211d:	b8 20 19 11 00       	mov    $0x111920,%eax
  102122:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102127:	89 c1                	mov    %eax,%ecx
  102129:	83 e1 01             	and    $0x1,%ecx
  10212c:	85 c9                	test   %ecx,%ecx
  10212e:	74 0c                	je     10213c <trap_dispatch+0x315>
  102130:	0f b6 0a             	movzbl (%edx),%ecx
  102133:	88 08                	mov    %cl,(%eax)
  102135:	8d 40 01             	lea    0x1(%eax),%eax
  102138:	8d 52 01             	lea    0x1(%edx),%edx
  10213b:	4b                   	dec    %ebx
  10213c:	89 c1                	mov    %eax,%ecx
  10213e:	83 e1 02             	and    $0x2,%ecx
  102141:	85 c9                	test   %ecx,%ecx
  102143:	74 0f                	je     102154 <trap_dispatch+0x32d>
  102145:	0f b7 0a             	movzwl (%edx),%ecx
  102148:	66 89 08             	mov    %cx,(%eax)
  10214b:	8d 40 02             	lea    0x2(%eax),%eax
  10214e:	8d 52 02             	lea    0x2(%edx),%edx
  102151:	83 eb 02             	sub    $0x2,%ebx
  102154:	89 df                	mov    %ebx,%edi
  102156:	83 e7 fc             	and    $0xfffffffc,%edi
  102159:	b9 00 00 00 00       	mov    $0x0,%ecx
  10215e:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102161:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102164:	83 c1 04             	add    $0x4,%ecx
  102167:	39 f9                	cmp    %edi,%ecx
  102169:	72 f3                	jb     10215e <trap_dispatch+0x337>
  10216b:	01 c8                	add    %ecx,%eax
  10216d:	01 ca                	add    %ecx,%edx
  10216f:	b9 00 00 00 00       	mov    $0x0,%ecx
  102174:	89 de                	mov    %ebx,%esi
  102176:	83 e6 02             	and    $0x2,%esi
  102179:	85 f6                	test   %esi,%esi
  10217b:	74 0b                	je     102188 <trap_dispatch+0x361>
  10217d:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102181:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102185:	83 c1 02             	add    $0x2,%ecx
  102188:	83 e3 01             	and    $0x1,%ebx
  10218b:	85 db                	test   %ebx,%ebx
  10218d:	74 07                	je     102196 <trap_dispatch+0x36f>
  10218f:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102193:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  102196:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  10219d:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  10219f:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  1021a6:	23 00 
  1021a8:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  1021af:	66 a3 48 19 11 00    	mov    %ax,0x111948
  1021b5:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  1021bc:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  1021c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1021c5:	83 c0 4c             	add    $0x4c,%eax
  1021c8:	a3 64 19 11 00       	mov    %eax,0x111964
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  1021cd:	a1 60 19 11 00       	mov    0x111960,%eax
  1021d2:	0d 00 30 00 00       	or     $0x3000,%eax
  1021d7:	a3 60 19 11 00       	mov    %eax,0x111960
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  1021dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1021df:	83 e8 04             	sub    $0x4,%eax
  1021e2:	ba 20 19 11 00       	mov    $0x111920,%edx
  1021e7:	89 10                	mov    %edx,(%eax)
}
  1021e9:	90                   	nop
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
        }*/
        switch_to_user(tf);
        break;
  1021ea:	e9 ca 00 00 00       	jmp    1022b9 <trap_dispatch+0x492>
  1021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1021f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  1021f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1021f8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021fc:	83 f8 08             	cmp    $0x8,%eax
  1021ff:	74 79                	je     10227a <trap_dispatch+0x453>
        tf->tf_cs = KERNEL_CS;
  102201:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102204:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  10220a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10220d:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  102213:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102216:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  10221a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10221d:	66 89 50 28          	mov    %dx,0x28(%eax)
  102221:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102224:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10222b:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  10222f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102232:	8b 40 40             	mov    0x40(%eax),%eax
  102235:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  10223a:	89 c2                	mov    %eax,%edx
  10223c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10223f:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102245:	8b 40 44             	mov    0x44(%eax),%eax
  102248:	83 e8 44             	sub    $0x44,%eax
  10224b:	a3 6c 19 11 00       	mov    %eax,0x11196c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  102250:	a1 6c 19 11 00       	mov    0x11196c,%eax
  102255:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  10225c:	00 
  10225d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102260:	89 54 24 04          	mov    %edx,0x4(%esp)
  102264:	89 04 24             	mov    %eax,(%esp)
  102267:	e8 ca 0f 00 00       	call   103236 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  10226c:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  102272:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102275:	83 e8 04             	sub    $0x4,%eax
  102278:	89 10                	mov    %edx,(%eax)
}
  10227a:	90                   	nop
            tf->tf_cs = KERNEL_CS;
            tf->tf_ds = tf->tf_es = KERNEL_DS;
            tf->tf_eflags &= ~FL_IOPL_MASK;
        }*/
        switch_to_kernel(tf);
        break;
  10227b:	eb 3c                	jmp    1022b9 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  10227d:	8b 45 08             	mov    0x8(%ebp),%eax
  102280:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102284:	83 e0 03             	and    $0x3,%eax
  102287:	85 c0                	test   %eax,%eax
  102289:	75 2e                	jne    1022b9 <trap_dispatch+0x492>
            print_trapframe(tf);
  10228b:	8b 45 08             	mov    0x8(%ebp),%eax
  10228e:	89 04 24             	mov    %eax,(%esp)
  102291:	e8 20 f9 ff ff       	call   101bb6 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102296:	c7 44 24 08 ca 3f 10 	movl   $0x103fca,0x8(%esp)
  10229d:	00 
  10229e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1022a5:	00 
  1022a6:	c7 04 24 ce 3d 10 00 	movl   $0x103dce,(%esp)
  1022ad:	e8 81 e1 ff ff       	call   100433 <__panic>
        break;
  1022b2:	90                   	nop
  1022b3:	eb 04                	jmp    1022b9 <trap_dispatch+0x492>
        break;
  1022b5:	90                   	nop
  1022b6:	eb 01                	jmp    1022b9 <trap_dispatch+0x492>
        break;
  1022b8:	90                   	nop
        }
    }
}
  1022b9:	90                   	nop
  1022ba:	83 c4 3c             	add    $0x3c,%esp
  1022bd:	5b                   	pop    %ebx
  1022be:	5e                   	pop    %esi
  1022bf:	5f                   	pop    %edi
  1022c0:	5d                   	pop    %ebp
  1022c1:	c3                   	ret    

001022c2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1022c2:	f3 0f 1e fb          	endbr32 
  1022c6:	55                   	push   %ebp
  1022c7:	89 e5                	mov    %esp,%ebp
  1022c9:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1022cf:	89 04 24             	mov    %eax,(%esp)
  1022d2:	e8 50 fb ff ff       	call   101e27 <trap_dispatch>
}
  1022d7:	90                   	nop
  1022d8:	c9                   	leave  
  1022d9:	c3                   	ret    

001022da <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $0
  1022dc:	6a 00                	push   $0x0
  jmp __alltraps
  1022de:	e9 69 0a 00 00       	jmp    102d4c <__alltraps>

001022e3 <vector1>:
.globl vector1
vector1:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $1
  1022e5:	6a 01                	push   $0x1
  jmp __alltraps
  1022e7:	e9 60 0a 00 00       	jmp    102d4c <__alltraps>

001022ec <vector2>:
.globl vector2
vector2:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $2
  1022ee:	6a 02                	push   $0x2
  jmp __alltraps
  1022f0:	e9 57 0a 00 00       	jmp    102d4c <__alltraps>

001022f5 <vector3>:
.globl vector3
vector3:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $3
  1022f7:	6a 03                	push   $0x3
  jmp __alltraps
  1022f9:	e9 4e 0a 00 00       	jmp    102d4c <__alltraps>

001022fe <vector4>:
.globl vector4
vector4:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $4
  102300:	6a 04                	push   $0x4
  jmp __alltraps
  102302:	e9 45 0a 00 00       	jmp    102d4c <__alltraps>

00102307 <vector5>:
.globl vector5
vector5:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $5
  102309:	6a 05                	push   $0x5
  jmp __alltraps
  10230b:	e9 3c 0a 00 00       	jmp    102d4c <__alltraps>

00102310 <vector6>:
.globl vector6
vector6:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $6
  102312:	6a 06                	push   $0x6
  jmp __alltraps
  102314:	e9 33 0a 00 00       	jmp    102d4c <__alltraps>

00102319 <vector7>:
.globl vector7
vector7:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $7
  10231b:	6a 07                	push   $0x7
  jmp __alltraps
  10231d:	e9 2a 0a 00 00       	jmp    102d4c <__alltraps>

00102322 <vector8>:
.globl vector8
vector8:
  pushl $8
  102322:	6a 08                	push   $0x8
  jmp __alltraps
  102324:	e9 23 0a 00 00       	jmp    102d4c <__alltraps>

00102329 <vector9>:
.globl vector9
vector9:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $9
  10232b:	6a 09                	push   $0x9
  jmp __alltraps
  10232d:	e9 1a 0a 00 00       	jmp    102d4c <__alltraps>

00102332 <vector10>:
.globl vector10
vector10:
  pushl $10
  102332:	6a 0a                	push   $0xa
  jmp __alltraps
  102334:	e9 13 0a 00 00       	jmp    102d4c <__alltraps>

00102339 <vector11>:
.globl vector11
vector11:
  pushl $11
  102339:	6a 0b                	push   $0xb
  jmp __alltraps
  10233b:	e9 0c 0a 00 00       	jmp    102d4c <__alltraps>

00102340 <vector12>:
.globl vector12
vector12:
  pushl $12
  102340:	6a 0c                	push   $0xc
  jmp __alltraps
  102342:	e9 05 0a 00 00       	jmp    102d4c <__alltraps>

00102347 <vector13>:
.globl vector13
vector13:
  pushl $13
  102347:	6a 0d                	push   $0xd
  jmp __alltraps
  102349:	e9 fe 09 00 00       	jmp    102d4c <__alltraps>

0010234e <vector14>:
.globl vector14
vector14:
  pushl $14
  10234e:	6a 0e                	push   $0xe
  jmp __alltraps
  102350:	e9 f7 09 00 00       	jmp    102d4c <__alltraps>

00102355 <vector15>:
.globl vector15
vector15:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $15
  102357:	6a 0f                	push   $0xf
  jmp __alltraps
  102359:	e9 ee 09 00 00       	jmp    102d4c <__alltraps>

0010235e <vector16>:
.globl vector16
vector16:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $16
  102360:	6a 10                	push   $0x10
  jmp __alltraps
  102362:	e9 e5 09 00 00       	jmp    102d4c <__alltraps>

00102367 <vector17>:
.globl vector17
vector17:
  pushl $17
  102367:	6a 11                	push   $0x11
  jmp __alltraps
  102369:	e9 de 09 00 00       	jmp    102d4c <__alltraps>

0010236e <vector18>:
.globl vector18
vector18:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $18
  102370:	6a 12                	push   $0x12
  jmp __alltraps
  102372:	e9 d5 09 00 00       	jmp    102d4c <__alltraps>

00102377 <vector19>:
.globl vector19
vector19:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $19
  102379:	6a 13                	push   $0x13
  jmp __alltraps
  10237b:	e9 cc 09 00 00       	jmp    102d4c <__alltraps>

00102380 <vector20>:
.globl vector20
vector20:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $20
  102382:	6a 14                	push   $0x14
  jmp __alltraps
  102384:	e9 c3 09 00 00       	jmp    102d4c <__alltraps>

00102389 <vector21>:
.globl vector21
vector21:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $21
  10238b:	6a 15                	push   $0x15
  jmp __alltraps
  10238d:	e9 ba 09 00 00       	jmp    102d4c <__alltraps>

00102392 <vector22>:
.globl vector22
vector22:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $22
  102394:	6a 16                	push   $0x16
  jmp __alltraps
  102396:	e9 b1 09 00 00       	jmp    102d4c <__alltraps>

0010239b <vector23>:
.globl vector23
vector23:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $23
  10239d:	6a 17                	push   $0x17
  jmp __alltraps
  10239f:	e9 a8 09 00 00       	jmp    102d4c <__alltraps>

001023a4 <vector24>:
.globl vector24
vector24:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $24
  1023a6:	6a 18                	push   $0x18
  jmp __alltraps
  1023a8:	e9 9f 09 00 00       	jmp    102d4c <__alltraps>

001023ad <vector25>:
.globl vector25
vector25:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $25
  1023af:	6a 19                	push   $0x19
  jmp __alltraps
  1023b1:	e9 96 09 00 00       	jmp    102d4c <__alltraps>

001023b6 <vector26>:
.globl vector26
vector26:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $26
  1023b8:	6a 1a                	push   $0x1a
  jmp __alltraps
  1023ba:	e9 8d 09 00 00       	jmp    102d4c <__alltraps>

001023bf <vector27>:
.globl vector27
vector27:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $27
  1023c1:	6a 1b                	push   $0x1b
  jmp __alltraps
  1023c3:	e9 84 09 00 00       	jmp    102d4c <__alltraps>

001023c8 <vector28>:
.globl vector28
vector28:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $28
  1023ca:	6a 1c                	push   $0x1c
  jmp __alltraps
  1023cc:	e9 7b 09 00 00       	jmp    102d4c <__alltraps>

001023d1 <vector29>:
.globl vector29
vector29:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $29
  1023d3:	6a 1d                	push   $0x1d
  jmp __alltraps
  1023d5:	e9 72 09 00 00       	jmp    102d4c <__alltraps>

001023da <vector30>:
.globl vector30
vector30:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $30
  1023dc:	6a 1e                	push   $0x1e
  jmp __alltraps
  1023de:	e9 69 09 00 00       	jmp    102d4c <__alltraps>

001023e3 <vector31>:
.globl vector31
vector31:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $31
  1023e5:	6a 1f                	push   $0x1f
  jmp __alltraps
  1023e7:	e9 60 09 00 00       	jmp    102d4c <__alltraps>

001023ec <vector32>:
.globl vector32
vector32:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $32
  1023ee:	6a 20                	push   $0x20
  jmp __alltraps
  1023f0:	e9 57 09 00 00       	jmp    102d4c <__alltraps>

001023f5 <vector33>:
.globl vector33
vector33:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $33
  1023f7:	6a 21                	push   $0x21
  jmp __alltraps
  1023f9:	e9 4e 09 00 00       	jmp    102d4c <__alltraps>

001023fe <vector34>:
.globl vector34
vector34:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $34
  102400:	6a 22                	push   $0x22
  jmp __alltraps
  102402:	e9 45 09 00 00       	jmp    102d4c <__alltraps>

00102407 <vector35>:
.globl vector35
vector35:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $35
  102409:	6a 23                	push   $0x23
  jmp __alltraps
  10240b:	e9 3c 09 00 00       	jmp    102d4c <__alltraps>

00102410 <vector36>:
.globl vector36
vector36:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $36
  102412:	6a 24                	push   $0x24
  jmp __alltraps
  102414:	e9 33 09 00 00       	jmp    102d4c <__alltraps>

00102419 <vector37>:
.globl vector37
vector37:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $37
  10241b:	6a 25                	push   $0x25
  jmp __alltraps
  10241d:	e9 2a 09 00 00       	jmp    102d4c <__alltraps>

00102422 <vector38>:
.globl vector38
vector38:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $38
  102424:	6a 26                	push   $0x26
  jmp __alltraps
  102426:	e9 21 09 00 00       	jmp    102d4c <__alltraps>

0010242b <vector39>:
.globl vector39
vector39:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $39
  10242d:	6a 27                	push   $0x27
  jmp __alltraps
  10242f:	e9 18 09 00 00       	jmp    102d4c <__alltraps>

00102434 <vector40>:
.globl vector40
vector40:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $40
  102436:	6a 28                	push   $0x28
  jmp __alltraps
  102438:	e9 0f 09 00 00       	jmp    102d4c <__alltraps>

0010243d <vector41>:
.globl vector41
vector41:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $41
  10243f:	6a 29                	push   $0x29
  jmp __alltraps
  102441:	e9 06 09 00 00       	jmp    102d4c <__alltraps>

00102446 <vector42>:
.globl vector42
vector42:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $42
  102448:	6a 2a                	push   $0x2a
  jmp __alltraps
  10244a:	e9 fd 08 00 00       	jmp    102d4c <__alltraps>

0010244f <vector43>:
.globl vector43
vector43:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $43
  102451:	6a 2b                	push   $0x2b
  jmp __alltraps
  102453:	e9 f4 08 00 00       	jmp    102d4c <__alltraps>

00102458 <vector44>:
.globl vector44
vector44:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $44
  10245a:	6a 2c                	push   $0x2c
  jmp __alltraps
  10245c:	e9 eb 08 00 00       	jmp    102d4c <__alltraps>

00102461 <vector45>:
.globl vector45
vector45:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $45
  102463:	6a 2d                	push   $0x2d
  jmp __alltraps
  102465:	e9 e2 08 00 00       	jmp    102d4c <__alltraps>

0010246a <vector46>:
.globl vector46
vector46:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $46
  10246c:	6a 2e                	push   $0x2e
  jmp __alltraps
  10246e:	e9 d9 08 00 00       	jmp    102d4c <__alltraps>

00102473 <vector47>:
.globl vector47
vector47:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $47
  102475:	6a 2f                	push   $0x2f
  jmp __alltraps
  102477:	e9 d0 08 00 00       	jmp    102d4c <__alltraps>

0010247c <vector48>:
.globl vector48
vector48:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $48
  10247e:	6a 30                	push   $0x30
  jmp __alltraps
  102480:	e9 c7 08 00 00       	jmp    102d4c <__alltraps>

00102485 <vector49>:
.globl vector49
vector49:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $49
  102487:	6a 31                	push   $0x31
  jmp __alltraps
  102489:	e9 be 08 00 00       	jmp    102d4c <__alltraps>

0010248e <vector50>:
.globl vector50
vector50:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $50
  102490:	6a 32                	push   $0x32
  jmp __alltraps
  102492:	e9 b5 08 00 00       	jmp    102d4c <__alltraps>

00102497 <vector51>:
.globl vector51
vector51:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $51
  102499:	6a 33                	push   $0x33
  jmp __alltraps
  10249b:	e9 ac 08 00 00       	jmp    102d4c <__alltraps>

001024a0 <vector52>:
.globl vector52
vector52:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $52
  1024a2:	6a 34                	push   $0x34
  jmp __alltraps
  1024a4:	e9 a3 08 00 00       	jmp    102d4c <__alltraps>

001024a9 <vector53>:
.globl vector53
vector53:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $53
  1024ab:	6a 35                	push   $0x35
  jmp __alltraps
  1024ad:	e9 9a 08 00 00       	jmp    102d4c <__alltraps>

001024b2 <vector54>:
.globl vector54
vector54:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $54
  1024b4:	6a 36                	push   $0x36
  jmp __alltraps
  1024b6:	e9 91 08 00 00       	jmp    102d4c <__alltraps>

001024bb <vector55>:
.globl vector55
vector55:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $55
  1024bd:	6a 37                	push   $0x37
  jmp __alltraps
  1024bf:	e9 88 08 00 00       	jmp    102d4c <__alltraps>

001024c4 <vector56>:
.globl vector56
vector56:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $56
  1024c6:	6a 38                	push   $0x38
  jmp __alltraps
  1024c8:	e9 7f 08 00 00       	jmp    102d4c <__alltraps>

001024cd <vector57>:
.globl vector57
vector57:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $57
  1024cf:	6a 39                	push   $0x39
  jmp __alltraps
  1024d1:	e9 76 08 00 00       	jmp    102d4c <__alltraps>

001024d6 <vector58>:
.globl vector58
vector58:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $58
  1024d8:	6a 3a                	push   $0x3a
  jmp __alltraps
  1024da:	e9 6d 08 00 00       	jmp    102d4c <__alltraps>

001024df <vector59>:
.globl vector59
vector59:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $59
  1024e1:	6a 3b                	push   $0x3b
  jmp __alltraps
  1024e3:	e9 64 08 00 00       	jmp    102d4c <__alltraps>

001024e8 <vector60>:
.globl vector60
vector60:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $60
  1024ea:	6a 3c                	push   $0x3c
  jmp __alltraps
  1024ec:	e9 5b 08 00 00       	jmp    102d4c <__alltraps>

001024f1 <vector61>:
.globl vector61
vector61:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $61
  1024f3:	6a 3d                	push   $0x3d
  jmp __alltraps
  1024f5:	e9 52 08 00 00       	jmp    102d4c <__alltraps>

001024fa <vector62>:
.globl vector62
vector62:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $62
  1024fc:	6a 3e                	push   $0x3e
  jmp __alltraps
  1024fe:	e9 49 08 00 00       	jmp    102d4c <__alltraps>

00102503 <vector63>:
.globl vector63
vector63:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $63
  102505:	6a 3f                	push   $0x3f
  jmp __alltraps
  102507:	e9 40 08 00 00       	jmp    102d4c <__alltraps>

0010250c <vector64>:
.globl vector64
vector64:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $64
  10250e:	6a 40                	push   $0x40
  jmp __alltraps
  102510:	e9 37 08 00 00       	jmp    102d4c <__alltraps>

00102515 <vector65>:
.globl vector65
vector65:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $65
  102517:	6a 41                	push   $0x41
  jmp __alltraps
  102519:	e9 2e 08 00 00       	jmp    102d4c <__alltraps>

0010251e <vector66>:
.globl vector66
vector66:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $66
  102520:	6a 42                	push   $0x42
  jmp __alltraps
  102522:	e9 25 08 00 00       	jmp    102d4c <__alltraps>

00102527 <vector67>:
.globl vector67
vector67:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $67
  102529:	6a 43                	push   $0x43
  jmp __alltraps
  10252b:	e9 1c 08 00 00       	jmp    102d4c <__alltraps>

00102530 <vector68>:
.globl vector68
vector68:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $68
  102532:	6a 44                	push   $0x44
  jmp __alltraps
  102534:	e9 13 08 00 00       	jmp    102d4c <__alltraps>

00102539 <vector69>:
.globl vector69
vector69:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $69
  10253b:	6a 45                	push   $0x45
  jmp __alltraps
  10253d:	e9 0a 08 00 00       	jmp    102d4c <__alltraps>

00102542 <vector70>:
.globl vector70
vector70:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $70
  102544:	6a 46                	push   $0x46
  jmp __alltraps
  102546:	e9 01 08 00 00       	jmp    102d4c <__alltraps>

0010254b <vector71>:
.globl vector71
vector71:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $71
  10254d:	6a 47                	push   $0x47
  jmp __alltraps
  10254f:	e9 f8 07 00 00       	jmp    102d4c <__alltraps>

00102554 <vector72>:
.globl vector72
vector72:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $72
  102556:	6a 48                	push   $0x48
  jmp __alltraps
  102558:	e9 ef 07 00 00       	jmp    102d4c <__alltraps>

0010255d <vector73>:
.globl vector73
vector73:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $73
  10255f:	6a 49                	push   $0x49
  jmp __alltraps
  102561:	e9 e6 07 00 00       	jmp    102d4c <__alltraps>

00102566 <vector74>:
.globl vector74
vector74:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $74
  102568:	6a 4a                	push   $0x4a
  jmp __alltraps
  10256a:	e9 dd 07 00 00       	jmp    102d4c <__alltraps>

0010256f <vector75>:
.globl vector75
vector75:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $75
  102571:	6a 4b                	push   $0x4b
  jmp __alltraps
  102573:	e9 d4 07 00 00       	jmp    102d4c <__alltraps>

00102578 <vector76>:
.globl vector76
vector76:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $76
  10257a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10257c:	e9 cb 07 00 00       	jmp    102d4c <__alltraps>

00102581 <vector77>:
.globl vector77
vector77:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $77
  102583:	6a 4d                	push   $0x4d
  jmp __alltraps
  102585:	e9 c2 07 00 00       	jmp    102d4c <__alltraps>

0010258a <vector78>:
.globl vector78
vector78:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $78
  10258c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10258e:	e9 b9 07 00 00       	jmp    102d4c <__alltraps>

00102593 <vector79>:
.globl vector79
vector79:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $79
  102595:	6a 4f                	push   $0x4f
  jmp __alltraps
  102597:	e9 b0 07 00 00       	jmp    102d4c <__alltraps>

0010259c <vector80>:
.globl vector80
vector80:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $80
  10259e:	6a 50                	push   $0x50
  jmp __alltraps
  1025a0:	e9 a7 07 00 00       	jmp    102d4c <__alltraps>

001025a5 <vector81>:
.globl vector81
vector81:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $81
  1025a7:	6a 51                	push   $0x51
  jmp __alltraps
  1025a9:	e9 9e 07 00 00       	jmp    102d4c <__alltraps>

001025ae <vector82>:
.globl vector82
vector82:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $82
  1025b0:	6a 52                	push   $0x52
  jmp __alltraps
  1025b2:	e9 95 07 00 00       	jmp    102d4c <__alltraps>

001025b7 <vector83>:
.globl vector83
vector83:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $83
  1025b9:	6a 53                	push   $0x53
  jmp __alltraps
  1025bb:	e9 8c 07 00 00       	jmp    102d4c <__alltraps>

001025c0 <vector84>:
.globl vector84
vector84:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $84
  1025c2:	6a 54                	push   $0x54
  jmp __alltraps
  1025c4:	e9 83 07 00 00       	jmp    102d4c <__alltraps>

001025c9 <vector85>:
.globl vector85
vector85:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $85
  1025cb:	6a 55                	push   $0x55
  jmp __alltraps
  1025cd:	e9 7a 07 00 00       	jmp    102d4c <__alltraps>

001025d2 <vector86>:
.globl vector86
vector86:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $86
  1025d4:	6a 56                	push   $0x56
  jmp __alltraps
  1025d6:	e9 71 07 00 00       	jmp    102d4c <__alltraps>

001025db <vector87>:
.globl vector87
vector87:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $87
  1025dd:	6a 57                	push   $0x57
  jmp __alltraps
  1025df:	e9 68 07 00 00       	jmp    102d4c <__alltraps>

001025e4 <vector88>:
.globl vector88
vector88:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $88
  1025e6:	6a 58                	push   $0x58
  jmp __alltraps
  1025e8:	e9 5f 07 00 00       	jmp    102d4c <__alltraps>

001025ed <vector89>:
.globl vector89
vector89:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $89
  1025ef:	6a 59                	push   $0x59
  jmp __alltraps
  1025f1:	e9 56 07 00 00       	jmp    102d4c <__alltraps>

001025f6 <vector90>:
.globl vector90
vector90:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $90
  1025f8:	6a 5a                	push   $0x5a
  jmp __alltraps
  1025fa:	e9 4d 07 00 00       	jmp    102d4c <__alltraps>

001025ff <vector91>:
.globl vector91
vector91:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $91
  102601:	6a 5b                	push   $0x5b
  jmp __alltraps
  102603:	e9 44 07 00 00       	jmp    102d4c <__alltraps>

00102608 <vector92>:
.globl vector92
vector92:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $92
  10260a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10260c:	e9 3b 07 00 00       	jmp    102d4c <__alltraps>

00102611 <vector93>:
.globl vector93
vector93:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $93
  102613:	6a 5d                	push   $0x5d
  jmp __alltraps
  102615:	e9 32 07 00 00       	jmp    102d4c <__alltraps>

0010261a <vector94>:
.globl vector94
vector94:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $94
  10261c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10261e:	e9 29 07 00 00       	jmp    102d4c <__alltraps>

00102623 <vector95>:
.globl vector95
vector95:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $95
  102625:	6a 5f                	push   $0x5f
  jmp __alltraps
  102627:	e9 20 07 00 00       	jmp    102d4c <__alltraps>

0010262c <vector96>:
.globl vector96
vector96:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $96
  10262e:	6a 60                	push   $0x60
  jmp __alltraps
  102630:	e9 17 07 00 00       	jmp    102d4c <__alltraps>

00102635 <vector97>:
.globl vector97
vector97:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $97
  102637:	6a 61                	push   $0x61
  jmp __alltraps
  102639:	e9 0e 07 00 00       	jmp    102d4c <__alltraps>

0010263e <vector98>:
.globl vector98
vector98:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $98
  102640:	6a 62                	push   $0x62
  jmp __alltraps
  102642:	e9 05 07 00 00       	jmp    102d4c <__alltraps>

00102647 <vector99>:
.globl vector99
vector99:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $99
  102649:	6a 63                	push   $0x63
  jmp __alltraps
  10264b:	e9 fc 06 00 00       	jmp    102d4c <__alltraps>

00102650 <vector100>:
.globl vector100
vector100:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $100
  102652:	6a 64                	push   $0x64
  jmp __alltraps
  102654:	e9 f3 06 00 00       	jmp    102d4c <__alltraps>

00102659 <vector101>:
.globl vector101
vector101:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $101
  10265b:	6a 65                	push   $0x65
  jmp __alltraps
  10265d:	e9 ea 06 00 00       	jmp    102d4c <__alltraps>

00102662 <vector102>:
.globl vector102
vector102:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $102
  102664:	6a 66                	push   $0x66
  jmp __alltraps
  102666:	e9 e1 06 00 00       	jmp    102d4c <__alltraps>

0010266b <vector103>:
.globl vector103
vector103:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $103
  10266d:	6a 67                	push   $0x67
  jmp __alltraps
  10266f:	e9 d8 06 00 00       	jmp    102d4c <__alltraps>

00102674 <vector104>:
.globl vector104
vector104:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $104
  102676:	6a 68                	push   $0x68
  jmp __alltraps
  102678:	e9 cf 06 00 00       	jmp    102d4c <__alltraps>

0010267d <vector105>:
.globl vector105
vector105:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $105
  10267f:	6a 69                	push   $0x69
  jmp __alltraps
  102681:	e9 c6 06 00 00       	jmp    102d4c <__alltraps>

00102686 <vector106>:
.globl vector106
vector106:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $106
  102688:	6a 6a                	push   $0x6a
  jmp __alltraps
  10268a:	e9 bd 06 00 00       	jmp    102d4c <__alltraps>

0010268f <vector107>:
.globl vector107
vector107:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $107
  102691:	6a 6b                	push   $0x6b
  jmp __alltraps
  102693:	e9 b4 06 00 00       	jmp    102d4c <__alltraps>

00102698 <vector108>:
.globl vector108
vector108:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $108
  10269a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10269c:	e9 ab 06 00 00       	jmp    102d4c <__alltraps>

001026a1 <vector109>:
.globl vector109
vector109:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $109
  1026a3:	6a 6d                	push   $0x6d
  jmp __alltraps
  1026a5:	e9 a2 06 00 00       	jmp    102d4c <__alltraps>

001026aa <vector110>:
.globl vector110
vector110:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $110
  1026ac:	6a 6e                	push   $0x6e
  jmp __alltraps
  1026ae:	e9 99 06 00 00       	jmp    102d4c <__alltraps>

001026b3 <vector111>:
.globl vector111
vector111:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $111
  1026b5:	6a 6f                	push   $0x6f
  jmp __alltraps
  1026b7:	e9 90 06 00 00       	jmp    102d4c <__alltraps>

001026bc <vector112>:
.globl vector112
vector112:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $112
  1026be:	6a 70                	push   $0x70
  jmp __alltraps
  1026c0:	e9 87 06 00 00       	jmp    102d4c <__alltraps>

001026c5 <vector113>:
.globl vector113
vector113:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $113
  1026c7:	6a 71                	push   $0x71
  jmp __alltraps
  1026c9:	e9 7e 06 00 00       	jmp    102d4c <__alltraps>

001026ce <vector114>:
.globl vector114
vector114:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $114
  1026d0:	6a 72                	push   $0x72
  jmp __alltraps
  1026d2:	e9 75 06 00 00       	jmp    102d4c <__alltraps>

001026d7 <vector115>:
.globl vector115
vector115:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $115
  1026d9:	6a 73                	push   $0x73
  jmp __alltraps
  1026db:	e9 6c 06 00 00       	jmp    102d4c <__alltraps>

001026e0 <vector116>:
.globl vector116
vector116:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $116
  1026e2:	6a 74                	push   $0x74
  jmp __alltraps
  1026e4:	e9 63 06 00 00       	jmp    102d4c <__alltraps>

001026e9 <vector117>:
.globl vector117
vector117:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $117
  1026eb:	6a 75                	push   $0x75
  jmp __alltraps
  1026ed:	e9 5a 06 00 00       	jmp    102d4c <__alltraps>

001026f2 <vector118>:
.globl vector118
vector118:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $118
  1026f4:	6a 76                	push   $0x76
  jmp __alltraps
  1026f6:	e9 51 06 00 00       	jmp    102d4c <__alltraps>

001026fb <vector119>:
.globl vector119
vector119:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $119
  1026fd:	6a 77                	push   $0x77
  jmp __alltraps
  1026ff:	e9 48 06 00 00       	jmp    102d4c <__alltraps>

00102704 <vector120>:
.globl vector120
vector120:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $120
  102706:	6a 78                	push   $0x78
  jmp __alltraps
  102708:	e9 3f 06 00 00       	jmp    102d4c <__alltraps>

0010270d <vector121>:
.globl vector121
vector121:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $121
  10270f:	6a 79                	push   $0x79
  jmp __alltraps
  102711:	e9 36 06 00 00       	jmp    102d4c <__alltraps>

00102716 <vector122>:
.globl vector122
vector122:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $122
  102718:	6a 7a                	push   $0x7a
  jmp __alltraps
  10271a:	e9 2d 06 00 00       	jmp    102d4c <__alltraps>

0010271f <vector123>:
.globl vector123
vector123:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $123
  102721:	6a 7b                	push   $0x7b
  jmp __alltraps
  102723:	e9 24 06 00 00       	jmp    102d4c <__alltraps>

00102728 <vector124>:
.globl vector124
vector124:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $124
  10272a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10272c:	e9 1b 06 00 00       	jmp    102d4c <__alltraps>

00102731 <vector125>:
.globl vector125
vector125:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $125
  102733:	6a 7d                	push   $0x7d
  jmp __alltraps
  102735:	e9 12 06 00 00       	jmp    102d4c <__alltraps>

0010273a <vector126>:
.globl vector126
vector126:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $126
  10273c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10273e:	e9 09 06 00 00       	jmp    102d4c <__alltraps>

00102743 <vector127>:
.globl vector127
vector127:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $127
  102745:	6a 7f                	push   $0x7f
  jmp __alltraps
  102747:	e9 00 06 00 00       	jmp    102d4c <__alltraps>

0010274c <vector128>:
.globl vector128
vector128:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $128
  10274e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102753:	e9 f4 05 00 00       	jmp    102d4c <__alltraps>

00102758 <vector129>:
.globl vector129
vector129:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $129
  10275a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10275f:	e9 e8 05 00 00       	jmp    102d4c <__alltraps>

00102764 <vector130>:
.globl vector130
vector130:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $130
  102766:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10276b:	e9 dc 05 00 00       	jmp    102d4c <__alltraps>

00102770 <vector131>:
.globl vector131
vector131:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $131
  102772:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102777:	e9 d0 05 00 00       	jmp    102d4c <__alltraps>

0010277c <vector132>:
.globl vector132
vector132:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $132
  10277e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102783:	e9 c4 05 00 00       	jmp    102d4c <__alltraps>

00102788 <vector133>:
.globl vector133
vector133:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $133
  10278a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10278f:	e9 b8 05 00 00       	jmp    102d4c <__alltraps>

00102794 <vector134>:
.globl vector134
vector134:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $134
  102796:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10279b:	e9 ac 05 00 00       	jmp    102d4c <__alltraps>

001027a0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $135
  1027a2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1027a7:	e9 a0 05 00 00       	jmp    102d4c <__alltraps>

001027ac <vector136>:
.globl vector136
vector136:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $136
  1027ae:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1027b3:	e9 94 05 00 00       	jmp    102d4c <__alltraps>

001027b8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $137
  1027ba:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1027bf:	e9 88 05 00 00       	jmp    102d4c <__alltraps>

001027c4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $138
  1027c6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1027cb:	e9 7c 05 00 00       	jmp    102d4c <__alltraps>

001027d0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $139
  1027d2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1027d7:	e9 70 05 00 00       	jmp    102d4c <__alltraps>

001027dc <vector140>:
.globl vector140
vector140:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $140
  1027de:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1027e3:	e9 64 05 00 00       	jmp    102d4c <__alltraps>

001027e8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $141
  1027ea:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1027ef:	e9 58 05 00 00       	jmp    102d4c <__alltraps>

001027f4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $142
  1027f6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1027fb:	e9 4c 05 00 00       	jmp    102d4c <__alltraps>

00102800 <vector143>:
.globl vector143
vector143:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $143
  102802:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102807:	e9 40 05 00 00       	jmp    102d4c <__alltraps>

0010280c <vector144>:
.globl vector144
vector144:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $144
  10280e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102813:	e9 34 05 00 00       	jmp    102d4c <__alltraps>

00102818 <vector145>:
.globl vector145
vector145:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $145
  10281a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10281f:	e9 28 05 00 00       	jmp    102d4c <__alltraps>

00102824 <vector146>:
.globl vector146
vector146:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $146
  102826:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10282b:	e9 1c 05 00 00       	jmp    102d4c <__alltraps>

00102830 <vector147>:
.globl vector147
vector147:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $147
  102832:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102837:	e9 10 05 00 00       	jmp    102d4c <__alltraps>

0010283c <vector148>:
.globl vector148
vector148:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $148
  10283e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102843:	e9 04 05 00 00       	jmp    102d4c <__alltraps>

00102848 <vector149>:
.globl vector149
vector149:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $149
  10284a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10284f:	e9 f8 04 00 00       	jmp    102d4c <__alltraps>

00102854 <vector150>:
.globl vector150
vector150:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $150
  102856:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10285b:	e9 ec 04 00 00       	jmp    102d4c <__alltraps>

00102860 <vector151>:
.globl vector151
vector151:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $151
  102862:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102867:	e9 e0 04 00 00       	jmp    102d4c <__alltraps>

0010286c <vector152>:
.globl vector152
vector152:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $152
  10286e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102873:	e9 d4 04 00 00       	jmp    102d4c <__alltraps>

00102878 <vector153>:
.globl vector153
vector153:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $153
  10287a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10287f:	e9 c8 04 00 00       	jmp    102d4c <__alltraps>

00102884 <vector154>:
.globl vector154
vector154:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $154
  102886:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10288b:	e9 bc 04 00 00       	jmp    102d4c <__alltraps>

00102890 <vector155>:
.globl vector155
vector155:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $155
  102892:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102897:	e9 b0 04 00 00       	jmp    102d4c <__alltraps>

0010289c <vector156>:
.globl vector156
vector156:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $156
  10289e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1028a3:	e9 a4 04 00 00       	jmp    102d4c <__alltraps>

001028a8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $157
  1028aa:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1028af:	e9 98 04 00 00       	jmp    102d4c <__alltraps>

001028b4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $158
  1028b6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1028bb:	e9 8c 04 00 00       	jmp    102d4c <__alltraps>

001028c0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $159
  1028c2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1028c7:	e9 80 04 00 00       	jmp    102d4c <__alltraps>

001028cc <vector160>:
.globl vector160
vector160:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $160
  1028ce:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1028d3:	e9 74 04 00 00       	jmp    102d4c <__alltraps>

001028d8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $161
  1028da:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1028df:	e9 68 04 00 00       	jmp    102d4c <__alltraps>

001028e4 <vector162>:
.globl vector162
vector162:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $162
  1028e6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1028eb:	e9 5c 04 00 00       	jmp    102d4c <__alltraps>

001028f0 <vector163>:
.globl vector163
vector163:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $163
  1028f2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1028f7:	e9 50 04 00 00       	jmp    102d4c <__alltraps>

001028fc <vector164>:
.globl vector164
vector164:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $164
  1028fe:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102903:	e9 44 04 00 00       	jmp    102d4c <__alltraps>

00102908 <vector165>:
.globl vector165
vector165:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $165
  10290a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10290f:	e9 38 04 00 00       	jmp    102d4c <__alltraps>

00102914 <vector166>:
.globl vector166
vector166:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $166
  102916:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10291b:	e9 2c 04 00 00       	jmp    102d4c <__alltraps>

00102920 <vector167>:
.globl vector167
vector167:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $167
  102922:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102927:	e9 20 04 00 00       	jmp    102d4c <__alltraps>

0010292c <vector168>:
.globl vector168
vector168:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $168
  10292e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102933:	e9 14 04 00 00       	jmp    102d4c <__alltraps>

00102938 <vector169>:
.globl vector169
vector169:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $169
  10293a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10293f:	e9 08 04 00 00       	jmp    102d4c <__alltraps>

00102944 <vector170>:
.globl vector170
vector170:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $170
  102946:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10294b:	e9 fc 03 00 00       	jmp    102d4c <__alltraps>

00102950 <vector171>:
.globl vector171
vector171:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $171
  102952:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102957:	e9 f0 03 00 00       	jmp    102d4c <__alltraps>

0010295c <vector172>:
.globl vector172
vector172:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $172
  10295e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102963:	e9 e4 03 00 00       	jmp    102d4c <__alltraps>

00102968 <vector173>:
.globl vector173
vector173:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $173
  10296a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10296f:	e9 d8 03 00 00       	jmp    102d4c <__alltraps>

00102974 <vector174>:
.globl vector174
vector174:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $174
  102976:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10297b:	e9 cc 03 00 00       	jmp    102d4c <__alltraps>

00102980 <vector175>:
.globl vector175
vector175:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $175
  102982:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102987:	e9 c0 03 00 00       	jmp    102d4c <__alltraps>

0010298c <vector176>:
.globl vector176
vector176:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $176
  10298e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102993:	e9 b4 03 00 00       	jmp    102d4c <__alltraps>

00102998 <vector177>:
.globl vector177
vector177:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $177
  10299a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10299f:	e9 a8 03 00 00       	jmp    102d4c <__alltraps>

001029a4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $178
  1029a6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1029ab:	e9 9c 03 00 00       	jmp    102d4c <__alltraps>

001029b0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1029b0:	6a 00                	push   $0x0
  pushl $179
  1029b2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1029b7:	e9 90 03 00 00       	jmp    102d4c <__alltraps>

001029bc <vector180>:
.globl vector180
vector180:
  pushl $0
  1029bc:	6a 00                	push   $0x0
  pushl $180
  1029be:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1029c3:	e9 84 03 00 00       	jmp    102d4c <__alltraps>

001029c8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1029c8:	6a 00                	push   $0x0
  pushl $181
  1029ca:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1029cf:	e9 78 03 00 00       	jmp    102d4c <__alltraps>

001029d4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1029d4:	6a 00                	push   $0x0
  pushl $182
  1029d6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1029db:	e9 6c 03 00 00       	jmp    102d4c <__alltraps>

001029e0 <vector183>:
.globl vector183
vector183:
  pushl $0
  1029e0:	6a 00                	push   $0x0
  pushl $183
  1029e2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1029e7:	e9 60 03 00 00       	jmp    102d4c <__alltraps>

001029ec <vector184>:
.globl vector184
vector184:
  pushl $0
  1029ec:	6a 00                	push   $0x0
  pushl $184
  1029ee:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1029f3:	e9 54 03 00 00       	jmp    102d4c <__alltraps>

001029f8 <vector185>:
.globl vector185
vector185:
  pushl $0
  1029f8:	6a 00                	push   $0x0
  pushl $185
  1029fa:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1029ff:	e9 48 03 00 00       	jmp    102d4c <__alltraps>

00102a04 <vector186>:
.globl vector186
vector186:
  pushl $0
  102a04:	6a 00                	push   $0x0
  pushl $186
  102a06:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102a0b:	e9 3c 03 00 00       	jmp    102d4c <__alltraps>

00102a10 <vector187>:
.globl vector187
vector187:
  pushl $0
  102a10:	6a 00                	push   $0x0
  pushl $187
  102a12:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102a17:	e9 30 03 00 00       	jmp    102d4c <__alltraps>

00102a1c <vector188>:
.globl vector188
vector188:
  pushl $0
  102a1c:	6a 00                	push   $0x0
  pushl $188
  102a1e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102a23:	e9 24 03 00 00       	jmp    102d4c <__alltraps>

00102a28 <vector189>:
.globl vector189
vector189:
  pushl $0
  102a28:	6a 00                	push   $0x0
  pushl $189
  102a2a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102a2f:	e9 18 03 00 00       	jmp    102d4c <__alltraps>

00102a34 <vector190>:
.globl vector190
vector190:
  pushl $0
  102a34:	6a 00                	push   $0x0
  pushl $190
  102a36:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102a3b:	e9 0c 03 00 00       	jmp    102d4c <__alltraps>

00102a40 <vector191>:
.globl vector191
vector191:
  pushl $0
  102a40:	6a 00                	push   $0x0
  pushl $191
  102a42:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102a47:	e9 00 03 00 00       	jmp    102d4c <__alltraps>

00102a4c <vector192>:
.globl vector192
vector192:
  pushl $0
  102a4c:	6a 00                	push   $0x0
  pushl $192
  102a4e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102a53:	e9 f4 02 00 00       	jmp    102d4c <__alltraps>

00102a58 <vector193>:
.globl vector193
vector193:
  pushl $0
  102a58:	6a 00                	push   $0x0
  pushl $193
  102a5a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102a5f:	e9 e8 02 00 00       	jmp    102d4c <__alltraps>

00102a64 <vector194>:
.globl vector194
vector194:
  pushl $0
  102a64:	6a 00                	push   $0x0
  pushl $194
  102a66:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102a6b:	e9 dc 02 00 00       	jmp    102d4c <__alltraps>

00102a70 <vector195>:
.globl vector195
vector195:
  pushl $0
  102a70:	6a 00                	push   $0x0
  pushl $195
  102a72:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102a77:	e9 d0 02 00 00       	jmp    102d4c <__alltraps>

00102a7c <vector196>:
.globl vector196
vector196:
  pushl $0
  102a7c:	6a 00                	push   $0x0
  pushl $196
  102a7e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a83:	e9 c4 02 00 00       	jmp    102d4c <__alltraps>

00102a88 <vector197>:
.globl vector197
vector197:
  pushl $0
  102a88:	6a 00                	push   $0x0
  pushl $197
  102a8a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a8f:	e9 b8 02 00 00       	jmp    102d4c <__alltraps>

00102a94 <vector198>:
.globl vector198
vector198:
  pushl $0
  102a94:	6a 00                	push   $0x0
  pushl $198
  102a96:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a9b:	e9 ac 02 00 00       	jmp    102d4c <__alltraps>

00102aa0 <vector199>:
.globl vector199
vector199:
  pushl $0
  102aa0:	6a 00                	push   $0x0
  pushl $199
  102aa2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102aa7:	e9 a0 02 00 00       	jmp    102d4c <__alltraps>

00102aac <vector200>:
.globl vector200
vector200:
  pushl $0
  102aac:	6a 00                	push   $0x0
  pushl $200
  102aae:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102ab3:	e9 94 02 00 00       	jmp    102d4c <__alltraps>

00102ab8 <vector201>:
.globl vector201
vector201:
  pushl $0
  102ab8:	6a 00                	push   $0x0
  pushl $201
  102aba:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102abf:	e9 88 02 00 00       	jmp    102d4c <__alltraps>

00102ac4 <vector202>:
.globl vector202
vector202:
  pushl $0
  102ac4:	6a 00                	push   $0x0
  pushl $202
  102ac6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102acb:	e9 7c 02 00 00       	jmp    102d4c <__alltraps>

00102ad0 <vector203>:
.globl vector203
vector203:
  pushl $0
  102ad0:	6a 00                	push   $0x0
  pushl $203
  102ad2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102ad7:	e9 70 02 00 00       	jmp    102d4c <__alltraps>

00102adc <vector204>:
.globl vector204
vector204:
  pushl $0
  102adc:	6a 00                	push   $0x0
  pushl $204
  102ade:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102ae3:	e9 64 02 00 00       	jmp    102d4c <__alltraps>

00102ae8 <vector205>:
.globl vector205
vector205:
  pushl $0
  102ae8:	6a 00                	push   $0x0
  pushl $205
  102aea:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102aef:	e9 58 02 00 00       	jmp    102d4c <__alltraps>

00102af4 <vector206>:
.globl vector206
vector206:
  pushl $0
  102af4:	6a 00                	push   $0x0
  pushl $206
  102af6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102afb:	e9 4c 02 00 00       	jmp    102d4c <__alltraps>

00102b00 <vector207>:
.globl vector207
vector207:
  pushl $0
  102b00:	6a 00                	push   $0x0
  pushl $207
  102b02:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102b07:	e9 40 02 00 00       	jmp    102d4c <__alltraps>

00102b0c <vector208>:
.globl vector208
vector208:
  pushl $0
  102b0c:	6a 00                	push   $0x0
  pushl $208
  102b0e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102b13:	e9 34 02 00 00       	jmp    102d4c <__alltraps>

00102b18 <vector209>:
.globl vector209
vector209:
  pushl $0
  102b18:	6a 00                	push   $0x0
  pushl $209
  102b1a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102b1f:	e9 28 02 00 00       	jmp    102d4c <__alltraps>

00102b24 <vector210>:
.globl vector210
vector210:
  pushl $0
  102b24:	6a 00                	push   $0x0
  pushl $210
  102b26:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102b2b:	e9 1c 02 00 00       	jmp    102d4c <__alltraps>

00102b30 <vector211>:
.globl vector211
vector211:
  pushl $0
  102b30:	6a 00                	push   $0x0
  pushl $211
  102b32:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102b37:	e9 10 02 00 00       	jmp    102d4c <__alltraps>

00102b3c <vector212>:
.globl vector212
vector212:
  pushl $0
  102b3c:	6a 00                	push   $0x0
  pushl $212
  102b3e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102b43:	e9 04 02 00 00       	jmp    102d4c <__alltraps>

00102b48 <vector213>:
.globl vector213
vector213:
  pushl $0
  102b48:	6a 00                	push   $0x0
  pushl $213
  102b4a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102b4f:	e9 f8 01 00 00       	jmp    102d4c <__alltraps>

00102b54 <vector214>:
.globl vector214
vector214:
  pushl $0
  102b54:	6a 00                	push   $0x0
  pushl $214
  102b56:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102b5b:	e9 ec 01 00 00       	jmp    102d4c <__alltraps>

00102b60 <vector215>:
.globl vector215
vector215:
  pushl $0
  102b60:	6a 00                	push   $0x0
  pushl $215
  102b62:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102b67:	e9 e0 01 00 00       	jmp    102d4c <__alltraps>

00102b6c <vector216>:
.globl vector216
vector216:
  pushl $0
  102b6c:	6a 00                	push   $0x0
  pushl $216
  102b6e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102b73:	e9 d4 01 00 00       	jmp    102d4c <__alltraps>

00102b78 <vector217>:
.globl vector217
vector217:
  pushl $0
  102b78:	6a 00                	push   $0x0
  pushl $217
  102b7a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102b7f:	e9 c8 01 00 00       	jmp    102d4c <__alltraps>

00102b84 <vector218>:
.globl vector218
vector218:
  pushl $0
  102b84:	6a 00                	push   $0x0
  pushl $218
  102b86:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b8b:	e9 bc 01 00 00       	jmp    102d4c <__alltraps>

00102b90 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b90:	6a 00                	push   $0x0
  pushl $219
  102b92:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b97:	e9 b0 01 00 00       	jmp    102d4c <__alltraps>

00102b9c <vector220>:
.globl vector220
vector220:
  pushl $0
  102b9c:	6a 00                	push   $0x0
  pushl $220
  102b9e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102ba3:	e9 a4 01 00 00       	jmp    102d4c <__alltraps>

00102ba8 <vector221>:
.globl vector221
vector221:
  pushl $0
  102ba8:	6a 00                	push   $0x0
  pushl $221
  102baa:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102baf:	e9 98 01 00 00       	jmp    102d4c <__alltraps>

00102bb4 <vector222>:
.globl vector222
vector222:
  pushl $0
  102bb4:	6a 00                	push   $0x0
  pushl $222
  102bb6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102bbb:	e9 8c 01 00 00       	jmp    102d4c <__alltraps>

00102bc0 <vector223>:
.globl vector223
vector223:
  pushl $0
  102bc0:	6a 00                	push   $0x0
  pushl $223
  102bc2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102bc7:	e9 80 01 00 00       	jmp    102d4c <__alltraps>

00102bcc <vector224>:
.globl vector224
vector224:
  pushl $0
  102bcc:	6a 00                	push   $0x0
  pushl $224
  102bce:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102bd3:	e9 74 01 00 00       	jmp    102d4c <__alltraps>

00102bd8 <vector225>:
.globl vector225
vector225:
  pushl $0
  102bd8:	6a 00                	push   $0x0
  pushl $225
  102bda:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102bdf:	e9 68 01 00 00       	jmp    102d4c <__alltraps>

00102be4 <vector226>:
.globl vector226
vector226:
  pushl $0
  102be4:	6a 00                	push   $0x0
  pushl $226
  102be6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102beb:	e9 5c 01 00 00       	jmp    102d4c <__alltraps>

00102bf0 <vector227>:
.globl vector227
vector227:
  pushl $0
  102bf0:	6a 00                	push   $0x0
  pushl $227
  102bf2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102bf7:	e9 50 01 00 00       	jmp    102d4c <__alltraps>

00102bfc <vector228>:
.globl vector228
vector228:
  pushl $0
  102bfc:	6a 00                	push   $0x0
  pushl $228
  102bfe:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102c03:	e9 44 01 00 00       	jmp    102d4c <__alltraps>

00102c08 <vector229>:
.globl vector229
vector229:
  pushl $0
  102c08:	6a 00                	push   $0x0
  pushl $229
  102c0a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102c0f:	e9 38 01 00 00       	jmp    102d4c <__alltraps>

00102c14 <vector230>:
.globl vector230
vector230:
  pushl $0
  102c14:	6a 00                	push   $0x0
  pushl $230
  102c16:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102c1b:	e9 2c 01 00 00       	jmp    102d4c <__alltraps>

00102c20 <vector231>:
.globl vector231
vector231:
  pushl $0
  102c20:	6a 00                	push   $0x0
  pushl $231
  102c22:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102c27:	e9 20 01 00 00       	jmp    102d4c <__alltraps>

00102c2c <vector232>:
.globl vector232
vector232:
  pushl $0
  102c2c:	6a 00                	push   $0x0
  pushl $232
  102c2e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102c33:	e9 14 01 00 00       	jmp    102d4c <__alltraps>

00102c38 <vector233>:
.globl vector233
vector233:
  pushl $0
  102c38:	6a 00                	push   $0x0
  pushl $233
  102c3a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102c3f:	e9 08 01 00 00       	jmp    102d4c <__alltraps>

00102c44 <vector234>:
.globl vector234
vector234:
  pushl $0
  102c44:	6a 00                	push   $0x0
  pushl $234
  102c46:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102c4b:	e9 fc 00 00 00       	jmp    102d4c <__alltraps>

00102c50 <vector235>:
.globl vector235
vector235:
  pushl $0
  102c50:	6a 00                	push   $0x0
  pushl $235
  102c52:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102c57:	e9 f0 00 00 00       	jmp    102d4c <__alltraps>

00102c5c <vector236>:
.globl vector236
vector236:
  pushl $0
  102c5c:	6a 00                	push   $0x0
  pushl $236
  102c5e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102c63:	e9 e4 00 00 00       	jmp    102d4c <__alltraps>

00102c68 <vector237>:
.globl vector237
vector237:
  pushl $0
  102c68:	6a 00                	push   $0x0
  pushl $237
  102c6a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102c6f:	e9 d8 00 00 00       	jmp    102d4c <__alltraps>

00102c74 <vector238>:
.globl vector238
vector238:
  pushl $0
  102c74:	6a 00                	push   $0x0
  pushl $238
  102c76:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102c7b:	e9 cc 00 00 00       	jmp    102d4c <__alltraps>

00102c80 <vector239>:
.globl vector239
vector239:
  pushl $0
  102c80:	6a 00                	push   $0x0
  pushl $239
  102c82:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c87:	e9 c0 00 00 00       	jmp    102d4c <__alltraps>

00102c8c <vector240>:
.globl vector240
vector240:
  pushl $0
  102c8c:	6a 00                	push   $0x0
  pushl $240
  102c8e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c93:	e9 b4 00 00 00       	jmp    102d4c <__alltraps>

00102c98 <vector241>:
.globl vector241
vector241:
  pushl $0
  102c98:	6a 00                	push   $0x0
  pushl $241
  102c9a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c9f:	e9 a8 00 00 00       	jmp    102d4c <__alltraps>

00102ca4 <vector242>:
.globl vector242
vector242:
  pushl $0
  102ca4:	6a 00                	push   $0x0
  pushl $242
  102ca6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102cab:	e9 9c 00 00 00       	jmp    102d4c <__alltraps>

00102cb0 <vector243>:
.globl vector243
vector243:
  pushl $0
  102cb0:	6a 00                	push   $0x0
  pushl $243
  102cb2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102cb7:	e9 90 00 00 00       	jmp    102d4c <__alltraps>

00102cbc <vector244>:
.globl vector244
vector244:
  pushl $0
  102cbc:	6a 00                	push   $0x0
  pushl $244
  102cbe:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102cc3:	e9 84 00 00 00       	jmp    102d4c <__alltraps>

00102cc8 <vector245>:
.globl vector245
vector245:
  pushl $0
  102cc8:	6a 00                	push   $0x0
  pushl $245
  102cca:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102ccf:	e9 78 00 00 00       	jmp    102d4c <__alltraps>

00102cd4 <vector246>:
.globl vector246
vector246:
  pushl $0
  102cd4:	6a 00                	push   $0x0
  pushl $246
  102cd6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102cdb:	e9 6c 00 00 00       	jmp    102d4c <__alltraps>

00102ce0 <vector247>:
.globl vector247
vector247:
  pushl $0
  102ce0:	6a 00                	push   $0x0
  pushl $247
  102ce2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102ce7:	e9 60 00 00 00       	jmp    102d4c <__alltraps>

00102cec <vector248>:
.globl vector248
vector248:
  pushl $0
  102cec:	6a 00                	push   $0x0
  pushl $248
  102cee:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102cf3:	e9 54 00 00 00       	jmp    102d4c <__alltraps>

00102cf8 <vector249>:
.globl vector249
vector249:
  pushl $0
  102cf8:	6a 00                	push   $0x0
  pushl $249
  102cfa:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102cff:	e9 48 00 00 00       	jmp    102d4c <__alltraps>

00102d04 <vector250>:
.globl vector250
vector250:
  pushl $0
  102d04:	6a 00                	push   $0x0
  pushl $250
  102d06:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102d0b:	e9 3c 00 00 00       	jmp    102d4c <__alltraps>

00102d10 <vector251>:
.globl vector251
vector251:
  pushl $0
  102d10:	6a 00                	push   $0x0
  pushl $251
  102d12:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102d17:	e9 30 00 00 00       	jmp    102d4c <__alltraps>

00102d1c <vector252>:
.globl vector252
vector252:
  pushl $0
  102d1c:	6a 00                	push   $0x0
  pushl $252
  102d1e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102d23:	e9 24 00 00 00       	jmp    102d4c <__alltraps>

00102d28 <vector253>:
.globl vector253
vector253:
  pushl $0
  102d28:	6a 00                	push   $0x0
  pushl $253
  102d2a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102d2f:	e9 18 00 00 00       	jmp    102d4c <__alltraps>

00102d34 <vector254>:
.globl vector254
vector254:
  pushl $0
  102d34:	6a 00                	push   $0x0
  pushl $254
  102d36:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102d3b:	e9 0c 00 00 00       	jmp    102d4c <__alltraps>

00102d40 <vector255>:
.globl vector255
vector255:
  pushl $0
  102d40:	6a 00                	push   $0x0
  pushl $255
  102d42:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102d47:	e9 00 00 00 00       	jmp    102d4c <__alltraps>

00102d4c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102d4c:	1e                   	push   %ds
    pushl %es
  102d4d:	06                   	push   %es
    pushl %fs
  102d4e:	0f a0                	push   %fs
    pushl %gs
  102d50:	0f a8                	push   %gs
    pushal
  102d52:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102d53:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102d58:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102d5a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102d5c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102d5d:	e8 60 f5 ff ff       	call   1022c2 <trap>

    # pop the pushed stack pointer
    popl %esp
  102d62:	5c                   	pop    %esp

00102d63 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102d63:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102d64:	0f a9                	pop    %gs
    popl %fs
  102d66:	0f a1                	pop    %fs
    popl %es
  102d68:	07                   	pop    %es
    popl %ds
  102d69:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102d6a:	83 c4 08             	add    $0x8,%esp
    iret
  102d6d:	cf                   	iret   

00102d6e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d6e:	55                   	push   %ebp
  102d6f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d77:	b8 23 00 00 00       	mov    $0x23,%eax
  102d7c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d7e:	b8 23 00 00 00       	mov    $0x23,%eax
  102d83:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d85:	b8 10 00 00 00       	mov    $0x10,%eax
  102d8a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102d8c:	b8 10 00 00 00       	mov    $0x10,%eax
  102d91:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102d93:	b8 10 00 00 00       	mov    $0x10,%eax
  102d98:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102d9a:	ea a1 2d 10 00 08 00 	ljmp   $0x8,$0x102da1
}
  102da1:	90                   	nop
  102da2:	5d                   	pop    %ebp
  102da3:	c3                   	ret    

00102da4 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102da4:	f3 0f 1e fb          	endbr32 
  102da8:	55                   	push   %ebp
  102da9:	89 e5                	mov    %esp,%ebp
  102dab:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102dae:	b8 80 19 11 00       	mov    $0x111980,%eax
  102db3:	05 00 04 00 00       	add    $0x400,%eax
  102db8:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102dbd:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102dc4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102dc6:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102dcd:	68 00 
  102dcf:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102dd4:	0f b7 c0             	movzwl %ax,%eax
  102dd7:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102ddd:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102de2:	c1 e8 10             	shr    $0x10,%eax
  102de5:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102dea:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102df1:	24 f0                	and    $0xf0,%al
  102df3:	0c 09                	or     $0x9,%al
  102df5:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102dfa:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e01:	0c 10                	or     $0x10,%al
  102e03:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102e08:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e0f:	24 9f                	and    $0x9f,%al
  102e11:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102e16:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e1d:	0c 80                	or     $0x80,%al
  102e1f:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102e24:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e2b:	24 f0                	and    $0xf0,%al
  102e2d:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e32:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e39:	24 ef                	and    $0xef,%al
  102e3b:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e40:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e47:	24 df                	and    $0xdf,%al
  102e49:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e4e:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e55:	0c 40                	or     $0x40,%al
  102e57:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e5c:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e63:	24 7f                	and    $0x7f,%al
  102e65:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e6a:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102e6f:	c1 e8 18             	shr    $0x18,%eax
  102e72:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102e77:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e7e:	24 ef                	and    $0xef,%al
  102e80:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102e85:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102e8c:	e8 dd fe ff ff       	call   102d6e <lgdt>
  102e91:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102e97:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102e9b:	0f 00 d8             	ltr    %ax
}
  102e9e:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102e9f:	90                   	nop
  102ea0:	c9                   	leave  
  102ea1:	c3                   	ret    

00102ea2 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ea2:	f3 0f 1e fb          	endbr32 
  102ea6:	55                   	push   %ebp
  102ea7:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ea9:	e8 f6 fe ff ff       	call   102da4 <gdt_init>
}
  102eae:	90                   	nop
  102eaf:	5d                   	pop    %ebp
  102eb0:	c3                   	ret    

00102eb1 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102eb1:	f3 0f 1e fb          	endbr32 
  102eb5:	55                   	push   %ebp
  102eb6:	89 e5                	mov    %esp,%ebp
  102eb8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102ec2:	eb 03                	jmp    102ec7 <strlen+0x16>
        cnt ++;
  102ec4:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eca:	8d 50 01             	lea    0x1(%eax),%edx
  102ecd:	89 55 08             	mov    %edx,0x8(%ebp)
  102ed0:	0f b6 00             	movzbl (%eax),%eax
  102ed3:	84 c0                	test   %al,%al
  102ed5:	75 ed                	jne    102ec4 <strlen+0x13>
    }
    return cnt;
  102ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102eda:	c9                   	leave  
  102edb:	c3                   	ret    

00102edc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102edc:	f3 0f 1e fb          	endbr32 
  102ee0:	55                   	push   %ebp
  102ee1:	89 e5                	mov    %esp,%ebp
  102ee3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ee6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102eed:	eb 03                	jmp    102ef2 <strnlen+0x16>
        cnt ++;
  102eef:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ef5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ef8:	73 10                	jae    102f0a <strnlen+0x2e>
  102efa:	8b 45 08             	mov    0x8(%ebp),%eax
  102efd:	8d 50 01             	lea    0x1(%eax),%edx
  102f00:	89 55 08             	mov    %edx,0x8(%ebp)
  102f03:	0f b6 00             	movzbl (%eax),%eax
  102f06:	84 c0                	test   %al,%al
  102f08:	75 e5                	jne    102eef <strnlen+0x13>
    }
    return cnt;
  102f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102f0d:	c9                   	leave  
  102f0e:	c3                   	ret    

00102f0f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102f0f:	f3 0f 1e fb          	endbr32 
  102f13:	55                   	push   %ebp
  102f14:	89 e5                	mov    %esp,%ebp
  102f16:	57                   	push   %edi
  102f17:	56                   	push   %esi
  102f18:	83 ec 20             	sub    $0x20,%esp
  102f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102f27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2d:	89 d1                	mov    %edx,%ecx
  102f2f:	89 c2                	mov    %eax,%edx
  102f31:	89 ce                	mov    %ecx,%esi
  102f33:	89 d7                	mov    %edx,%edi
  102f35:	ac                   	lods   %ds:(%esi),%al
  102f36:	aa                   	stos   %al,%es:(%edi)
  102f37:	84 c0                	test   %al,%al
  102f39:	75 fa                	jne    102f35 <strcpy+0x26>
  102f3b:	89 fa                	mov    %edi,%edx
  102f3d:	89 f1                	mov    %esi,%ecx
  102f3f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f42:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102f4b:	83 c4 20             	add    $0x20,%esp
  102f4e:	5e                   	pop    %esi
  102f4f:	5f                   	pop    %edi
  102f50:	5d                   	pop    %ebp
  102f51:	c3                   	ret    

00102f52 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102f52:	f3 0f 1e fb          	endbr32 
  102f56:	55                   	push   %ebp
  102f57:	89 e5                	mov    %esp,%ebp
  102f59:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102f62:	eb 1e                	jmp    102f82 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f67:	0f b6 10             	movzbl (%eax),%edx
  102f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f6d:	88 10                	mov    %dl,(%eax)
  102f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f72:	0f b6 00             	movzbl (%eax),%eax
  102f75:	84 c0                	test   %al,%al
  102f77:	74 03                	je     102f7c <strncpy+0x2a>
            src ++;
  102f79:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102f7c:	ff 45 fc             	incl   -0x4(%ebp)
  102f7f:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f86:	75 dc                	jne    102f64 <strncpy+0x12>
    }
    return dst;
  102f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f8b:	c9                   	leave  
  102f8c:	c3                   	ret    

00102f8d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102f8d:	f3 0f 1e fb          	endbr32 
  102f91:	55                   	push   %ebp
  102f92:	89 e5                	mov    %esp,%ebp
  102f94:	57                   	push   %edi
  102f95:	56                   	push   %esi
  102f96:	83 ec 20             	sub    $0x20,%esp
  102f99:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fab:	89 d1                	mov    %edx,%ecx
  102fad:	89 c2                	mov    %eax,%edx
  102faf:	89 ce                	mov    %ecx,%esi
  102fb1:	89 d7                	mov    %edx,%edi
  102fb3:	ac                   	lods   %ds:(%esi),%al
  102fb4:	ae                   	scas   %es:(%edi),%al
  102fb5:	75 08                	jne    102fbf <strcmp+0x32>
  102fb7:	84 c0                	test   %al,%al
  102fb9:	75 f8                	jne    102fb3 <strcmp+0x26>
  102fbb:	31 c0                	xor    %eax,%eax
  102fbd:	eb 04                	jmp    102fc3 <strcmp+0x36>
  102fbf:	19 c0                	sbb    %eax,%eax
  102fc1:	0c 01                	or     $0x1,%al
  102fc3:	89 fa                	mov    %edi,%edx
  102fc5:	89 f1                	mov    %esi,%ecx
  102fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fca:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102fcd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102fd3:	83 c4 20             	add    $0x20,%esp
  102fd6:	5e                   	pop    %esi
  102fd7:	5f                   	pop    %edi
  102fd8:	5d                   	pop    %ebp
  102fd9:	c3                   	ret    

00102fda <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102fda:	f3 0f 1e fb          	endbr32 
  102fde:	55                   	push   %ebp
  102fdf:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102fe1:	eb 09                	jmp    102fec <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102fe3:	ff 4d 10             	decl   0x10(%ebp)
  102fe6:	ff 45 08             	incl   0x8(%ebp)
  102fe9:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102fec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ff0:	74 1a                	je     10300c <strncmp+0x32>
  102ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff5:	0f b6 00             	movzbl (%eax),%eax
  102ff8:	84 c0                	test   %al,%al
  102ffa:	74 10                	je     10300c <strncmp+0x32>
  102ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fff:	0f b6 10             	movzbl (%eax),%edx
  103002:	8b 45 0c             	mov    0xc(%ebp),%eax
  103005:	0f b6 00             	movzbl (%eax),%eax
  103008:	38 c2                	cmp    %al,%dl
  10300a:	74 d7                	je     102fe3 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10300c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103010:	74 18                	je     10302a <strncmp+0x50>
  103012:	8b 45 08             	mov    0x8(%ebp),%eax
  103015:	0f b6 00             	movzbl (%eax),%eax
  103018:	0f b6 d0             	movzbl %al,%edx
  10301b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301e:	0f b6 00             	movzbl (%eax),%eax
  103021:	0f b6 c0             	movzbl %al,%eax
  103024:	29 c2                	sub    %eax,%edx
  103026:	89 d0                	mov    %edx,%eax
  103028:	eb 05                	jmp    10302f <strncmp+0x55>
  10302a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10302f:	5d                   	pop    %ebp
  103030:	c3                   	ret    

00103031 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103031:	f3 0f 1e fb          	endbr32 
  103035:	55                   	push   %ebp
  103036:	89 e5                	mov    %esp,%ebp
  103038:	83 ec 04             	sub    $0x4,%esp
  10303b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103041:	eb 13                	jmp    103056 <strchr+0x25>
        if (*s == c) {
  103043:	8b 45 08             	mov    0x8(%ebp),%eax
  103046:	0f b6 00             	movzbl (%eax),%eax
  103049:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10304c:	75 05                	jne    103053 <strchr+0x22>
            return (char *)s;
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	eb 12                	jmp    103065 <strchr+0x34>
        }
        s ++;
  103053:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103056:	8b 45 08             	mov    0x8(%ebp),%eax
  103059:	0f b6 00             	movzbl (%eax),%eax
  10305c:	84 c0                	test   %al,%al
  10305e:	75 e3                	jne    103043 <strchr+0x12>
    }
    return NULL;
  103060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103065:	c9                   	leave  
  103066:	c3                   	ret    

00103067 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103067:	f3 0f 1e fb          	endbr32 
  10306b:	55                   	push   %ebp
  10306c:	89 e5                	mov    %esp,%ebp
  10306e:	83 ec 04             	sub    $0x4,%esp
  103071:	8b 45 0c             	mov    0xc(%ebp),%eax
  103074:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103077:	eb 0e                	jmp    103087 <strfind+0x20>
        if (*s == c) {
  103079:	8b 45 08             	mov    0x8(%ebp),%eax
  10307c:	0f b6 00             	movzbl (%eax),%eax
  10307f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103082:	74 0f                	je     103093 <strfind+0x2c>
            break;
        }
        s ++;
  103084:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103087:	8b 45 08             	mov    0x8(%ebp),%eax
  10308a:	0f b6 00             	movzbl (%eax),%eax
  10308d:	84 c0                	test   %al,%al
  10308f:	75 e8                	jne    103079 <strfind+0x12>
  103091:	eb 01                	jmp    103094 <strfind+0x2d>
            break;
  103093:	90                   	nop
    }
    return (char *)s;
  103094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103097:	c9                   	leave  
  103098:	c3                   	ret    

00103099 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103099:	f3 0f 1e fb          	endbr32 
  10309d:	55                   	push   %ebp
  10309e:	89 e5                	mov    %esp,%ebp
  1030a0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1030a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1030aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1030b1:	eb 03                	jmp    1030b6 <strtol+0x1d>
        s ++;
  1030b3:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b9:	0f b6 00             	movzbl (%eax),%eax
  1030bc:	3c 20                	cmp    $0x20,%al
  1030be:	74 f3                	je     1030b3 <strtol+0x1a>
  1030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c3:	0f b6 00             	movzbl (%eax),%eax
  1030c6:	3c 09                	cmp    $0x9,%al
  1030c8:	74 e9                	je     1030b3 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1030cd:	0f b6 00             	movzbl (%eax),%eax
  1030d0:	3c 2b                	cmp    $0x2b,%al
  1030d2:	75 05                	jne    1030d9 <strtol+0x40>
        s ++;
  1030d4:	ff 45 08             	incl   0x8(%ebp)
  1030d7:	eb 14                	jmp    1030ed <strtol+0x54>
    }
    else if (*s == '-') {
  1030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030dc:	0f b6 00             	movzbl (%eax),%eax
  1030df:	3c 2d                	cmp    $0x2d,%al
  1030e1:	75 0a                	jne    1030ed <strtol+0x54>
        s ++, neg = 1;
  1030e3:	ff 45 08             	incl   0x8(%ebp)
  1030e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1030ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030f1:	74 06                	je     1030f9 <strtol+0x60>
  1030f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1030f7:	75 22                	jne    10311b <strtol+0x82>
  1030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fc:	0f b6 00             	movzbl (%eax),%eax
  1030ff:	3c 30                	cmp    $0x30,%al
  103101:	75 18                	jne    10311b <strtol+0x82>
  103103:	8b 45 08             	mov    0x8(%ebp),%eax
  103106:	40                   	inc    %eax
  103107:	0f b6 00             	movzbl (%eax),%eax
  10310a:	3c 78                	cmp    $0x78,%al
  10310c:	75 0d                	jne    10311b <strtol+0x82>
        s += 2, base = 16;
  10310e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103112:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103119:	eb 29                	jmp    103144 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  10311b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10311f:	75 16                	jne    103137 <strtol+0x9e>
  103121:	8b 45 08             	mov    0x8(%ebp),%eax
  103124:	0f b6 00             	movzbl (%eax),%eax
  103127:	3c 30                	cmp    $0x30,%al
  103129:	75 0c                	jne    103137 <strtol+0x9e>
        s ++, base = 8;
  10312b:	ff 45 08             	incl   0x8(%ebp)
  10312e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103135:	eb 0d                	jmp    103144 <strtol+0xab>
    }
    else if (base == 0) {
  103137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10313b:	75 07                	jne    103144 <strtol+0xab>
        base = 10;
  10313d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103144:	8b 45 08             	mov    0x8(%ebp),%eax
  103147:	0f b6 00             	movzbl (%eax),%eax
  10314a:	3c 2f                	cmp    $0x2f,%al
  10314c:	7e 1b                	jle    103169 <strtol+0xd0>
  10314e:	8b 45 08             	mov    0x8(%ebp),%eax
  103151:	0f b6 00             	movzbl (%eax),%eax
  103154:	3c 39                	cmp    $0x39,%al
  103156:	7f 11                	jg     103169 <strtol+0xd0>
            dig = *s - '0';
  103158:	8b 45 08             	mov    0x8(%ebp),%eax
  10315b:	0f b6 00             	movzbl (%eax),%eax
  10315e:	0f be c0             	movsbl %al,%eax
  103161:	83 e8 30             	sub    $0x30,%eax
  103164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103167:	eb 48                	jmp    1031b1 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103169:	8b 45 08             	mov    0x8(%ebp),%eax
  10316c:	0f b6 00             	movzbl (%eax),%eax
  10316f:	3c 60                	cmp    $0x60,%al
  103171:	7e 1b                	jle    10318e <strtol+0xf5>
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
  103176:	0f b6 00             	movzbl (%eax),%eax
  103179:	3c 7a                	cmp    $0x7a,%al
  10317b:	7f 11                	jg     10318e <strtol+0xf5>
            dig = *s - 'a' + 10;
  10317d:	8b 45 08             	mov    0x8(%ebp),%eax
  103180:	0f b6 00             	movzbl (%eax),%eax
  103183:	0f be c0             	movsbl %al,%eax
  103186:	83 e8 57             	sub    $0x57,%eax
  103189:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10318c:	eb 23                	jmp    1031b1 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10318e:	8b 45 08             	mov    0x8(%ebp),%eax
  103191:	0f b6 00             	movzbl (%eax),%eax
  103194:	3c 40                	cmp    $0x40,%al
  103196:	7e 3b                	jle    1031d3 <strtol+0x13a>
  103198:	8b 45 08             	mov    0x8(%ebp),%eax
  10319b:	0f b6 00             	movzbl (%eax),%eax
  10319e:	3c 5a                	cmp    $0x5a,%al
  1031a0:	7f 31                	jg     1031d3 <strtol+0x13a>
            dig = *s - 'A' + 10;
  1031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a5:	0f b6 00             	movzbl (%eax),%eax
  1031a8:	0f be c0             	movsbl %al,%eax
  1031ab:	83 e8 37             	sub    $0x37,%eax
  1031ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031b4:	3b 45 10             	cmp    0x10(%ebp),%eax
  1031b7:	7d 19                	jge    1031d2 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  1031b9:	ff 45 08             	incl   0x8(%ebp)
  1031bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031bf:	0f af 45 10          	imul   0x10(%ebp),%eax
  1031c3:	89 c2                	mov    %eax,%edx
  1031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031c8:	01 d0                	add    %edx,%eax
  1031ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1031cd:	e9 72 ff ff ff       	jmp    103144 <strtol+0xab>
            break;
  1031d2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1031d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031d7:	74 08                	je     1031e1 <strtol+0x148>
        *endptr = (char *) s;
  1031d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1031df:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1031e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1031e5:	74 07                	je     1031ee <strtol+0x155>
  1031e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031ea:	f7 d8                	neg    %eax
  1031ec:	eb 03                	jmp    1031f1 <strtol+0x158>
  1031ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1031f1:	c9                   	leave  
  1031f2:	c3                   	ret    

001031f3 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1031f3:	f3 0f 1e fb          	endbr32 
  1031f7:	55                   	push   %ebp
  1031f8:	89 e5                	mov    %esp,%ebp
  1031fa:	57                   	push   %edi
  1031fb:	83 ec 24             	sub    $0x24,%esp
  1031fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103201:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103204:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103208:	8b 45 08             	mov    0x8(%ebp),%eax
  10320b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10320e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  103211:	8b 45 10             	mov    0x10(%ebp),%eax
  103214:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103217:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10321a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10321e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103221:	89 d7                	mov    %edx,%edi
  103223:	f3 aa                	rep stos %al,%es:(%edi)
  103225:	89 fa                	mov    %edi,%edx
  103227:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10322a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10322d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103230:	83 c4 24             	add    $0x24,%esp
  103233:	5f                   	pop    %edi
  103234:	5d                   	pop    %ebp
  103235:	c3                   	ret    

00103236 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103236:	f3 0f 1e fb          	endbr32 
  10323a:	55                   	push   %ebp
  10323b:	89 e5                	mov    %esp,%ebp
  10323d:	57                   	push   %edi
  10323e:	56                   	push   %esi
  10323f:	53                   	push   %ebx
  103240:	83 ec 30             	sub    $0x30,%esp
  103243:	8b 45 08             	mov    0x8(%ebp),%eax
  103246:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103249:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10324f:	8b 45 10             	mov    0x10(%ebp),%eax
  103252:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103258:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10325b:	73 42                	jae    10329f <memmove+0x69>
  10325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103266:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10326c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10326f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103272:	c1 e8 02             	shr    $0x2,%eax
  103275:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103277:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10327a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10327d:	89 d7                	mov    %edx,%edi
  10327f:	89 c6                	mov    %eax,%esi
  103281:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103283:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103286:	83 e1 03             	and    $0x3,%ecx
  103289:	74 02                	je     10328d <memmove+0x57>
  10328b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10328d:	89 f0                	mov    %esi,%eax
  10328f:	89 fa                	mov    %edi,%edx
  103291:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103294:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103297:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  10329a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10329d:	eb 36                	jmp    1032d5 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032a8:	01 c2                	add    %eax,%edx
  1032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ad:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032b9:	89 c1                	mov    %eax,%ecx
  1032bb:	89 d8                	mov    %ebx,%eax
  1032bd:	89 d6                	mov    %edx,%esi
  1032bf:	89 c7                	mov    %eax,%edi
  1032c1:	fd                   	std    
  1032c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1032c4:	fc                   	cld    
  1032c5:	89 f8                	mov    %edi,%eax
  1032c7:	89 f2                	mov    %esi,%edx
  1032c9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1032cc:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1032cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1032d5:	83 c4 30             	add    $0x30,%esp
  1032d8:	5b                   	pop    %ebx
  1032d9:	5e                   	pop    %esi
  1032da:	5f                   	pop    %edi
  1032db:	5d                   	pop    %ebp
  1032dc:	c3                   	ret    

001032dd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1032dd:	f3 0f 1e fb          	endbr32 
  1032e1:	55                   	push   %ebp
  1032e2:	89 e5                	mov    %esp,%ebp
  1032e4:	57                   	push   %edi
  1032e5:	56                   	push   %esi
  1032e6:	83 ec 20             	sub    $0x20,%esp
  1032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1032fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032fe:	c1 e8 02             	shr    $0x2,%eax
  103301:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103309:	89 d7                	mov    %edx,%edi
  10330b:	89 c6                	mov    %eax,%esi
  10330d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10330f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103312:	83 e1 03             	and    $0x3,%ecx
  103315:	74 02                	je     103319 <memcpy+0x3c>
  103317:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103319:	89 f0                	mov    %esi,%eax
  10331b:	89 fa                	mov    %edi,%edx
  10331d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103320:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103323:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103326:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103329:	83 c4 20             	add    $0x20,%esp
  10332c:	5e                   	pop    %esi
  10332d:	5f                   	pop    %edi
  10332e:	5d                   	pop    %ebp
  10332f:	c3                   	ret    

00103330 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103330:	f3 0f 1e fb          	endbr32 
  103334:	55                   	push   %ebp
  103335:	89 e5                	mov    %esp,%ebp
  103337:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10333a:	8b 45 08             	mov    0x8(%ebp),%eax
  10333d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103340:	8b 45 0c             	mov    0xc(%ebp),%eax
  103343:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103346:	eb 2e                	jmp    103376 <memcmp+0x46>
        if (*s1 != *s2) {
  103348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10334b:	0f b6 10             	movzbl (%eax),%edx
  10334e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103351:	0f b6 00             	movzbl (%eax),%eax
  103354:	38 c2                	cmp    %al,%dl
  103356:	74 18                	je     103370 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103358:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10335b:	0f b6 00             	movzbl (%eax),%eax
  10335e:	0f b6 d0             	movzbl %al,%edx
  103361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103364:	0f b6 00             	movzbl (%eax),%eax
  103367:	0f b6 c0             	movzbl %al,%eax
  10336a:	29 c2                	sub    %eax,%edx
  10336c:	89 d0                	mov    %edx,%eax
  10336e:	eb 18                	jmp    103388 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  103370:	ff 45 fc             	incl   -0x4(%ebp)
  103373:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103376:	8b 45 10             	mov    0x10(%ebp),%eax
  103379:	8d 50 ff             	lea    -0x1(%eax),%edx
  10337c:	89 55 10             	mov    %edx,0x10(%ebp)
  10337f:	85 c0                	test   %eax,%eax
  103381:	75 c5                	jne    103348 <memcmp+0x18>
    }
    return 0;
  103383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103388:	c9                   	leave  
  103389:	c3                   	ret    

0010338a <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10338a:	f3 0f 1e fb          	endbr32 
  10338e:	55                   	push   %ebp
  10338f:	89 e5                	mov    %esp,%ebp
  103391:	83 ec 58             	sub    $0x58,%esp
  103394:	8b 45 10             	mov    0x10(%ebp),%eax
  103397:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10339a:	8b 45 14             	mov    0x14(%ebp),%eax
  10339d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1033a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033a9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1033ac:	8b 45 18             	mov    0x18(%ebp),%eax
  1033af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1033b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033bb:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033c8:	74 1c                	je     1033e6 <printnum+0x5c>
  1033ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033cd:	ba 00 00 00 00       	mov    $0x0,%edx
  1033d2:	f7 75 e4             	divl   -0x1c(%ebp)
  1033d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1033d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033db:	ba 00 00 00 00       	mov    $0x0,%edx
  1033e0:	f7 75 e4             	divl   -0x1c(%ebp)
  1033e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033ec:	f7 75 e4             	divl   -0x1c(%ebp)
  1033ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1033f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1033fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033fe:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103404:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103407:	8b 45 18             	mov    0x18(%ebp),%eax
  10340a:	ba 00 00 00 00       	mov    $0x0,%edx
  10340f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103412:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103415:	19 d1                	sbb    %edx,%ecx
  103417:	72 4c                	jb     103465 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103419:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10341c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10341f:	8b 45 20             	mov    0x20(%ebp),%eax
  103422:	89 44 24 18          	mov    %eax,0x18(%esp)
  103426:	89 54 24 14          	mov    %edx,0x14(%esp)
  10342a:	8b 45 18             	mov    0x18(%ebp),%eax
  10342d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103434:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103437:	89 44 24 08          	mov    %eax,0x8(%esp)
  10343b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10343f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103442:	89 44 24 04          	mov    %eax,0x4(%esp)
  103446:	8b 45 08             	mov    0x8(%ebp),%eax
  103449:	89 04 24             	mov    %eax,(%esp)
  10344c:	e8 39 ff ff ff       	call   10338a <printnum>
  103451:	eb 1b                	jmp    10346e <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103453:	8b 45 0c             	mov    0xc(%ebp),%eax
  103456:	89 44 24 04          	mov    %eax,0x4(%esp)
  10345a:	8b 45 20             	mov    0x20(%ebp),%eax
  10345d:	89 04 24             	mov    %eax,(%esp)
  103460:	8b 45 08             	mov    0x8(%ebp),%eax
  103463:	ff d0                	call   *%eax
        while (-- width > 0)
  103465:	ff 4d 1c             	decl   0x1c(%ebp)
  103468:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10346c:	7f e5                	jg     103453 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10346e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103471:	05 10 42 10 00       	add    $0x104210,%eax
  103476:	0f b6 00             	movzbl (%eax),%eax
  103479:	0f be c0             	movsbl %al,%eax
  10347c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10347f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103483:	89 04 24             	mov    %eax,(%esp)
  103486:	8b 45 08             	mov    0x8(%ebp),%eax
  103489:	ff d0                	call   *%eax
}
  10348b:	90                   	nop
  10348c:	c9                   	leave  
  10348d:	c3                   	ret    

0010348e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10348e:	f3 0f 1e fb          	endbr32 
  103492:	55                   	push   %ebp
  103493:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103495:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103499:	7e 14                	jle    1034af <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  10349b:	8b 45 08             	mov    0x8(%ebp),%eax
  10349e:	8b 00                	mov    (%eax),%eax
  1034a0:	8d 48 08             	lea    0x8(%eax),%ecx
  1034a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1034a6:	89 0a                	mov    %ecx,(%edx)
  1034a8:	8b 50 04             	mov    0x4(%eax),%edx
  1034ab:	8b 00                	mov    (%eax),%eax
  1034ad:	eb 30                	jmp    1034df <getuint+0x51>
    }
    else if (lflag) {
  1034af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034b3:	74 16                	je     1034cb <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b8:	8b 00                	mov    (%eax),%eax
  1034ba:	8d 48 04             	lea    0x4(%eax),%ecx
  1034bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1034c0:	89 0a                	mov    %ecx,(%edx)
  1034c2:	8b 00                	mov    (%eax),%eax
  1034c4:	ba 00 00 00 00       	mov    $0x0,%edx
  1034c9:	eb 14                	jmp    1034df <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ce:	8b 00                	mov    (%eax),%eax
  1034d0:	8d 48 04             	lea    0x4(%eax),%ecx
  1034d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1034d6:	89 0a                	mov    %ecx,(%edx)
  1034d8:	8b 00                	mov    (%eax),%eax
  1034da:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1034df:	5d                   	pop    %ebp
  1034e0:	c3                   	ret    

001034e1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1034e1:	f3 0f 1e fb          	endbr32 
  1034e5:	55                   	push   %ebp
  1034e6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1034e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1034ec:	7e 14                	jle    103502 <getint+0x21>
        return va_arg(*ap, long long);
  1034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f1:	8b 00                	mov    (%eax),%eax
  1034f3:	8d 48 08             	lea    0x8(%eax),%ecx
  1034f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1034f9:	89 0a                	mov    %ecx,(%edx)
  1034fb:	8b 50 04             	mov    0x4(%eax),%edx
  1034fe:	8b 00                	mov    (%eax),%eax
  103500:	eb 28                	jmp    10352a <getint+0x49>
    }
    else if (lflag) {
  103502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103506:	74 12                	je     10351a <getint+0x39>
        return va_arg(*ap, long);
  103508:	8b 45 08             	mov    0x8(%ebp),%eax
  10350b:	8b 00                	mov    (%eax),%eax
  10350d:	8d 48 04             	lea    0x4(%eax),%ecx
  103510:	8b 55 08             	mov    0x8(%ebp),%edx
  103513:	89 0a                	mov    %ecx,(%edx)
  103515:	8b 00                	mov    (%eax),%eax
  103517:	99                   	cltd   
  103518:	eb 10                	jmp    10352a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  10351a:	8b 45 08             	mov    0x8(%ebp),%eax
  10351d:	8b 00                	mov    (%eax),%eax
  10351f:	8d 48 04             	lea    0x4(%eax),%ecx
  103522:	8b 55 08             	mov    0x8(%ebp),%edx
  103525:	89 0a                	mov    %ecx,(%edx)
  103527:	8b 00                	mov    (%eax),%eax
  103529:	99                   	cltd   
    }
}
  10352a:	5d                   	pop    %ebp
  10352b:	c3                   	ret    

0010352c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10352c:	f3 0f 1e fb          	endbr32 
  103530:	55                   	push   %ebp
  103531:	89 e5                	mov    %esp,%ebp
  103533:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103536:	8d 45 14             	lea    0x14(%ebp),%eax
  103539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10353f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103543:	8b 45 10             	mov    0x10(%ebp),%eax
  103546:	89 44 24 08          	mov    %eax,0x8(%esp)
  10354a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10354d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103551:	8b 45 08             	mov    0x8(%ebp),%eax
  103554:	89 04 24             	mov    %eax,(%esp)
  103557:	e8 03 00 00 00       	call   10355f <vprintfmt>
    va_end(ap);
}
  10355c:	90                   	nop
  10355d:	c9                   	leave  
  10355e:	c3                   	ret    

0010355f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10355f:	f3 0f 1e fb          	endbr32 
  103563:	55                   	push   %ebp
  103564:	89 e5                	mov    %esp,%ebp
  103566:	56                   	push   %esi
  103567:	53                   	push   %ebx
  103568:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10356b:	eb 17                	jmp    103584 <vprintfmt+0x25>
            if (ch == '\0') {
  10356d:	85 db                	test   %ebx,%ebx
  10356f:	0f 84 c0 03 00 00    	je     103935 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  103575:	8b 45 0c             	mov    0xc(%ebp),%eax
  103578:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357c:	89 1c 24             	mov    %ebx,(%esp)
  10357f:	8b 45 08             	mov    0x8(%ebp),%eax
  103582:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103584:	8b 45 10             	mov    0x10(%ebp),%eax
  103587:	8d 50 01             	lea    0x1(%eax),%edx
  10358a:	89 55 10             	mov    %edx,0x10(%ebp)
  10358d:	0f b6 00             	movzbl (%eax),%eax
  103590:	0f b6 d8             	movzbl %al,%ebx
  103593:	83 fb 25             	cmp    $0x25,%ebx
  103596:	75 d5                	jne    10356d <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103598:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10359c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1035a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1035b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1035b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b9:	8d 50 01             	lea    0x1(%eax),%edx
  1035bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1035bf:	0f b6 00             	movzbl (%eax),%eax
  1035c2:	0f b6 d8             	movzbl %al,%ebx
  1035c5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1035c8:	83 f8 55             	cmp    $0x55,%eax
  1035cb:	0f 87 38 03 00 00    	ja     103909 <vprintfmt+0x3aa>
  1035d1:	8b 04 85 34 42 10 00 	mov    0x104234(,%eax,4),%eax
  1035d8:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1035db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1035df:	eb d5                	jmp    1035b6 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1035e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1035e5:	eb cf                	jmp    1035b6 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1035e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1035ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1035f1:	89 d0                	mov    %edx,%eax
  1035f3:	c1 e0 02             	shl    $0x2,%eax
  1035f6:	01 d0                	add    %edx,%eax
  1035f8:	01 c0                	add    %eax,%eax
  1035fa:	01 d8                	add    %ebx,%eax
  1035fc:	83 e8 30             	sub    $0x30,%eax
  1035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103602:	8b 45 10             	mov    0x10(%ebp),%eax
  103605:	0f b6 00             	movzbl (%eax),%eax
  103608:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10360b:	83 fb 2f             	cmp    $0x2f,%ebx
  10360e:	7e 38                	jle    103648 <vprintfmt+0xe9>
  103610:	83 fb 39             	cmp    $0x39,%ebx
  103613:	7f 33                	jg     103648 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103615:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103618:	eb d4                	jmp    1035ee <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10361a:	8b 45 14             	mov    0x14(%ebp),%eax
  10361d:	8d 50 04             	lea    0x4(%eax),%edx
  103620:	89 55 14             	mov    %edx,0x14(%ebp)
  103623:	8b 00                	mov    (%eax),%eax
  103625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103628:	eb 1f                	jmp    103649 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  10362a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10362e:	79 86                	jns    1035b6 <vprintfmt+0x57>
                width = 0;
  103630:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103637:	e9 7a ff ff ff       	jmp    1035b6 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10363c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103643:	e9 6e ff ff ff       	jmp    1035b6 <vprintfmt+0x57>
            goto process_precision;
  103648:	90                   	nop

        process_precision:
            if (width < 0)
  103649:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10364d:	0f 89 63 ff ff ff    	jns    1035b6 <vprintfmt+0x57>
                width = precision, precision = -1;
  103653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103656:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103659:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103660:	e9 51 ff ff ff       	jmp    1035b6 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103665:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103668:	e9 49 ff ff ff       	jmp    1035b6 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10366d:	8b 45 14             	mov    0x14(%ebp),%eax
  103670:	8d 50 04             	lea    0x4(%eax),%edx
  103673:	89 55 14             	mov    %edx,0x14(%ebp)
  103676:	8b 00                	mov    (%eax),%eax
  103678:	8b 55 0c             	mov    0xc(%ebp),%edx
  10367b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10367f:	89 04 24             	mov    %eax,(%esp)
  103682:	8b 45 08             	mov    0x8(%ebp),%eax
  103685:	ff d0                	call   *%eax
            break;
  103687:	e9 a4 02 00 00       	jmp    103930 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10368c:	8b 45 14             	mov    0x14(%ebp),%eax
  10368f:	8d 50 04             	lea    0x4(%eax),%edx
  103692:	89 55 14             	mov    %edx,0x14(%ebp)
  103695:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103697:	85 db                	test   %ebx,%ebx
  103699:	79 02                	jns    10369d <vprintfmt+0x13e>
                err = -err;
  10369b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10369d:	83 fb 06             	cmp    $0x6,%ebx
  1036a0:	7f 0b                	jg     1036ad <vprintfmt+0x14e>
  1036a2:	8b 34 9d f4 41 10 00 	mov    0x1041f4(,%ebx,4),%esi
  1036a9:	85 f6                	test   %esi,%esi
  1036ab:	75 23                	jne    1036d0 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1036ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1036b1:	c7 44 24 08 21 42 10 	movl   $0x104221,0x8(%esp)
  1036b8:	00 
  1036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1036c3:	89 04 24             	mov    %eax,(%esp)
  1036c6:	e8 61 fe ff ff       	call   10352c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1036cb:	e9 60 02 00 00       	jmp    103930 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1036d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1036d4:	c7 44 24 08 2a 42 10 	movl   $0x10422a,0x8(%esp)
  1036db:	00 
  1036dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e6:	89 04 24             	mov    %eax,(%esp)
  1036e9:	e8 3e fe ff ff       	call   10352c <printfmt>
            break;
  1036ee:	e9 3d 02 00 00       	jmp    103930 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1036f3:	8b 45 14             	mov    0x14(%ebp),%eax
  1036f6:	8d 50 04             	lea    0x4(%eax),%edx
  1036f9:	89 55 14             	mov    %edx,0x14(%ebp)
  1036fc:	8b 30                	mov    (%eax),%esi
  1036fe:	85 f6                	test   %esi,%esi
  103700:	75 05                	jne    103707 <vprintfmt+0x1a8>
                p = "(null)";
  103702:	be 2d 42 10 00       	mov    $0x10422d,%esi
            }
            if (width > 0 && padc != '-') {
  103707:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10370b:	7e 76                	jle    103783 <vprintfmt+0x224>
  10370d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103711:	74 70                	je     103783 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103716:	89 44 24 04          	mov    %eax,0x4(%esp)
  10371a:	89 34 24             	mov    %esi,(%esp)
  10371d:	e8 ba f7 ff ff       	call   102edc <strnlen>
  103722:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103725:	29 c2                	sub    %eax,%edx
  103727:	89 d0                	mov    %edx,%eax
  103729:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10372c:	eb 16                	jmp    103744 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10372e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103732:	8b 55 0c             	mov    0xc(%ebp),%edx
  103735:	89 54 24 04          	mov    %edx,0x4(%esp)
  103739:	89 04 24             	mov    %eax,(%esp)
  10373c:	8b 45 08             	mov    0x8(%ebp),%eax
  10373f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103741:	ff 4d e8             	decl   -0x18(%ebp)
  103744:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103748:	7f e4                	jg     10372e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10374a:	eb 37                	jmp    103783 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10374c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103750:	74 1f                	je     103771 <vprintfmt+0x212>
  103752:	83 fb 1f             	cmp    $0x1f,%ebx
  103755:	7e 05                	jle    10375c <vprintfmt+0x1fd>
  103757:	83 fb 7e             	cmp    $0x7e,%ebx
  10375a:	7e 15                	jle    103771 <vprintfmt+0x212>
                    putch('?', putdat);
  10375c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10375f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103763:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10376a:	8b 45 08             	mov    0x8(%ebp),%eax
  10376d:	ff d0                	call   *%eax
  10376f:	eb 0f                	jmp    103780 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  103771:	8b 45 0c             	mov    0xc(%ebp),%eax
  103774:	89 44 24 04          	mov    %eax,0x4(%esp)
  103778:	89 1c 24             	mov    %ebx,(%esp)
  10377b:	8b 45 08             	mov    0x8(%ebp),%eax
  10377e:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103780:	ff 4d e8             	decl   -0x18(%ebp)
  103783:	89 f0                	mov    %esi,%eax
  103785:	8d 70 01             	lea    0x1(%eax),%esi
  103788:	0f b6 00             	movzbl (%eax),%eax
  10378b:	0f be d8             	movsbl %al,%ebx
  10378e:	85 db                	test   %ebx,%ebx
  103790:	74 27                	je     1037b9 <vprintfmt+0x25a>
  103792:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103796:	78 b4                	js     10374c <vprintfmt+0x1ed>
  103798:	ff 4d e4             	decl   -0x1c(%ebp)
  10379b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10379f:	79 ab                	jns    10374c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1037a1:	eb 16                	jmp    1037b9 <vprintfmt+0x25a>
                putch(' ', putdat);
  1037a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037aa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1037b4:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1037b6:	ff 4d e8             	decl   -0x18(%ebp)
  1037b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1037bd:	7f e4                	jg     1037a3 <vprintfmt+0x244>
            }
            break;
  1037bf:	e9 6c 01 00 00       	jmp    103930 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1037c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1037c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037cb:	8d 45 14             	lea    0x14(%ebp),%eax
  1037ce:	89 04 24             	mov    %eax,(%esp)
  1037d1:	e8 0b fd ff ff       	call   1034e1 <getint>
  1037d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1037dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037e2:	85 d2                	test   %edx,%edx
  1037e4:	79 26                	jns    10380c <vprintfmt+0x2ad>
                putch('-', putdat);
  1037e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ed:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1037f7:	ff d0                	call   *%eax
                num = -(long long)num;
  1037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037ff:	f7 d8                	neg    %eax
  103801:	83 d2 00             	adc    $0x0,%edx
  103804:	f7 da                	neg    %edx
  103806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103809:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10380c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103813:	e9 a8 00 00 00       	jmp    1038c0 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10381b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10381f:	8d 45 14             	lea    0x14(%ebp),%eax
  103822:	89 04 24             	mov    %eax,(%esp)
  103825:	e8 64 fc ff ff       	call   10348e <getuint>
  10382a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10382d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103830:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103837:	e9 84 00 00 00       	jmp    1038c0 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10383f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103843:	8d 45 14             	lea    0x14(%ebp),%eax
  103846:	89 04 24             	mov    %eax,(%esp)
  103849:	e8 40 fc ff ff       	call   10348e <getuint>
  10384e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103851:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103854:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10385b:	eb 63                	jmp    1038c0 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  10385d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103860:	89 44 24 04          	mov    %eax,0x4(%esp)
  103864:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10386b:	8b 45 08             	mov    0x8(%ebp),%eax
  10386e:	ff d0                	call   *%eax
            putch('x', putdat);
  103870:	8b 45 0c             	mov    0xc(%ebp),%eax
  103873:	89 44 24 04          	mov    %eax,0x4(%esp)
  103877:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10387e:	8b 45 08             	mov    0x8(%ebp),%eax
  103881:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103883:	8b 45 14             	mov    0x14(%ebp),%eax
  103886:	8d 50 04             	lea    0x4(%eax),%edx
  103889:	89 55 14             	mov    %edx,0x14(%ebp)
  10388c:	8b 00                	mov    (%eax),%eax
  10388e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103891:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103898:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10389f:	eb 1f                	jmp    1038c0 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1038a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038a8:	8d 45 14             	lea    0x14(%ebp),%eax
  1038ab:	89 04 24             	mov    %eax,(%esp)
  1038ae:	e8 db fb ff ff       	call   10348e <getuint>
  1038b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1038b9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1038c0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1038c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038c7:	89 54 24 18          	mov    %edx,0x18(%esp)
  1038cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1038ce:	89 54 24 14          	mov    %edx,0x14(%esp)
  1038d2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1038dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1038e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ee:	89 04 24             	mov    %eax,(%esp)
  1038f1:	e8 94 fa ff ff       	call   10338a <printnum>
            break;
  1038f6:	eb 38                	jmp    103930 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1038f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038ff:	89 1c 24             	mov    %ebx,(%esp)
  103902:	8b 45 08             	mov    0x8(%ebp),%eax
  103905:	ff d0                	call   *%eax
            break;
  103907:	eb 27                	jmp    103930 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10390c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103910:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103917:	8b 45 08             	mov    0x8(%ebp),%eax
  10391a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10391c:	ff 4d 10             	decl   0x10(%ebp)
  10391f:	eb 03                	jmp    103924 <vprintfmt+0x3c5>
  103921:	ff 4d 10             	decl   0x10(%ebp)
  103924:	8b 45 10             	mov    0x10(%ebp),%eax
  103927:	48                   	dec    %eax
  103928:	0f b6 00             	movzbl (%eax),%eax
  10392b:	3c 25                	cmp    $0x25,%al
  10392d:	75 f2                	jne    103921 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10392f:	90                   	nop
    while (1) {
  103930:	e9 36 fc ff ff       	jmp    10356b <vprintfmt+0xc>
                return;
  103935:	90                   	nop
        }
    }
}
  103936:	83 c4 40             	add    $0x40,%esp
  103939:	5b                   	pop    %ebx
  10393a:	5e                   	pop    %esi
  10393b:	5d                   	pop    %ebp
  10393c:	c3                   	ret    

0010393d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10393d:	f3 0f 1e fb          	endbr32 
  103941:	55                   	push   %ebp
  103942:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103944:	8b 45 0c             	mov    0xc(%ebp),%eax
  103947:	8b 40 08             	mov    0x8(%eax),%eax
  10394a:	8d 50 01             	lea    0x1(%eax),%edx
  10394d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103950:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103953:	8b 45 0c             	mov    0xc(%ebp),%eax
  103956:	8b 10                	mov    (%eax),%edx
  103958:	8b 45 0c             	mov    0xc(%ebp),%eax
  10395b:	8b 40 04             	mov    0x4(%eax),%eax
  10395e:	39 c2                	cmp    %eax,%edx
  103960:	73 12                	jae    103974 <sprintputch+0x37>
        *b->buf ++ = ch;
  103962:	8b 45 0c             	mov    0xc(%ebp),%eax
  103965:	8b 00                	mov    (%eax),%eax
  103967:	8d 48 01             	lea    0x1(%eax),%ecx
  10396a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10396d:	89 0a                	mov    %ecx,(%edx)
  10396f:	8b 55 08             	mov    0x8(%ebp),%edx
  103972:	88 10                	mov    %dl,(%eax)
    }
}
  103974:	90                   	nop
  103975:	5d                   	pop    %ebp
  103976:	c3                   	ret    

00103977 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103977:	f3 0f 1e fb          	endbr32 
  10397b:	55                   	push   %ebp
  10397c:	89 e5                	mov    %esp,%ebp
  10397e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103981:	8d 45 14             	lea    0x14(%ebp),%eax
  103984:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10398a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10398e:	8b 45 10             	mov    0x10(%ebp),%eax
  103991:	89 44 24 08          	mov    %eax,0x8(%esp)
  103995:	8b 45 0c             	mov    0xc(%ebp),%eax
  103998:	89 44 24 04          	mov    %eax,0x4(%esp)
  10399c:	8b 45 08             	mov    0x8(%ebp),%eax
  10399f:	89 04 24             	mov    %eax,(%esp)
  1039a2:	e8 08 00 00 00       	call   1039af <vsnprintf>
  1039a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1039ad:	c9                   	leave  
  1039ae:	c3                   	ret    

001039af <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1039af:	f3 0f 1e fb          	endbr32 
  1039b3:	55                   	push   %ebp
  1039b4:	89 e5                	mov    %esp,%ebp
  1039b6:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1039c8:	01 d0                	add    %edx,%eax
  1039ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1039d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1039d8:	74 0a                	je     1039e4 <vsnprintf+0x35>
  1039da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1039dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039e0:	39 c2                	cmp    %eax,%edx
  1039e2:	76 07                	jbe    1039eb <vsnprintf+0x3c>
        return -E_INVAL;
  1039e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1039e9:	eb 2a                	jmp    103a15 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1039eb:	8b 45 14             	mov    0x14(%ebp),%eax
  1039ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1039f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1039fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a00:	c7 04 24 3d 39 10 00 	movl   $0x10393d,(%esp)
  103a07:	e8 53 fb ff ff       	call   10355f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a0f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103a15:	c9                   	leave  
  103a16:	c3                   	ret    

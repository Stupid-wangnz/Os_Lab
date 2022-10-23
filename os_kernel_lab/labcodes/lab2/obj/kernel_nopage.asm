
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100045:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  10005d:	e8 e1 57 00 00       	call   105843 <memset>

    cons_init();                // init the console
  100062:	e8 4b 16 00 00       	call   1016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 80 60 10 00 	movl   $0x106080,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 9c 60 10 00 	movl   $0x10609c,(%esp)
  10007c:	e8 44 02 00 00       	call   1002c5 <cprintf>

    print_kerninfo();
  100081:	e8 02 09 00 00       	call   100988 <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 5d 32 00 00       	call   1032ed <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 98 17 00 00       	call   10182d <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 18 19 00 00       	call   1019b2 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 5a 0d 00 00       	call   100df9 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 d5 18 00 00       	call   101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 17 0d 00 00       	call   100de3 <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 a1 60 10 00 	movl   $0x1060a1,(%esp)
  10017d:	e8 43 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 af 60 10 00 	movl   $0x1060af,(%esp)
  10019c:	e8 24 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 bd 60 10 00 	movl   $0x1060bd,(%esp)
  1001bb:	e8 05 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 cb 60 10 00 	movl   $0x1060cb,(%esp)
  1001da:	e8 e6 00 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 d9 60 10 00 	movl   $0x1060d9,(%esp)
  1001f9:	e8 c7 00 00 00       	call   1002c5 <cprintf>
    round ++;
  1001fe:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
  100213:	83 ec 08             	sub    $0x8,%esp
  100216:	cd 78                	int    $0x78
  100218:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
        "movl %%ebp, %%esp\n"
		:
		:"i" (T_SWITCH_TOU)
	);
}
  10021a:	90                   	nop
  10021b:	5d                   	pop    %ebp
  10021c:	c3                   	ret    

0010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10021d:	f3 0f 1e fb          	endbr32 
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    __asm__ __volatile__(
  100224:	cd 79                	int    $0x79
  100226:	89 ec                	mov    %ebp,%esp
    	"int %0 \n"
    	"movl %%ebp,%%esp \n" 
    	:
    	:"i"(T_SWITCH_TOK)
    );
}
  100228:	90                   	nop
  100229:	5d                   	pop    %ebp
  10022a:	c3                   	ret    

0010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10022b:	f3 0f 1e fb          	endbr32 
  10022f:	55                   	push   %ebp
  100230:	89 e5                	mov    %esp,%ebp
  100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100235:	e8 10 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023a:	c7 04 24 e8 60 10 00 	movl   $0x1060e8,(%esp)
  100241:	e8 7f 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_user();
  100246:	e8 c1 ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  10024b:	e8 fa fe ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100250:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
  100257:	e8 69 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_kernel();
  10025c:	e8 bc ff ff ff       	call   10021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100261:	e8 e4 fe ff ff       	call   10014a <lab1_print_cur_status>
}
  100266:	90                   	nop
  100267:	c9                   	leave  
  100268:	c3                   	ret    

00100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100269:	f3 0f 1e fb          	endbr32 
  10026d:	55                   	push   %ebp
  10026e:	89 e5                	mov    %esp,%ebp
  100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	89 04 24             	mov    %eax,(%esp)
  100279:	e8 65 14 00 00       	call   1016e3 <cons_putc>
    (*cnt) ++;
  10027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100281:	8b 00                	mov    (%eax),%eax
  100283:	8d 50 01             	lea    0x1(%eax),%edx
  100286:	8b 45 0c             	mov    0xc(%ebp),%eax
  100289:	89 10                	mov    %edx,(%eax)
}
  10028b:	90                   	nop
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    

0010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10028e:	f3 0f 1e fb          	endbr32 
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10029f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b4:	c7 04 24 69 02 10 00 	movl   $0x100269,(%esp)
  1002bb:	e8 ef 58 00 00       	call   105baf <vprintfmt>
    return cnt;
  1002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c3:	c9                   	leave  
  1002c4:	c3                   	ret    

001002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002c5:	f3 0f 1e fb          	endbr32 
  1002c9:	55                   	push   %ebp
  1002ca:	89 e5                	mov    %esp,%ebp
  1002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002df:	89 04 24             	mov    %eax,(%esp)
  1002e2:	e8 a7 ff ff ff       	call   10028e <vcprintf>
  1002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ef:	f3 0f 1e fb          	endbr32 
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fc:	89 04 24             	mov    %eax,(%esp)
  1002ff:	e8 df 13 00 00       	call   1016e3 <cons_putc>
}
  100304:	90                   	nop
  100305:	c9                   	leave  
  100306:	c3                   	ret    

00100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100307:	f3 0f 1e fb          	endbr32 
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100318:	eb 13                	jmp    10032d <cputs+0x26>
        cputch(c, &cnt);
  10031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100321:	89 54 24 04          	mov    %edx,0x4(%esp)
  100325:	89 04 24             	mov    %eax,(%esp)
  100328:	e8 3c ff ff ff       	call   100269 <cputch>
    while ((c = *str ++) != '\0') {
  10032d:	8b 45 08             	mov    0x8(%ebp),%eax
  100330:	8d 50 01             	lea    0x1(%eax),%edx
  100333:	89 55 08             	mov    %edx,0x8(%ebp)
  100336:	0f b6 00             	movzbl (%eax),%eax
  100339:	88 45 f7             	mov    %al,-0x9(%ebp)
  10033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100340:	75 d8                	jne    10031a <cputs+0x13>
    }
    cputch('\n', &cnt);
  100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100345:	89 44 24 04          	mov    %eax,0x4(%esp)
  100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100350:	e8 14 ff ff ff       	call   100269 <cputch>
    return cnt;
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100358:	c9                   	leave  
  100359:	c3                   	ret    

0010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035a:	f3 0f 1e fb          	endbr32 
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100364:	90                   	nop
  100365:	e8 ba 13 00 00       	call   101724 <cons_getc>
  10036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100371:	74 f2                	je     100365 <getchar+0xb>
        /* do nothing */;
    return c;
  100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100376:	c9                   	leave  
  100377:	c3                   	ret    

00100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100378:	f3 0f 1e fb          	endbr32 
  10037c:	55                   	push   %ebp
  10037d:	89 e5                	mov    %esp,%ebp
  10037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100386:	74 13                	je     10039b <readline+0x23>
        cprintf("%s", prompt);
  100388:	8b 45 08             	mov    0x8(%ebp),%eax
  10038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10038f:	c7 04 24 27 61 10 00 	movl   $0x106127,(%esp)
  100396:	e8 2a ff ff ff       	call   1002c5 <cprintf>
    }
    int i = 0, c;
  10039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a2:	e8 b3 ff ff ff       	call   10035a <getchar>
  1003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003ae:	79 07                	jns    1003b7 <readline+0x3f>
            return NULL;
  1003b0:	b8 00 00 00 00       	mov    $0x0,%eax
  1003b5:	eb 78                	jmp    10042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003bb:	7e 28                	jle    1003e5 <readline+0x6d>
  1003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c4:	7f 1f                	jg     1003e5 <readline+0x6d>
            cputchar(c);
  1003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c9:	89 04 24             	mov    %eax,(%esp)
  1003cc:	e8 1e ff ff ff       	call   1002ef <cputchar>
            buf[i ++] = c;
  1003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d4:	8d 50 01             	lea    0x1(%eax),%edx
  1003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003dd:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003e3:	eb 45                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003e9:	75 16                	jne    100401 <readline+0x89>
  1003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ef:	7e 10                	jle    100401 <readline+0x89>
            cputchar(c);
  1003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f4:	89 04 24             	mov    %eax,(%esp)
  1003f7:	e8 f3 fe ff ff       	call   1002ef <cputchar>
            i --;
  1003fc:	ff 4d f4             	decl   -0xc(%ebp)
  1003ff:	eb 29                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100405:	74 06                	je     10040d <readline+0x95>
  100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10040b:	75 95                	jne    1003a2 <readline+0x2a>
            cputchar(c);
  10040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100410:	89 04 24             	mov    %eax,(%esp)
  100413:	e8 d7 fe ff ff       	call   1002ef <cputchar>
            buf[i] = '\0';
  100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041b:	05 20 c0 11 00       	add    $0x11c020,%eax
  100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100423:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  100428:	eb 05                	jmp    10042f <readline+0xb7>
        c = getchar();
  10042a:	e9 73 ff ff ff       	jmp    1003a2 <readline+0x2a>
        }
    }
}
  10042f:	c9                   	leave  
  100430:	c3                   	ret    

00100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100431:	f3 0f 1e fb          	endbr32 
  100435:	55                   	push   %ebp
  100436:	89 e5                	mov    %esp,%ebp
  100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10043b:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100440:	85 c0                	test   %eax,%eax
  100442:	75 5b                	jne    10049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100444:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  10044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10044e:	8d 45 14             	lea    0x14(%ebp),%eax
  100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100454:	8b 45 0c             	mov    0xc(%ebp),%eax
  100457:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045b:	8b 45 08             	mov    0x8(%ebp),%eax
  10045e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100462:	c7 04 24 2a 61 10 00 	movl   $0x10612a,(%esp)
  100469:	e8 57 fe ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  10046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100471:	89 44 24 04          	mov    %eax,0x4(%esp)
  100475:	8b 45 10             	mov    0x10(%ebp),%eax
  100478:	89 04 24             	mov    %eax,(%esp)
  10047b:	e8 0e fe ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  100480:	c7 04 24 46 61 10 00 	movl   $0x106146,(%esp)
  100487:	e8 39 fe ff ff       	call   1002c5 <cprintf>
    
    cprintf("stack trackback:\n");
  10048c:	c7 04 24 48 61 10 00 	movl   $0x106148,(%esp)
  100493:	e8 2d fe ff ff       	call   1002c5 <cprintf>
    print_stackframe();
  100498:	e8 3d 06 00 00       	call   100ada <print_stackframe>
  10049d:	eb 01                	jmp    1004a0 <__panic+0x6f>
        goto panic_dead;
  10049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a0:	e8 e0 14 00 00       	call   101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004ac:	e8 59 08 00 00       	call   100d0a <kmonitor>
  1004b1:	eb f2                	jmp    1004a5 <__panic+0x74>

001004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b3:	f3 0f 1e fb          	endbr32 
  1004b7:	55                   	push   %ebp
  1004b8:	89 e5                	mov    %esp,%ebp
  1004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d1:	c7 04 24 5a 61 10 00 	movl   $0x10615a,(%esp)
  1004d8:	e8 e8 fd ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  1004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e7:	89 04 24             	mov    %eax,(%esp)
  1004ea:	e8 9f fd ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  1004ef:	c7 04 24 46 61 10 00 	movl   $0x106146,(%esp)
  1004f6:	e8 ca fd ff ff       	call   1002c5 <cprintf>
    va_end(ap);
}
  1004fb:	90                   	nop
  1004fc:	c9                   	leave  
  1004fd:	c3                   	ret    

001004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004fe:	f3 0f 1e fb          	endbr32 
  100502:	55                   	push   %ebp
  100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100505:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  10050a:	5d                   	pop    %ebp
  10050b:	c3                   	ret    

0010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10050c:	f3 0f 1e fb          	endbr32 
  100510:	55                   	push   %ebp
  100511:	89 e5                	mov    %esp,%ebp
  100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100516:	8b 45 0c             	mov    0xc(%ebp),%eax
  100519:	8b 00                	mov    (%eax),%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10051e:	8b 45 10             	mov    0x10(%ebp),%eax
  100521:	8b 00                	mov    (%eax),%eax
  100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10052d:	e9 ca 00 00 00       	jmp    1005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	c1 ea 1f             	shr    $0x1f,%edx
  10053f:	01 d0                	add    %edx,%eax
  100541:	d1 f8                	sar    %eax
  100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10054c:	eb 03                	jmp    100551 <stab_binsearch+0x45>
            m --;
  10054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100557:	7c 1f                	jl     100578 <stab_binsearch+0x6c>
  100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055c:	89 d0                	mov    %edx,%eax
  10055e:	01 c0                	add    %eax,%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	c1 e0 02             	shl    $0x2,%eax
  100565:	89 c2                	mov    %eax,%edx
  100567:	8b 45 08             	mov    0x8(%ebp),%eax
  10056a:	01 d0                	add    %edx,%eax
  10056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100570:	0f b6 c0             	movzbl %al,%eax
  100573:	39 45 14             	cmp    %eax,0x14(%ebp)
  100576:	75 d6                	jne    10054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10057e:	7d 09                	jge    100589 <stab_binsearch+0x7d>
            l = true_m + 1;
  100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100583:	40                   	inc    %eax
  100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100587:	eb 73                	jmp    1005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	01 c0                	add    %eax,%eax
  100597:	01 d0                	add    %edx,%eax
  100599:	c1 e0 02             	shl    $0x2,%eax
  10059c:	89 c2                	mov    %eax,%edx
  10059e:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a1:	01 d0                	add    %edx,%eax
  1005a3:	8b 40 08             	mov    0x8(%eax),%eax
  1005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a9:	76 11                	jbe    1005bc <stab_binsearch+0xb0>
            *region_left = m;
  1005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005b6:	40                   	inc    %eax
  1005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005ba:	eb 40                	jmp    1005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bf:	89 d0                	mov    %edx,%eax
  1005c1:	01 c0                	add    %eax,%eax
  1005c3:	01 d0                	add    %edx,%eax
  1005c5:	c1 e0 02             	shl    $0x2,%eax
  1005c8:	89 c2                	mov    %eax,%edx
  1005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cd:	01 d0                	add    %edx,%eax
  1005cf:	8b 40 08             	mov    0x8(%eax),%eax
  1005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005d5:	73 14                	jae    1005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e5:	48                   	dec    %eax
  1005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005e9:	eb 11                	jmp    1005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f1:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100602:	0f 8e 2a ff ff ff    	jle    100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10060c:	75 0f                	jne    10061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	8b 00                	mov    (%eax),%eax
  100613:	8d 50 ff             	lea    -0x1(%eax),%edx
  100616:	8b 45 10             	mov    0x10(%ebp),%eax
  100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10061b:	eb 3e                	jmp    10065b <stab_binsearch+0x14f>
        l = *region_right;
  10061d:	8b 45 10             	mov    0x10(%ebp),%eax
  100620:	8b 00                	mov    (%eax),%eax
  100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100625:	eb 03                	jmp    10062a <stab_binsearch+0x11e>
  100627:	ff 4d fc             	decl   -0x4(%ebp)
  10062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062d:	8b 00                	mov    (%eax),%eax
  10062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100632:	7e 1f                	jle    100653 <stab_binsearch+0x147>
  100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100637:	89 d0                	mov    %edx,%eax
  100639:	01 c0                	add    %eax,%eax
  10063b:	01 d0                	add    %edx,%eax
  10063d:	c1 e0 02             	shl    $0x2,%eax
  100640:	89 c2                	mov    %eax,%edx
  100642:	8b 45 08             	mov    0x8(%ebp),%eax
  100645:	01 d0                	add    %edx,%eax
  100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10064b:	0f b6 c0             	movzbl %al,%eax
  10064e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100651:	75 d4                	jne    100627 <stab_binsearch+0x11b>
        *region_left = l;
  100653:	8b 45 0c             	mov    0xc(%ebp),%eax
  100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100659:	89 10                	mov    %edx,(%eax)
}
  10065b:	90                   	nop
  10065c:	c9                   	leave  
  10065d:	c3                   	ret    

0010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10065e:	f3 0f 1e fb          	endbr32 
  100662:	55                   	push   %ebp
  100663:	89 e5                	mov    %esp,%ebp
  100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100668:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066b:	c7 00 78 61 10 00    	movl   $0x106178,(%eax)
    info->eip_line = 0;
  100671:	8b 45 0c             	mov    0xc(%ebp),%eax
  100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067e:	c7 40 08 78 61 10 00 	movl   $0x106178,0x8(%eax)
    info->eip_fn_namelen = 9;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100692:	8b 55 08             	mov    0x8(%ebp),%edx
  100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a2:	c7 45 f4 f0 73 10 00 	movl   $0x1073f0,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006a9:	c7 45 f0 74 3a 11 00 	movl   $0x113a74,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b0:	c7 45 ec 75 3a 11 00 	movl   $0x113a75,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b7:	c7 45 e8 78 65 11 00 	movl   $0x116578,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c4:	76 0b                	jbe    1006d1 <debuginfo_eip+0x73>
  1006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c9:	48                   	dec    %eax
  1006ca:	0f b6 00             	movzbl (%eax),%eax
  1006cd:	84 c0                	test   %al,%al
  1006cf:	74 0a                	je     1006db <debuginfo_eip+0x7d>
        return -1;
  1006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d6:	e9 ab 02 00 00       	jmp    100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006e8:	c1 f8 02             	sar    $0x2,%eax
  1006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f1:	48                   	dec    %eax
  1006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100703:	00 
  100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100707:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10070e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	89 04 24             	mov    %eax,(%esp)
  100718:	e8 ef fd ff ff       	call   10050c <stab_binsearch>
    if (lfile == 0)
  10071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100720:	85 c0                	test   %eax,%eax
  100722:	75 0a                	jne    10072e <debuginfo_eip+0xd0>
        return -1;
  100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100729:	e9 58 02 00 00       	jmp    100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073a:	8b 45 08             	mov    0x8(%ebp),%eax
  10073d:	89 44 24 10          	mov    %eax,0x10(%esp)
  100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100748:	00 
  100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100753:	89 44 24 04          	mov    %eax,0x4(%esp)
  100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075a:	89 04 24             	mov    %eax,(%esp)
  10075d:	e8 aa fd ff ff       	call   10050c <stab_binsearch>

    if (lfun <= rfun) {
  100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100768:	39 c2                	cmp    %eax,%edx
  10076a:	7f 78                	jg     1007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	89 d0                	mov    %edx,%eax
  100773:	01 c0                	add    %eax,%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	c1 e0 02             	shl    $0x2,%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	8b 10                	mov    (%eax),%edx
  100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	73 22                	jae    1007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 10                	mov    (%eax),%edx
  1007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a7:	01 c2                	add    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	8b 50 08             	mov    0x8(%eax),%edx
  1007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d0:	8b 40 10             	mov    0x10(%eax),%eax
  1007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e2:	eb 15                	jmp    1007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fc:	8b 40 08             	mov    0x8(%eax),%eax
  1007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100806:	00 
  100807:	89 04 24             	mov    %eax,(%esp)
  10080a:	e8 a8 4e 00 00       	call   1056b7 <strfind>
  10080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100812:	8b 52 08             	mov    0x8(%edx),%edx
  100815:	29 d0                	sub    %edx,%eax
  100817:	89 c2                	mov    %eax,%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10081f:	8b 45 08             	mov    0x8(%ebp),%eax
  100822:	89 44 24 10          	mov    %eax,0x10(%esp)
  100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10082d:	00 
  10082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100831:	89 44 24 08          	mov    %eax,0x8(%esp)
  100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100838:	89 44 24 04          	mov    %eax,0x4(%esp)
  10083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083f:	89 04 24             	mov    %eax,(%esp)
  100842:	e8 c5 fc ff ff       	call   10050c <stab_binsearch>
    if (lline <= rline) {
  100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10084d:	39 c2                	cmp    %eax,%edx
  10084f:	7f 23                	jg     100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100872:	eb 11                	jmp    100885 <debuginfo_eip+0x227>
        return -1;
  100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100879:	e9 08 01 00 00       	jmp    100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100881:	48                   	dec    %eax
  100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088b:	39 c2                	cmp    %eax,%edx
  10088d:	7c 56                	jl     1008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	89 d0                	mov    %edx,%eax
  100896:	01 c0                	add    %eax,%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	c1 e0 02             	shl    $0x2,%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a2:	01 d0                	add    %edx,%eax
  1008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008a8:	3c 84                	cmp    $0x84,%al
  1008aa:	74 39                	je     1008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	89 d0                	mov    %edx,%eax
  1008b3:	01 c0                	add    %eax,%eax
  1008b5:	01 d0                	add    %edx,%eax
  1008b7:	c1 e0 02             	shl    $0x2,%eax
  1008ba:	89 c2                	mov    %eax,%edx
  1008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008bf:	01 d0                	add    %edx,%eax
  1008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c5:	3c 64                	cmp    $0x64,%al
  1008c7:	75 b5                	jne    10087e <debuginfo_eip+0x220>
  1008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	89 d0                	mov    %edx,%eax
  1008d0:	01 c0                	add    %eax,%eax
  1008d2:	01 d0                	add    %edx,%eax
  1008d4:	c1 e0 02             	shl    $0x2,%eax
  1008d7:	89 c2                	mov    %eax,%edx
  1008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008dc:	01 d0                	add    %edx,%eax
  1008de:	8b 40 08             	mov    0x8(%eax),%eax
  1008e1:	85 c0                	test   %eax,%eax
  1008e3:	74 99                	je     10087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008eb:	39 c2                	cmp    %eax,%edx
  1008ed:	7c 42                	jl     100931 <debuginfo_eip+0x2d3>
  1008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	01 c0                	add    %eax,%eax
  1008f8:	01 d0                	add    %edx,%eax
  1008fa:	c1 e0 02             	shl    $0x2,%eax
  1008fd:	89 c2                	mov    %eax,%edx
  1008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100902:	01 d0                	add    %edx,%eax
  100904:	8b 10                	mov    (%eax),%edx
  100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10090c:	39 c2                	cmp    %eax,%edx
  10090e:	73 21                	jae    100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	89 d0                	mov    %edx,%eax
  100917:	01 c0                	add    %eax,%eax
  100919:	01 d0                	add    %edx,%eax
  10091b:	c1 e0 02             	shl    $0x2,%eax
  10091e:	89 c2                	mov    %eax,%edx
  100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100923:	01 d0                	add    %edx,%eax
  100925:	8b 10                	mov    (%eax),%edx
  100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092a:	01 c2                	add    %eax,%edx
  10092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100937:	39 c2                	cmp    %eax,%edx
  100939:	7d 46                	jge    100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10093e:	40                   	inc    %eax
  10093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100942:	eb 16                	jmp    10095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100944:	8b 45 0c             	mov    0xc(%ebp),%eax
  100947:	8b 40 14             	mov    0x14(%eax),%eax
  10094a:	8d 50 01             	lea    0x1(%eax),%edx
  10094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100956:	40                   	inc    %eax
  100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100960:	39 c2                	cmp    %eax,%edx
  100962:	7d 1d                	jge    100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	89 d0                	mov    %edx,%eax
  10096b:	01 c0                	add    %eax,%eax
  10096d:	01 d0                	add    %edx,%eax
  10096f:	c1 e0 02             	shl    $0x2,%eax
  100972:	89 c2                	mov    %eax,%edx
  100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100977:	01 d0                	add    %edx,%eax
  100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10097d:	3c a0                	cmp    $0xa0,%al
  10097f:	74 c3                	je     100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100986:	c9                   	leave  
  100987:	c3                   	ret    

00100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100988:	f3 0f 1e fb          	endbr32 
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100992:	c7 04 24 82 61 10 00 	movl   $0x106182,(%esp)
  100999:	e8 27 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10099e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009a5:	00 
  1009a6:	c7 04 24 9b 61 10 00 	movl   $0x10619b,(%esp)
  1009ad:	e8 13 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b2:	c7 44 24 04 67 60 10 	movl   $0x106067,0x4(%esp)
  1009b9:	00 
  1009ba:	c7 04 24 b3 61 10 00 	movl   $0x1061b3,(%esp)
  1009c1:	e8 ff f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c6:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009cd:	00 
  1009ce:	c7 04 24 cb 61 10 00 	movl   $0x1061cb,(%esp)
  1009d5:	e8 eb f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009da:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009e1:	00 
  1009e2:	c7 04 24 e3 61 10 00 	movl   $0x1061e3,(%esp)
  1009e9:	e8 d7 f8 ff ff       	call   1002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ee:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  1009f3:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a03:	85 c0                	test   %eax,%eax
  100a05:	0f 48 c2             	cmovs  %edx,%eax
  100a08:	c1 f8 0a             	sar    $0xa,%eax
  100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0f:	c7 04 24 fc 61 10 00 	movl   $0x1061fc,(%esp)
  100a16:	e8 aa f8 ff ff       	call   1002c5 <cprintf>
}
  100a1b:	90                   	nop
  100a1c:	c9                   	leave  
  100a1d:	c3                   	ret    

00100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a1e:	f3 0f 1e fb          	endbr32 
  100a22:	55                   	push   %ebp
  100a23:	89 e5                	mov    %esp,%ebp
  100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a32:	8b 45 08             	mov    0x8(%ebp),%eax
  100a35:	89 04 24             	mov    %eax,(%esp)
  100a38:	e8 21 fc ff ff       	call   10065e <debuginfo_eip>
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	74 15                	je     100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a41:	8b 45 08             	mov    0x8(%ebp),%eax
  100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a48:	c7 04 24 26 62 10 00 	movl   $0x106226,(%esp)
  100a4f:	e8 71 f8 ff ff       	call   1002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a54:	eb 6c                	jmp    100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a5d:	eb 1b                	jmp    100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	01 d0                	add    %edx,%eax
  100a67:	0f b6 10             	movzbl (%eax),%edx
  100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a73:	01 c8                	add    %ecx,%eax
  100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a77:	ff 45 f4             	incl   -0xc(%ebp)
  100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a80:	7c dd                	jl     100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8b:	01 d0                	add    %edx,%eax
  100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a93:	8b 55 08             	mov    0x8(%ebp),%edx
  100a96:	89 d1                	mov    %edx,%ecx
  100a98:	29 c1                	sub    %eax,%ecx
  100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 42 62 10 00 	movl   $0x106242,(%esp)
  100abd:	e8 03 f8 ff ff       	call   1002c5 <cprintf>
}
  100ac2:	90                   	nop
  100ac3:	c9                   	leave  
  100ac4:	c3                   	ret    

00100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ac5:	f3 0f 1e fb          	endbr32 
  100ac9:	55                   	push   %ebp
  100aca:	89 e5                	mov    %esp,%ebp
  100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100acf:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ad8:	c9                   	leave  
  100ad9:	c3                   	ret    

00100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100ada:	f3 0f 1e fb          	endbr32 
  100ade:	55                   	push   %ebp
  100adf:	89 e5                	mov    %esp,%ebp
  100ae1:	53                   	push   %ebx
  100ae2:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ae5:	89 e8                	mov    %ebp,%eax
  100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
  100aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  100af0:	e8 d0 ff ff ff       	call   100ac5 <read_eip>
  100af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100af8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aff:	eb 7e                	jmp    100b7f <print_stackframe+0xa5>
	{
		cprintf("ebp:0x%08x eip:0x%08x\n",ebp,eip);
  100b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0f:	c7 04 24 54 62 10 00 	movl   $0x106254,(%esp)
  100b16:	e8 aa f7 ff ff       	call   1002c5 <cprintf>
		uint32_t *args=(uint32_t *)ebp+2;
  100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1e:	83 c0 08             	add    $0x8,%eax
  100b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));//依次打印调用函数的参数1 2 3 4
  100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b27:	83 c0 0c             	add    $0xc,%eax
  100b2a:	8b 18                	mov    (%eax),%ebx
  100b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b2f:	83 c0 08             	add    $0x8,%eax
  100b32:	8b 08                	mov    (%eax),%ecx
  100b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b37:	83 c0 04             	add    $0x4,%eax
  100b3a:	8b 10                	mov    (%eax),%edx
  100b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b3f:	8b 00                	mov    (%eax),%eax
  100b41:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b45:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b49:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b51:	c7 04 24 6c 62 10 00 	movl   $0x10626c,(%esp)
  100b58:	e8 68 f7 ff ff       	call   1002c5 <cprintf>
 
 
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。

		print_debuginfo(eip-1);
  100b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b60:	48                   	dec    %eax
  100b61:	89 04 24             	mov    %eax,(%esp)
  100b64:	e8 b5 fe ff ff       	call   100a1e <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
  100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6c:	83 c0 04             	add    $0x4,%eax
  100b6f:	8b 00                	mov    (%eax),%eax
  100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
  100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b77:	8b 00                	mov    (%eax),%eax
  100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100b7c:	ff 45 ec             	incl   -0x14(%ebp)
  100b7f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b83:	7f 0a                	jg     100b8f <print_stackframe+0xb5>
  100b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b89:	0f 85 72 ff ff ff    	jne    100b01 <print_stackframe+0x27>
    }
}
  100b8f:	90                   	nop
  100b90:	83 c4 44             	add    $0x44,%esp
  100b93:	5b                   	pop    %ebx
  100b94:	5d                   	pop    %ebp
  100b95:	c3                   	ret    

00100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b96:	f3 0f 1e fb          	endbr32 
  100b9a:	55                   	push   %ebp
  100b9b:	89 e5                	mov    %esp,%ebp
  100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba7:	eb 0c                	jmp    100bb5 <parse+0x1f>
            *buf ++ = '\0';
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	8d 50 01             	lea    0x1(%eax),%edx
  100baf:	89 55 08             	mov    %edx,0x8(%ebp)
  100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	84 c0                	test   %al,%al
  100bbd:	74 1d                	je     100bdc <parse+0x46>
  100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc2:	0f b6 00             	movzbl (%eax),%eax
  100bc5:	0f be c0             	movsbl %al,%eax
  100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcc:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  100bd3:	e8 a9 4a 00 00       	call   105681 <strchr>
  100bd8:	85 c0                	test   %eax,%eax
  100bda:	75 cd                	jne    100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
  100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdf:	0f b6 00             	movzbl (%eax),%eax
  100be2:	84 c0                	test   %al,%al
  100be4:	74 65                	je     100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bea:	75 14                	jne    100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bf3:	00 
  100bf4:	c7 04 24 15 63 10 00 	movl   $0x106315,(%esp)
  100bfb:	e8 c5 f6 ff ff       	call   1002c5 <cprintf>
        }
        argv[argc ++] = buf;
  100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c03:	8d 50 01             	lea    0x1(%eax),%edx
  100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c13:	01 c2                	add    %eax,%edx
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1a:	eb 03                	jmp    100c1f <parse+0x89>
            buf ++;
  100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c22:	0f b6 00             	movzbl (%eax),%eax
  100c25:	84 c0                	test   %al,%al
  100c27:	74 8c                	je     100bb5 <parse+0x1f>
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	0f b6 00             	movzbl (%eax),%eax
  100c2f:	0f be c0             	movsbl %al,%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  100c3d:	e8 3f 4a 00 00       	call   105681 <strchr>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	74 d6                	je     100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c46:	e9 6a ff ff ff       	jmp    100bb5 <parse+0x1f>
            break;
  100c4b:	90                   	nop
        }
    }
    return argc;
  100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c51:	f3 0f 1e fb          	endbr32 
  100c55:	55                   	push   %ebp
  100c56:	89 e5                	mov    %esp,%ebp
  100c58:	53                   	push   %ebx
  100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c63:	8b 45 08             	mov    0x8(%ebp),%eax
  100c66:	89 04 24             	mov    %eax,(%esp)
  100c69:	e8 28 ff ff ff       	call   100b96 <parse>
  100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c75:	75 0a                	jne    100c81 <runcmd+0x30>
        return 0;
  100c77:	b8 00 00 00 00       	mov    $0x0,%eax
  100c7c:	e9 83 00 00 00       	jmp    100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c88:	eb 5a                	jmp    100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c90:	89 d0                	mov    %edx,%eax
  100c92:	01 c0                	add    %eax,%eax
  100c94:	01 d0                	add    %edx,%eax
  100c96:	c1 e0 02             	shl    $0x2,%eax
  100c99:	05 00 90 11 00       	add    $0x119000,%eax
  100c9e:	8b 00                	mov    (%eax),%eax
  100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca4:	89 04 24             	mov    %eax,(%esp)
  100ca7:	e8 31 49 00 00       	call   1055dd <strcmp>
  100cac:	85 c0                	test   %eax,%eax
  100cae:	75 31                	jne    100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb3:	89 d0                	mov    %edx,%eax
  100cb5:	01 c0                	add    %eax,%eax
  100cb7:	01 d0                	add    %edx,%eax
  100cb9:	c1 e0 02             	shl    $0x2,%eax
  100cbc:	05 08 90 11 00       	add    $0x119008,%eax
  100cc1:	8b 10                	mov    (%eax),%edx
  100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cc6:	83 c0 04             	add    $0x4,%eax
  100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cda:	89 1c 24             	mov    %ebx,(%esp)
  100cdd:	ff d2                	call   *%edx
  100cdf:	eb 23                	jmp    100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce1:	ff 45 f4             	incl   -0xc(%ebp)
  100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce7:	83 f8 02             	cmp    $0x2,%eax
  100cea:	76 9e                	jbe    100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf3:	c7 04 24 33 63 10 00 	movl   $0x106333,(%esp)
  100cfa:	e8 c6 f5 ff ff       	call   1002c5 <cprintf>
    return 0;
  100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d04:	83 c4 64             	add    $0x64,%esp
  100d07:	5b                   	pop    %ebx
  100d08:	5d                   	pop    %ebp
  100d09:	c3                   	ret    

00100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d0a:	f3 0f 1e fb          	endbr32 
  100d0e:	55                   	push   %ebp
  100d0f:	89 e5                	mov    %esp,%ebp
  100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d14:	c7 04 24 4c 63 10 00 	movl   $0x10634c,(%esp)
  100d1b:	e8 a5 f5 ff ff       	call   1002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d20:	c7 04 24 74 63 10 00 	movl   $0x106374,(%esp)
  100d27:	e8 99 f5 ff ff       	call   1002c5 <cprintf>

    if (tf != NULL) {
  100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d30:	74 0b                	je     100d3d <kmonitor+0x33>
        print_trapframe(tf);
  100d32:	8b 45 08             	mov    0x8(%ebp),%eax
  100d35:	89 04 24             	mov    %eax,(%esp)
  100d38:	e8 b6 0e 00 00       	call   101bf3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d3d:	c7 04 24 99 63 10 00 	movl   $0x106399,(%esp)
  100d44:	e8 2f f6 ff ff       	call   100378 <readline>
  100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d50:	74 eb                	je     100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d52:	8b 45 08             	mov    0x8(%ebp),%eax
  100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5c:	89 04 24             	mov    %eax,(%esp)
  100d5f:	e8 ed fe ff ff       	call   100c51 <runcmd>
  100d64:	85 c0                	test   %eax,%eax
  100d66:	78 02                	js     100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d68:	eb d3                	jmp    100d3d <kmonitor+0x33>
                break;
  100d6a:	90                   	nop
            }
        }
    }
}
  100d6b:	90                   	nop
  100d6c:	c9                   	leave  
  100d6d:	c3                   	ret    

00100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d6e:	f3 0f 1e fb          	endbr32 
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d7f:	eb 3d                	jmp    100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d84:	89 d0                	mov    %edx,%eax
  100d86:	01 c0                	add    %eax,%eax
  100d88:	01 d0                	add    %edx,%eax
  100d8a:	c1 e0 02             	shl    $0x2,%eax
  100d8d:	05 04 90 11 00       	add    $0x119004,%eax
  100d92:	8b 08                	mov    (%eax),%ecx
  100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d97:	89 d0                	mov    %edx,%eax
  100d99:	01 c0                	add    %eax,%eax
  100d9b:	01 d0                	add    %edx,%eax
  100d9d:	c1 e0 02             	shl    $0x2,%eax
  100da0:	05 00 90 11 00       	add    $0x119000,%eax
  100da5:	8b 00                	mov    (%eax),%eax
  100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100daf:	c7 04 24 9d 63 10 00 	movl   $0x10639d,(%esp)
  100db6:	e8 0a f5 ff ff       	call   1002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100dbb:	ff 45 f4             	incl   -0xc(%ebp)
  100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc1:	83 f8 02             	cmp    $0x2,%eax
  100dc4:	76 bb                	jbe    100d81 <mon_help+0x13>
    }
    return 0;
  100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dcd:	f3 0f 1e fb          	endbr32 
  100dd1:	55                   	push   %ebp
  100dd2:	89 e5                	mov    %esp,%ebp
  100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd7:	e8 ac fb ff ff       	call   100988 <print_kerninfo>
    return 0;
  100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de1:	c9                   	leave  
  100de2:	c3                   	ret    

00100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100de3:	f3 0f 1e fb          	endbr32 
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ded:	e8 e8 fc ff ff       	call   100ada <print_stackframe>
    return 0;
  100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df9:	f3 0f 1e fb          	endbr32 
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 28             	sub    $0x28,%esp
  100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e15:	ee                   	out    %al,(%dx)
}
  100e16:	90                   	nop
  100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e29:	ee                   	out    %al,(%dx)
}
  100e2a:	90                   	nop
  100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e3d:	ee                   	out    %al,(%dx)
}
  100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e3f:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e49:	c7 04 24 a6 63 10 00 	movl   $0x1063a6,(%esp)
  100e50:	e8 70 f4 ff ff       	call   1002c5 <cprintf>
    pic_enable(IRQ_TIMER);
  100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e5c:	e8 95 09 00 00       	call   1017f6 <pic_enable>
}
  100e61:	90                   	nop
  100e62:	c9                   	leave  
  100e63:	c3                   	ret    

00100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e6a:	9c                   	pushf  
  100e6b:	58                   	pop    %eax
  100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e72:	25 00 02 00 00       	and    $0x200,%eax
  100e77:	85 c0                	test   %eax,%eax
  100e79:	74 0c                	je     100e87 <__intr_save+0x23>
        intr_disable();
  100e7b:	e8 05 0b 00 00       	call   101985 <intr_disable>
        return 1;
  100e80:	b8 01 00 00 00       	mov    $0x1,%eax
  100e85:	eb 05                	jmp    100e8c <__intr_save+0x28>
    }
    return 0;
  100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e8c:	c9                   	leave  
  100e8d:	c3                   	ret    

00100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e8e:	55                   	push   %ebp
  100e8f:	89 e5                	mov    %esp,%ebp
  100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e98:	74 05                	je     100e9f <__intr_restore+0x11>
        intr_enable();
  100e9a:	e8 da 0a 00 00       	call   101979 <intr_enable>
    }
}
  100e9f:	90                   	nop
  100ea0:	c9                   	leave  
  100ea1:	c3                   	ret    

00100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ea2:	f3 0f 1e fb          	endbr32 
  100ea6:	55                   	push   %ebp
  100ea7:	89 e5                	mov    %esp,%ebp
  100ea9:	83 ec 10             	sub    $0x10,%esp
  100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb6:	89 c2                	mov    %eax,%edx
  100eb8:	ec                   	in     (%dx),%al
  100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ee6:	89 c2                	mov    %eax,%edx
  100ee8:	ec                   	in     (%dx),%al
  100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eec:	90                   	nop
  100eed:	c9                   	leave  
  100eee:	c3                   	ret    

00100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eef:	f3 0f 1e fb          	endbr32 
  100ef3:	55                   	push   %ebp
  100ef4:	89 e5                	mov    %esp,%ebp
  100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f03:	0f b7 00             	movzwl (%eax),%eax
  100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f15:	0f b7 00             	movzwl (%eax),%eax
  100f18:	0f b7 c0             	movzwl %ax,%eax
  100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f20:	74 12                	je     100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f29:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f30:	b4 03 
  100f32:	eb 13                	jmp    100f47 <cga_init+0x58>
    } else {
        *cp = was;
  100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f3e:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f47:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f60:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f67:	40                   	inc    %eax
  100f68:	0f b7 c0             	movzwl %ax,%eax
  100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f73:	89 c2                	mov    %eax,%edx
  100f75:	ec                   	in     (%dx),%al
  100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	c1 e0 08             	shl    $0x8,%eax
  100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f86:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f9d:	ee                   	out    %al,(%dx)
}
  100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f9f:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100fa6:	40                   	inc    %eax
  100fa7:	0f b7 c0             	movzwl %ax,%eax
  100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fb2:	89 c2                	mov    %eax,%edx
  100fb4:	ec                   	in     (%dx),%al
  100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fbc:	0f b6 c0             	movzbl %al,%eax
  100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc5:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fcd:	0f b7 c0             	movzwl %ax,%eax
  100fd0:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100fd6:	90                   	nop
  100fd7:	c9                   	leave  
  100fd8:	c3                   	ret    

00100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd9:	f3 0f 1e fb          	endbr32 
  100fdd:	55                   	push   %ebp
  100fde:	89 e5                	mov    %esp,%ebp
  100fe0:	83 ec 48             	sub    $0x48,%esp
  100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
}
  100ff6:	90                   	nop
  100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101009:	ee                   	out    %al,(%dx)
}
  10100a:	90                   	nop
  10100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
}
  10101e:	90                   	nop
  10101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
}
  101032:	90                   	nop
  101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101045:	ee                   	out    %al,(%dx)
}
  101046:	90                   	nop
  101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101059:	ee                   	out    %al,(%dx)
}
  10105a:	90                   	nop
  10105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10106d:	ee                   	out    %al,(%dx)
}
  10106e:	90                   	nop
  10106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101079:	89 c2                	mov    %eax,%edx
  10107b:	ec                   	in     (%dx),%al
  10107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101083:	3c ff                	cmp    $0xff,%al
  101085:	0f 95 c0             	setne  %al
  101088:	0f b6 c0             	movzbl %al,%eax
  10108b:	a3 48 c4 11 00       	mov    %eax,0x11c448
  101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10109a:	89 c2                	mov    %eax,%edx
  10109c:	ec                   	in     (%dx),%al
  10109d:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010aa:	89 c2                	mov    %eax,%edx
  1010ac:	ec                   	in     (%dx),%al
  1010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010b0:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1010b5:	85 c0                	test   %eax,%eax
  1010b7:	74 0c                	je     1010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010c0:	e8 31 07 00 00       	call   1017f6 <pic_enable>
    }
}
  1010c5:	90                   	nop
  1010c6:	c9                   	leave  
  1010c7:	c3                   	ret    

001010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010c8:	f3 0f 1e fb          	endbr32 
  1010cc:	55                   	push   %ebp
  1010cd:	89 e5                	mov    %esp,%ebp
  1010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d9:	eb 08                	jmp    1010e3 <lpt_putc_sub+0x1b>
        delay();
  1010db:	e8 c2 fd ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010e0:	ff 45 fc             	incl   -0x4(%ebp)
  1010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010ed:	89 c2                	mov    %eax,%edx
  1010ef:	ec                   	in     (%dx),%al
  1010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010f7:	84 c0                	test   %al,%al
  1010f9:	78 09                	js     101104 <lpt_putc_sub+0x3c>
  1010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101102:	7e d7                	jle    1010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	0f b6 c0             	movzbl %al,%eax
  10110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10111b:	ee                   	out    %al,(%dx)
}
  10111c:	90                   	nop
  10111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10112f:	ee                   	out    %al,(%dx)
}
  101130:	90                   	nop
  101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101143:	ee                   	out    %al,(%dx)
}
  101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101145:	90                   	nop
  101146:	c9                   	leave  
  101147:	c3                   	ret    

00101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101148:	f3 0f 1e fb          	endbr32 
  10114c:	55                   	push   %ebp
  10114d:	89 e5                	mov    %esp,%ebp
  10114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101156:	74 0d                	je     101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101158:	8b 45 08             	mov    0x8(%ebp),%eax
  10115b:	89 04 24             	mov    %eax,(%esp)
  10115e:	e8 65 ff ff ff       	call   1010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101163:	eb 24                	jmp    101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10116c:	e8 57 ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101178:	e8 4b ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101184:	e8 3f ff ff ff       	call   1010c8 <lpt_putc_sub>
}
  101189:	90                   	nop
  10118a:	c9                   	leave  
  10118b:	c3                   	ret    

0010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10118c:	f3 0f 1e fb          	endbr32 
  101190:	55                   	push   %ebp
  101191:	89 e5                	mov    %esp,%ebp
  101193:	53                   	push   %ebx
  101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101197:	8b 45 08             	mov    0x8(%ebp),%eax
  10119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10119f:	85 c0                	test   %eax,%eax
  1011a1:	75 07                	jne    1011aa <cga_putc+0x1e>
        c |= 0x0700;
  1011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ad:	0f b6 c0             	movzbl %al,%eax
  1011b0:	83 f8 0d             	cmp    $0xd,%eax
  1011b3:	74 72                	je     101227 <cga_putc+0x9b>
  1011b5:	83 f8 0d             	cmp    $0xd,%eax
  1011b8:	0f 8f a3 00 00 00    	jg     101261 <cga_putc+0xd5>
  1011be:	83 f8 08             	cmp    $0x8,%eax
  1011c1:	74 0a                	je     1011cd <cga_putc+0x41>
  1011c3:	83 f8 0a             	cmp    $0xa,%eax
  1011c6:	74 4c                	je     101214 <cga_putc+0x88>
  1011c8:	e9 94 00 00 00       	jmp    101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011cd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011d4:	85 c0                	test   %eax,%eax
  1011d6:	0f 84 af 00 00 00    	je     10128b <cga_putc+0xff>
            crt_pos --;
  1011dc:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011e3:	48                   	dec    %eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f0:	98                   	cwtl   
  1011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011f6:	98                   	cwtl   
  1011f7:	83 c8 20             	or     $0x20,%eax
  1011fa:	98                   	cwtl   
  1011fb:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  101201:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101208:	01 c9                	add    %ecx,%ecx
  10120a:	01 ca                	add    %ecx,%edx
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101212:	eb 77                	jmp    10128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101214:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10121b:	83 c0 50             	add    $0x50,%eax
  10121e:	0f b7 c0             	movzwl %ax,%eax
  101221:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101227:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  10122e:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10123a:	89 c8                	mov    %ecx,%eax
  10123c:	f7 e2                	mul    %edx
  10123e:	c1 ea 06             	shr    $0x6,%edx
  101241:	89 d0                	mov    %edx,%eax
  101243:	c1 e0 02             	shl    $0x2,%eax
  101246:	01 d0                	add    %edx,%eax
  101248:	c1 e0 04             	shl    $0x4,%eax
  10124b:	29 c1                	sub    %eax,%ecx
  10124d:	89 c8                	mov    %ecx,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	29 c3                	sub    %eax,%ebx
  101254:	89 d8                	mov    %ebx,%eax
  101256:	0f b7 c0             	movzwl %ax,%eax
  101259:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  10125f:	eb 2b                	jmp    10128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101261:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101267:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10126e:	8d 50 01             	lea    0x1(%eax),%edx
  101271:	0f b7 d2             	movzwl %dx,%edx
  101274:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  10127b:	01 c0                	add    %eax,%eax
  10127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101280:	8b 45 08             	mov    0x8(%ebp),%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 89 02             	mov    %ax,(%edx)
        break;
  101289:	eb 01                	jmp    10128c <cga_putc+0x100>
        break;
  10128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10128c:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101298:	76 5d                	jbe    1012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10129a:	a1 40 c4 11 00       	mov    0x11c440,%eax
  10129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012a5:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012b1:	00 
  1012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012b6:	89 04 24             	mov    %eax,(%esp)
  1012b9:	e8 c8 45 00 00       	call   105886 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012c5:	eb 14                	jmp    1012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c7:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cf:	01 d2                	add    %edx,%edx
  1012d1:	01 d0                	add    %edx,%eax
  1012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012d8:	ff 45 f4             	incl   -0xc(%ebp)
  1012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012e2:	7e e3                	jle    1012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012e4:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012eb:	83 e8 50             	sub    $0x50,%eax
  1012ee:	0f b7 c0             	movzwl %ax,%eax
  1012f1:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f7:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101310:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101317:	c1 e8 08             	shr    $0x8,%eax
  10131a:	0f b7 c0             	movzwl %ax,%eax
  10131d:	0f b6 c0             	movzbl %al,%eax
  101320:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101327:	42                   	inc    %edx
  101328:	0f b7 d2             	movzwl %dx,%edx
  10132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10133a:	ee                   	out    %al,(%dx)
}
  10133b:	90                   	nop
    outb(addr_6845, 15);
  10133c:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101353:	ee                   	out    %al,(%dx)
}
  101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101355:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101366:	42                   	inc    %edx
  101367:	0f b7 d2             	movzwl %dx,%edx
  10136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101379:	ee                   	out    %al,(%dx)
}
  10137a:	90                   	nop
}
  10137b:	90                   	nop
  10137c:	83 c4 34             	add    $0x34,%esp
  10137f:	5b                   	pop    %ebx
  101380:	5d                   	pop    %ebp
  101381:	c3                   	ret    

00101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101382:	f3 0f 1e fb          	endbr32 
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101393:	eb 08                	jmp    10139d <serial_putc_sub+0x1b>
        delay();
  101395:	e8 08 fb ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10139a:	ff 45 fc             	incl   -0x4(%ebp)
  10139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a7:	89 c2                	mov    %eax,%edx
  1013a9:	ec                   	in     (%dx),%al
  1013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013b1:	0f b6 c0             	movzbl %al,%eax
  1013b4:	83 e0 20             	and    $0x20,%eax
  1013b7:	85 c0                	test   %eax,%eax
  1013b9:	75 09                	jne    1013c4 <serial_putc_sub+0x42>
  1013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013c2:	7e d1                	jle    101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013db:	ee                   	out    %al,(%dx)
}
  1013dc:	90                   	nop
}
  1013dd:	90                   	nop
  1013de:	c9                   	leave  
  1013df:	c3                   	ret    

001013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013e0:	f3 0f 1e fb          	endbr32 
  1013e4:	55                   	push   %ebp
  1013e5:	89 e5                	mov    %esp,%ebp
  1013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013ee:	74 0d                	je     1013fd <serial_putc+0x1d>
        serial_putc_sub(c);
  1013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1013f3:	89 04 24             	mov    %eax,(%esp)
  1013f6:	e8 87 ff ff ff       	call   101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013fb:	eb 24                	jmp    101421 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101404:	e8 79 ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub(' ');
  101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101410:	e8 6d ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub('\b');
  101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10141c:	e8 61 ff ff ff       	call   101382 <serial_putc_sub>
}
  101421:	90                   	nop
  101422:	c9                   	leave  
  101423:	c3                   	ret    

00101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101424:	f3 0f 1e fb          	endbr32 
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10142e:	eb 33                	jmp    101463 <cons_intr+0x3f>
        if (c != 0) {
  101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101434:	74 2d                	je     101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101436:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10143b:	8d 50 01             	lea    0x1(%eax),%edx
  10143e:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101447:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10144d:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101452:	3d 00 02 00 00       	cmp    $0x200,%eax
  101457:	75 0a                	jne    101463 <cons_intr+0x3f>
                cons.wpos = 0;
  101459:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101463:	8b 45 08             	mov    0x8(%ebp),%eax
  101466:	ff d0                	call   *%eax
  101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10146f:	75 bf                	jne    101430 <cons_intr+0xc>
            }
        }
    }
}
  101471:	90                   	nop
  101472:	90                   	nop
  101473:	c9                   	leave  
  101474:	c3                   	ret    

00101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101475:	f3 0f 1e fb          	endbr32 
  101479:	55                   	push   %ebp
  10147a:	89 e5                	mov    %esp,%ebp
  10147c:	83 ec 10             	sub    $0x10,%esp
  10147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101489:	89 c2                	mov    %eax,%edx
  10148b:	ec                   	in     (%dx),%al
  10148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101493:	0f b6 c0             	movzbl %al,%eax
  101496:	83 e0 01             	and    $0x1,%eax
  101499:	85 c0                	test   %eax,%eax
  10149b:	75 07                	jne    1014a4 <serial_proc_data+0x2f>
        return -1;
  10149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a2:	eb 2a                	jmp    1014ce <serial_proc_data+0x59>
  1014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014ae:	89 c2                	mov    %eax,%edx
  1014b0:	ec                   	in     (%dx),%al
  1014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014b8:	0f b6 c0             	movzbl %al,%eax
  1014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014c2:	75 07                	jne    1014cb <serial_proc_data+0x56>
        c = '\b';
  1014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014ce:	c9                   	leave  
  1014cf:	c3                   	ret    

001014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014d0:	f3 0f 1e fb          	endbr32 
  1014d4:	55                   	push   %ebp
  1014d5:	89 e5                	mov    %esp,%ebp
  1014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014da:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1014df:	85 c0                	test   %eax,%eax
  1014e1:	74 0c                	je     1014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014e3:	c7 04 24 75 14 10 00 	movl   $0x101475,(%esp)
  1014ea:	e8 35 ff ff ff       	call   101424 <cons_intr>
    }
}
  1014ef:	90                   	nop
  1014f0:	c9                   	leave  
  1014f1:	c3                   	ret    

001014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014f2:	f3 0f 1e fb          	endbr32 
  1014f6:	55                   	push   %ebp
  1014f7:	89 e5                	mov    %esp,%ebp
  1014f9:	83 ec 38             	sub    $0x38,%esp
  1014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101505:	89 c2                	mov    %eax,%edx
  101507:	ec                   	in     (%dx),%al
  101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10150f:	0f b6 c0             	movzbl %al,%eax
  101512:	83 e0 01             	and    $0x1,%eax
  101515:	85 c0                	test   %eax,%eax
  101517:	75 0a                	jne    101523 <kbd_proc_data+0x31>
        return -1;
  101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10151e:	e9 56 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
  101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10152c:	89 c2                	mov    %eax,%edx
  10152e:	ec                   	in     (%dx),%al
  10152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10153d:	75 17                	jne    101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  10153f:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101544:	83 c8 40             	or     $0x40,%eax
  101547:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  10154c:	b8 00 00 00 00       	mov    $0x0,%eax
  101551:	e9 23 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155a:	84 c0                	test   %al,%al
  10155c:	79 45                	jns    1015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10155e:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101563:	83 e0 40             	and    $0x40,%eax
  101566:	85 c0                	test   %eax,%eax
  101568:	75 08                	jne    101572 <kbd_proc_data+0x80>
  10156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156e:	24 7f                	and    $0x7f,%al
  101570:	eb 04                	jmp    101576 <kbd_proc_data+0x84>
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157d:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101584:	0c 40                	or     $0x40,%al
  101586:	0f b6 c0             	movzbl %al,%eax
  101589:	f7 d0                	not    %eax
  10158b:	89 c2                	mov    %eax,%edx
  10158d:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101592:	21 d0                	and    %edx,%eax
  101594:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101599:	b8 00 00 00 00       	mov    $0x0,%eax
  10159e:	e9 d6 00 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015a3:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015a8:	83 e0 40             	and    $0x40,%eax
  1015ab:	85 c0                	test   %eax,%eax
  1015ad:	74 11                	je     1015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015b3:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b8:	83 e0 bf             	and    $0xffffffbf,%eax
  1015bb:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  1015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c4:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015cb:	0f b6 d0             	movzbl %al,%edx
  1015ce:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015d3:	09 d0                	or     %edx,%eax
  1015d5:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  1015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015de:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  1015e5:	0f b6 d0             	movzbl %al,%edx
  1015e8:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015ed:	31 d0                	xor    %edx,%eax
  1015ef:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015f4:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015f9:	83 e0 03             	and    $0x3,%eax
  1015fc:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101607:	01 d0                	add    %edx,%eax
  101609:	0f b6 00             	movzbl (%eax),%eax
  10160c:	0f b6 c0             	movzbl %al,%eax
  10160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101612:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101617:	83 e0 08             	and    $0x8,%eax
  10161a:	85 c0                	test   %eax,%eax
  10161c:	74 22                	je     101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101622:	7e 0c                	jle    101630 <kbd_proc_data+0x13e>
  101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101628:	7f 06                	jg     101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10162e:	eb 10                	jmp    101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101634:	7e 0a                	jle    101640 <kbd_proc_data+0x14e>
  101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10163a:	7f 04                	jg     101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101640:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101645:	f7 d0                	not    %eax
  101647:	83 e0 06             	and    $0x6,%eax
  10164a:	85 c0                	test   %eax,%eax
  10164c:	75 28                	jne    101676 <kbd_proc_data+0x184>
  10164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101655:	75 1f                	jne    101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101657:	c7 04 24 c1 63 10 00 	movl   $0x1063c1,(%esp)
  10165e:	e8 62 ec ff ff       	call   1002c5 <cprintf>
  101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
}
  101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101679:	c9                   	leave  
  10167a:	c3                   	ret    

0010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10167b:	f3 0f 1e fb          	endbr32 
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101685:	c7 04 24 f2 14 10 00 	movl   $0x1014f2,(%esp)
  10168c:	e8 93 fd ff ff       	call   101424 <cons_intr>
}
  101691:	90                   	nop
  101692:	c9                   	leave  
  101693:	c3                   	ret    

00101694 <kbd_init>:

static void
kbd_init(void) {
  101694:	f3 0f 1e fb          	endbr32 
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10169e:	e8 d8 ff ff ff       	call   10167b <kbd_intr>
    pic_enable(IRQ_KBD);
  1016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016aa:	e8 47 01 00 00       	call   1017f6 <pic_enable>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016b2:	f3 0f 1e fb          	endbr32 
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016bc:	e8 2e f8 ff ff       	call   100eef <cga_init>
    serial_init();
  1016c1:	e8 13 f9 ff ff       	call   100fd9 <serial_init>
    kbd_init();
  1016c6:	e8 c9 ff ff ff       	call   101694 <kbd_init>
    if (!serial_exists) {
  1016cb:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	75 0c                	jne    1016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016d4:	c7 04 24 cd 63 10 00 	movl   $0x1063cd,(%esp)
  1016db:	e8 e5 eb ff ff       	call   1002c5 <cprintf>
    }
}
  1016e0:	90                   	nop
  1016e1:	c9                   	leave  
  1016e2:	c3                   	ret    

001016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016e3:	f3 0f 1e fb          	endbr32 
  1016e7:	55                   	push   %ebp
  1016e8:	89 e5                	mov    %esp,%ebp
  1016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016ed:	e8 72 f7 ff ff       	call   100e64 <__intr_save>
  1016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f8:	89 04 24             	mov    %eax,(%esp)
  1016fb:	e8 48 fa ff ff       	call   101148 <lpt_putc>
        cga_putc(c);
  101700:	8b 45 08             	mov    0x8(%ebp),%eax
  101703:	89 04 24             	mov    %eax,(%esp)
  101706:	e8 81 fa ff ff       	call   10118c <cga_putc>
        serial_putc(c);
  10170b:	8b 45 08             	mov    0x8(%ebp),%eax
  10170e:	89 04 24             	mov    %eax,(%esp)
  101711:	e8 ca fc ff ff       	call   1013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101719:	89 04 24             	mov    %eax,(%esp)
  10171c:	e8 6d f7 ff ff       	call   100e8e <__intr_restore>
}
  101721:	90                   	nop
  101722:	c9                   	leave  
  101723:	c3                   	ret    

00101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101724:	f3 0f 1e fb          	endbr32 
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
  10172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101735:	e8 2a f7 ff ff       	call   100e64 <__intr_save>
  10173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10173d:	e8 8e fd ff ff       	call   1014d0 <serial_intr>
        kbd_intr();
  101742:	e8 34 ff ff ff       	call   10167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101747:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  10174d:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101752:	39 c2                	cmp    %eax,%edx
  101754:	74 31                	je     101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101756:	a1 60 c6 11 00       	mov    0x11c660,%eax
  10175b:	8d 50 01             	lea    0x1(%eax),%edx
  10175e:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  101764:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  10176b:	0f b6 c0             	movzbl %al,%eax
  10176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101771:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101776:	3d 00 02 00 00       	cmp    $0x200,%eax
  10177b:	75 0a                	jne    101787 <cons_getc+0x63>
                cons.rpos = 0;
  10177d:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10178a:	89 04 24             	mov    %eax,(%esp)
  10178d:	e8 fc f6 ff ff       	call   100e8e <__intr_restore>
    return c;
  101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101795:	c9                   	leave  
  101796:	c3                   	ret    

00101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101797:	f3 0f 1e fb          	endbr32 
  10179b:	55                   	push   %ebp
  10179c:	89 e5                	mov    %esp,%ebp
  10179e:	83 ec 14             	sub    $0x14,%esp
  1017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017ab:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1017b1:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1017b6:	85 c0                	test   %eax,%eax
  1017b8:	74 39                	je     1017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017bd:	0f b6 c0             	movzbl %al,%eax
  1017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017d1:	ee                   	out    %al,(%dx)
}
  1017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017d7:	c1 e8 08             	shr    $0x8,%eax
  1017da:	0f b7 c0             	movzwl %ax,%eax
  1017dd:	0f b6 c0             	movzbl %al,%eax
  1017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f1:	ee                   	out    %al,(%dx)
}
  1017f2:	90                   	nop
    }
}
  1017f3:	90                   	nop
  1017f4:	c9                   	leave  
  1017f5:	c3                   	ret    

001017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017f6:	f3 0f 1e fb          	endbr32 
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101800:	8b 45 08             	mov    0x8(%ebp),%eax
  101803:	ba 01 00 00 00       	mov    $0x1,%edx
  101808:	88 c1                	mov    %al,%cl
  10180a:	d3 e2                	shl    %cl,%edx
  10180c:	89 d0                	mov    %edx,%eax
  10180e:	98                   	cwtl   
  10180f:	f7 d0                	not    %eax
  101811:	0f bf d0             	movswl %ax,%edx
  101814:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10181b:	98                   	cwtl   
  10181c:	21 d0                	and    %edx,%eax
  10181e:	98                   	cwtl   
  10181f:	0f b7 c0             	movzwl %ax,%eax
  101822:	89 04 24             	mov    %eax,(%esp)
  101825:	e8 6d ff ff ff       	call   101797 <pic_setmask>
}
  10182a:	90                   	nop
  10182b:	c9                   	leave  
  10182c:	c3                   	ret    

0010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10182d:	f3 0f 1e fb          	endbr32 
  101831:	55                   	push   %ebp
  101832:	89 e5                	mov    %esp,%ebp
  101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101837:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  10183e:	00 00 00 
  101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
}
  101854:	90                   	nop
  101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101867:	ee                   	out    %al,(%dx)
}
  101868:	90                   	nop
  101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10187b:	ee                   	out    %al,(%dx)
}
  10187c:	90                   	nop
  10187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10188f:	ee                   	out    %al,(%dx)
}
  101890:	90                   	nop
  101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018a3:	ee                   	out    %al,(%dx)
}
  1018a4:	90                   	nop
  1018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018b7:	ee                   	out    %al,(%dx)
}
  1018b8:	90                   	nop
  1018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018cb:	ee                   	out    %al,(%dx)
}
  1018cc:	90                   	nop
  1018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018df:	ee                   	out    %al,(%dx)
}
  1018e0:	90                   	nop
  1018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018f3:	ee                   	out    %al,(%dx)
}
  1018f4:	90                   	nop
  1018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101907:	ee                   	out    %al,(%dx)
}
  101908:	90                   	nop
  101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10191b:	ee                   	out    %al,(%dx)
}
  10191c:	90                   	nop
  10191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10192f:	ee                   	out    %al,(%dx)
}
  101930:	90                   	nop
  101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101943:	ee                   	out    %al,(%dx)
}
  101944:	90                   	nop
  101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101957:	ee                   	out    %al,(%dx)
}
  101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101959:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101965:	74 0f                	je     101976 <pic_init+0x149>
        pic_setmask(irq_mask);
  101967:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10196e:	89 04 24             	mov    %eax,(%esp)
  101971:	e8 21 fe ff ff       	call   101797 <pic_setmask>
    }
}
  101976:	90                   	nop
  101977:	c9                   	leave  
  101978:	c3                   	ret    

00101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101979:	f3 0f 1e fb          	endbr32 
  10197d:	55                   	push   %ebp
  10197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101980:	fb                   	sti    
}
  101981:	90                   	nop
    sti();
}
  101982:	90                   	nop
  101983:	5d                   	pop    %ebp
  101984:	c3                   	ret    

00101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101985:	f3 0f 1e fb          	endbr32 
  101989:	55                   	push   %ebp
  10198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10198c:	fa                   	cli    
}
  10198d:	90                   	nop
    cli();
}
  10198e:	90                   	nop
  10198f:	5d                   	pop    %ebp
  101990:	c3                   	ret    

00101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101991:	f3 0f 1e fb          	endbr32 
  101995:	55                   	push   %ebp
  101996:	89 e5                	mov    %esp,%ebp
  101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1019a2:	00 
  1019a3:	c7 04 24 00 64 10 00 	movl   $0x106400,(%esp)
  1019aa:	e8 16 e9 ff ff       	call   1002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1019af:	90                   	nop
  1019b0:	c9                   	leave  
  1019b1:	c3                   	ret    

001019b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019b2:	f3 0f 1e fb          	endbr32 
  1019b6:	55                   	push   %ebp
  1019b7:	89 e5                	mov    %esp,%ebp
  1019b9:	83 ec 10             	sub    $0x10,%esp
      */
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  1019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019c3:	e9 c4 00 00 00       	jmp    101a8c <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  1019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cb:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  1019d2:	0f b7 d0             	movzwl %ax,%edx
  1019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d8:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  1019df:	00 
  1019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e3:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  1019ea:	00 08 00 
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019f7:	00 
  1019f8:	80 e2 e0             	and    $0xe0,%dl
  1019fb:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a0c:	00 
  101a0d:	80 e2 1f             	and    $0x1f,%dl
  101a10:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1a:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a21:	00 
  101a22:	80 e2 f0             	and    $0xf0,%dl
  101a25:	80 ca 0e             	or     $0xe,%dl
  101a28:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a39:	00 
  101a3a:	80 e2 ef             	and    $0xef,%dl
  101a3d:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a47:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a4e:	00 
  101a4f:	80 e2 9f             	and    $0x9f,%dl
  101a52:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5c:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a63:	00 
  101a64:	80 ca 80             	or     $0x80,%dl
  101a67:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a71:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a78:	c1 e8 10             	shr    $0x10,%eax
  101a7b:	0f b7 d0             	movzwl %ax,%edx
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a88:	00 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  101a89:	ff 45 fc             	incl   -0x4(%ebp)
  101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a94:	0f 86 2e ff ff ff    	jbe    1019c8 <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
  101a9a:	a1 e0 97 11 00       	mov    0x1197e0,%eax
  101a9f:	0f b7 c0             	movzwl %ax,%eax
  101aa2:	66 a3 80 ca 11 00    	mov    %ax,0x11ca80
  101aa8:	66 c7 05 82 ca 11 00 	movw   $0x8,0x11ca82
  101aaf:	08 00 
  101ab1:	0f b6 05 84 ca 11 00 	movzbl 0x11ca84,%eax
  101ab8:	24 e0                	and    $0xe0,%al
  101aba:	a2 84 ca 11 00       	mov    %al,0x11ca84
  101abf:	0f b6 05 84 ca 11 00 	movzbl 0x11ca84,%eax
  101ac6:	24 1f                	and    $0x1f,%al
  101ac8:	a2 84 ca 11 00       	mov    %al,0x11ca84
  101acd:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101ad4:	0c 0f                	or     $0xf,%al
  101ad6:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101adb:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101ae2:	24 ef                	and    $0xef,%al
  101ae4:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101ae9:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101af0:	0c 60                	or     $0x60,%al
  101af2:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101af7:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101afe:	0c 80                	or     $0x80,%al
  101b00:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101b05:	a1 e0 97 11 00       	mov    0x1197e0,%eax
  101b0a:	c1 e8 10             	shr    $0x10,%eax
  101b0d:	0f b7 c0             	movzwl %ax,%eax
  101b10:	66 a3 86 ca 11 00    	mov    %ax,0x11ca86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101b16:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101b1b:	0f b7 c0             	movzwl %ax,%eax
  101b1e:	66 a3 48 ca 11 00    	mov    %ax,0x11ca48
  101b24:	66 c7 05 4a ca 11 00 	movw   $0x8,0x11ca4a
  101b2b:	08 00 
  101b2d:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101b34:	24 e0                	and    $0xe0,%al
  101b36:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101b3b:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101b42:	24 1f                	and    $0x1f,%al
  101b44:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101b49:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b50:	24 f0                	and    $0xf0,%al
  101b52:	0c 0e                	or     $0xe,%al
  101b54:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b59:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b60:	24 ef                	and    $0xef,%al
  101b62:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b67:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b6e:	0c 60                	or     $0x60,%al
  101b70:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b75:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b7c:	0c 80                	or     $0x80,%al
  101b7e:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b83:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101b88:	c1 e8 10             	shr    $0x10,%eax
  101b8b:	0f b7 c0             	movzwl %ax,%eax
  101b8e:	66 a3 4e ca 11 00    	mov    %ax,0x11ca4e
  101b94:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b9e:	0f 01 18             	lidtl  (%eax)
}
  101ba1:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
  101ba2:	90                   	nop
  101ba3:	c9                   	leave  
  101ba4:	c3                   	ret    

00101ba5 <trapname>:

static const char *
trapname(int trapno) {
  101ba5:	f3 0f 1e fb          	endbr32 
  101ba9:	55                   	push   %ebp
  101baa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101bac:	8b 45 08             	mov    0x8(%ebp),%eax
  101baf:	83 f8 13             	cmp    $0x13,%eax
  101bb2:	77 0c                	ja     101bc0 <trapname+0x1b>
        return excnames[trapno];
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 04 85 60 67 10 00 	mov    0x106760(,%eax,4),%eax
  101bbe:	eb 18                	jmp    101bd8 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101bc0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101bc4:	7e 0d                	jle    101bd3 <trapname+0x2e>
  101bc6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bca:	7f 07                	jg     101bd3 <trapname+0x2e>
        return "Hardware Interrupt";
  101bcc:	b8 0a 64 10 00       	mov    $0x10640a,%eax
  101bd1:	eb 05                	jmp    101bd8 <trapname+0x33>
    }
    return "(unknown trap)";
  101bd3:	b8 1d 64 10 00       	mov    $0x10641d,%eax
}
  101bd8:	5d                   	pop    %ebp
  101bd9:	c3                   	ret    

00101bda <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bda:	f3 0f 1e fb          	endbr32 
  101bde:	55                   	push   %ebp
  101bdf:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101be8:	83 f8 08             	cmp    $0x8,%eax
  101beb:	0f 94 c0             	sete   %al
  101bee:	0f b6 c0             	movzbl %al,%eax
}
  101bf1:	5d                   	pop    %ebp
  101bf2:	c3                   	ret    

00101bf3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101bf3:	f3 0f 1e fb          	endbr32 
  101bf7:	55                   	push   %ebp
  101bf8:	89 e5                	mov    %esp,%ebp
  101bfa:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 5e 64 10 00 	movl   $0x10645e,(%esp)
  101c0b:	e8 b5 e6 ff ff       	call   1002c5 <cprintf>
    print_regs(&tf->tf_regs);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	89 04 24             	mov    %eax,(%esp)
  101c16:	e8 8d 01 00 00       	call   101da8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 6f 64 10 00 	movl   $0x10646f,(%esp)
  101c2d:	e8 93 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3d:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  101c44:	e8 7c e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 95 64 10 00 	movl   $0x106495,(%esp)
  101c5b:	e8 65 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 a8 64 10 00 	movl   $0x1064a8,(%esp)
  101c72:	e8 4e e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 30             	mov    0x30(%eax),%eax
  101c7d:	89 04 24             	mov    %eax,(%esp)
  101c80:	e8 20 ff ff ff       	call   101ba5 <trapname>
  101c85:	8b 55 08             	mov    0x8(%ebp),%edx
  101c88:	8b 52 30             	mov    0x30(%edx),%edx
  101c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c93:	c7 04 24 bb 64 10 00 	movl   $0x1064bb,(%esp)
  101c9a:	e8 26 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca2:	8b 40 34             	mov    0x34(%eax),%eax
  101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca9:	c7 04 24 cd 64 10 00 	movl   $0x1064cd,(%esp)
  101cb0:	e8 10 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb8:	8b 40 38             	mov    0x38(%eax),%eax
  101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbf:	c7 04 24 dc 64 10 00 	movl   $0x1064dc,(%esp)
  101cc6:	e8 fa e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd6:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  101cdd:	e8 e3 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce5:	8b 40 40             	mov    0x40(%eax),%eax
  101ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cec:	c7 04 24 fe 64 10 00 	movl   $0x1064fe,(%esp)
  101cf3:	e8 cd e5 ff ff       	call   1002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101cff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d06:	eb 3d                	jmp    101d45 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	8b 50 40             	mov    0x40(%eax),%edx
  101d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d11:	21 d0                	and    %edx,%eax
  101d13:	85 c0                	test   %eax,%eax
  101d15:	74 28                	je     101d3f <print_trapframe+0x14c>
  101d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d1a:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101d21:	85 c0                	test   %eax,%eax
  101d23:	74 1a                	je     101d3f <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d28:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d33:	c7 04 24 0d 65 10 00 	movl   $0x10650d,(%esp)
  101d3a:	e8 86 e5 ff ff       	call   1002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d3f:	ff 45 f4             	incl   -0xc(%ebp)
  101d42:	d1 65 f0             	shll   -0x10(%ebp)
  101d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d48:	83 f8 17             	cmp    $0x17,%eax
  101d4b:	76 bb                	jbe    101d08 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	8b 40 40             	mov    0x40(%eax),%eax
  101d53:	c1 e8 0c             	shr    $0xc,%eax
  101d56:	83 e0 03             	and    $0x3,%eax
  101d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5d:	c7 04 24 11 65 10 00 	movl   $0x106511,(%esp)
  101d64:	e8 5c e5 ff ff       	call   1002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d69:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6c:	89 04 24             	mov    %eax,(%esp)
  101d6f:	e8 66 fe ff ff       	call   101bda <trap_in_kernel>
  101d74:	85 c0                	test   %eax,%eax
  101d76:	75 2d                	jne    101da5 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d78:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7b:	8b 40 44             	mov    0x44(%eax),%eax
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 1a 65 10 00 	movl   $0x10651a,(%esp)
  101d89:	e8 37 e5 ff ff       	call   1002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d99:	c7 04 24 29 65 10 00 	movl   $0x106529,(%esp)
  101da0:	e8 20 e5 ff ff       	call   1002c5 <cprintf>
    }
}
  101da5:	90                   	nop
  101da6:	c9                   	leave  
  101da7:	c3                   	ret    

00101da8 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101da8:	f3 0f 1e fb          	endbr32 
  101dac:	55                   	push   %ebp
  101dad:	89 e5                	mov    %esp,%ebp
  101daf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101db2:	8b 45 08             	mov    0x8(%ebp),%eax
  101db5:	8b 00                	mov    (%eax),%eax
  101db7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbb:	c7 04 24 3c 65 10 00 	movl   $0x10653c,(%esp)
  101dc2:	e8 fe e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	8b 40 04             	mov    0x4(%eax),%eax
  101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd1:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  101dd8:	e8 e8 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	8b 40 08             	mov    0x8(%eax),%eax
  101de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de7:	c7 04 24 5a 65 10 00 	movl   $0x10655a,(%esp)
  101dee:	e8 d2 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	8b 40 0c             	mov    0xc(%eax),%eax
  101df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dfd:	c7 04 24 69 65 10 00 	movl   $0x106569,(%esp)
  101e04:	e8 bc e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e09:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0c:	8b 40 10             	mov    0x10(%eax),%eax
  101e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e13:	c7 04 24 78 65 10 00 	movl   $0x106578,(%esp)
  101e1a:	e8 a6 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e22:	8b 40 14             	mov    0x14(%eax),%eax
  101e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e29:	c7 04 24 87 65 10 00 	movl   $0x106587,(%esp)
  101e30:	e8 90 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	8b 40 18             	mov    0x18(%eax),%eax
  101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e3f:	c7 04 24 96 65 10 00 	movl   $0x106596,(%esp)
  101e46:	e8 7a e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e55:	c7 04 24 a5 65 10 00 	movl   $0x1065a5,(%esp)
  101e5c:	e8 64 e4 ff ff       	call   1002c5 <cprintf>
}
  101e61:	90                   	nop
  101e62:	c9                   	leave  
  101e63:	c3                   	ret    

00101e64 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e64:	f3 0f 1e fb          	endbr32 
  101e68:	55                   	push   %ebp
  101e69:	89 e5                	mov    %esp,%ebp
  101e6b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e71:	8b 40 30             	mov    0x30(%eax),%eax
  101e74:	83 f8 79             	cmp    $0x79,%eax
  101e77:	0f 87 99 00 00 00    	ja     101f16 <trap_dispatch+0xb2>
  101e7d:	83 f8 78             	cmp    $0x78,%eax
  101e80:	73 78                	jae    101efa <trap_dispatch+0x96>
  101e82:	83 f8 2f             	cmp    $0x2f,%eax
  101e85:	0f 87 8b 00 00 00    	ja     101f16 <trap_dispatch+0xb2>
  101e8b:	83 f8 2e             	cmp    $0x2e,%eax
  101e8e:	0f 83 b7 00 00 00    	jae    101f4b <trap_dispatch+0xe7>
  101e94:	83 f8 24             	cmp    $0x24,%eax
  101e97:	74 15                	je     101eae <trap_dispatch+0x4a>
  101e99:	83 f8 24             	cmp    $0x24,%eax
  101e9c:	77 78                	ja     101f16 <trap_dispatch+0xb2>
  101e9e:	83 f8 20             	cmp    $0x20,%eax
  101ea1:	0f 84 a7 00 00 00    	je     101f4e <trap_dispatch+0xea>
  101ea7:	83 f8 21             	cmp    $0x21,%eax
  101eaa:	74 28                	je     101ed4 <trap_dispatch+0x70>
  101eac:	eb 68                	jmp    101f16 <trap_dispatch+0xb2>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101eae:	e8 71 f8 ff ff       	call   101724 <cons_getc>
  101eb3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101eba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec6:	c7 04 24 b4 65 10 00 	movl   $0x1065b4,(%esp)
  101ecd:	e8 f3 e3 ff ff       	call   1002c5 <cprintf>
        break;
  101ed2:	eb 7b                	jmp    101f4f <trap_dispatch+0xeb>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed4:	e8 4b f8 ff ff       	call   101724 <cons_getc>
  101ed9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101edc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ee0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ee4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eec:	c7 04 24 c6 65 10 00 	movl   $0x1065c6,(%esp)
  101ef3:	e8 cd e3 ff ff       	call   1002c5 <cprintf>
        break;
  101ef8:	eb 55                	jmp    101f4f <trap_dispatch+0xeb>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101efa:	c7 44 24 08 d5 65 10 	movl   $0x1065d5,0x8(%esp)
  101f01:	00 
  101f02:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101f09:	00 
  101f0a:	c7 04 24 e5 65 10 00 	movl   $0x1065e5,(%esp)
  101f11:	e8 1b e5 ff ff       	call   100431 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f16:	8b 45 08             	mov    0x8(%ebp),%eax
  101f19:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f1d:	83 e0 03             	and    $0x3,%eax
  101f20:	85 c0                	test   %eax,%eax
  101f22:	75 2b                	jne    101f4f <trap_dispatch+0xeb>
            print_trapframe(tf);
  101f24:	8b 45 08             	mov    0x8(%ebp),%eax
  101f27:	89 04 24             	mov    %eax,(%esp)
  101f2a:	e8 c4 fc ff ff       	call   101bf3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f2f:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  101f36:	00 
  101f37:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101f3e:	00 
  101f3f:	c7 04 24 e5 65 10 00 	movl   $0x1065e5,(%esp)
  101f46:	e8 e6 e4 ff ff       	call   100431 <__panic>
        break;
  101f4b:	90                   	nop
  101f4c:	eb 01                	jmp    101f4f <trap_dispatch+0xeb>
        break;
  101f4e:	90                   	nop
        }
    }
}
  101f4f:	90                   	nop
  101f50:	c9                   	leave  
  101f51:	c3                   	ret    

00101f52 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f52:	f3 0f 1e fb          	endbr32 
  101f56:	55                   	push   %ebp
  101f57:	89 e5                	mov    %esp,%ebp
  101f59:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	89 04 24             	mov    %eax,(%esp)
  101f62:	e8 fd fe ff ff       	call   101e64 <trap_dispatch>
}
  101f67:	90                   	nop
  101f68:	c9                   	leave  
  101f69:	c3                   	ret    

00101f6a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $0
  101f6c:	6a 00                	push   $0x0
  jmp __alltraps
  101f6e:	e9 69 0a 00 00       	jmp    1029dc <__alltraps>

00101f73 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $1
  101f75:	6a 01                	push   $0x1
  jmp __alltraps
  101f77:	e9 60 0a 00 00       	jmp    1029dc <__alltraps>

00101f7c <vector2>:
.globl vector2
vector2:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $2
  101f7e:	6a 02                	push   $0x2
  jmp __alltraps
  101f80:	e9 57 0a 00 00       	jmp    1029dc <__alltraps>

00101f85 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $3
  101f87:	6a 03                	push   $0x3
  jmp __alltraps
  101f89:	e9 4e 0a 00 00       	jmp    1029dc <__alltraps>

00101f8e <vector4>:
.globl vector4
vector4:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $4
  101f90:	6a 04                	push   $0x4
  jmp __alltraps
  101f92:	e9 45 0a 00 00       	jmp    1029dc <__alltraps>

00101f97 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $5
  101f99:	6a 05                	push   $0x5
  jmp __alltraps
  101f9b:	e9 3c 0a 00 00       	jmp    1029dc <__alltraps>

00101fa0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $6
  101fa2:	6a 06                	push   $0x6
  jmp __alltraps
  101fa4:	e9 33 0a 00 00       	jmp    1029dc <__alltraps>

00101fa9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $7
  101fab:	6a 07                	push   $0x7
  jmp __alltraps
  101fad:	e9 2a 0a 00 00       	jmp    1029dc <__alltraps>

00101fb2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fb2:	6a 08                	push   $0x8
  jmp __alltraps
  101fb4:	e9 23 0a 00 00       	jmp    1029dc <__alltraps>

00101fb9 <vector9>:
.globl vector9
vector9:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $9
  101fbb:	6a 09                	push   $0x9
  jmp __alltraps
  101fbd:	e9 1a 0a 00 00       	jmp    1029dc <__alltraps>

00101fc2 <vector10>:
.globl vector10
vector10:
  pushl $10
  101fc2:	6a 0a                	push   $0xa
  jmp __alltraps
  101fc4:	e9 13 0a 00 00       	jmp    1029dc <__alltraps>

00101fc9 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fc9:	6a 0b                	push   $0xb
  jmp __alltraps
  101fcb:	e9 0c 0a 00 00       	jmp    1029dc <__alltraps>

00101fd0 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fd0:	6a 0c                	push   $0xc
  jmp __alltraps
  101fd2:	e9 05 0a 00 00       	jmp    1029dc <__alltraps>

00101fd7 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fd7:	6a 0d                	push   $0xd
  jmp __alltraps
  101fd9:	e9 fe 09 00 00       	jmp    1029dc <__alltraps>

00101fde <vector14>:
.globl vector14
vector14:
  pushl $14
  101fde:	6a 0e                	push   $0xe
  jmp __alltraps
  101fe0:	e9 f7 09 00 00       	jmp    1029dc <__alltraps>

00101fe5 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $15
  101fe7:	6a 0f                	push   $0xf
  jmp __alltraps
  101fe9:	e9 ee 09 00 00       	jmp    1029dc <__alltraps>

00101fee <vector16>:
.globl vector16
vector16:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $16
  101ff0:	6a 10                	push   $0x10
  jmp __alltraps
  101ff2:	e9 e5 09 00 00       	jmp    1029dc <__alltraps>

00101ff7 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ff7:	6a 11                	push   $0x11
  jmp __alltraps
  101ff9:	e9 de 09 00 00       	jmp    1029dc <__alltraps>

00101ffe <vector18>:
.globl vector18
vector18:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $18
  102000:	6a 12                	push   $0x12
  jmp __alltraps
  102002:	e9 d5 09 00 00       	jmp    1029dc <__alltraps>

00102007 <vector19>:
.globl vector19
vector19:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $19
  102009:	6a 13                	push   $0x13
  jmp __alltraps
  10200b:	e9 cc 09 00 00       	jmp    1029dc <__alltraps>

00102010 <vector20>:
.globl vector20
vector20:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $20
  102012:	6a 14                	push   $0x14
  jmp __alltraps
  102014:	e9 c3 09 00 00       	jmp    1029dc <__alltraps>

00102019 <vector21>:
.globl vector21
vector21:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $21
  10201b:	6a 15                	push   $0x15
  jmp __alltraps
  10201d:	e9 ba 09 00 00       	jmp    1029dc <__alltraps>

00102022 <vector22>:
.globl vector22
vector22:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $22
  102024:	6a 16                	push   $0x16
  jmp __alltraps
  102026:	e9 b1 09 00 00       	jmp    1029dc <__alltraps>

0010202b <vector23>:
.globl vector23
vector23:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $23
  10202d:	6a 17                	push   $0x17
  jmp __alltraps
  10202f:	e9 a8 09 00 00       	jmp    1029dc <__alltraps>

00102034 <vector24>:
.globl vector24
vector24:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $24
  102036:	6a 18                	push   $0x18
  jmp __alltraps
  102038:	e9 9f 09 00 00       	jmp    1029dc <__alltraps>

0010203d <vector25>:
.globl vector25
vector25:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $25
  10203f:	6a 19                	push   $0x19
  jmp __alltraps
  102041:	e9 96 09 00 00       	jmp    1029dc <__alltraps>

00102046 <vector26>:
.globl vector26
vector26:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $26
  102048:	6a 1a                	push   $0x1a
  jmp __alltraps
  10204a:	e9 8d 09 00 00       	jmp    1029dc <__alltraps>

0010204f <vector27>:
.globl vector27
vector27:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $27
  102051:	6a 1b                	push   $0x1b
  jmp __alltraps
  102053:	e9 84 09 00 00       	jmp    1029dc <__alltraps>

00102058 <vector28>:
.globl vector28
vector28:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $28
  10205a:	6a 1c                	push   $0x1c
  jmp __alltraps
  10205c:	e9 7b 09 00 00       	jmp    1029dc <__alltraps>

00102061 <vector29>:
.globl vector29
vector29:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $29
  102063:	6a 1d                	push   $0x1d
  jmp __alltraps
  102065:	e9 72 09 00 00       	jmp    1029dc <__alltraps>

0010206a <vector30>:
.globl vector30
vector30:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $30
  10206c:	6a 1e                	push   $0x1e
  jmp __alltraps
  10206e:	e9 69 09 00 00       	jmp    1029dc <__alltraps>

00102073 <vector31>:
.globl vector31
vector31:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $31
  102075:	6a 1f                	push   $0x1f
  jmp __alltraps
  102077:	e9 60 09 00 00       	jmp    1029dc <__alltraps>

0010207c <vector32>:
.globl vector32
vector32:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $32
  10207e:	6a 20                	push   $0x20
  jmp __alltraps
  102080:	e9 57 09 00 00       	jmp    1029dc <__alltraps>

00102085 <vector33>:
.globl vector33
vector33:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $33
  102087:	6a 21                	push   $0x21
  jmp __alltraps
  102089:	e9 4e 09 00 00       	jmp    1029dc <__alltraps>

0010208e <vector34>:
.globl vector34
vector34:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $34
  102090:	6a 22                	push   $0x22
  jmp __alltraps
  102092:	e9 45 09 00 00       	jmp    1029dc <__alltraps>

00102097 <vector35>:
.globl vector35
vector35:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $35
  102099:	6a 23                	push   $0x23
  jmp __alltraps
  10209b:	e9 3c 09 00 00       	jmp    1029dc <__alltraps>

001020a0 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $36
  1020a2:	6a 24                	push   $0x24
  jmp __alltraps
  1020a4:	e9 33 09 00 00       	jmp    1029dc <__alltraps>

001020a9 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $37
  1020ab:	6a 25                	push   $0x25
  jmp __alltraps
  1020ad:	e9 2a 09 00 00       	jmp    1029dc <__alltraps>

001020b2 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $38
  1020b4:	6a 26                	push   $0x26
  jmp __alltraps
  1020b6:	e9 21 09 00 00       	jmp    1029dc <__alltraps>

001020bb <vector39>:
.globl vector39
vector39:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $39
  1020bd:	6a 27                	push   $0x27
  jmp __alltraps
  1020bf:	e9 18 09 00 00       	jmp    1029dc <__alltraps>

001020c4 <vector40>:
.globl vector40
vector40:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $40
  1020c6:	6a 28                	push   $0x28
  jmp __alltraps
  1020c8:	e9 0f 09 00 00       	jmp    1029dc <__alltraps>

001020cd <vector41>:
.globl vector41
vector41:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $41
  1020cf:	6a 29                	push   $0x29
  jmp __alltraps
  1020d1:	e9 06 09 00 00       	jmp    1029dc <__alltraps>

001020d6 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $42
  1020d8:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020da:	e9 fd 08 00 00       	jmp    1029dc <__alltraps>

001020df <vector43>:
.globl vector43
vector43:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $43
  1020e1:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020e3:	e9 f4 08 00 00       	jmp    1029dc <__alltraps>

001020e8 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $44
  1020ea:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020ec:	e9 eb 08 00 00       	jmp    1029dc <__alltraps>

001020f1 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $45
  1020f3:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020f5:	e9 e2 08 00 00       	jmp    1029dc <__alltraps>

001020fa <vector46>:
.globl vector46
vector46:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $46
  1020fc:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020fe:	e9 d9 08 00 00       	jmp    1029dc <__alltraps>

00102103 <vector47>:
.globl vector47
vector47:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $47
  102105:	6a 2f                	push   $0x2f
  jmp __alltraps
  102107:	e9 d0 08 00 00       	jmp    1029dc <__alltraps>

0010210c <vector48>:
.globl vector48
vector48:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $48
  10210e:	6a 30                	push   $0x30
  jmp __alltraps
  102110:	e9 c7 08 00 00       	jmp    1029dc <__alltraps>

00102115 <vector49>:
.globl vector49
vector49:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $49
  102117:	6a 31                	push   $0x31
  jmp __alltraps
  102119:	e9 be 08 00 00       	jmp    1029dc <__alltraps>

0010211e <vector50>:
.globl vector50
vector50:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $50
  102120:	6a 32                	push   $0x32
  jmp __alltraps
  102122:	e9 b5 08 00 00       	jmp    1029dc <__alltraps>

00102127 <vector51>:
.globl vector51
vector51:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $51
  102129:	6a 33                	push   $0x33
  jmp __alltraps
  10212b:	e9 ac 08 00 00       	jmp    1029dc <__alltraps>

00102130 <vector52>:
.globl vector52
vector52:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $52
  102132:	6a 34                	push   $0x34
  jmp __alltraps
  102134:	e9 a3 08 00 00       	jmp    1029dc <__alltraps>

00102139 <vector53>:
.globl vector53
vector53:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $53
  10213b:	6a 35                	push   $0x35
  jmp __alltraps
  10213d:	e9 9a 08 00 00       	jmp    1029dc <__alltraps>

00102142 <vector54>:
.globl vector54
vector54:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $54
  102144:	6a 36                	push   $0x36
  jmp __alltraps
  102146:	e9 91 08 00 00       	jmp    1029dc <__alltraps>

0010214b <vector55>:
.globl vector55
vector55:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $55
  10214d:	6a 37                	push   $0x37
  jmp __alltraps
  10214f:	e9 88 08 00 00       	jmp    1029dc <__alltraps>

00102154 <vector56>:
.globl vector56
vector56:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $56
  102156:	6a 38                	push   $0x38
  jmp __alltraps
  102158:	e9 7f 08 00 00       	jmp    1029dc <__alltraps>

0010215d <vector57>:
.globl vector57
vector57:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $57
  10215f:	6a 39                	push   $0x39
  jmp __alltraps
  102161:	e9 76 08 00 00       	jmp    1029dc <__alltraps>

00102166 <vector58>:
.globl vector58
vector58:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $58
  102168:	6a 3a                	push   $0x3a
  jmp __alltraps
  10216a:	e9 6d 08 00 00       	jmp    1029dc <__alltraps>

0010216f <vector59>:
.globl vector59
vector59:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $59
  102171:	6a 3b                	push   $0x3b
  jmp __alltraps
  102173:	e9 64 08 00 00       	jmp    1029dc <__alltraps>

00102178 <vector60>:
.globl vector60
vector60:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $60
  10217a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10217c:	e9 5b 08 00 00       	jmp    1029dc <__alltraps>

00102181 <vector61>:
.globl vector61
vector61:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $61
  102183:	6a 3d                	push   $0x3d
  jmp __alltraps
  102185:	e9 52 08 00 00       	jmp    1029dc <__alltraps>

0010218a <vector62>:
.globl vector62
vector62:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $62
  10218c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10218e:	e9 49 08 00 00       	jmp    1029dc <__alltraps>

00102193 <vector63>:
.globl vector63
vector63:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $63
  102195:	6a 3f                	push   $0x3f
  jmp __alltraps
  102197:	e9 40 08 00 00       	jmp    1029dc <__alltraps>

0010219c <vector64>:
.globl vector64
vector64:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $64
  10219e:	6a 40                	push   $0x40
  jmp __alltraps
  1021a0:	e9 37 08 00 00       	jmp    1029dc <__alltraps>

001021a5 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $65
  1021a7:	6a 41                	push   $0x41
  jmp __alltraps
  1021a9:	e9 2e 08 00 00       	jmp    1029dc <__alltraps>

001021ae <vector66>:
.globl vector66
vector66:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $66
  1021b0:	6a 42                	push   $0x42
  jmp __alltraps
  1021b2:	e9 25 08 00 00       	jmp    1029dc <__alltraps>

001021b7 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $67
  1021b9:	6a 43                	push   $0x43
  jmp __alltraps
  1021bb:	e9 1c 08 00 00       	jmp    1029dc <__alltraps>

001021c0 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $68
  1021c2:	6a 44                	push   $0x44
  jmp __alltraps
  1021c4:	e9 13 08 00 00       	jmp    1029dc <__alltraps>

001021c9 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $69
  1021cb:	6a 45                	push   $0x45
  jmp __alltraps
  1021cd:	e9 0a 08 00 00       	jmp    1029dc <__alltraps>

001021d2 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $70
  1021d4:	6a 46                	push   $0x46
  jmp __alltraps
  1021d6:	e9 01 08 00 00       	jmp    1029dc <__alltraps>

001021db <vector71>:
.globl vector71
vector71:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $71
  1021dd:	6a 47                	push   $0x47
  jmp __alltraps
  1021df:	e9 f8 07 00 00       	jmp    1029dc <__alltraps>

001021e4 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $72
  1021e6:	6a 48                	push   $0x48
  jmp __alltraps
  1021e8:	e9 ef 07 00 00       	jmp    1029dc <__alltraps>

001021ed <vector73>:
.globl vector73
vector73:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $73
  1021ef:	6a 49                	push   $0x49
  jmp __alltraps
  1021f1:	e9 e6 07 00 00       	jmp    1029dc <__alltraps>

001021f6 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $74
  1021f8:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021fa:	e9 dd 07 00 00       	jmp    1029dc <__alltraps>

001021ff <vector75>:
.globl vector75
vector75:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $75
  102201:	6a 4b                	push   $0x4b
  jmp __alltraps
  102203:	e9 d4 07 00 00       	jmp    1029dc <__alltraps>

00102208 <vector76>:
.globl vector76
vector76:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $76
  10220a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10220c:	e9 cb 07 00 00       	jmp    1029dc <__alltraps>

00102211 <vector77>:
.globl vector77
vector77:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $77
  102213:	6a 4d                	push   $0x4d
  jmp __alltraps
  102215:	e9 c2 07 00 00       	jmp    1029dc <__alltraps>

0010221a <vector78>:
.globl vector78
vector78:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $78
  10221c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10221e:	e9 b9 07 00 00       	jmp    1029dc <__alltraps>

00102223 <vector79>:
.globl vector79
vector79:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $79
  102225:	6a 4f                	push   $0x4f
  jmp __alltraps
  102227:	e9 b0 07 00 00       	jmp    1029dc <__alltraps>

0010222c <vector80>:
.globl vector80
vector80:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $80
  10222e:	6a 50                	push   $0x50
  jmp __alltraps
  102230:	e9 a7 07 00 00       	jmp    1029dc <__alltraps>

00102235 <vector81>:
.globl vector81
vector81:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $81
  102237:	6a 51                	push   $0x51
  jmp __alltraps
  102239:	e9 9e 07 00 00       	jmp    1029dc <__alltraps>

0010223e <vector82>:
.globl vector82
vector82:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $82
  102240:	6a 52                	push   $0x52
  jmp __alltraps
  102242:	e9 95 07 00 00       	jmp    1029dc <__alltraps>

00102247 <vector83>:
.globl vector83
vector83:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $83
  102249:	6a 53                	push   $0x53
  jmp __alltraps
  10224b:	e9 8c 07 00 00       	jmp    1029dc <__alltraps>

00102250 <vector84>:
.globl vector84
vector84:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $84
  102252:	6a 54                	push   $0x54
  jmp __alltraps
  102254:	e9 83 07 00 00       	jmp    1029dc <__alltraps>

00102259 <vector85>:
.globl vector85
vector85:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $85
  10225b:	6a 55                	push   $0x55
  jmp __alltraps
  10225d:	e9 7a 07 00 00       	jmp    1029dc <__alltraps>

00102262 <vector86>:
.globl vector86
vector86:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $86
  102264:	6a 56                	push   $0x56
  jmp __alltraps
  102266:	e9 71 07 00 00       	jmp    1029dc <__alltraps>

0010226b <vector87>:
.globl vector87
vector87:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $87
  10226d:	6a 57                	push   $0x57
  jmp __alltraps
  10226f:	e9 68 07 00 00       	jmp    1029dc <__alltraps>

00102274 <vector88>:
.globl vector88
vector88:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $88
  102276:	6a 58                	push   $0x58
  jmp __alltraps
  102278:	e9 5f 07 00 00       	jmp    1029dc <__alltraps>

0010227d <vector89>:
.globl vector89
vector89:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $89
  10227f:	6a 59                	push   $0x59
  jmp __alltraps
  102281:	e9 56 07 00 00       	jmp    1029dc <__alltraps>

00102286 <vector90>:
.globl vector90
vector90:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $90
  102288:	6a 5a                	push   $0x5a
  jmp __alltraps
  10228a:	e9 4d 07 00 00       	jmp    1029dc <__alltraps>

0010228f <vector91>:
.globl vector91
vector91:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $91
  102291:	6a 5b                	push   $0x5b
  jmp __alltraps
  102293:	e9 44 07 00 00       	jmp    1029dc <__alltraps>

00102298 <vector92>:
.globl vector92
vector92:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $92
  10229a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10229c:	e9 3b 07 00 00       	jmp    1029dc <__alltraps>

001022a1 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $93
  1022a3:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022a5:	e9 32 07 00 00       	jmp    1029dc <__alltraps>

001022aa <vector94>:
.globl vector94
vector94:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $94
  1022ac:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022ae:	e9 29 07 00 00       	jmp    1029dc <__alltraps>

001022b3 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $95
  1022b5:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022b7:	e9 20 07 00 00       	jmp    1029dc <__alltraps>

001022bc <vector96>:
.globl vector96
vector96:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $96
  1022be:	6a 60                	push   $0x60
  jmp __alltraps
  1022c0:	e9 17 07 00 00       	jmp    1029dc <__alltraps>

001022c5 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $97
  1022c7:	6a 61                	push   $0x61
  jmp __alltraps
  1022c9:	e9 0e 07 00 00       	jmp    1029dc <__alltraps>

001022ce <vector98>:
.globl vector98
vector98:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $98
  1022d0:	6a 62                	push   $0x62
  jmp __alltraps
  1022d2:	e9 05 07 00 00       	jmp    1029dc <__alltraps>

001022d7 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $99
  1022d9:	6a 63                	push   $0x63
  jmp __alltraps
  1022db:	e9 fc 06 00 00       	jmp    1029dc <__alltraps>

001022e0 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $100
  1022e2:	6a 64                	push   $0x64
  jmp __alltraps
  1022e4:	e9 f3 06 00 00       	jmp    1029dc <__alltraps>

001022e9 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $101
  1022eb:	6a 65                	push   $0x65
  jmp __alltraps
  1022ed:	e9 ea 06 00 00       	jmp    1029dc <__alltraps>

001022f2 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $102
  1022f4:	6a 66                	push   $0x66
  jmp __alltraps
  1022f6:	e9 e1 06 00 00       	jmp    1029dc <__alltraps>

001022fb <vector103>:
.globl vector103
vector103:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $103
  1022fd:	6a 67                	push   $0x67
  jmp __alltraps
  1022ff:	e9 d8 06 00 00       	jmp    1029dc <__alltraps>

00102304 <vector104>:
.globl vector104
vector104:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $104
  102306:	6a 68                	push   $0x68
  jmp __alltraps
  102308:	e9 cf 06 00 00       	jmp    1029dc <__alltraps>

0010230d <vector105>:
.globl vector105
vector105:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $105
  10230f:	6a 69                	push   $0x69
  jmp __alltraps
  102311:	e9 c6 06 00 00       	jmp    1029dc <__alltraps>

00102316 <vector106>:
.globl vector106
vector106:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $106
  102318:	6a 6a                	push   $0x6a
  jmp __alltraps
  10231a:	e9 bd 06 00 00       	jmp    1029dc <__alltraps>

0010231f <vector107>:
.globl vector107
vector107:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $107
  102321:	6a 6b                	push   $0x6b
  jmp __alltraps
  102323:	e9 b4 06 00 00       	jmp    1029dc <__alltraps>

00102328 <vector108>:
.globl vector108
vector108:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $108
  10232a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10232c:	e9 ab 06 00 00       	jmp    1029dc <__alltraps>

00102331 <vector109>:
.globl vector109
vector109:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $109
  102333:	6a 6d                	push   $0x6d
  jmp __alltraps
  102335:	e9 a2 06 00 00       	jmp    1029dc <__alltraps>

0010233a <vector110>:
.globl vector110
vector110:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $110
  10233c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10233e:	e9 99 06 00 00       	jmp    1029dc <__alltraps>

00102343 <vector111>:
.globl vector111
vector111:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $111
  102345:	6a 6f                	push   $0x6f
  jmp __alltraps
  102347:	e9 90 06 00 00       	jmp    1029dc <__alltraps>

0010234c <vector112>:
.globl vector112
vector112:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $112
  10234e:	6a 70                	push   $0x70
  jmp __alltraps
  102350:	e9 87 06 00 00       	jmp    1029dc <__alltraps>

00102355 <vector113>:
.globl vector113
vector113:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $113
  102357:	6a 71                	push   $0x71
  jmp __alltraps
  102359:	e9 7e 06 00 00       	jmp    1029dc <__alltraps>

0010235e <vector114>:
.globl vector114
vector114:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $114
  102360:	6a 72                	push   $0x72
  jmp __alltraps
  102362:	e9 75 06 00 00       	jmp    1029dc <__alltraps>

00102367 <vector115>:
.globl vector115
vector115:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $115
  102369:	6a 73                	push   $0x73
  jmp __alltraps
  10236b:	e9 6c 06 00 00       	jmp    1029dc <__alltraps>

00102370 <vector116>:
.globl vector116
vector116:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $116
  102372:	6a 74                	push   $0x74
  jmp __alltraps
  102374:	e9 63 06 00 00       	jmp    1029dc <__alltraps>

00102379 <vector117>:
.globl vector117
vector117:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $117
  10237b:	6a 75                	push   $0x75
  jmp __alltraps
  10237d:	e9 5a 06 00 00       	jmp    1029dc <__alltraps>

00102382 <vector118>:
.globl vector118
vector118:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $118
  102384:	6a 76                	push   $0x76
  jmp __alltraps
  102386:	e9 51 06 00 00       	jmp    1029dc <__alltraps>

0010238b <vector119>:
.globl vector119
vector119:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $119
  10238d:	6a 77                	push   $0x77
  jmp __alltraps
  10238f:	e9 48 06 00 00       	jmp    1029dc <__alltraps>

00102394 <vector120>:
.globl vector120
vector120:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $120
  102396:	6a 78                	push   $0x78
  jmp __alltraps
  102398:	e9 3f 06 00 00       	jmp    1029dc <__alltraps>

0010239d <vector121>:
.globl vector121
vector121:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $121
  10239f:	6a 79                	push   $0x79
  jmp __alltraps
  1023a1:	e9 36 06 00 00       	jmp    1029dc <__alltraps>

001023a6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $122
  1023a8:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023aa:	e9 2d 06 00 00       	jmp    1029dc <__alltraps>

001023af <vector123>:
.globl vector123
vector123:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $123
  1023b1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023b3:	e9 24 06 00 00       	jmp    1029dc <__alltraps>

001023b8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $124
  1023ba:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023bc:	e9 1b 06 00 00       	jmp    1029dc <__alltraps>

001023c1 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $125
  1023c3:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023c5:	e9 12 06 00 00       	jmp    1029dc <__alltraps>

001023ca <vector126>:
.globl vector126
vector126:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $126
  1023cc:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023ce:	e9 09 06 00 00       	jmp    1029dc <__alltraps>

001023d3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $127
  1023d5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023d7:	e9 00 06 00 00       	jmp    1029dc <__alltraps>

001023dc <vector128>:
.globl vector128
vector128:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $128
  1023de:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023e3:	e9 f4 05 00 00       	jmp    1029dc <__alltraps>

001023e8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $129
  1023ea:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023ef:	e9 e8 05 00 00       	jmp    1029dc <__alltraps>

001023f4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $130
  1023f6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023fb:	e9 dc 05 00 00       	jmp    1029dc <__alltraps>

00102400 <vector131>:
.globl vector131
vector131:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $131
  102402:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102407:	e9 d0 05 00 00       	jmp    1029dc <__alltraps>

0010240c <vector132>:
.globl vector132
vector132:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $132
  10240e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102413:	e9 c4 05 00 00       	jmp    1029dc <__alltraps>

00102418 <vector133>:
.globl vector133
vector133:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $133
  10241a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10241f:	e9 b8 05 00 00       	jmp    1029dc <__alltraps>

00102424 <vector134>:
.globl vector134
vector134:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $134
  102426:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10242b:	e9 ac 05 00 00       	jmp    1029dc <__alltraps>

00102430 <vector135>:
.globl vector135
vector135:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $135
  102432:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102437:	e9 a0 05 00 00       	jmp    1029dc <__alltraps>

0010243c <vector136>:
.globl vector136
vector136:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $136
  10243e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102443:	e9 94 05 00 00       	jmp    1029dc <__alltraps>

00102448 <vector137>:
.globl vector137
vector137:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $137
  10244a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10244f:	e9 88 05 00 00       	jmp    1029dc <__alltraps>

00102454 <vector138>:
.globl vector138
vector138:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $138
  102456:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10245b:	e9 7c 05 00 00       	jmp    1029dc <__alltraps>

00102460 <vector139>:
.globl vector139
vector139:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $139
  102462:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102467:	e9 70 05 00 00       	jmp    1029dc <__alltraps>

0010246c <vector140>:
.globl vector140
vector140:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $140
  10246e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102473:	e9 64 05 00 00       	jmp    1029dc <__alltraps>

00102478 <vector141>:
.globl vector141
vector141:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $141
  10247a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10247f:	e9 58 05 00 00       	jmp    1029dc <__alltraps>

00102484 <vector142>:
.globl vector142
vector142:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $142
  102486:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10248b:	e9 4c 05 00 00       	jmp    1029dc <__alltraps>

00102490 <vector143>:
.globl vector143
vector143:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $143
  102492:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102497:	e9 40 05 00 00       	jmp    1029dc <__alltraps>

0010249c <vector144>:
.globl vector144
vector144:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $144
  10249e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024a3:	e9 34 05 00 00       	jmp    1029dc <__alltraps>

001024a8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $145
  1024aa:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024af:	e9 28 05 00 00       	jmp    1029dc <__alltraps>

001024b4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $146
  1024b6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024bb:	e9 1c 05 00 00       	jmp    1029dc <__alltraps>

001024c0 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $147
  1024c2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024c7:	e9 10 05 00 00       	jmp    1029dc <__alltraps>

001024cc <vector148>:
.globl vector148
vector148:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $148
  1024ce:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024d3:	e9 04 05 00 00       	jmp    1029dc <__alltraps>

001024d8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $149
  1024da:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024df:	e9 f8 04 00 00       	jmp    1029dc <__alltraps>

001024e4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $150
  1024e6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024eb:	e9 ec 04 00 00       	jmp    1029dc <__alltraps>

001024f0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $151
  1024f2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024f7:	e9 e0 04 00 00       	jmp    1029dc <__alltraps>

001024fc <vector152>:
.globl vector152
vector152:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $152
  1024fe:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102503:	e9 d4 04 00 00       	jmp    1029dc <__alltraps>

00102508 <vector153>:
.globl vector153
vector153:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $153
  10250a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10250f:	e9 c8 04 00 00       	jmp    1029dc <__alltraps>

00102514 <vector154>:
.globl vector154
vector154:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $154
  102516:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10251b:	e9 bc 04 00 00       	jmp    1029dc <__alltraps>

00102520 <vector155>:
.globl vector155
vector155:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $155
  102522:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102527:	e9 b0 04 00 00       	jmp    1029dc <__alltraps>

0010252c <vector156>:
.globl vector156
vector156:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $156
  10252e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102533:	e9 a4 04 00 00       	jmp    1029dc <__alltraps>

00102538 <vector157>:
.globl vector157
vector157:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $157
  10253a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10253f:	e9 98 04 00 00       	jmp    1029dc <__alltraps>

00102544 <vector158>:
.globl vector158
vector158:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $158
  102546:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10254b:	e9 8c 04 00 00       	jmp    1029dc <__alltraps>

00102550 <vector159>:
.globl vector159
vector159:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $159
  102552:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102557:	e9 80 04 00 00       	jmp    1029dc <__alltraps>

0010255c <vector160>:
.globl vector160
vector160:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $160
  10255e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102563:	e9 74 04 00 00       	jmp    1029dc <__alltraps>

00102568 <vector161>:
.globl vector161
vector161:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $161
  10256a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10256f:	e9 68 04 00 00       	jmp    1029dc <__alltraps>

00102574 <vector162>:
.globl vector162
vector162:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $162
  102576:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10257b:	e9 5c 04 00 00       	jmp    1029dc <__alltraps>

00102580 <vector163>:
.globl vector163
vector163:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $163
  102582:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102587:	e9 50 04 00 00       	jmp    1029dc <__alltraps>

0010258c <vector164>:
.globl vector164
vector164:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $164
  10258e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102593:	e9 44 04 00 00       	jmp    1029dc <__alltraps>

00102598 <vector165>:
.globl vector165
vector165:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $165
  10259a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10259f:	e9 38 04 00 00       	jmp    1029dc <__alltraps>

001025a4 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $166
  1025a6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025ab:	e9 2c 04 00 00       	jmp    1029dc <__alltraps>

001025b0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $167
  1025b2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025b7:	e9 20 04 00 00       	jmp    1029dc <__alltraps>

001025bc <vector168>:
.globl vector168
vector168:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $168
  1025be:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025c3:	e9 14 04 00 00       	jmp    1029dc <__alltraps>

001025c8 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $169
  1025ca:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025cf:	e9 08 04 00 00       	jmp    1029dc <__alltraps>

001025d4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $170
  1025d6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025db:	e9 fc 03 00 00       	jmp    1029dc <__alltraps>

001025e0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $171
  1025e2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025e7:	e9 f0 03 00 00       	jmp    1029dc <__alltraps>

001025ec <vector172>:
.globl vector172
vector172:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $172
  1025ee:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025f3:	e9 e4 03 00 00       	jmp    1029dc <__alltraps>

001025f8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $173
  1025fa:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025ff:	e9 d8 03 00 00       	jmp    1029dc <__alltraps>

00102604 <vector174>:
.globl vector174
vector174:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $174
  102606:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10260b:	e9 cc 03 00 00       	jmp    1029dc <__alltraps>

00102610 <vector175>:
.globl vector175
vector175:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $175
  102612:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102617:	e9 c0 03 00 00       	jmp    1029dc <__alltraps>

0010261c <vector176>:
.globl vector176
vector176:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $176
  10261e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102623:	e9 b4 03 00 00       	jmp    1029dc <__alltraps>

00102628 <vector177>:
.globl vector177
vector177:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $177
  10262a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10262f:	e9 a8 03 00 00       	jmp    1029dc <__alltraps>

00102634 <vector178>:
.globl vector178
vector178:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $178
  102636:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10263b:	e9 9c 03 00 00       	jmp    1029dc <__alltraps>

00102640 <vector179>:
.globl vector179
vector179:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $179
  102642:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102647:	e9 90 03 00 00       	jmp    1029dc <__alltraps>

0010264c <vector180>:
.globl vector180
vector180:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $180
  10264e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102653:	e9 84 03 00 00       	jmp    1029dc <__alltraps>

00102658 <vector181>:
.globl vector181
vector181:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $181
  10265a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10265f:	e9 78 03 00 00       	jmp    1029dc <__alltraps>

00102664 <vector182>:
.globl vector182
vector182:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $182
  102666:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10266b:	e9 6c 03 00 00       	jmp    1029dc <__alltraps>

00102670 <vector183>:
.globl vector183
vector183:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $183
  102672:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102677:	e9 60 03 00 00       	jmp    1029dc <__alltraps>

0010267c <vector184>:
.globl vector184
vector184:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $184
  10267e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102683:	e9 54 03 00 00       	jmp    1029dc <__alltraps>

00102688 <vector185>:
.globl vector185
vector185:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $185
  10268a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10268f:	e9 48 03 00 00       	jmp    1029dc <__alltraps>

00102694 <vector186>:
.globl vector186
vector186:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $186
  102696:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10269b:	e9 3c 03 00 00       	jmp    1029dc <__alltraps>

001026a0 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $187
  1026a2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026a7:	e9 30 03 00 00       	jmp    1029dc <__alltraps>

001026ac <vector188>:
.globl vector188
vector188:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $188
  1026ae:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026b3:	e9 24 03 00 00       	jmp    1029dc <__alltraps>

001026b8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $189
  1026ba:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026bf:	e9 18 03 00 00       	jmp    1029dc <__alltraps>

001026c4 <vector190>:
.globl vector190
vector190:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $190
  1026c6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026cb:	e9 0c 03 00 00       	jmp    1029dc <__alltraps>

001026d0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $191
  1026d2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026d7:	e9 00 03 00 00       	jmp    1029dc <__alltraps>

001026dc <vector192>:
.globl vector192
vector192:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $192
  1026de:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026e3:	e9 f4 02 00 00       	jmp    1029dc <__alltraps>

001026e8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $193
  1026ea:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026ef:	e9 e8 02 00 00       	jmp    1029dc <__alltraps>

001026f4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $194
  1026f6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026fb:	e9 dc 02 00 00       	jmp    1029dc <__alltraps>

00102700 <vector195>:
.globl vector195
vector195:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $195
  102702:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102707:	e9 d0 02 00 00       	jmp    1029dc <__alltraps>

0010270c <vector196>:
.globl vector196
vector196:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $196
  10270e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102713:	e9 c4 02 00 00       	jmp    1029dc <__alltraps>

00102718 <vector197>:
.globl vector197
vector197:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $197
  10271a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10271f:	e9 b8 02 00 00       	jmp    1029dc <__alltraps>

00102724 <vector198>:
.globl vector198
vector198:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $198
  102726:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10272b:	e9 ac 02 00 00       	jmp    1029dc <__alltraps>

00102730 <vector199>:
.globl vector199
vector199:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $199
  102732:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102737:	e9 a0 02 00 00       	jmp    1029dc <__alltraps>

0010273c <vector200>:
.globl vector200
vector200:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $200
  10273e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102743:	e9 94 02 00 00       	jmp    1029dc <__alltraps>

00102748 <vector201>:
.globl vector201
vector201:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $201
  10274a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10274f:	e9 88 02 00 00       	jmp    1029dc <__alltraps>

00102754 <vector202>:
.globl vector202
vector202:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $202
  102756:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10275b:	e9 7c 02 00 00       	jmp    1029dc <__alltraps>

00102760 <vector203>:
.globl vector203
vector203:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $203
  102762:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102767:	e9 70 02 00 00       	jmp    1029dc <__alltraps>

0010276c <vector204>:
.globl vector204
vector204:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $204
  10276e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102773:	e9 64 02 00 00       	jmp    1029dc <__alltraps>

00102778 <vector205>:
.globl vector205
vector205:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $205
  10277a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10277f:	e9 58 02 00 00       	jmp    1029dc <__alltraps>

00102784 <vector206>:
.globl vector206
vector206:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $206
  102786:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10278b:	e9 4c 02 00 00       	jmp    1029dc <__alltraps>

00102790 <vector207>:
.globl vector207
vector207:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $207
  102792:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102797:	e9 40 02 00 00       	jmp    1029dc <__alltraps>

0010279c <vector208>:
.globl vector208
vector208:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $208
  10279e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027a3:	e9 34 02 00 00       	jmp    1029dc <__alltraps>

001027a8 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $209
  1027aa:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027af:	e9 28 02 00 00       	jmp    1029dc <__alltraps>

001027b4 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $210
  1027b6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027bb:	e9 1c 02 00 00       	jmp    1029dc <__alltraps>

001027c0 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $211
  1027c2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027c7:	e9 10 02 00 00       	jmp    1029dc <__alltraps>

001027cc <vector212>:
.globl vector212
vector212:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $212
  1027ce:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027d3:	e9 04 02 00 00       	jmp    1029dc <__alltraps>

001027d8 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $213
  1027da:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027df:	e9 f8 01 00 00       	jmp    1029dc <__alltraps>

001027e4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $214
  1027e6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027eb:	e9 ec 01 00 00       	jmp    1029dc <__alltraps>

001027f0 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $215
  1027f2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027f7:	e9 e0 01 00 00       	jmp    1029dc <__alltraps>

001027fc <vector216>:
.globl vector216
vector216:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $216
  1027fe:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102803:	e9 d4 01 00 00       	jmp    1029dc <__alltraps>

00102808 <vector217>:
.globl vector217
vector217:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $217
  10280a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10280f:	e9 c8 01 00 00       	jmp    1029dc <__alltraps>

00102814 <vector218>:
.globl vector218
vector218:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $218
  102816:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10281b:	e9 bc 01 00 00       	jmp    1029dc <__alltraps>

00102820 <vector219>:
.globl vector219
vector219:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $219
  102822:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102827:	e9 b0 01 00 00       	jmp    1029dc <__alltraps>

0010282c <vector220>:
.globl vector220
vector220:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $220
  10282e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102833:	e9 a4 01 00 00       	jmp    1029dc <__alltraps>

00102838 <vector221>:
.globl vector221
vector221:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $221
  10283a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10283f:	e9 98 01 00 00       	jmp    1029dc <__alltraps>

00102844 <vector222>:
.globl vector222
vector222:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $222
  102846:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10284b:	e9 8c 01 00 00       	jmp    1029dc <__alltraps>

00102850 <vector223>:
.globl vector223
vector223:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $223
  102852:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102857:	e9 80 01 00 00       	jmp    1029dc <__alltraps>

0010285c <vector224>:
.globl vector224
vector224:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $224
  10285e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102863:	e9 74 01 00 00       	jmp    1029dc <__alltraps>

00102868 <vector225>:
.globl vector225
vector225:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $225
  10286a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10286f:	e9 68 01 00 00       	jmp    1029dc <__alltraps>

00102874 <vector226>:
.globl vector226
vector226:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $226
  102876:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10287b:	e9 5c 01 00 00       	jmp    1029dc <__alltraps>

00102880 <vector227>:
.globl vector227
vector227:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $227
  102882:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102887:	e9 50 01 00 00       	jmp    1029dc <__alltraps>

0010288c <vector228>:
.globl vector228
vector228:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $228
  10288e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102893:	e9 44 01 00 00       	jmp    1029dc <__alltraps>

00102898 <vector229>:
.globl vector229
vector229:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $229
  10289a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10289f:	e9 38 01 00 00       	jmp    1029dc <__alltraps>

001028a4 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $230
  1028a6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028ab:	e9 2c 01 00 00       	jmp    1029dc <__alltraps>

001028b0 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $231
  1028b2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028b7:	e9 20 01 00 00       	jmp    1029dc <__alltraps>

001028bc <vector232>:
.globl vector232
vector232:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $232
  1028be:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028c3:	e9 14 01 00 00       	jmp    1029dc <__alltraps>

001028c8 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $233
  1028ca:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028cf:	e9 08 01 00 00       	jmp    1029dc <__alltraps>

001028d4 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028d4:	6a 00                	push   $0x0
  pushl $234
  1028d6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028db:	e9 fc 00 00 00       	jmp    1029dc <__alltraps>

001028e0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028e0:	6a 00                	push   $0x0
  pushl $235
  1028e2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028e7:	e9 f0 00 00 00       	jmp    1029dc <__alltraps>

001028ec <vector236>:
.globl vector236
vector236:
  pushl $0
  1028ec:	6a 00                	push   $0x0
  pushl $236
  1028ee:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028f3:	e9 e4 00 00 00       	jmp    1029dc <__alltraps>

001028f8 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028f8:	6a 00                	push   $0x0
  pushl $237
  1028fa:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028ff:	e9 d8 00 00 00       	jmp    1029dc <__alltraps>

00102904 <vector238>:
.globl vector238
vector238:
  pushl $0
  102904:	6a 00                	push   $0x0
  pushl $238
  102906:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10290b:	e9 cc 00 00 00       	jmp    1029dc <__alltraps>

00102910 <vector239>:
.globl vector239
vector239:
  pushl $0
  102910:	6a 00                	push   $0x0
  pushl $239
  102912:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102917:	e9 c0 00 00 00       	jmp    1029dc <__alltraps>

0010291c <vector240>:
.globl vector240
vector240:
  pushl $0
  10291c:	6a 00                	push   $0x0
  pushl $240
  10291e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102923:	e9 b4 00 00 00       	jmp    1029dc <__alltraps>

00102928 <vector241>:
.globl vector241
vector241:
  pushl $0
  102928:	6a 00                	push   $0x0
  pushl $241
  10292a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10292f:	e9 a8 00 00 00       	jmp    1029dc <__alltraps>

00102934 <vector242>:
.globl vector242
vector242:
  pushl $0
  102934:	6a 00                	push   $0x0
  pushl $242
  102936:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10293b:	e9 9c 00 00 00       	jmp    1029dc <__alltraps>

00102940 <vector243>:
.globl vector243
vector243:
  pushl $0
  102940:	6a 00                	push   $0x0
  pushl $243
  102942:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102947:	e9 90 00 00 00       	jmp    1029dc <__alltraps>

0010294c <vector244>:
.globl vector244
vector244:
  pushl $0
  10294c:	6a 00                	push   $0x0
  pushl $244
  10294e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102953:	e9 84 00 00 00       	jmp    1029dc <__alltraps>

00102958 <vector245>:
.globl vector245
vector245:
  pushl $0
  102958:	6a 00                	push   $0x0
  pushl $245
  10295a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10295f:	e9 78 00 00 00       	jmp    1029dc <__alltraps>

00102964 <vector246>:
.globl vector246
vector246:
  pushl $0
  102964:	6a 00                	push   $0x0
  pushl $246
  102966:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10296b:	e9 6c 00 00 00       	jmp    1029dc <__alltraps>

00102970 <vector247>:
.globl vector247
vector247:
  pushl $0
  102970:	6a 00                	push   $0x0
  pushl $247
  102972:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102977:	e9 60 00 00 00       	jmp    1029dc <__alltraps>

0010297c <vector248>:
.globl vector248
vector248:
  pushl $0
  10297c:	6a 00                	push   $0x0
  pushl $248
  10297e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102983:	e9 54 00 00 00       	jmp    1029dc <__alltraps>

00102988 <vector249>:
.globl vector249
vector249:
  pushl $0
  102988:	6a 00                	push   $0x0
  pushl $249
  10298a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10298f:	e9 48 00 00 00       	jmp    1029dc <__alltraps>

00102994 <vector250>:
.globl vector250
vector250:
  pushl $0
  102994:	6a 00                	push   $0x0
  pushl $250
  102996:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10299b:	e9 3c 00 00 00       	jmp    1029dc <__alltraps>

001029a0 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029a0:	6a 00                	push   $0x0
  pushl $251
  1029a2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029a7:	e9 30 00 00 00       	jmp    1029dc <__alltraps>

001029ac <vector252>:
.globl vector252
vector252:
  pushl $0
  1029ac:	6a 00                	push   $0x0
  pushl $252
  1029ae:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029b3:	e9 24 00 00 00       	jmp    1029dc <__alltraps>

001029b8 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029b8:	6a 00                	push   $0x0
  pushl $253
  1029ba:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029bf:	e9 18 00 00 00       	jmp    1029dc <__alltraps>

001029c4 <vector254>:
.globl vector254
vector254:
  pushl $0
  1029c4:	6a 00                	push   $0x0
  pushl $254
  1029c6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029cb:	e9 0c 00 00 00       	jmp    1029dc <__alltraps>

001029d0 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029d0:	6a 00                	push   $0x0
  pushl $255
  1029d2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029d7:	e9 00 00 00 00       	jmp    1029dc <__alltraps>

001029dc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029dc:	1e                   	push   %ds
    pushl %es
  1029dd:	06                   	push   %es
    pushl %fs
  1029de:	0f a0                	push   %fs
    pushl %gs
  1029e0:	0f a8                	push   %gs
    pushal
  1029e2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029e3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029e8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029ea:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029ec:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029ed:	e8 60 f5 ff ff       	call   101f52 <trap>

    # pop the pushed stack pointer
    popl %esp
  1029f2:	5c                   	pop    %esp

001029f3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029f3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029f4:	0f a9                	pop    %gs
    popl %fs
  1029f6:	0f a1                	pop    %fs
    popl %es
  1029f8:	07                   	pop    %es
    popl %ds
  1029f9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029fa:	83 c4 08             	add    $0x8,%esp
    iret
  1029fd:	cf                   	iret   

001029fe <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029fe:	55                   	push   %ebp
  1029ff:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a01:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102a06:	8b 55 08             	mov    0x8(%ebp),%edx
  102a09:	29 c2                	sub    %eax,%edx
  102a0b:	89 d0                	mov    %edx,%eax
  102a0d:	c1 f8 02             	sar    $0x2,%eax
  102a10:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a16:	5d                   	pop    %ebp
  102a17:	c3                   	ret    

00102a18 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a18:	55                   	push   %ebp
  102a19:	89 e5                	mov    %esp,%ebp
  102a1b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a21:	89 04 24             	mov    %eax,(%esp)
  102a24:	e8 d5 ff ff ff       	call   1029fe <page2ppn>
  102a29:	c1 e0 0c             	shl    $0xc,%eax
}
  102a2c:	c9                   	leave  
  102a2d:	c3                   	ret    

00102a2e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102a2e:	55                   	push   %ebp
  102a2f:	89 e5                	mov    %esp,%ebp
  102a31:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102a34:	8b 45 08             	mov    0x8(%ebp),%eax
  102a37:	c1 e8 0c             	shr    $0xc,%eax
  102a3a:	89 c2                	mov    %eax,%edx
  102a3c:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102a41:	39 c2                	cmp    %eax,%edx
  102a43:	72 1c                	jb     102a61 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102a45:	c7 44 24 08 b0 67 10 	movl   $0x1067b0,0x8(%esp)
  102a4c:	00 
  102a4d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a54:	00 
  102a55:	c7 04 24 cf 67 10 00 	movl   $0x1067cf,(%esp)
  102a5c:	e8 d0 d9 ff ff       	call   100431 <__panic>
    }
    return &pages[PPN(pa)];
  102a61:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102a67:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6a:	c1 e8 0c             	shr    $0xc,%eax
  102a6d:	89 c2                	mov    %eax,%edx
  102a6f:	89 d0                	mov    %edx,%eax
  102a71:	c1 e0 02             	shl    $0x2,%eax
  102a74:	01 d0                	add    %edx,%eax
  102a76:	c1 e0 02             	shl    $0x2,%eax
  102a79:	01 c8                	add    %ecx,%eax
}
  102a7b:	c9                   	leave  
  102a7c:	c3                   	ret    

00102a7d <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102a7d:	55                   	push   %ebp
  102a7e:	89 e5                	mov    %esp,%ebp
  102a80:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a83:	8b 45 08             	mov    0x8(%ebp),%eax
  102a86:	89 04 24             	mov    %eax,(%esp)
  102a89:	e8 8a ff ff ff       	call   102a18 <page2pa>
  102a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a94:	c1 e8 0c             	shr    $0xc,%eax
  102a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a9a:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102a9f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102aa2:	72 23                	jb     102ac7 <page2kva+0x4a>
  102aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102aab:	c7 44 24 08 e0 67 10 	movl   $0x1067e0,0x8(%esp)
  102ab2:	00 
  102ab3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102aba:	00 
  102abb:	c7 04 24 cf 67 10 00 	movl   $0x1067cf,(%esp)
  102ac2:	e8 6a d9 ff ff       	call   100431 <__panic>
  102ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aca:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102acf:	c9                   	leave  
  102ad0:	c3                   	ret    

00102ad1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102ad1:	55                   	push   %ebp
  102ad2:	89 e5                	mov    %esp,%ebp
  102ad4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  102ada:	83 e0 01             	and    $0x1,%eax
  102add:	85 c0                	test   %eax,%eax
  102adf:	75 1c                	jne    102afd <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102ae1:	c7 44 24 08 04 68 10 	movl   $0x106804,0x8(%esp)
  102ae8:	00 
  102ae9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102af0:	00 
  102af1:	c7 04 24 cf 67 10 00 	movl   $0x1067cf,(%esp)
  102af8:	e8 34 d9 ff ff       	call   100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102afd:	8b 45 08             	mov    0x8(%ebp),%eax
  102b00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b05:	89 04 24             	mov    %eax,(%esp)
  102b08:	e8 21 ff ff ff       	call   102a2e <pa2page>
}
  102b0d:	c9                   	leave  
  102b0e:	c3                   	ret    

00102b0f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102b0f:	55                   	push   %ebp
  102b10:	89 e5                	mov    %esp,%ebp
  102b12:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102b15:	8b 45 08             	mov    0x8(%ebp),%eax
  102b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b1d:	89 04 24             	mov    %eax,(%esp)
  102b20:	e8 09 ff ff ff       	call   102a2e <pa2page>
}
  102b25:	c9                   	leave  
  102b26:	c3                   	ret    

00102b27 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102b27:	55                   	push   %ebp
  102b28:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2d:	8b 00                	mov    (%eax),%eax
}
  102b2f:	5d                   	pop    %ebp
  102b30:	c3                   	ret    

00102b31 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102b31:	55                   	push   %ebp
  102b32:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102b34:	8b 45 08             	mov    0x8(%ebp),%eax
  102b37:	8b 00                	mov    (%eax),%eax
  102b39:	8d 50 01             	lea    0x1(%eax),%edx
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b41:	8b 45 08             	mov    0x8(%ebp),%eax
  102b44:	8b 00                	mov    (%eax),%eax
}
  102b46:	5d                   	pop    %ebp
  102b47:	c3                   	ret    

00102b48 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b48:	55                   	push   %ebp
  102b49:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4e:	8b 00                	mov    (%eax),%eax
  102b50:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b53:	8b 45 08             	mov    0x8(%ebp),%eax
  102b56:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b58:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5b:	8b 00                	mov    (%eax),%eax
}
  102b5d:	5d                   	pop    %ebp
  102b5e:	c3                   	ret    

00102b5f <__intr_save>:
__intr_save(void) {
  102b5f:	55                   	push   %ebp
  102b60:	89 e5                	mov    %esp,%ebp
  102b62:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102b65:	9c                   	pushf  
  102b66:	58                   	pop    %eax
  102b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102b6d:	25 00 02 00 00       	and    $0x200,%eax
  102b72:	85 c0                	test   %eax,%eax
  102b74:	74 0c                	je     102b82 <__intr_save+0x23>
        intr_disable();
  102b76:	e8 0a ee ff ff       	call   101985 <intr_disable>
        return 1;
  102b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  102b80:	eb 05                	jmp    102b87 <__intr_save+0x28>
    return 0;
  102b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b87:	c9                   	leave  
  102b88:	c3                   	ret    

00102b89 <__intr_restore>:
__intr_restore(bool flag) {
  102b89:	55                   	push   %ebp
  102b8a:	89 e5                	mov    %esp,%ebp
  102b8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102b8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b93:	74 05                	je     102b9a <__intr_restore+0x11>
        intr_enable();
  102b95:	e8 df ed ff ff       	call   101979 <intr_enable>
}
  102b9a:	90                   	nop
  102b9b:	c9                   	leave  
  102b9c:	c3                   	ret    

00102b9d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b9d:	55                   	push   %ebp
  102b9e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ba6:	b8 23 00 00 00       	mov    $0x23,%eax
  102bab:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102bad:	b8 23 00 00 00       	mov    $0x23,%eax
  102bb2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102bb4:	b8 10 00 00 00       	mov    $0x10,%eax
  102bb9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102bbb:	b8 10 00 00 00       	mov    $0x10,%eax
  102bc0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102bc2:	b8 10 00 00 00       	mov    $0x10,%eax
  102bc7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102bc9:	ea d0 2b 10 00 08 00 	ljmp   $0x8,$0x102bd0
}
  102bd0:	90                   	nop
  102bd1:	5d                   	pop    %ebp
  102bd2:	c3                   	ret    

00102bd3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102bd3:	f3 0f 1e fb          	endbr32 
  102bd7:	55                   	push   %ebp
  102bd8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102be2:	90                   	nop
  102be3:	5d                   	pop    %ebp
  102be4:	c3                   	ret    

00102be5 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102be5:	f3 0f 1e fb          	endbr32 
  102be9:	55                   	push   %ebp
  102bea:	89 e5                	mov    %esp,%ebp
  102bec:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102bef:	b8 00 90 11 00       	mov    $0x119000,%eax
  102bf4:	89 04 24             	mov    %eax,(%esp)
  102bf7:	e8 d7 ff ff ff       	call   102bd3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102bfc:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102c03:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102c05:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102c0c:	68 00 
  102c0e:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c13:	0f b7 c0             	movzwl %ax,%eax
  102c16:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102c1c:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c21:	c1 e8 10             	shr    $0x10,%eax
  102c24:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102c29:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c30:	24 f0                	and    $0xf0,%al
  102c32:	0c 09                	or     $0x9,%al
  102c34:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c39:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c40:	24 ef                	and    $0xef,%al
  102c42:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c47:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c4e:	24 9f                	and    $0x9f,%al
  102c50:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c55:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102c5c:	0c 80                	or     $0x80,%al
  102c5e:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102c63:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c6a:	24 f0                	and    $0xf0,%al
  102c6c:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c71:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c78:	24 ef                	and    $0xef,%al
  102c7a:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c7f:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c86:	24 df                	and    $0xdf,%al
  102c88:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c8d:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c94:	0c 40                	or     $0x40,%al
  102c96:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c9b:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102ca2:	24 7f                	and    $0x7f,%al
  102ca4:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102ca9:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102cae:	c1 e8 18             	shr    $0x18,%eax
  102cb1:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102cb6:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102cbd:	e8 db fe ff ff       	call   102b9d <lgdt>
  102cc2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102cc8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102ccc:	0f 00 d8             	ltr    %ax
}
  102ccf:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102cd0:	90                   	nop
  102cd1:	c9                   	leave  
  102cd2:	c3                   	ret    

00102cd3 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102cd3:	f3 0f 1e fb          	endbr32 
  102cd7:	55                   	push   %ebp
  102cd8:	89 e5                	mov    %esp,%ebp
  102cda:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102cdd:	c7 05 10 cf 11 00 d8 	movl   $0x1071d8,0x11cf10
  102ce4:	71 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102ce7:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102cec:	8b 00                	mov    (%eax),%eax
  102cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf2:	c7 04 24 30 68 10 00 	movl   $0x106830,(%esp)
  102cf9:	e8 c7 d5 ff ff       	call   1002c5 <cprintf>
    pmm_manager->init();
  102cfe:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d03:	8b 40 04             	mov    0x4(%eax),%eax
  102d06:	ff d0                	call   *%eax
}
  102d08:	90                   	nop
  102d09:	c9                   	leave  
  102d0a:	c3                   	ret    

00102d0b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102d0b:	f3 0f 1e fb          	endbr32 
  102d0f:	55                   	push   %ebp
  102d10:	89 e5                	mov    %esp,%ebp
  102d12:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102d15:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d1a:	8b 40 08             	mov    0x8(%eax),%eax
  102d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d20:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d24:	8b 55 08             	mov    0x8(%ebp),%edx
  102d27:	89 14 24             	mov    %edx,(%esp)
  102d2a:	ff d0                	call   *%eax
}
  102d2c:	90                   	nop
  102d2d:	c9                   	leave  
  102d2e:	c3                   	ret    

00102d2f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102d2f:	f3 0f 1e fb          	endbr32 
  102d33:	55                   	push   %ebp
  102d34:	89 e5                	mov    %esp,%ebp
  102d36:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102d40:	e8 1a fe ff ff       	call   102b5f <__intr_save>
  102d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102d48:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  102d50:	8b 55 08             	mov    0x8(%ebp),%edx
  102d53:	89 14 24             	mov    %edx,(%esp)
  102d56:	ff d0                	call   *%eax
  102d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d5e:	89 04 24             	mov    %eax,(%esp)
  102d61:	e8 23 fe ff ff       	call   102b89 <__intr_restore>
    return page;
  102d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d69:	c9                   	leave  
  102d6a:	c3                   	ret    

00102d6b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102d6b:	f3 0f 1e fb          	endbr32 
  102d6f:	55                   	push   %ebp
  102d70:	89 e5                	mov    %esp,%ebp
  102d72:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102d75:	e8 e5 fd ff ff       	call   102b5f <__intr_save>
  102d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102d7d:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d82:	8b 40 10             	mov    0x10(%eax),%eax
  102d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d88:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  102d8f:	89 14 24             	mov    %edx,(%esp)
  102d92:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d97:	89 04 24             	mov    %eax,(%esp)
  102d9a:	e8 ea fd ff ff       	call   102b89 <__intr_restore>
}
  102d9f:	90                   	nop
  102da0:	c9                   	leave  
  102da1:	c3                   	ret    

00102da2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102da2:	f3 0f 1e fb          	endbr32 
  102da6:	55                   	push   %ebp
  102da7:	89 e5                	mov    %esp,%ebp
  102da9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102dac:	e8 ae fd ff ff       	call   102b5f <__intr_save>
  102db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102db4:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102db9:	8b 40 14             	mov    0x14(%eax),%eax
  102dbc:	ff d0                	call   *%eax
  102dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc4:	89 04 24             	mov    %eax,(%esp)
  102dc7:	e8 bd fd ff ff       	call   102b89 <__intr_restore>
    return ret;
  102dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102dcf:	c9                   	leave  
  102dd0:	c3                   	ret    

00102dd1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102dd1:	f3 0f 1e fb          	endbr32 
  102dd5:	55                   	push   %ebp
  102dd6:	89 e5                	mov    %esp,%ebp
  102dd8:	57                   	push   %edi
  102dd9:	56                   	push   %esi
  102dda:	53                   	push   %ebx
  102ddb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102de1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102def:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102df6:	c7 04 24 47 68 10 00 	movl   $0x106847,(%esp)
  102dfd:	e8 c3 d4 ff ff       	call   1002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102e02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e09:	e9 1a 01 00 00       	jmp    102f28 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e0e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e11:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e14:	89 d0                	mov    %edx,%eax
  102e16:	c1 e0 02             	shl    $0x2,%eax
  102e19:	01 d0                	add    %edx,%eax
  102e1b:	c1 e0 02             	shl    $0x2,%eax
  102e1e:	01 c8                	add    %ecx,%eax
  102e20:	8b 50 08             	mov    0x8(%eax),%edx
  102e23:	8b 40 04             	mov    0x4(%eax),%eax
  102e26:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102e29:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e32:	89 d0                	mov    %edx,%eax
  102e34:	c1 e0 02             	shl    $0x2,%eax
  102e37:	01 d0                	add    %edx,%eax
  102e39:	c1 e0 02             	shl    $0x2,%eax
  102e3c:	01 c8                	add    %ecx,%eax
  102e3e:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e41:	8b 58 10             	mov    0x10(%eax),%ebx
  102e44:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e47:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e4a:	01 c8                	add    %ecx,%eax
  102e4c:	11 da                	adc    %ebx,%edx
  102e4e:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e51:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102e54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e5a:	89 d0                	mov    %edx,%eax
  102e5c:	c1 e0 02             	shl    $0x2,%eax
  102e5f:	01 d0                	add    %edx,%eax
  102e61:	c1 e0 02             	shl    $0x2,%eax
  102e64:	01 c8                	add    %ecx,%eax
  102e66:	83 c0 14             	add    $0x14,%eax
  102e69:	8b 00                	mov    (%eax),%eax
  102e6b:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102e6e:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e71:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e74:	83 c0 ff             	add    $0xffffffff,%eax
  102e77:	83 d2 ff             	adc    $0xffffffff,%edx
  102e7a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102e80:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102e86:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e89:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e8c:	89 d0                	mov    %edx,%eax
  102e8e:	c1 e0 02             	shl    $0x2,%eax
  102e91:	01 d0                	add    %edx,%eax
  102e93:	c1 e0 02             	shl    $0x2,%eax
  102e96:	01 c8                	add    %ecx,%eax
  102e98:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e9b:	8b 58 10             	mov    0x10(%eax),%ebx
  102e9e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102ea1:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102ea5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102eab:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102eb1:	89 44 24 14          	mov    %eax,0x14(%esp)
  102eb5:	89 54 24 18          	mov    %edx,0x18(%esp)
  102eb9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ebc:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ec3:	89 54 24 10          	mov    %edx,0x10(%esp)
  102ec7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102ecf:	c7 04 24 54 68 10 00 	movl   $0x106854,(%esp)
  102ed6:	e8 ea d3 ff ff       	call   1002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102edb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ee1:	89 d0                	mov    %edx,%eax
  102ee3:	c1 e0 02             	shl    $0x2,%eax
  102ee6:	01 d0                	add    %edx,%eax
  102ee8:	c1 e0 02             	shl    $0x2,%eax
  102eeb:	01 c8                	add    %ecx,%eax
  102eed:	83 c0 14             	add    $0x14,%eax
  102ef0:	8b 00                	mov    (%eax),%eax
  102ef2:	83 f8 01             	cmp    $0x1,%eax
  102ef5:	75 2e                	jne    102f25 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  102ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102efd:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102f00:	89 d0                	mov    %edx,%eax
  102f02:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102f05:	73 1e                	jae    102f25 <page_init+0x154>
  102f07:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  102f11:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102f14:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102f17:	72 0c                	jb     102f25 <page_init+0x154>
                maxpa = end;
  102f19:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f1c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102f25:	ff 45 dc             	incl   -0x24(%ebp)
  102f28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f2b:	8b 00                	mov    (%eax),%eax
  102f2d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102f30:	0f 8c d8 fe ff ff    	jl     102e0e <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102f36:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  102f40:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102f43:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102f46:	73 0e                	jae    102f56 <page_init+0x185>
        maxpa = KMEMSIZE;
  102f48:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102f4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f5c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f60:	c1 ea 0c             	shr    $0xc,%edx
  102f63:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102f68:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102f6f:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102f74:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102f7a:	01 d0                	add    %edx,%eax
  102f7c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102f7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f82:	ba 00 00 00 00       	mov    $0x0,%edx
  102f87:	f7 75 c0             	divl   -0x40(%ebp)
  102f8a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f8d:	29 d0                	sub    %edx,%eax
  102f8f:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i ++) {
  102f94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f9b:	eb 2f                	jmp    102fcc <page_init+0x1fb>
        SetPageReserved(pages + i);
  102f9d:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102fa3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fa6:	89 d0                	mov    %edx,%eax
  102fa8:	c1 e0 02             	shl    $0x2,%eax
  102fab:	01 d0                	add    %edx,%eax
  102fad:	c1 e0 02             	shl    $0x2,%eax
  102fb0:	01 c8                	add    %ecx,%eax
  102fb2:	83 c0 04             	add    $0x4,%eax
  102fb5:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102fbc:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102fbf:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fc2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102fc5:	0f ab 10             	bts    %edx,(%eax)
}
  102fc8:	90                   	nop
    for (i = 0; i < npage; i ++) {
  102fc9:	ff 45 dc             	incl   -0x24(%ebp)
  102fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fcf:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102fd4:	39 c2                	cmp    %eax,%edx
  102fd6:	72 c5                	jb     102f9d <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102fd8:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  102fde:	89 d0                	mov    %edx,%eax
  102fe0:	c1 e0 02             	shl    $0x2,%eax
  102fe3:	01 d0                	add    %edx,%eax
  102fe5:	c1 e0 02             	shl    $0x2,%eax
  102fe8:	89 c2                	mov    %eax,%edx
  102fea:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102fef:	01 d0                	add    %edx,%eax
  102ff1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102ff4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102ffb:	77 23                	ja     103020 <page_init+0x24f>
  102ffd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103000:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103004:	c7 44 24 08 84 68 10 	movl   $0x106884,0x8(%esp)
  10300b:	00 
  10300c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103013:	00 
  103014:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10301b:	e8 11 d4 ff ff       	call   100431 <__panic>
  103020:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103023:	05 00 00 00 40       	add    $0x40000000,%eax
  103028:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10302b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103032:	e9 4b 01 00 00       	jmp    103182 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103037:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10303a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10303d:	89 d0                	mov    %edx,%eax
  10303f:	c1 e0 02             	shl    $0x2,%eax
  103042:	01 d0                	add    %edx,%eax
  103044:	c1 e0 02             	shl    $0x2,%eax
  103047:	01 c8                	add    %ecx,%eax
  103049:	8b 50 08             	mov    0x8(%eax),%edx
  10304c:	8b 40 04             	mov    0x4(%eax),%eax
  10304f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103052:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103055:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103058:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10305b:	89 d0                	mov    %edx,%eax
  10305d:	c1 e0 02             	shl    $0x2,%eax
  103060:	01 d0                	add    %edx,%eax
  103062:	c1 e0 02             	shl    $0x2,%eax
  103065:	01 c8                	add    %ecx,%eax
  103067:	8b 48 0c             	mov    0xc(%eax),%ecx
  10306a:	8b 58 10             	mov    0x10(%eax),%ebx
  10306d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103070:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103073:	01 c8                	add    %ecx,%eax
  103075:	11 da                	adc    %ebx,%edx
  103077:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10307a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10307d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103080:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103083:	89 d0                	mov    %edx,%eax
  103085:	c1 e0 02             	shl    $0x2,%eax
  103088:	01 d0                	add    %edx,%eax
  10308a:	c1 e0 02             	shl    $0x2,%eax
  10308d:	01 c8                	add    %ecx,%eax
  10308f:	83 c0 14             	add    $0x14,%eax
  103092:	8b 00                	mov    (%eax),%eax
  103094:	83 f8 01             	cmp    $0x1,%eax
  103097:	0f 85 e2 00 00 00    	jne    10317f <page_init+0x3ae>
            if (begin < freemem) {
  10309d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1030a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1030a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1030ab:	19 d1                	sbb    %edx,%ecx
  1030ad:	73 0d                	jae    1030bc <page_init+0x2eb>
                begin = freemem;
  1030af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1030bc:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  1030c6:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1030c9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030cc:	73 0e                	jae    1030dc <page_init+0x30b>
                end = KMEMSIZE;
  1030ce:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1030d5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1030dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030e2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030e5:	89 d0                	mov    %edx,%eax
  1030e7:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030ea:	0f 83 8f 00 00 00    	jae    10317f <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  1030f0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1030f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1030fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1030fd:	01 d0                	add    %edx,%eax
  1030ff:	48                   	dec    %eax
  103100:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103103:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103106:	ba 00 00 00 00       	mov    $0x0,%edx
  10310b:	f7 75 b0             	divl   -0x50(%ebp)
  10310e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103111:	29 d0                	sub    %edx,%eax
  103113:	ba 00 00 00 00       	mov    $0x0,%edx
  103118:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10311b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10311e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103121:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103124:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103127:	ba 00 00 00 00       	mov    $0x0,%edx
  10312c:	89 c3                	mov    %eax,%ebx
  10312e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103134:	89 de                	mov    %ebx,%esi
  103136:	89 d0                	mov    %edx,%eax
  103138:	83 e0 00             	and    $0x0,%eax
  10313b:	89 c7                	mov    %eax,%edi
  10313d:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103140:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103143:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103146:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103149:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10314c:	89 d0                	mov    %edx,%eax
  10314e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103151:	73 2c                	jae    10317f <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103153:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103156:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103159:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10315c:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10315f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103163:	c1 ea 0c             	shr    $0xc,%edx
  103166:	89 c3                	mov    %eax,%ebx
  103168:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10316b:	89 04 24             	mov    %eax,(%esp)
  10316e:	e8 bb f8 ff ff       	call   102a2e <pa2page>
  103173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103177:	89 04 24             	mov    %eax,(%esp)
  10317a:	e8 8c fb ff ff       	call   102d0b <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10317f:	ff 45 dc             	incl   -0x24(%ebp)
  103182:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103185:	8b 00                	mov    (%eax),%eax
  103187:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10318a:	0f 8c a7 fe ff ff    	jl     103037 <page_init+0x266>
                }
            }
        }
    }
}
  103190:	90                   	nop
  103191:	90                   	nop
  103192:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103198:	5b                   	pop    %ebx
  103199:	5e                   	pop    %esi
  10319a:	5f                   	pop    %edi
  10319b:	5d                   	pop    %ebp
  10319c:	c3                   	ret    

0010319d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10319d:	f3 0f 1e fb          	endbr32 
  1031a1:	55                   	push   %ebp
  1031a2:	89 e5                	mov    %esp,%ebp
  1031a4:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1031a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031aa:	33 45 14             	xor    0x14(%ebp),%eax
  1031ad:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031b2:	85 c0                	test   %eax,%eax
  1031b4:	74 24                	je     1031da <boot_map_segment+0x3d>
  1031b6:	c7 44 24 0c b6 68 10 	movl   $0x1068b6,0xc(%esp)
  1031bd:	00 
  1031be:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1031c5:	00 
  1031c6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1031cd:	00 
  1031ce:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1031d5:	e8 57 d2 ff ff       	call   100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1031da:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1031e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031e9:	89 c2                	mov    %eax,%edx
  1031eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1031ee:	01 c2                	add    %eax,%edx
  1031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f3:	01 d0                	add    %edx,%eax
  1031f5:	48                   	dec    %eax
  1031f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031fc:	ba 00 00 00 00       	mov    $0x0,%edx
  103201:	f7 75 f0             	divl   -0x10(%ebp)
  103204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103207:	29 d0                	sub    %edx,%eax
  103209:	c1 e8 0c             	shr    $0xc,%eax
  10320c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10320f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103212:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10321d:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103220:	8b 45 14             	mov    0x14(%ebp),%eax
  103223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103229:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10322e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103231:	eb 68                	jmp    10329b <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10323a:	00 
  10323b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10323e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	89 04 24             	mov    %eax,(%esp)
  103248:	e8 8a 01 00 00       	call   1033d7 <get_pte>
  10324d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103250:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103254:	75 24                	jne    10327a <boot_map_segment+0xdd>
  103256:	c7 44 24 0c e2 68 10 	movl   $0x1068e2,0xc(%esp)
  10325d:	00 
  10325e:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103265:	00 
  103266:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10326d:	00 
  10326e:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103275:	e8 b7 d1 ff ff       	call   100431 <__panic>
        *ptep = pa | PTE_P | perm;
  10327a:	8b 45 14             	mov    0x14(%ebp),%eax
  10327d:	0b 45 18             	or     0x18(%ebp),%eax
  103280:	83 c8 01             	or     $0x1,%eax
  103283:	89 c2                	mov    %eax,%edx
  103285:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103288:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10328a:	ff 4d f4             	decl   -0xc(%ebp)
  10328d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103294:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10329b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10329f:	75 92                	jne    103233 <boot_map_segment+0x96>
    }
}
  1032a1:	90                   	nop
  1032a2:	90                   	nop
  1032a3:	c9                   	leave  
  1032a4:	c3                   	ret    

001032a5 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1032a5:	f3 0f 1e fb          	endbr32 
  1032a9:	55                   	push   %ebp
  1032aa:	89 e5                	mov    %esp,%ebp
  1032ac:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1032af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b6:	e8 74 fa ff ff       	call   102d2f <alloc_pages>
  1032bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1032be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032c2:	75 1c                	jne    1032e0 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  1032c4:	c7 44 24 08 ef 68 10 	movl   $0x1068ef,0x8(%esp)
  1032cb:	00 
  1032cc:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1032d3:	00 
  1032d4:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1032db:	e8 51 d1 ff ff       	call   100431 <__panic>
    }
    return page2kva(p);
  1032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e3:	89 04 24             	mov    %eax,(%esp)
  1032e6:	e8 92 f7 ff ff       	call   102a7d <page2kva>
}
  1032eb:	c9                   	leave  
  1032ec:	c3                   	ret    

001032ed <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1032ed:	f3 0f 1e fb          	endbr32 
  1032f1:	55                   	push   %ebp
  1032f2:	89 e5                	mov    %esp,%ebp
  1032f4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1032f7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103306:	77 23                	ja     10332b <pmm_init+0x3e>
  103308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10330b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10330f:	c7 44 24 08 84 68 10 	movl   $0x106884,0x8(%esp)
  103316:	00 
  103317:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10331e:	00 
  10331f:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103326:	e8 06 d1 ff ff       	call   100431 <__panic>
  10332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10332e:	05 00 00 00 40       	add    $0x40000000,%eax
  103333:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103338:	e8 96 f9 ff ff       	call   102cd3 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10333d:	e8 8f fa ff ff       	call   102dd1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103342:	e8 64 02 00 00       	call   1035ab <check_alloc_page>

    check_pgdir();
  103347:	e8 82 02 00 00       	call   1035ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10334c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103351:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103354:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10335b:	77 23                	ja     103380 <pmm_init+0x93>
  10335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103360:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103364:	c7 44 24 08 84 68 10 	movl   $0x106884,0x8(%esp)
  10336b:	00 
  10336c:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103373:	00 
  103374:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10337b:	e8 b1 d0 ff ff       	call   100431 <__panic>
  103380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103383:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103389:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10338e:	05 ac 0f 00 00       	add    $0xfac,%eax
  103393:	83 ca 03             	or     $0x3,%edx
  103396:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103398:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10339d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1033a4:	00 
  1033a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1033ac:	00 
  1033ad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1033b4:	38 
  1033b5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1033bc:	c0 
  1033bd:	89 04 24             	mov    %eax,(%esp)
  1033c0:	e8 d8 fd ff ff       	call   10319d <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1033c5:	e8 1b f8 ff ff       	call   102be5 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1033ca:	e8 9f 08 00 00       	call   103c6e <check_boot_pgdir>

    print_pgdir();
  1033cf:	e8 24 0d 00 00       	call   1040f8 <print_pgdir>

}
  1033d4:	90                   	nop
  1033d5:	c9                   	leave  
  1033d6:	c3                   	ret    

001033d7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1033d7:	f3 0f 1e fb          	endbr32 
  1033db:	55                   	push   %ebp
  1033dc:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1033de:	90                   	nop
  1033df:	5d                   	pop    %ebp
  1033e0:	c3                   	ret    

001033e1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1033e1:	f3 0f 1e fb          	endbr32 
  1033e5:	55                   	push   %ebp
  1033e6:	89 e5                	mov    %esp,%ebp
  1033e8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1033eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1033f2:	00 
  1033f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fd:	89 04 24             	mov    %eax,(%esp)
  103400:	e8 d2 ff ff ff       	call   1033d7 <get_pte>
  103405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10340c:	74 08                	je     103416 <get_page+0x35>
        *ptep_store = ptep;
  10340e:	8b 45 10             	mov    0x10(%ebp),%eax
  103411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103414:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10341a:	74 1b                	je     103437 <get_page+0x56>
  10341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10341f:	8b 00                	mov    (%eax),%eax
  103421:	83 e0 01             	and    $0x1,%eax
  103424:	85 c0                	test   %eax,%eax
  103426:	74 0f                	je     103437 <get_page+0x56>
        return pte2page(*ptep);
  103428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10342b:	8b 00                	mov    (%eax),%eax
  10342d:	89 04 24             	mov    %eax,(%esp)
  103430:	e8 9c f6 ff ff       	call   102ad1 <pte2page>
  103435:	eb 05                	jmp    10343c <get_page+0x5b>
    }
    return NULL;
  103437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10343c:	c9                   	leave  
  10343d:	c3                   	ret    

0010343e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10343e:	55                   	push   %ebp
  10343f:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103441:	90                   	nop
  103442:	5d                   	pop    %ebp
  103443:	c3                   	ret    

00103444 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103444:	f3 0f 1e fb          	endbr32 
  103448:	55                   	push   %ebp
  103449:	89 e5                	mov    %esp,%ebp
  10344b:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10344e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103455:	00 
  103456:	8b 45 0c             	mov    0xc(%ebp),%eax
  103459:	89 44 24 04          	mov    %eax,0x4(%esp)
  10345d:	8b 45 08             	mov    0x8(%ebp),%eax
  103460:	89 04 24             	mov    %eax,(%esp)
  103463:	e8 6f ff ff ff       	call   1033d7 <get_pte>
  103468:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10346b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10346f:	74 19                	je     10348a <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  103471:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103474:	89 44 24 08          	mov    %eax,0x8(%esp)
  103478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10347b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10347f:	8b 45 08             	mov    0x8(%ebp),%eax
  103482:	89 04 24             	mov    %eax,(%esp)
  103485:	e8 b4 ff ff ff       	call   10343e <page_remove_pte>
    }
}
  10348a:	90                   	nop
  10348b:	c9                   	leave  
  10348c:	c3                   	ret    

0010348d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10348d:	f3 0f 1e fb          	endbr32 
  103491:	55                   	push   %ebp
  103492:	89 e5                	mov    %esp,%ebp
  103494:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10349e:	00 
  10349f:	8b 45 10             	mov    0x10(%ebp),%eax
  1034a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a9:	89 04 24             	mov    %eax,(%esp)
  1034ac:	e8 26 ff ff ff       	call   1033d7 <get_pte>
  1034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1034b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034b8:	75 0a                	jne    1034c4 <page_insert+0x37>
        return -E_NO_MEM;
  1034ba:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1034bf:	e9 84 00 00 00       	jmp    103548 <page_insert+0xbb>
    }
    page_ref_inc(page);
  1034c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c7:	89 04 24             	mov    %eax,(%esp)
  1034ca:	e8 62 f6 ff ff       	call   102b31 <page_ref_inc>
    if (*ptep & PTE_P) {
  1034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d2:	8b 00                	mov    (%eax),%eax
  1034d4:	83 e0 01             	and    $0x1,%eax
  1034d7:	85 c0                	test   %eax,%eax
  1034d9:	74 3e                	je     103519 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  1034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034de:	8b 00                	mov    (%eax),%eax
  1034e0:	89 04 24             	mov    %eax,(%esp)
  1034e3:	e8 e9 f5 ff ff       	call   102ad1 <pte2page>
  1034e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034f1:	75 0d                	jne    103500 <page_insert+0x73>
            page_ref_dec(page);
  1034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f6:	89 04 24             	mov    %eax,(%esp)
  1034f9:	e8 4a f6 ff ff       	call   102b48 <page_ref_dec>
  1034fe:	eb 19                	jmp    103519 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103503:	89 44 24 08          	mov    %eax,0x8(%esp)
  103507:	8b 45 10             	mov    0x10(%ebp),%eax
  10350a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350e:	8b 45 08             	mov    0x8(%ebp),%eax
  103511:	89 04 24             	mov    %eax,(%esp)
  103514:	e8 25 ff ff ff       	call   10343e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103519:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351c:	89 04 24             	mov    %eax,(%esp)
  10351f:	e8 f4 f4 ff ff       	call   102a18 <page2pa>
  103524:	0b 45 14             	or     0x14(%ebp),%eax
  103527:	83 c8 01             	or     $0x1,%eax
  10352a:	89 c2                	mov    %eax,%edx
  10352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10352f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103531:	8b 45 10             	mov    0x10(%ebp),%eax
  103534:	89 44 24 04          	mov    %eax,0x4(%esp)
  103538:	8b 45 08             	mov    0x8(%ebp),%eax
  10353b:	89 04 24             	mov    %eax,(%esp)
  10353e:	e8 07 00 00 00       	call   10354a <tlb_invalidate>
    return 0;
  103543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103548:	c9                   	leave  
  103549:	c3                   	ret    

0010354a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10354a:	f3 0f 1e fb          	endbr32 
  10354e:	55                   	push   %ebp
  10354f:	89 e5                	mov    %esp,%ebp
  103551:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103554:	0f 20 d8             	mov    %cr3,%eax
  103557:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10355a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10355d:	8b 45 08             	mov    0x8(%ebp),%eax
  103560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103563:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10356a:	77 23                	ja     10358f <tlb_invalidate+0x45>
  10356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10356f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103573:	c7 44 24 08 84 68 10 	movl   $0x106884,0x8(%esp)
  10357a:	00 
  10357b:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  103582:	00 
  103583:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10358a:	e8 a2 ce ff ff       	call   100431 <__panic>
  10358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103592:	05 00 00 00 40       	add    $0x40000000,%eax
  103597:	39 d0                	cmp    %edx,%eax
  103599:	75 0d                	jne    1035a8 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  10359b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10359e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a4:	0f 01 38             	invlpg (%eax)
}
  1035a7:	90                   	nop
    }
}
  1035a8:	90                   	nop
  1035a9:	c9                   	leave  
  1035aa:	c3                   	ret    

001035ab <check_alloc_page>:

static void
check_alloc_page(void) {
  1035ab:	f3 0f 1e fb          	endbr32 
  1035af:	55                   	push   %ebp
  1035b0:	89 e5                	mov    %esp,%ebp
  1035b2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1035b5:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  1035ba:	8b 40 18             	mov    0x18(%eax),%eax
  1035bd:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1035bf:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1035c6:	e8 fa cc ff ff       	call   1002c5 <cprintf>
}
  1035cb:	90                   	nop
  1035cc:	c9                   	leave  
  1035cd:	c3                   	ret    

001035ce <check_pgdir>:

static void
check_pgdir(void) {
  1035ce:	f3 0f 1e fb          	endbr32 
  1035d2:	55                   	push   %ebp
  1035d3:	89 e5                	mov    %esp,%ebp
  1035d5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035d8:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1035dd:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035e2:	76 24                	jbe    103608 <check_pgdir+0x3a>
  1035e4:	c7 44 24 0c 27 69 10 	movl   $0x106927,0xc(%esp)
  1035eb:	00 
  1035ec:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1035f3:	00 
  1035f4:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  1035fb:	00 
  1035fc:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103603:	e8 29 ce ff ff       	call   100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103608:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10360d:	85 c0                	test   %eax,%eax
  10360f:	74 0e                	je     10361f <check_pgdir+0x51>
  103611:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103616:	25 ff 0f 00 00       	and    $0xfff,%eax
  10361b:	85 c0                	test   %eax,%eax
  10361d:	74 24                	je     103643 <check_pgdir+0x75>
  10361f:	c7 44 24 0c 44 69 10 	movl   $0x106944,0xc(%esp)
  103626:	00 
  103627:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  10362e:	00 
  10362f:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  103636:	00 
  103637:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10363e:	e8 ee cd ff ff       	call   100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103643:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103648:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10364f:	00 
  103650:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103657:	00 
  103658:	89 04 24             	mov    %eax,(%esp)
  10365b:	e8 81 fd ff ff       	call   1033e1 <get_page>
  103660:	85 c0                	test   %eax,%eax
  103662:	74 24                	je     103688 <check_pgdir+0xba>
  103664:	c7 44 24 0c 7c 69 10 	movl   $0x10697c,0xc(%esp)
  10366b:	00 
  10366c:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103673:	00 
  103674:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  10367b:	00 
  10367c:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103683:	e8 a9 cd ff ff       	call   100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103688:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10368f:	e8 9b f6 ff ff       	call   102d2f <alloc_pages>
  103694:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103697:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10369c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1036a3:	00 
  1036a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036ab:	00 
  1036ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1036b3:	89 04 24             	mov    %eax,(%esp)
  1036b6:	e8 d2 fd ff ff       	call   10348d <page_insert>
  1036bb:	85 c0                	test   %eax,%eax
  1036bd:	74 24                	je     1036e3 <check_pgdir+0x115>
  1036bf:	c7 44 24 0c a4 69 10 	movl   $0x1069a4,0xc(%esp)
  1036c6:	00 
  1036c7:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1036ce:	00 
  1036cf:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1036d6:	00 
  1036d7:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1036de:	e8 4e cd ff ff       	call   100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1036e3:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1036e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036ef:	00 
  1036f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036f7:	00 
  1036f8:	89 04 24             	mov    %eax,(%esp)
  1036fb:	e8 d7 fc ff ff       	call   1033d7 <get_pte>
  103700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103707:	75 24                	jne    10372d <check_pgdir+0x15f>
  103709:	c7 44 24 0c d0 69 10 	movl   $0x1069d0,0xc(%esp)
  103710:	00 
  103711:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103718:	00 
  103719:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  103720:	00 
  103721:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103728:	e8 04 cd ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  10372d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103730:	8b 00                	mov    (%eax),%eax
  103732:	89 04 24             	mov    %eax,(%esp)
  103735:	e8 97 f3 ff ff       	call   102ad1 <pte2page>
  10373a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10373d:	74 24                	je     103763 <check_pgdir+0x195>
  10373f:	c7 44 24 0c fd 69 10 	movl   $0x1069fd,0xc(%esp)
  103746:	00 
  103747:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  10374e:	00 
  10374f:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  103756:	00 
  103757:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10375e:	e8 ce cc ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 1);
  103763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103766:	89 04 24             	mov    %eax,(%esp)
  103769:	e8 b9 f3 ff ff       	call   102b27 <page_ref>
  10376e:	83 f8 01             	cmp    $0x1,%eax
  103771:	74 24                	je     103797 <check_pgdir+0x1c9>
  103773:	c7 44 24 0c 13 6a 10 	movl   $0x106a13,0xc(%esp)
  10377a:	00 
  10377b:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103782:	00 
  103783:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10378a:	00 
  10378b:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103792:	e8 9a cc ff ff       	call   100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103797:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10379c:	8b 00                	mov    (%eax),%eax
  10379e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1037a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037a9:	c1 e8 0c             	shr    $0xc,%eax
  1037ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1037af:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1037b4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1037b7:	72 23                	jb     1037dc <check_pgdir+0x20e>
  1037b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1037c0:	c7 44 24 08 e0 67 10 	movl   $0x1067e0,0x8(%esp)
  1037c7:	00 
  1037c8:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1037cf:	00 
  1037d0:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1037d7:	e8 55 cc ff ff       	call   100431 <__panic>
  1037dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037df:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037e4:	83 c0 04             	add    $0x4,%eax
  1037e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1037ea:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037f6:	00 
  1037f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037fe:	00 
  1037ff:	89 04 24             	mov    %eax,(%esp)
  103802:	e8 d0 fb ff ff       	call   1033d7 <get_pte>
  103807:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10380a:	74 24                	je     103830 <check_pgdir+0x262>
  10380c:	c7 44 24 0c 28 6a 10 	movl   $0x106a28,0xc(%esp)
  103813:	00 
  103814:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  10381b:	00 
  10381c:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  103823:	00 
  103824:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  10382b:	e8 01 cc ff ff       	call   100431 <__panic>

    p2 = alloc_page();
  103830:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103837:	e8 f3 f4 ff ff       	call   102d2f <alloc_pages>
  10383c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10383f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103844:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10384b:	00 
  10384c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103853:	00 
  103854:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103857:	89 54 24 04          	mov    %edx,0x4(%esp)
  10385b:	89 04 24             	mov    %eax,(%esp)
  10385e:	e8 2a fc ff ff       	call   10348d <page_insert>
  103863:	85 c0                	test   %eax,%eax
  103865:	74 24                	je     10388b <check_pgdir+0x2bd>
  103867:	c7 44 24 0c 50 6a 10 	movl   $0x106a50,0xc(%esp)
  10386e:	00 
  10386f:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103876:	00 
  103877:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  10387e:	00 
  10387f:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103886:	e8 a6 cb ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10388b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103890:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103897:	00 
  103898:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10389f:	00 
  1038a0:	89 04 24             	mov    %eax,(%esp)
  1038a3:	e8 2f fb ff ff       	call   1033d7 <get_pte>
  1038a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038af:	75 24                	jne    1038d5 <check_pgdir+0x307>
  1038b1:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  1038b8:	00 
  1038b9:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1038c0:	00 
  1038c1:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  1038c8:	00 
  1038c9:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1038d0:	e8 5c cb ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_U);
  1038d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038d8:	8b 00                	mov    (%eax),%eax
  1038da:	83 e0 04             	and    $0x4,%eax
  1038dd:	85 c0                	test   %eax,%eax
  1038df:	75 24                	jne    103905 <check_pgdir+0x337>
  1038e1:	c7 44 24 0c b8 6a 10 	movl   $0x106ab8,0xc(%esp)
  1038e8:	00 
  1038e9:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1038f0:	00 
  1038f1:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  1038f8:	00 
  1038f9:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103900:	e8 2c cb ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_W);
  103905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103908:	8b 00                	mov    (%eax),%eax
  10390a:	83 e0 02             	and    $0x2,%eax
  10390d:	85 c0                	test   %eax,%eax
  10390f:	75 24                	jne    103935 <check_pgdir+0x367>
  103911:	c7 44 24 0c c6 6a 10 	movl   $0x106ac6,0xc(%esp)
  103918:	00 
  103919:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103920:	00 
  103921:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  103928:	00 
  103929:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103930:	e8 fc ca ff ff       	call   100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103935:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10393a:	8b 00                	mov    (%eax),%eax
  10393c:	83 e0 04             	and    $0x4,%eax
  10393f:	85 c0                	test   %eax,%eax
  103941:	75 24                	jne    103967 <check_pgdir+0x399>
  103943:	c7 44 24 0c d4 6a 10 	movl   $0x106ad4,0xc(%esp)
  10394a:	00 
  10394b:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103952:	00 
  103953:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  10395a:	00 
  10395b:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103962:	e8 ca ca ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 1);
  103967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10396a:	89 04 24             	mov    %eax,(%esp)
  10396d:	e8 b5 f1 ff ff       	call   102b27 <page_ref>
  103972:	83 f8 01             	cmp    $0x1,%eax
  103975:	74 24                	je     10399b <check_pgdir+0x3cd>
  103977:	c7 44 24 0c ea 6a 10 	movl   $0x106aea,0xc(%esp)
  10397e:	00 
  10397f:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103986:	00 
  103987:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10398e:	00 
  10398f:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103996:	e8 96 ca ff ff       	call   100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10399b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1039a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1039a7:	00 
  1039a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1039af:	00 
  1039b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039b7:	89 04 24             	mov    %eax,(%esp)
  1039ba:	e8 ce fa ff ff       	call   10348d <page_insert>
  1039bf:	85 c0                	test   %eax,%eax
  1039c1:	74 24                	je     1039e7 <check_pgdir+0x419>
  1039c3:	c7 44 24 0c fc 6a 10 	movl   $0x106afc,0xc(%esp)
  1039ca:	00 
  1039cb:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  1039d2:	00 
  1039d3:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1039da:	00 
  1039db:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  1039e2:	e8 4a ca ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 2);
  1039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039ea:	89 04 24             	mov    %eax,(%esp)
  1039ed:	e8 35 f1 ff ff       	call   102b27 <page_ref>
  1039f2:	83 f8 02             	cmp    $0x2,%eax
  1039f5:	74 24                	je     103a1b <check_pgdir+0x44d>
  1039f7:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  1039fe:	00 
  1039ff:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103a06:	00 
  103a07:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103a0e:	00 
  103a0f:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103a16:	e8 16 ca ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a1e:	89 04 24             	mov    %eax,(%esp)
  103a21:	e8 01 f1 ff ff       	call   102b27 <page_ref>
  103a26:	85 c0                	test   %eax,%eax
  103a28:	74 24                	je     103a4e <check_pgdir+0x480>
  103a2a:	c7 44 24 0c 3a 6b 10 	movl   $0x106b3a,0xc(%esp)
  103a31:	00 
  103a32:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103a39:	00 
  103a3a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103a41:	00 
  103a42:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103a49:	e8 e3 c9 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a4e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a5a:	00 
  103a5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a62:	00 
  103a63:	89 04 24             	mov    %eax,(%esp)
  103a66:	e8 6c f9 ff ff       	call   1033d7 <get_pte>
  103a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a72:	75 24                	jne    103a98 <check_pgdir+0x4ca>
  103a74:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  103a7b:	00 
  103a7c:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103a83:	00 
  103a84:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  103a8b:	00 
  103a8c:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103a93:	e8 99 c9 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a9b:	8b 00                	mov    (%eax),%eax
  103a9d:	89 04 24             	mov    %eax,(%esp)
  103aa0:	e8 2c f0 ff ff       	call   102ad1 <pte2page>
  103aa5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103aa8:	74 24                	je     103ace <check_pgdir+0x500>
  103aaa:	c7 44 24 0c fd 69 10 	movl   $0x1069fd,0xc(%esp)
  103ab1:	00 
  103ab2:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103ab9:	00 
  103aba:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103ac1:	00 
  103ac2:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103ac9:	e8 63 c9 ff ff       	call   100431 <__panic>
    assert((*ptep & PTE_U) == 0);
  103ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ad1:	8b 00                	mov    (%eax),%eax
  103ad3:	83 e0 04             	and    $0x4,%eax
  103ad6:	85 c0                	test   %eax,%eax
  103ad8:	74 24                	je     103afe <check_pgdir+0x530>
  103ada:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  103ae1:	00 
  103ae2:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103ae9:	00 
  103aea:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103af1:	00 
  103af2:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103af9:	e8 33 c9 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, 0x0);
  103afe:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b0a:	00 
  103b0b:	89 04 24             	mov    %eax,(%esp)
  103b0e:	e8 31 f9 ff ff       	call   103444 <page_remove>
    assert(page_ref(p1) == 1);
  103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b16:	89 04 24             	mov    %eax,(%esp)
  103b19:	e8 09 f0 ff ff       	call   102b27 <page_ref>
  103b1e:	83 f8 01             	cmp    $0x1,%eax
  103b21:	74 24                	je     103b47 <check_pgdir+0x579>
  103b23:	c7 44 24 0c 13 6a 10 	movl   $0x106a13,0xc(%esp)
  103b2a:	00 
  103b2b:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103b32:	00 
  103b33:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103b3a:	00 
  103b3b:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103b42:	e8 ea c8 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b4a:	89 04 24             	mov    %eax,(%esp)
  103b4d:	e8 d5 ef ff ff       	call   102b27 <page_ref>
  103b52:	85 c0                	test   %eax,%eax
  103b54:	74 24                	je     103b7a <check_pgdir+0x5ac>
  103b56:	c7 44 24 0c 3a 6b 10 	movl   $0x106b3a,0xc(%esp)
  103b5d:	00 
  103b5e:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103b65:	00 
  103b66:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103b6d:	00 
  103b6e:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103b75:	e8 b7 c8 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b7a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b7f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b86:	00 
  103b87:	89 04 24             	mov    %eax,(%esp)
  103b8a:	e8 b5 f8 ff ff       	call   103444 <page_remove>
    assert(page_ref(p1) == 0);
  103b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b92:	89 04 24             	mov    %eax,(%esp)
  103b95:	e8 8d ef ff ff       	call   102b27 <page_ref>
  103b9a:	85 c0                	test   %eax,%eax
  103b9c:	74 24                	je     103bc2 <check_pgdir+0x5f4>
  103b9e:	c7 44 24 0c 61 6b 10 	movl   $0x106b61,0xc(%esp)
  103ba5:	00 
  103ba6:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103bad:	00 
  103bae:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103bb5:	00 
  103bb6:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103bbd:	e8 6f c8 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bc5:	89 04 24             	mov    %eax,(%esp)
  103bc8:	e8 5a ef ff ff       	call   102b27 <page_ref>
  103bcd:	85 c0                	test   %eax,%eax
  103bcf:	74 24                	je     103bf5 <check_pgdir+0x627>
  103bd1:	c7 44 24 0c 3a 6b 10 	movl   $0x106b3a,0xc(%esp)
  103bd8:	00 
  103bd9:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103be0:	00 
  103be1:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103be8:	00 
  103be9:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103bf0:	e8 3c c8 ff ff       	call   100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103bf5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103bfa:	8b 00                	mov    (%eax),%eax
  103bfc:	89 04 24             	mov    %eax,(%esp)
  103bff:	e8 0b ef ff ff       	call   102b0f <pde2page>
  103c04:	89 04 24             	mov    %eax,(%esp)
  103c07:	e8 1b ef ff ff       	call   102b27 <page_ref>
  103c0c:	83 f8 01             	cmp    $0x1,%eax
  103c0f:	74 24                	je     103c35 <check_pgdir+0x667>
  103c11:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  103c18:	00 
  103c19:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103c20:	00 
  103c21:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103c28:	00 
  103c29:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103c30:	e8 fc c7 ff ff       	call   100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103c35:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c3a:	8b 00                	mov    (%eax),%eax
  103c3c:	89 04 24             	mov    %eax,(%esp)
  103c3f:	e8 cb ee ff ff       	call   102b0f <pde2page>
  103c44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c4b:	00 
  103c4c:	89 04 24             	mov    %eax,(%esp)
  103c4f:	e8 17 f1 ff ff       	call   102d6b <free_pages>
    boot_pgdir[0] = 0;
  103c54:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c5f:	c7 04 24 9b 6b 10 00 	movl   $0x106b9b,(%esp)
  103c66:	e8 5a c6 ff ff       	call   1002c5 <cprintf>
}
  103c6b:	90                   	nop
  103c6c:	c9                   	leave  
  103c6d:	c3                   	ret    

00103c6e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c6e:	f3 0f 1e fb          	endbr32 
  103c72:	55                   	push   %ebp
  103c73:	89 e5                	mov    %esp,%ebp
  103c75:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c7f:	e9 ca 00 00 00       	jmp    103d4e <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c8d:	c1 e8 0c             	shr    $0xc,%eax
  103c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c93:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103c98:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103c9b:	72 23                	jb     103cc0 <check_boot_pgdir+0x52>
  103c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ca0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ca4:	c7 44 24 08 e0 67 10 	movl   $0x1067e0,0x8(%esp)
  103cab:	00 
  103cac:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103cb3:	00 
  103cb4:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103cbb:	e8 71 c7 ff ff       	call   100431 <__panic>
  103cc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cc3:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103cc8:	89 c2                	mov    %eax,%edx
  103cca:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ccf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103cd6:	00 
  103cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cdb:	89 04 24             	mov    %eax,(%esp)
  103cde:	e8 f4 f6 ff ff       	call   1033d7 <get_pte>
  103ce3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103ce6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103cea:	75 24                	jne    103d10 <check_boot_pgdir+0xa2>
  103cec:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  103cf3:	00 
  103cf4:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103cfb:	00 
  103cfc:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103d03:	00 
  103d04:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103d0b:	e8 21 c7 ff ff       	call   100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103d13:	8b 00                	mov    (%eax),%eax
  103d15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d1a:	89 c2                	mov    %eax,%edx
  103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d1f:	39 c2                	cmp    %eax,%edx
  103d21:	74 24                	je     103d47 <check_boot_pgdir+0xd9>
  103d23:	c7 44 24 0c f5 6b 10 	movl   $0x106bf5,0xc(%esp)
  103d2a:	00 
  103d2b:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103d32:	00 
  103d33:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103d3a:	00 
  103d3b:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103d42:	e8 ea c6 ff ff       	call   100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103d47:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d51:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103d56:	39 c2                	cmp    %eax,%edx
  103d58:	0f 82 26 ff ff ff    	jb     103c84 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103d5e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d63:	05 ac 0f 00 00       	add    $0xfac,%eax
  103d68:	8b 00                	mov    (%eax),%eax
  103d6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d6f:	89 c2                	mov    %eax,%edx
  103d71:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d79:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103d80:	77 23                	ja     103da5 <check_boot_pgdir+0x137>
  103d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d89:	c7 44 24 08 84 68 10 	movl   $0x106884,0x8(%esp)
  103d90:	00 
  103d91:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103d98:	00 
  103d99:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103da0:	e8 8c c6 ff ff       	call   100431 <__panic>
  103da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103da8:	05 00 00 00 40       	add    $0x40000000,%eax
  103dad:	39 d0                	cmp    %edx,%eax
  103daf:	74 24                	je     103dd5 <check_boot_pgdir+0x167>
  103db1:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  103db8:	00 
  103db9:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103dc0:	00 
  103dc1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103dc8:	00 
  103dc9:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103dd0:	e8 5c c6 ff ff       	call   100431 <__panic>

    assert(boot_pgdir[0] == 0);
  103dd5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103dda:	8b 00                	mov    (%eax),%eax
  103ddc:	85 c0                	test   %eax,%eax
  103dde:	74 24                	je     103e04 <check_boot_pgdir+0x196>
  103de0:	c7 44 24 0c 40 6c 10 	movl   $0x106c40,0xc(%esp)
  103de7:	00 
  103de8:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103def:	00 
  103df0:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103df7:	00 
  103df8:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103dff:	e8 2d c6 ff ff       	call   100431 <__panic>

    struct Page *p;
    p = alloc_page();
  103e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103e0b:	e8 1f ef ff ff       	call   102d2f <alloc_pages>
  103e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103e13:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e18:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e1f:	00 
  103e20:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103e27:	00 
  103e28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103e2b:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e2f:	89 04 24             	mov    %eax,(%esp)
  103e32:	e8 56 f6 ff ff       	call   10348d <page_insert>
  103e37:	85 c0                	test   %eax,%eax
  103e39:	74 24                	je     103e5f <check_boot_pgdir+0x1f1>
  103e3b:	c7 44 24 0c 54 6c 10 	movl   $0x106c54,0xc(%esp)
  103e42:	00 
  103e43:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103e4a:	00 
  103e4b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103e52:	00 
  103e53:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103e5a:	e8 d2 c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 1);
  103e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e62:	89 04 24             	mov    %eax,(%esp)
  103e65:	e8 bd ec ff ff       	call   102b27 <page_ref>
  103e6a:	83 f8 01             	cmp    $0x1,%eax
  103e6d:	74 24                	je     103e93 <check_boot_pgdir+0x225>
  103e6f:	c7 44 24 0c 82 6c 10 	movl   $0x106c82,0xc(%esp)
  103e76:	00 
  103e77:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103e7e:	00 
  103e7f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103e86:	00 
  103e87:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103e8e:	e8 9e c5 ff ff       	call   100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103e93:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e98:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e9f:	00 
  103ea0:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103ea7:	00 
  103ea8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103eab:	89 54 24 04          	mov    %edx,0x4(%esp)
  103eaf:	89 04 24             	mov    %eax,(%esp)
  103eb2:	e8 d6 f5 ff ff       	call   10348d <page_insert>
  103eb7:	85 c0                	test   %eax,%eax
  103eb9:	74 24                	je     103edf <check_boot_pgdir+0x271>
  103ebb:	c7 44 24 0c 94 6c 10 	movl   $0x106c94,0xc(%esp)
  103ec2:	00 
  103ec3:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103eca:	00 
  103ecb:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103ed2:	00 
  103ed3:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103eda:	e8 52 c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 2);
  103edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ee2:	89 04 24             	mov    %eax,(%esp)
  103ee5:	e8 3d ec ff ff       	call   102b27 <page_ref>
  103eea:	83 f8 02             	cmp    $0x2,%eax
  103eed:	74 24                	je     103f13 <check_boot_pgdir+0x2a5>
  103eef:	c7 44 24 0c cb 6c 10 	movl   $0x106ccb,0xc(%esp)
  103ef6:	00 
  103ef7:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103efe:	00 
  103eff:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103f06:	00 
  103f07:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103f0e:	e8 1e c5 ff ff       	call   100431 <__panic>

    const char *str = "ucore: Hello world!!";
  103f13:	c7 45 e8 dc 6c 10 00 	movl   $0x106cdc,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f21:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f28:	e8 32 16 00 00       	call   10555f <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103f2d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103f34:	00 
  103f35:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f3c:	e8 9c 16 00 00       	call   1055dd <strcmp>
  103f41:	85 c0                	test   %eax,%eax
  103f43:	74 24                	je     103f69 <check_boot_pgdir+0x2fb>
  103f45:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  103f4c:	00 
  103f4d:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103f54:	00 
  103f55:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103f5c:	00 
  103f5d:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103f64:	e8 c8 c4 ff ff       	call   100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f6c:	89 04 24             	mov    %eax,(%esp)
  103f6f:	e8 09 eb ff ff       	call   102a7d <page2kva>
  103f74:	05 00 01 00 00       	add    $0x100,%eax
  103f79:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103f7c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f83:	e8 79 15 00 00       	call   105501 <strlen>
  103f88:	85 c0                	test   %eax,%eax
  103f8a:	74 24                	je     103fb0 <check_boot_pgdir+0x342>
  103f8c:	c7 44 24 0c 2c 6d 10 	movl   $0x106d2c,0xc(%esp)
  103f93:	00 
  103f94:	c7 44 24 08 cd 68 10 	movl   $0x1068cd,0x8(%esp)
  103f9b:	00 
  103f9c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103fa3:	00 
  103fa4:	c7 04 24 a8 68 10 00 	movl   $0x1068a8,(%esp)
  103fab:	e8 81 c4 ff ff       	call   100431 <__panic>

    free_page(p);
  103fb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fb7:	00 
  103fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fbb:	89 04 24             	mov    %eax,(%esp)
  103fbe:	e8 a8 ed ff ff       	call   102d6b <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103fc3:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103fc8:	8b 00                	mov    (%eax),%eax
  103fca:	89 04 24             	mov    %eax,(%esp)
  103fcd:	e8 3d eb ff ff       	call   102b0f <pde2page>
  103fd2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fd9:	00 
  103fda:	89 04 24             	mov    %eax,(%esp)
  103fdd:	e8 89 ed ff ff       	call   102d6b <free_pages>
    boot_pgdir[0] = 0;
  103fe2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103fed:	c7 04 24 50 6d 10 00 	movl   $0x106d50,(%esp)
  103ff4:	e8 cc c2 ff ff       	call   1002c5 <cprintf>
}
  103ff9:	90                   	nop
  103ffa:	c9                   	leave  
  103ffb:	c3                   	ret    

00103ffc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103ffc:	f3 0f 1e fb          	endbr32 
  104000:	55                   	push   %ebp
  104001:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104003:	8b 45 08             	mov    0x8(%ebp),%eax
  104006:	83 e0 04             	and    $0x4,%eax
  104009:	85 c0                	test   %eax,%eax
  10400b:	74 04                	je     104011 <perm2str+0x15>
  10400d:	b0 75                	mov    $0x75,%al
  10400f:	eb 02                	jmp    104013 <perm2str+0x17>
  104011:	b0 2d                	mov    $0x2d,%al
  104013:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  104018:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10401f:	8b 45 08             	mov    0x8(%ebp),%eax
  104022:	83 e0 02             	and    $0x2,%eax
  104025:	85 c0                	test   %eax,%eax
  104027:	74 04                	je     10402d <perm2str+0x31>
  104029:	b0 77                	mov    $0x77,%al
  10402b:	eb 02                	jmp    10402f <perm2str+0x33>
  10402d:	b0 2d                	mov    $0x2d,%al
  10402f:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  104034:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  10403b:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  104040:	5d                   	pop    %ebp
  104041:	c3                   	ret    

00104042 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104042:	f3 0f 1e fb          	endbr32 
  104046:	55                   	push   %ebp
  104047:	89 e5                	mov    %esp,%ebp
  104049:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10404c:	8b 45 10             	mov    0x10(%ebp),%eax
  10404f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104052:	72 0d                	jb     104061 <get_pgtable_items+0x1f>
        return 0;
  104054:	b8 00 00 00 00       	mov    $0x0,%eax
  104059:	e9 98 00 00 00       	jmp    1040f6 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10405e:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104061:	8b 45 10             	mov    0x10(%ebp),%eax
  104064:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104067:	73 18                	jae    104081 <get_pgtable_items+0x3f>
  104069:	8b 45 10             	mov    0x10(%ebp),%eax
  10406c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104073:	8b 45 14             	mov    0x14(%ebp),%eax
  104076:	01 d0                	add    %edx,%eax
  104078:	8b 00                	mov    (%eax),%eax
  10407a:	83 e0 01             	and    $0x1,%eax
  10407d:	85 c0                	test   %eax,%eax
  10407f:	74 dd                	je     10405e <get_pgtable_items+0x1c>
    }
    if (start < right) {
  104081:	8b 45 10             	mov    0x10(%ebp),%eax
  104084:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104087:	73 68                	jae    1040f1 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104089:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10408d:	74 08                	je     104097 <get_pgtable_items+0x55>
            *left_store = start;
  10408f:	8b 45 18             	mov    0x18(%ebp),%eax
  104092:	8b 55 10             	mov    0x10(%ebp),%edx
  104095:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104097:	8b 45 10             	mov    0x10(%ebp),%eax
  10409a:	8d 50 01             	lea    0x1(%eax),%edx
  10409d:	89 55 10             	mov    %edx,0x10(%ebp)
  1040a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1040a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1040aa:	01 d0                	add    %edx,%eax
  1040ac:	8b 00                	mov    (%eax),%eax
  1040ae:	83 e0 07             	and    $0x7,%eax
  1040b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1040b4:	eb 03                	jmp    1040b9 <get_pgtable_items+0x77>
            start ++;
  1040b6:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1040b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1040bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040bf:	73 1d                	jae    1040de <get_pgtable_items+0x9c>
  1040c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1040c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1040cb:	8b 45 14             	mov    0x14(%ebp),%eax
  1040ce:	01 d0                	add    %edx,%eax
  1040d0:	8b 00                	mov    (%eax),%eax
  1040d2:	83 e0 07             	and    $0x7,%eax
  1040d5:	89 c2                	mov    %eax,%edx
  1040d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040da:	39 c2                	cmp    %eax,%edx
  1040dc:	74 d8                	je     1040b6 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  1040de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1040e2:	74 08                	je     1040ec <get_pgtable_items+0xaa>
            *right_store = start;
  1040e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1040e7:	8b 55 10             	mov    0x10(%ebp),%edx
  1040ea:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1040ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040ef:	eb 05                	jmp    1040f6 <get_pgtable_items+0xb4>
    }
    return 0;
  1040f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1040f6:	c9                   	leave  
  1040f7:	c3                   	ret    

001040f8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1040f8:	f3 0f 1e fb          	endbr32 
  1040fc:	55                   	push   %ebp
  1040fd:	89 e5                	mov    %esp,%ebp
  1040ff:	57                   	push   %edi
  104100:	56                   	push   %esi
  104101:	53                   	push   %ebx
  104102:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104105:	c7 04 24 70 6d 10 00 	movl   $0x106d70,(%esp)
  10410c:	e8 b4 c1 ff ff       	call   1002c5 <cprintf>
    size_t left, right = 0, perm;
  104111:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104118:	e9 fa 00 00 00       	jmp    104217 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10411d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104120:	89 04 24             	mov    %eax,(%esp)
  104123:	e8 d4 fe ff ff       	call   103ffc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104128:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10412e:	29 d1                	sub    %edx,%ecx
  104130:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104132:	89 d6                	mov    %edx,%esi
  104134:	c1 e6 16             	shl    $0x16,%esi
  104137:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10413a:	89 d3                	mov    %edx,%ebx
  10413c:	c1 e3 16             	shl    $0x16,%ebx
  10413f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104142:	89 d1                	mov    %edx,%ecx
  104144:	c1 e1 16             	shl    $0x16,%ecx
  104147:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10414a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10414d:	29 d7                	sub    %edx,%edi
  10414f:	89 fa                	mov    %edi,%edx
  104151:	89 44 24 14          	mov    %eax,0x14(%esp)
  104155:	89 74 24 10          	mov    %esi,0x10(%esp)
  104159:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10415d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104161:	89 54 24 04          	mov    %edx,0x4(%esp)
  104165:	c7 04 24 a1 6d 10 00 	movl   $0x106da1,(%esp)
  10416c:	e8 54 c1 ff ff       	call   1002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104174:	c1 e0 0a             	shl    $0xa,%eax
  104177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10417a:	eb 54                	jmp    1041d0 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10417c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10417f:	89 04 24             	mov    %eax,(%esp)
  104182:	e8 75 fe ff ff       	call   103ffc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104187:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10418d:	29 d1                	sub    %edx,%ecx
  10418f:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104191:	89 d6                	mov    %edx,%esi
  104193:	c1 e6 0c             	shl    $0xc,%esi
  104196:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104199:	89 d3                	mov    %edx,%ebx
  10419b:	c1 e3 0c             	shl    $0xc,%ebx
  10419e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1041a1:	89 d1                	mov    %edx,%ecx
  1041a3:	c1 e1 0c             	shl    $0xc,%ecx
  1041a6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1041a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1041ac:	29 d7                	sub    %edx,%edi
  1041ae:	89 fa                	mov    %edi,%edx
  1041b0:	89 44 24 14          	mov    %eax,0x14(%esp)
  1041b4:	89 74 24 10          	mov    %esi,0x10(%esp)
  1041b8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1041bc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1041c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041c4:	c7 04 24 c0 6d 10 00 	movl   $0x106dc0,(%esp)
  1041cb:	e8 f5 c0 ff ff       	call   1002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1041d0:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1041d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041db:	89 d3                	mov    %edx,%ebx
  1041dd:	c1 e3 0a             	shl    $0xa,%ebx
  1041e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1041e3:	89 d1                	mov    %edx,%ecx
  1041e5:	c1 e1 0a             	shl    $0xa,%ecx
  1041e8:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1041eb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1041ef:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1041f2:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1041fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1041fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104202:	89 0c 24             	mov    %ecx,(%esp)
  104205:	e8 38 fe ff ff       	call   104042 <get_pgtable_items>
  10420a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10420d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104211:	0f 85 65 ff ff ff    	jne    10417c <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104217:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10421c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10421f:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104222:	89 54 24 14          	mov    %edx,0x14(%esp)
  104226:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104229:	89 54 24 10          	mov    %edx,0x10(%esp)
  10422d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104231:	89 44 24 08          	mov    %eax,0x8(%esp)
  104235:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10423c:	00 
  10423d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104244:	e8 f9 fd ff ff       	call   104042 <get_pgtable_items>
  104249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10424c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104250:	0f 85 c7 fe ff ff    	jne    10411d <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104256:	c7 04 24 e4 6d 10 00 	movl   $0x106de4,(%esp)
  10425d:	e8 63 c0 ff ff       	call   1002c5 <cprintf>
}
  104262:	90                   	nop
  104263:	83 c4 4c             	add    $0x4c,%esp
  104266:	5b                   	pop    %ebx
  104267:	5e                   	pop    %esi
  104268:	5f                   	pop    %edi
  104269:	5d                   	pop    %ebp
  10426a:	c3                   	ret    

0010426b <page2ppn>:
page2ppn(struct Page *page) {
  10426b:	55                   	push   %ebp
  10426c:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10426e:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  104273:	8b 55 08             	mov    0x8(%ebp),%edx
  104276:	29 c2                	sub    %eax,%edx
  104278:	89 d0                	mov    %edx,%eax
  10427a:	c1 f8 02             	sar    $0x2,%eax
  10427d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104283:	5d                   	pop    %ebp
  104284:	c3                   	ret    

00104285 <page2pa>:
page2pa(struct Page *page) {
  104285:	55                   	push   %ebp
  104286:	89 e5                	mov    %esp,%ebp
  104288:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10428b:	8b 45 08             	mov    0x8(%ebp),%eax
  10428e:	89 04 24             	mov    %eax,(%esp)
  104291:	e8 d5 ff ff ff       	call   10426b <page2ppn>
  104296:	c1 e0 0c             	shl    $0xc,%eax
}
  104299:	c9                   	leave  
  10429a:	c3                   	ret    

0010429b <page_ref>:
page_ref(struct Page *page) {
  10429b:	55                   	push   %ebp
  10429c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10429e:	8b 45 08             	mov    0x8(%ebp),%eax
  1042a1:	8b 00                	mov    (%eax),%eax
}
  1042a3:	5d                   	pop    %ebp
  1042a4:	c3                   	ret    

001042a5 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1042a5:	55                   	push   %ebp
  1042a6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1042a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042ae:	89 10                	mov    %edx,(%eax)
}
  1042b0:	90                   	nop
  1042b1:	5d                   	pop    %ebp
  1042b2:	c3                   	ret    

001042b3 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1042b3:	f3 0f 1e fb          	endbr32 
  1042b7:	55                   	push   %ebp
  1042b8:	89 e5                	mov    %esp,%ebp
  1042ba:	83 ec 10             	sub    $0x10,%esp
  1042bd:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1042c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1042ca:	89 50 04             	mov    %edx,0x4(%eax)
  1042cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042d0:	8b 50 04             	mov    0x4(%eax),%edx
  1042d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042d6:	89 10                	mov    %edx,(%eax)
}
  1042d8:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1042d9:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  1042e0:	00 00 00 
}
  1042e3:	90                   	nop
  1042e4:	c9                   	leave  
  1042e5:	c3                   	ret    

001042e6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1042e6:	f3 0f 1e fb          	endbr32 
  1042ea:	55                   	push   %ebp
  1042eb:	89 e5                	mov    %esp,%ebp
  1042ed:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1042f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1042f4:	75 24                	jne    10431a <default_init_memmap+0x34>
  1042f6:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  1042fd:	00 
  1042fe:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104305:	00 
  104306:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  10430d:	00 
  10430e:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104315:	e8 17 c1 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  10431a:	8b 45 08             	mov    0x8(%ebp),%eax
  10431d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104320:	eb 7d                	jmp    10439f <default_init_memmap+0xb9>
        assert(PageReserved(p));
  104322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104325:	83 c0 04             	add    $0x4,%eax
  104328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10432f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104335:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104338:	0f a3 10             	bt     %edx,(%eax)
  10433b:	19 c0                	sbb    %eax,%eax
  10433d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104340:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104344:	0f 95 c0             	setne  %al
  104347:	0f b6 c0             	movzbl %al,%eax
  10434a:	85 c0                	test   %eax,%eax
  10434c:	75 24                	jne    104372 <default_init_memmap+0x8c>
  10434e:	c7 44 24 0c 49 6e 10 	movl   $0x106e49,0xc(%esp)
  104355:	00 
  104356:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10435d:	00 
  10435e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  104365:	00 
  104366:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10436d:	e8 bf c0 ff ff       	call   100431 <__panic>
        p->flags = p->property = 0;
  104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437f:	8b 50 08             	mov    0x8(%eax),%edx
  104382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104385:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104388:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10438f:	00 
  104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104393:	89 04 24             	mov    %eax,(%esp)
  104396:	e8 0a ff ff ff       	call   1042a5 <set_page_ref>
    for (; p != base + n; p ++) {
  10439b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10439f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043a2:	89 d0                	mov    %edx,%eax
  1043a4:	c1 e0 02             	shl    $0x2,%eax
  1043a7:	01 d0                	add    %edx,%eax
  1043a9:	c1 e0 02             	shl    $0x2,%eax
  1043ac:	89 c2                	mov    %eax,%edx
  1043ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b1:	01 d0                	add    %edx,%eax
  1043b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1043b6:	0f 85 66 ff ff ff    	jne    104322 <default_init_memmap+0x3c>
    }
    base->property = n;
  1043bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1043bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043c2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1043c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1043c8:	83 c0 04             	add    $0x4,%eax
  1043cb:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  1043d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1043d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1043db:	0f ab 10             	bts    %edx,(%eax)
}
  1043de:	90                   	nop
    nr_free += n;
  1043df:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  1043e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043e8:	01 d0                	add    %edx,%eax
  1043ea:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    list_add(&free_list, &(base->page_link));
  1043ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1043f2:	83 c0 0c             	add    $0xc,%eax
  1043f5:	c7 45 e4 1c cf 11 00 	movl   $0x11cf1c,-0x1c(%ebp)
  1043fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1043ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104402:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104408:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10440b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10440e:	8b 40 04             	mov    0x4(%eax),%eax
  104411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104414:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104417:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10441a:	89 55 d0             	mov    %edx,-0x30(%ebp)
  10441d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104420:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104423:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104426:	89 10                	mov    %edx,(%eax)
  104428:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10442b:	8b 10                	mov    (%eax),%edx
  10442d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104430:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104433:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104436:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104439:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10443c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10443f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104442:	89 10                	mov    %edx,(%eax)
}
  104444:	90                   	nop
}
  104445:	90                   	nop
}
  104446:	90                   	nop
}
  104447:	90                   	nop
  104448:	c9                   	leave  
  104449:	c3                   	ret    

0010444a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10444a:	f3 0f 1e fb          	endbr32 
  10444e:	55                   	push   %ebp
  10444f:	89 e5                	mov    %esp,%ebp
  104451:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104458:	75 24                	jne    10447e <default_alloc_pages+0x34>
  10445a:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104461:	00 
  104462:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104469:	00 
  10446a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104471:	00 
  104472:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104479:	e8 b3 bf ff ff       	call   100431 <__panic>
    if (n > nr_free) {
  10447e:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104483:	39 45 08             	cmp    %eax,0x8(%ebp)
  104486:	76 0a                	jbe    104492 <default_alloc_pages+0x48>
        return NULL;
  104488:	b8 00 00 00 00       	mov    $0x0,%eax
  10448d:	e9 4e 01 00 00       	jmp    1045e0 <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
  104492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104499:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1044a0:	eb 1c                	jmp    1044be <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  1044a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044a5:	83 e8 0c             	sub    $0xc,%eax
  1044a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1044ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044ae:	8b 40 08             	mov    0x8(%eax),%eax
  1044b1:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044b4:	77 08                	ja     1044be <default_alloc_pages+0x74>
            page = p;
  1044b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            //SetPageReserved(page);
            break;
  1044bc:	eb 18                	jmp    1044d6 <default_alloc_pages+0x8c>
  1044be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1044c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044c7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1044ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044cd:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1044d4:	75 cc                	jne    1044a2 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  1044d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044da:	0f 84 fd 00 00 00    	je     1045dd <default_alloc_pages+0x193>
        //list_del(&(page->page_link));
        if (page->property > n) {
  1044e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e3:	8b 40 08             	mov    0x8(%eax),%eax
  1044e6:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044e9:	0f 83 9a 00 00 00    	jae    104589 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
  1044ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1044f2:	89 d0                	mov    %edx,%eax
  1044f4:	c1 e0 02             	shl    $0x2,%eax
  1044f7:	01 d0                	add    %edx,%eax
  1044f9:	c1 e0 02             	shl    $0x2,%eax
  1044fc:	89 c2                	mov    %eax,%edx
  1044fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104501:	01 d0                	add    %edx,%eax
  104503:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104509:	8b 40 08             	mov    0x8(%eax),%eax
  10450c:	2b 45 08             	sub    0x8(%ebp),%eax
  10450f:	89 c2                	mov    %eax,%edx
  104511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104514:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10451a:	83 c0 04             	add    $0x4,%eax
  10451d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104524:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104527:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10452a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10452d:	0f ab 10             	bts    %edx,(%eax)
}
  104530:	90                   	nop
            //ClearPageReserved(p);
            list_add(&free_list, &(p->page_link));
  104531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104534:	83 c0 0c             	add    $0xc,%eax
  104537:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
  10453e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104544:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10454a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  10454d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104550:	8b 40 04             	mov    0x4(%eax),%eax
  104553:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104556:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104559:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10455c:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10455f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  104562:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104565:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104568:	89 10                	mov    %edx,(%eax)
  10456a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10456d:	8b 10                	mov    (%eax),%edx
  10456f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104572:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104575:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104578:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10457b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10457e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104581:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104584:	89 10                	mov    %edx,(%eax)
}
  104586:	90                   	nop
}
  104587:	90                   	nop
}
  104588:	90                   	nop
    }
        list_del(&(page->page_link));
  104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10458c:	83 c0 0c             	add    $0xc,%eax
  10458f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104592:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104595:	8b 40 04             	mov    0x4(%eax),%eax
  104598:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10459b:	8b 12                	mov    (%edx),%edx
  10459d:	89 55 b0             	mov    %edx,-0x50(%ebp)
  1045a0:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1045a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1045a6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1045a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1045ac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1045af:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1045b2:	89 10                	mov    %edx,(%eax)
}
  1045b4:	90                   	nop
}
  1045b5:	90                   	nop
        nr_free -= n;
  1045b6:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1045bb:	2b 45 08             	sub    0x8(%ebp),%eax
  1045be:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  1045c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c6:	83 c0 04             	add    $0x4,%eax
  1045c9:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  1045d0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1045d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1045d6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1045d9:	0f b3 10             	btr    %edx,(%eax)
}
  1045dc:	90                   	nop
    }
    return page;
  1045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1045e0:	c9                   	leave  
  1045e1:	c3                   	ret    

001045e2 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1045e2:	f3 0f 1e fb          	endbr32 
  1045e6:	55                   	push   %ebp
  1045e7:	89 e5                	mov    %esp,%ebp
  1045e9:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1045ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1045f3:	75 24                	jne    104619 <default_free_pages+0x37>
  1045f5:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  1045fc:	00 
  1045fd:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104604:	00 
  104605:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  10460c:	00 
  10460d:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104614:	e8 18 be ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104619:	8b 45 08             	mov    0x8(%ebp),%eax
  10461c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10461f:	e9 9d 00 00 00       	jmp    1046c1 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104627:	83 c0 04             	add    $0x4,%eax
  10462a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104631:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104637:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10463a:	0f a3 10             	bt     %edx,(%eax)
  10463d:	19 c0                	sbb    %eax,%eax
  10463f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104646:	0f 95 c0             	setne  %al
  104649:	0f b6 c0             	movzbl %al,%eax
  10464c:	85 c0                	test   %eax,%eax
  10464e:	75 2c                	jne    10467c <default_free_pages+0x9a>
  104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104653:	83 c0 04             	add    $0x4,%eax
  104656:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10465d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104660:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104663:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104666:	0f a3 10             	bt     %edx,(%eax)
  104669:	19 c0                	sbb    %eax,%eax
  10466b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10466e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104672:	0f 95 c0             	setne  %al
  104675:	0f b6 c0             	movzbl %al,%eax
  104678:	85 c0                	test   %eax,%eax
  10467a:	74 24                	je     1046a0 <default_free_pages+0xbe>
  10467c:	c7 44 24 0c 5c 6e 10 	movl   $0x106e5c,0xc(%esp)
  104683:	00 
  104684:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10468b:	00 
  10468c:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  104693:	00 
  104694:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10469b:	e8 91 bd ff ff       	call   100431 <__panic>
        p->flags = 0;
  1046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1046aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046b1:	00 
  1046b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b5:	89 04 24             	mov    %eax,(%esp)
  1046b8:	e8 e8 fb ff ff       	call   1042a5 <set_page_ref>
    for (; p != base + n; p ++) {
  1046bd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1046c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046c4:	89 d0                	mov    %edx,%eax
  1046c6:	c1 e0 02             	shl    $0x2,%eax
  1046c9:	01 d0                	add    %edx,%eax
  1046cb:	c1 e0 02             	shl    $0x2,%eax
  1046ce:	89 c2                	mov    %eax,%edx
  1046d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1046d3:	01 d0                	add    %edx,%eax
  1046d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1046d8:	0f 85 46 ff ff ff    	jne    104624 <default_free_pages+0x42>
    }
    base->property = n;
  1046de:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046e4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1046e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ea:	83 c0 04             	add    $0x4,%eax
  1046ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1046f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1046fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1046fd:	0f ab 10             	bts    %edx,(%eax)
}
  104700:	90                   	nop
  104701:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
    return listelm->next;
  104708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10470b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  10470e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104711:	e9 0e 01 00 00       	jmp    104824 <default_free_pages+0x242>
        p = le2page(le, page_link);
  104716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104719:	83 e8 0c             	sub    $0xc,%eax
  10471c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104722:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104725:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104728:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  10472b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  10472e:	8b 45 08             	mov    0x8(%ebp),%eax
  104731:	8b 50 08             	mov    0x8(%eax),%edx
  104734:	89 d0                	mov    %edx,%eax
  104736:	c1 e0 02             	shl    $0x2,%eax
  104739:	01 d0                	add    %edx,%eax
  10473b:	c1 e0 02             	shl    $0x2,%eax
  10473e:	89 c2                	mov    %eax,%edx
  104740:	8b 45 08             	mov    0x8(%ebp),%eax
  104743:	01 d0                	add    %edx,%eax
  104745:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104748:	75 5d                	jne    1047a7 <default_free_pages+0x1c5>
            base->property += p->property;
  10474a:	8b 45 08             	mov    0x8(%ebp),%eax
  10474d:	8b 50 08             	mov    0x8(%eax),%edx
  104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104753:	8b 40 08             	mov    0x8(%eax),%eax
  104756:	01 c2                	add    %eax,%edx
  104758:	8b 45 08             	mov    0x8(%ebp),%eax
  10475b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104761:	83 c0 04             	add    $0x4,%eax
  104764:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10476b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10476e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104771:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104774:	0f b3 10             	btr    %edx,(%eax)
}
  104777:	90                   	nop
            list_del(&(p->page_link));
  104778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10477b:	83 c0 0c             	add    $0xc,%eax
  10477e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104781:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104784:	8b 40 04             	mov    0x4(%eax),%eax
  104787:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10478a:	8b 12                	mov    (%edx),%edx
  10478c:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10478f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104792:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104795:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104798:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10479b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10479e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1047a1:	89 10                	mov    %edx,(%eax)
}
  1047a3:	90                   	nop
}
  1047a4:	90                   	nop
  1047a5:	eb 7d                	jmp    104824 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  1047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047aa:	8b 50 08             	mov    0x8(%eax),%edx
  1047ad:	89 d0                	mov    %edx,%eax
  1047af:	c1 e0 02             	shl    $0x2,%eax
  1047b2:	01 d0                	add    %edx,%eax
  1047b4:	c1 e0 02             	shl    $0x2,%eax
  1047b7:	89 c2                	mov    %eax,%edx
  1047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bc:	01 d0                	add    %edx,%eax
  1047be:	39 45 08             	cmp    %eax,0x8(%ebp)
  1047c1:	75 61                	jne    104824 <default_free_pages+0x242>
            p->property += base->property;
  1047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c6:	8b 50 08             	mov    0x8(%eax),%edx
  1047c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1047cc:	8b 40 08             	mov    0x8(%eax),%eax
  1047cf:	01 c2                	add    %eax,%edx
  1047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d4:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1047d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1047da:	83 c0 04             	add    $0x4,%eax
  1047dd:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1047e4:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1047e7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1047ea:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1047ed:	0f b3 10             	btr    %edx,(%eax)
}
  1047f0:	90                   	nop
            base = p;
  1047f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f4:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047fa:	83 c0 0c             	add    $0xc,%eax
  1047fd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104800:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104803:	8b 40 04             	mov    0x4(%eax),%eax
  104806:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104809:	8b 12                	mov    (%edx),%edx
  10480b:	89 55 ac             	mov    %edx,-0x54(%ebp)
  10480e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104811:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104814:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104817:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10481a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10481d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104820:	89 10                	mov    %edx,(%eax)
}
  104822:	90                   	nop
}
  104823:	90                   	nop
    while (le != &free_list) {
  104824:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  10482b:	0f 85 e5 fe ff ff    	jne    104716 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  104831:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104837:	8b 45 0c             	mov    0xc(%ebp),%eax
  10483a:	01 d0                	add    %edx,%eax
  10483c:	a3 24 cf 11 00       	mov    %eax,0x11cf24
  104841:	c7 45 9c 1c cf 11 00 	movl   $0x11cf1c,-0x64(%ebp)
    return listelm->next;
  104848:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10484b:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  10484e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104851:	eb 74                	jmp    1048c7 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  104853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104856:	83 e8 0c             	sub    $0xc,%eax
  104859:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  10485c:	8b 45 08             	mov    0x8(%ebp),%eax
  10485f:	8b 50 08             	mov    0x8(%eax),%edx
  104862:	89 d0                	mov    %edx,%eax
  104864:	c1 e0 02             	shl    $0x2,%eax
  104867:	01 d0                	add    %edx,%eax
  104869:	c1 e0 02             	shl    $0x2,%eax
  10486c:	89 c2                	mov    %eax,%edx
  10486e:	8b 45 08             	mov    0x8(%ebp),%eax
  104871:	01 d0                	add    %edx,%eax
  104873:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104876:	72 40                	jb     1048b8 <default_free_pages+0x2d6>
            assert(base + base->property != p);
  104878:	8b 45 08             	mov    0x8(%ebp),%eax
  10487b:	8b 50 08             	mov    0x8(%eax),%edx
  10487e:	89 d0                	mov    %edx,%eax
  104880:	c1 e0 02             	shl    $0x2,%eax
  104883:	01 d0                	add    %edx,%eax
  104885:	c1 e0 02             	shl    $0x2,%eax
  104888:	89 c2                	mov    %eax,%edx
  10488a:	8b 45 08             	mov    0x8(%ebp),%eax
  10488d:	01 d0                	add    %edx,%eax
  10488f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104892:	75 3e                	jne    1048d2 <default_free_pages+0x2f0>
  104894:	c7 44 24 0c 81 6e 10 	movl   $0x106e81,0xc(%esp)
  10489b:	00 
  10489c:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1048a3:	00 
  1048a4:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  1048ab:	00 
  1048ac:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1048b3:	e8 79 bb ff ff       	call   100431 <__panic>
  1048b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048bb:	89 45 98             	mov    %eax,-0x68(%ebp)
  1048be:	8b 45 98             	mov    -0x68(%ebp),%eax
  1048c1:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  1048c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1048c7:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1048ce:	75 83                	jne    104853 <default_free_pages+0x271>
  1048d0:	eb 01                	jmp    1048d3 <default_free_pages+0x2f1>
            break;
  1048d2:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  1048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d6:	8d 50 0c             	lea    0xc(%eax),%edx
  1048d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048dc:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1048df:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1048e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1048e5:	8b 00                	mov    (%eax),%eax
  1048e7:	8b 55 90             	mov    -0x70(%ebp),%edx
  1048ea:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1048ed:	89 45 88             	mov    %eax,-0x78(%ebp)
  1048f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1048f3:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  1048f6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1048f9:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1048fc:	89 10                	mov    %edx,(%eax)
  1048fe:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104901:	8b 10                	mov    (%eax),%edx
  104903:	8b 45 88             	mov    -0x78(%ebp),%eax
  104906:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104909:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10490c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10490f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104912:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104915:	8b 55 88             	mov    -0x78(%ebp),%edx
  104918:	89 10                	mov    %edx,(%eax)
}
  10491a:	90                   	nop
}
  10491b:	90                   	nop
}
  10491c:	90                   	nop
  10491d:	c9                   	leave  
  10491e:	c3                   	ret    

0010491f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10491f:	f3 0f 1e fb          	endbr32 
  104923:	55                   	push   %ebp
  104924:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104926:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  10492b:	5d                   	pop    %ebp
  10492c:	c3                   	ret    

0010492d <basic_check>:

static void
basic_check(void) {
  10492d:	f3 0f 1e fb          	endbr32 
  104931:	55                   	push   %ebp
  104932:	89 e5                	mov    %esp,%ebp
  104934:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104937:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10493e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104941:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104947:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10494a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104951:	e8 d9 e3 ff ff       	call   102d2f <alloc_pages>
  104956:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10495d:	75 24                	jne    104983 <basic_check+0x56>
  10495f:	c7 44 24 0c 9c 6e 10 	movl   $0x106e9c,0xc(%esp)
  104966:	00 
  104967:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10496e:	00 
  10496f:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104976:	00 
  104977:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10497e:	e8 ae ba ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104983:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10498a:	e8 a0 e3 ff ff       	call   102d2f <alloc_pages>
  10498f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104996:	75 24                	jne    1049bc <basic_check+0x8f>
  104998:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  10499f:	00 
  1049a0:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1049a7:	00 
  1049a8:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1049af:	00 
  1049b0:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1049b7:	e8 75 ba ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1049bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049c3:	e8 67 e3 ff ff       	call   102d2f <alloc_pages>
  1049c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1049cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1049cf:	75 24                	jne    1049f5 <basic_check+0xc8>
  1049d1:	c7 44 24 0c d4 6e 10 	movl   $0x106ed4,0xc(%esp)
  1049d8:	00 
  1049d9:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1049e0:	00 
  1049e1:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1049e8:	00 
  1049e9:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1049f0:	e8 3c ba ff ff       	call   100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1049f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049fb:	74 10                	je     104a0d <basic_check+0xe0>
  1049fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a03:	74 08                	je     104a0d <basic_check+0xe0>
  104a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a0b:	75 24                	jne    104a31 <basic_check+0x104>
  104a0d:	c7 44 24 0c f0 6e 10 	movl   $0x106ef0,0xc(%esp)
  104a14:	00 
  104a15:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104a24:	00 
  104a25:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104a2c:	e8 00 ba ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a34:	89 04 24             	mov    %eax,(%esp)
  104a37:	e8 5f f8 ff ff       	call   10429b <page_ref>
  104a3c:	85 c0                	test   %eax,%eax
  104a3e:	75 1e                	jne    104a5e <basic_check+0x131>
  104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a43:	89 04 24             	mov    %eax,(%esp)
  104a46:	e8 50 f8 ff ff       	call   10429b <page_ref>
  104a4b:	85 c0                	test   %eax,%eax
  104a4d:	75 0f                	jne    104a5e <basic_check+0x131>
  104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a52:	89 04 24             	mov    %eax,(%esp)
  104a55:	e8 41 f8 ff ff       	call   10429b <page_ref>
  104a5a:	85 c0                	test   %eax,%eax
  104a5c:	74 24                	je     104a82 <basic_check+0x155>
  104a5e:	c7 44 24 0c 14 6f 10 	movl   $0x106f14,0xc(%esp)
  104a65:	00 
  104a66:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104a6d:	00 
  104a6e:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104a75:	00 
  104a76:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104a7d:	e8 af b9 ff ff       	call   100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a85:	89 04 24             	mov    %eax,(%esp)
  104a88:	e8 f8 f7 ff ff       	call   104285 <page2pa>
  104a8d:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104a93:	c1 e2 0c             	shl    $0xc,%edx
  104a96:	39 d0                	cmp    %edx,%eax
  104a98:	72 24                	jb     104abe <basic_check+0x191>
  104a9a:	c7 44 24 0c 50 6f 10 	movl   $0x106f50,0xc(%esp)
  104aa1:	00 
  104aa2:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104aa9:	00 
  104aaa:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  104ab1:	00 
  104ab2:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104ab9:	e8 73 b9 ff ff       	call   100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac1:	89 04 24             	mov    %eax,(%esp)
  104ac4:	e8 bc f7 ff ff       	call   104285 <page2pa>
  104ac9:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104acf:	c1 e2 0c             	shl    $0xc,%edx
  104ad2:	39 d0                	cmp    %edx,%eax
  104ad4:	72 24                	jb     104afa <basic_check+0x1cd>
  104ad6:	c7 44 24 0c 6d 6f 10 	movl   $0x106f6d,0xc(%esp)
  104add:	00 
  104ade:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104ae5:	00 
  104ae6:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  104aed:	00 
  104aee:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104af5:	e8 37 b9 ff ff       	call   100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104afd:	89 04 24             	mov    %eax,(%esp)
  104b00:	e8 80 f7 ff ff       	call   104285 <page2pa>
  104b05:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b0b:	c1 e2 0c             	shl    $0xc,%edx
  104b0e:	39 d0                	cmp    %edx,%eax
  104b10:	72 24                	jb     104b36 <basic_check+0x209>
  104b12:	c7 44 24 0c 8a 6f 10 	movl   $0x106f8a,0xc(%esp)
  104b19:	00 
  104b1a:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104b21:	00 
  104b22:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  104b29:	00 
  104b2a:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104b31:	e8 fb b8 ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  104b36:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104b3b:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104b41:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104b44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104b47:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104b4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104b54:	89 50 04             	mov    %edx,0x4(%eax)
  104b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b5a:	8b 50 04             	mov    0x4(%eax),%edx
  104b5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b60:	89 10                	mov    %edx,(%eax)
}
  104b62:	90                   	nop
  104b63:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104b6d:	8b 40 04             	mov    0x4(%eax),%eax
  104b70:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104b73:	0f 94 c0             	sete   %al
  104b76:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104b79:	85 c0                	test   %eax,%eax
  104b7b:	75 24                	jne    104ba1 <basic_check+0x274>
  104b7d:	c7 44 24 0c a7 6f 10 	movl   $0x106fa7,0xc(%esp)
  104b84:	00 
  104b85:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104b8c:	00 
  104b8d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  104b94:	00 
  104b95:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104b9c:	e8 90 b8 ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  104ba1:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104ba9:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104bb0:	00 00 00 

    assert(alloc_page() == NULL);
  104bb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bba:	e8 70 e1 ff ff       	call   102d2f <alloc_pages>
  104bbf:	85 c0                	test   %eax,%eax
  104bc1:	74 24                	je     104be7 <basic_check+0x2ba>
  104bc3:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  104bca:	00 
  104bcb:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104bd2:	00 
  104bd3:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  104bda:	00 
  104bdb:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104be2:	e8 4a b8 ff ff       	call   100431 <__panic>

    free_page(p0);
  104be7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104bee:	00 
  104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bf2:	89 04 24             	mov    %eax,(%esp)
  104bf5:	e8 71 e1 ff ff       	call   102d6b <free_pages>
    free_page(p1);
  104bfa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c01:	00 
  104c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c05:	89 04 24             	mov    %eax,(%esp)
  104c08:	e8 5e e1 ff ff       	call   102d6b <free_pages>
    free_page(p2);
  104c0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c14:	00 
  104c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c18:	89 04 24             	mov    %eax,(%esp)
  104c1b:	e8 4b e1 ff ff       	call   102d6b <free_pages>
    assert(nr_free == 3);
  104c20:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104c25:	83 f8 03             	cmp    $0x3,%eax
  104c28:	74 24                	je     104c4e <basic_check+0x321>
  104c2a:	c7 44 24 0c d3 6f 10 	movl   $0x106fd3,0xc(%esp)
  104c31:	00 
  104c32:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104c39:	00 
  104c3a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104c41:	00 
  104c42:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104c49:	e8 e3 b7 ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104c4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c55:	e8 d5 e0 ff ff       	call   102d2f <alloc_pages>
  104c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104c61:	75 24                	jne    104c87 <basic_check+0x35a>
  104c63:	c7 44 24 0c 9c 6e 10 	movl   $0x106e9c,0xc(%esp)
  104c6a:	00 
  104c6b:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104c72:	00 
  104c73:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104c7a:	00 
  104c7b:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104c82:	e8 aa b7 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c8e:	e8 9c e0 ff ff       	call   102d2f <alloc_pages>
  104c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c9a:	75 24                	jne    104cc0 <basic_check+0x393>
  104c9c:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  104ca3:	00 
  104ca4:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104cab:	00 
  104cac:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104cb3:	00 
  104cb4:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104cbb:	e8 71 b7 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104cc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cc7:	e8 63 e0 ff ff       	call   102d2f <alloc_pages>
  104ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104cd3:	75 24                	jne    104cf9 <basic_check+0x3cc>
  104cd5:	c7 44 24 0c d4 6e 10 	movl   $0x106ed4,0xc(%esp)
  104cdc:	00 
  104cdd:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104ce4:	00 
  104ce5:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  104cec:	00 
  104ced:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104cf4:	e8 38 b7 ff ff       	call   100431 <__panic>

    assert(alloc_page() == NULL);
  104cf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d00:	e8 2a e0 ff ff       	call   102d2f <alloc_pages>
  104d05:	85 c0                	test   %eax,%eax
  104d07:	74 24                	je     104d2d <basic_check+0x400>
  104d09:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  104d10:	00 
  104d11:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104d18:	00 
  104d19:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  104d20:	00 
  104d21:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104d28:	e8 04 b7 ff ff       	call   100431 <__panic>

    free_page(p0);
  104d2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d34:	00 
  104d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d38:	89 04 24             	mov    %eax,(%esp)
  104d3b:	e8 2b e0 ff ff       	call   102d6b <free_pages>
  104d40:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104d47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104d4a:	8b 40 04             	mov    0x4(%eax),%eax
  104d4d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104d50:	0f 94 c0             	sete   %al
  104d53:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104d56:	85 c0                	test   %eax,%eax
  104d58:	74 24                	je     104d7e <basic_check+0x451>
  104d5a:	c7 44 24 0c e0 6f 10 	movl   $0x106fe0,0xc(%esp)
  104d61:	00 
  104d62:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104d69:	00 
  104d6a:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104d71:	00 
  104d72:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104d79:	e8 b3 b6 ff ff       	call   100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104d7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d85:	e8 a5 df ff ff       	call   102d2f <alloc_pages>
  104d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104d93:	74 24                	je     104db9 <basic_check+0x48c>
  104d95:	c7 44 24 0c f8 6f 10 	movl   $0x106ff8,0xc(%esp)
  104d9c:	00 
  104d9d:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104da4:	00 
  104da5:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104dac:	00 
  104dad:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104db4:	e8 78 b6 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  104db9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dc0:	e8 6a df ff ff       	call   102d2f <alloc_pages>
  104dc5:	85 c0                	test   %eax,%eax
  104dc7:	74 24                	je     104ded <basic_check+0x4c0>
  104dc9:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  104dd0:	00 
  104dd1:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104dd8:	00 
  104dd9:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  104de0:	00 
  104de1:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104de8:	e8 44 b6 ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  104ded:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104df2:	85 c0                	test   %eax,%eax
  104df4:	74 24                	je     104e1a <basic_check+0x4ed>
  104df6:	c7 44 24 0c 11 70 10 	movl   $0x107011,0xc(%esp)
  104dfd:	00 
  104dfe:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104e05:	00 
  104e06:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  104e0d:	00 
  104e0e:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104e15:	e8 17 b6 ff ff       	call   100431 <__panic>
    free_list = free_list_store;
  104e1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104e1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104e20:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104e25:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e2e:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104e33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e3a:	00 
  104e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e3e:	89 04 24             	mov    %eax,(%esp)
  104e41:	e8 25 df ff ff       	call   102d6b <free_pages>
    free_page(p1);
  104e46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e4d:	00 
  104e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e51:	89 04 24             	mov    %eax,(%esp)
  104e54:	e8 12 df ff ff       	call   102d6b <free_pages>
    free_page(p2);
  104e59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e60:	00 
  104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e64:	89 04 24             	mov    %eax,(%esp)
  104e67:	e8 ff de ff ff       	call   102d6b <free_pages>
}
  104e6c:	90                   	nop
  104e6d:	c9                   	leave  
  104e6e:	c3                   	ret    

00104e6f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104e6f:	f3 0f 1e fb          	endbr32 
  104e73:	55                   	push   %ebp
  104e74:	89 e5                	mov    %esp,%ebp
  104e76:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104e8a:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104e91:	eb 6a                	jmp    104efd <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  104e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e96:	83 e8 0c             	sub    $0xc,%eax
  104e99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104e9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e9f:	83 c0 04             	add    $0x4,%eax
  104ea2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104ea9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104eac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104eaf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104eb2:	0f a3 10             	bt     %edx,(%eax)
  104eb5:	19 c0                	sbb    %eax,%eax
  104eb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104eba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104ebe:	0f 95 c0             	setne  %al
  104ec1:	0f b6 c0             	movzbl %al,%eax
  104ec4:	85 c0                	test   %eax,%eax
  104ec6:	75 24                	jne    104eec <default_check+0x7d>
  104ec8:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104ecf:	00 
  104ed0:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104ed7:	00 
  104ed8:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104edf:	00 
  104ee0:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104ee7:	e8 45 b5 ff ff       	call   100431 <__panic>
        count ++, total += p->property;
  104eec:	ff 45 f4             	incl   -0xc(%ebp)
  104eef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104ef2:	8b 50 08             	mov    0x8(%eax),%edx
  104ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef8:	01 d0                	add    %edx,%eax
  104efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104f03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f06:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f0c:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  104f13:	0f 85 7a ff ff ff    	jne    104e93 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  104f19:	e8 84 de ff ff       	call   102da2 <nr_free_pages>
  104f1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104f21:	39 d0                	cmp    %edx,%eax
  104f23:	74 24                	je     104f49 <default_check+0xda>
  104f25:	c7 44 24 0c 2e 70 10 	movl   $0x10702e,0xc(%esp)
  104f2c:	00 
  104f2d:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104f34:	00 
  104f35:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  104f3c:	00 
  104f3d:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104f44:	e8 e8 b4 ff ff       	call   100431 <__panic>

    basic_check();
  104f49:	e8 df f9 ff ff       	call   10492d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104f4e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104f55:	e8 d5 dd ff ff       	call   102d2f <alloc_pages>
  104f5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  104f5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f61:	75 24                	jne    104f87 <default_check+0x118>
  104f63:	c7 44 24 0c 47 70 10 	movl   $0x107047,0xc(%esp)
  104f6a:	00 
  104f6b:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104f72:	00 
  104f73:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104f7a:	00 
  104f7b:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104f82:	e8 aa b4 ff ff       	call   100431 <__panic>
    assert(!PageProperty(p0));
  104f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f8a:	83 c0 04             	add    $0x4,%eax
  104f8d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104f94:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f97:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104f9a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104f9d:	0f a3 10             	bt     %edx,(%eax)
  104fa0:	19 c0                	sbb    %eax,%eax
  104fa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104fa5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104fa9:	0f 95 c0             	setne  %al
  104fac:	0f b6 c0             	movzbl %al,%eax
  104faf:	85 c0                	test   %eax,%eax
  104fb1:	74 24                	je     104fd7 <default_check+0x168>
  104fb3:	c7 44 24 0c 52 70 10 	movl   $0x107052,0xc(%esp)
  104fba:	00 
  104fbb:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  104fc2:	00 
  104fc3:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  104fca:	00 
  104fcb:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  104fd2:	e8 5a b4 ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  104fd7:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104fdc:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104fe2:	89 45 80             	mov    %eax,-0x80(%ebp)
  104fe5:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104fe8:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104fef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104ff2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104ff5:	89 50 04             	mov    %edx,0x4(%eax)
  104ff8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104ffb:	8b 50 04             	mov    0x4(%eax),%edx
  104ffe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105001:	89 10                	mov    %edx,(%eax)
}
  105003:	90                   	nop
  105004:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  10500b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10500e:	8b 40 04             	mov    0x4(%eax),%eax
  105011:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105014:	0f 94 c0             	sete   %al
  105017:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10501a:	85 c0                	test   %eax,%eax
  10501c:	75 24                	jne    105042 <default_check+0x1d3>
  10501e:	c7 44 24 0c a7 6f 10 	movl   $0x106fa7,0xc(%esp)
  105025:	00 
  105026:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10502d:	00 
  10502e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  105035:	00 
  105036:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10503d:	e8 ef b3 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105049:	e8 e1 dc ff ff       	call   102d2f <alloc_pages>
  10504e:	85 c0                	test   %eax,%eax
  105050:	74 24                	je     105076 <default_check+0x207>
  105052:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  105059:	00 
  10505a:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  105061:	00 
  105062:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  105069:	00 
  10506a:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  105071:	e8 bb b3 ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  105076:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  10507b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10507e:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  105085:	00 00 00 

    free_pages(p0 + 2, 3);
  105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10508b:	83 c0 28             	add    $0x28,%eax
  10508e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105095:	00 
  105096:	89 04 24             	mov    %eax,(%esp)
  105099:	e8 cd dc ff ff       	call   102d6b <free_pages>
    assert(alloc_pages(4) == NULL);
  10509e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1050a5:	e8 85 dc ff ff       	call   102d2f <alloc_pages>
  1050aa:	85 c0                	test   %eax,%eax
  1050ac:	74 24                	je     1050d2 <default_check+0x263>
  1050ae:	c7 44 24 0c 64 70 10 	movl   $0x107064,0xc(%esp)
  1050b5:	00 
  1050b6:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1050bd:	00 
  1050be:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1050c5:	00 
  1050c6:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1050cd:	e8 5f b3 ff ff       	call   100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1050d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050d5:	83 c0 28             	add    $0x28,%eax
  1050d8:	83 c0 04             	add    $0x4,%eax
  1050db:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1050e2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1050e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1050e8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1050eb:	0f a3 10             	bt     %edx,(%eax)
  1050ee:	19 c0                	sbb    %eax,%eax
  1050f0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1050f3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1050f7:	0f 95 c0             	setne  %al
  1050fa:	0f b6 c0             	movzbl %al,%eax
  1050fd:	85 c0                	test   %eax,%eax
  1050ff:	74 0e                	je     10510f <default_check+0x2a0>
  105101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105104:	83 c0 28             	add    $0x28,%eax
  105107:	8b 40 08             	mov    0x8(%eax),%eax
  10510a:	83 f8 03             	cmp    $0x3,%eax
  10510d:	74 24                	je     105133 <default_check+0x2c4>
  10510f:	c7 44 24 0c 7c 70 10 	movl   $0x10707c,0xc(%esp)
  105116:	00 
  105117:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10511e:	00 
  10511f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105126:	00 
  105127:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10512e:	e8 fe b2 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105133:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10513a:	e8 f0 db ff ff       	call   102d2f <alloc_pages>
  10513f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105142:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105146:	75 24                	jne    10516c <default_check+0x2fd>
  105148:	c7 44 24 0c a8 70 10 	movl   $0x1070a8,0xc(%esp)
  10514f:	00 
  105150:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  105157:	00 
  105158:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  10515f:	00 
  105160:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  105167:	e8 c5 b2 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  10516c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105173:	e8 b7 db ff ff       	call   102d2f <alloc_pages>
  105178:	85 c0                	test   %eax,%eax
  10517a:	74 24                	je     1051a0 <default_check+0x331>
  10517c:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  105183:	00 
  105184:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10518b:	00 
  10518c:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  105193:	00 
  105194:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10519b:	e8 91 b2 ff ff       	call   100431 <__panic>
    assert(p0 + 2 == p1);
  1051a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051a3:	83 c0 28             	add    $0x28,%eax
  1051a6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1051a9:	74 24                	je     1051cf <default_check+0x360>
  1051ab:	c7 44 24 0c c6 70 10 	movl   $0x1070c6,0xc(%esp)
  1051b2:	00 
  1051b3:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1051ba:	00 
  1051bb:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1051c2:	00 
  1051c3:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1051ca:	e8 62 b2 ff ff       	call   100431 <__panic>

    p2 = p0 + 1;
  1051cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051d2:	83 c0 14             	add    $0x14,%eax
  1051d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1051d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051df:	00 
  1051e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051e3:	89 04 24             	mov    %eax,(%esp)
  1051e6:	e8 80 db ff ff       	call   102d6b <free_pages>
    free_pages(p1, 3);
  1051eb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1051f2:	00 
  1051f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051f6:	89 04 24             	mov    %eax,(%esp)
  1051f9:	e8 6d db ff ff       	call   102d6b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1051fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105201:	83 c0 04             	add    $0x4,%eax
  105204:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10520b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10520e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105211:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105214:	0f a3 10             	bt     %edx,(%eax)
  105217:	19 c0                	sbb    %eax,%eax
  105219:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10521c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105220:	0f 95 c0             	setne  %al
  105223:	0f b6 c0             	movzbl %al,%eax
  105226:	85 c0                	test   %eax,%eax
  105228:	74 0b                	je     105235 <default_check+0x3c6>
  10522a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10522d:	8b 40 08             	mov    0x8(%eax),%eax
  105230:	83 f8 01             	cmp    $0x1,%eax
  105233:	74 24                	je     105259 <default_check+0x3ea>
  105235:	c7 44 24 0c d4 70 10 	movl   $0x1070d4,0xc(%esp)
  10523c:	00 
  10523d:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  105244:	00 
  105245:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  10524c:	00 
  10524d:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  105254:	e8 d8 b1 ff ff       	call   100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105259:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10525c:	83 c0 04             	add    $0x4,%eax
  10525f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105266:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105269:	8b 45 90             	mov    -0x70(%ebp),%eax
  10526c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10526f:	0f a3 10             	bt     %edx,(%eax)
  105272:	19 c0                	sbb    %eax,%eax
  105274:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105277:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10527b:	0f 95 c0             	setne  %al
  10527e:	0f b6 c0             	movzbl %al,%eax
  105281:	85 c0                	test   %eax,%eax
  105283:	74 0b                	je     105290 <default_check+0x421>
  105285:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105288:	8b 40 08             	mov    0x8(%eax),%eax
  10528b:	83 f8 03             	cmp    $0x3,%eax
  10528e:	74 24                	je     1052b4 <default_check+0x445>
  105290:	c7 44 24 0c fc 70 10 	movl   $0x1070fc,0xc(%esp)
  105297:	00 
  105298:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10529f:	00 
  1052a0:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1052a7:	00 
  1052a8:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1052af:	e8 7d b1 ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1052b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052bb:	e8 6f da ff ff       	call   102d2f <alloc_pages>
  1052c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052c6:	83 e8 14             	sub    $0x14,%eax
  1052c9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1052cc:	74 24                	je     1052f2 <default_check+0x483>
  1052ce:	c7 44 24 0c 22 71 10 	movl   $0x107122,0xc(%esp)
  1052d5:	00 
  1052d6:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1052dd:	00 
  1052de:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  1052e5:	00 
  1052e6:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1052ed:	e8 3f b1 ff ff       	call   100431 <__panic>
    free_page(p0);
  1052f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052f9:	00 
  1052fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052fd:	89 04 24             	mov    %eax,(%esp)
  105300:	e8 66 da ff ff       	call   102d6b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105305:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10530c:	e8 1e da ff ff       	call   102d2f <alloc_pages>
  105311:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105314:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105317:	83 c0 14             	add    $0x14,%eax
  10531a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10531d:	74 24                	je     105343 <default_check+0x4d4>
  10531f:	c7 44 24 0c 40 71 10 	movl   $0x107140,0xc(%esp)
  105326:	00 
  105327:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10532e:	00 
  10532f:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  105336:	00 
  105337:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10533e:	e8 ee b0 ff ff       	call   100431 <__panic>

    free_pages(p0, 2);
  105343:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10534a:	00 
  10534b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10534e:	89 04 24             	mov    %eax,(%esp)
  105351:	e8 15 da ff ff       	call   102d6b <free_pages>
    free_page(p2);
  105356:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10535d:	00 
  10535e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105361:	89 04 24             	mov    %eax,(%esp)
  105364:	e8 02 da ff ff       	call   102d6b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105369:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105370:	e8 ba d9 ff ff       	call   102d2f <alloc_pages>
  105375:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10537c:	75 24                	jne    1053a2 <default_check+0x533>
  10537e:	c7 44 24 0c 60 71 10 	movl   $0x107160,0xc(%esp)
  105385:	00 
  105386:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  10538d:	00 
  10538e:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105395:	00 
  105396:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  10539d:	e8 8f b0 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  1053a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1053a9:	e8 81 d9 ff ff       	call   102d2f <alloc_pages>
  1053ae:	85 c0                	test   %eax,%eax
  1053b0:	74 24                	je     1053d6 <default_check+0x567>
  1053b2:	c7 44 24 0c be 6f 10 	movl   $0x106fbe,0xc(%esp)
  1053b9:	00 
  1053ba:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1053c1:	00 
  1053c2:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  1053c9:	00 
  1053ca:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1053d1:	e8 5b b0 ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  1053d6:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1053db:	85 c0                	test   %eax,%eax
  1053dd:	74 24                	je     105403 <default_check+0x594>
  1053df:	c7 44 24 0c 11 70 10 	movl   $0x107011,0xc(%esp)
  1053e6:	00 
  1053e7:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1053ee:	00 
  1053ef:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1053f6:	00 
  1053f7:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1053fe:	e8 2e b0 ff ff       	call   100431 <__panic>
    nr_free = nr_free_store;
  105403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105406:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  10540b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10540e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105411:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  105416:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  10541c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105423:	00 
  105424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105427:	89 04 24             	mov    %eax,(%esp)
  10542a:	e8 3c d9 ff ff       	call   102d6b <free_pages>

    le = &free_list;
  10542f:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105436:	eb 5a                	jmp    105492 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
  105438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10543b:	8b 40 04             	mov    0x4(%eax),%eax
  10543e:	8b 00                	mov    (%eax),%eax
  105440:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105443:	75 0d                	jne    105452 <default_check+0x5e3>
  105445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105448:	8b 00                	mov    (%eax),%eax
  10544a:	8b 40 04             	mov    0x4(%eax),%eax
  10544d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105450:	74 24                	je     105476 <default_check+0x607>
  105452:	c7 44 24 0c 80 71 10 	movl   $0x107180,0xc(%esp)
  105459:	00 
  10545a:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  105461:	00 
  105462:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  105469:	00 
  10546a:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  105471:	e8 bb af ff ff       	call   100431 <__panic>
        struct Page *p = le2page(le, page_link);
  105476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105479:	83 e8 0c             	sub    $0xc,%eax
  10547c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  10547f:	ff 4d f4             	decl   -0xc(%ebp)
  105482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105488:	8b 40 08             	mov    0x8(%eax),%eax
  10548b:	29 c2                	sub    %eax,%edx
  10548d:	89 d0                	mov    %edx,%eax
  10548f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105495:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105498:	8b 45 88             	mov    -0x78(%ebp),%eax
  10549b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10549e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1054a1:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  1054a8:	75 8e                	jne    105438 <default_check+0x5c9>
    }
    assert(count == 0);
  1054aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1054ae:	74 24                	je     1054d4 <default_check+0x665>
  1054b0:	c7 44 24 0c ad 71 10 	movl   $0x1071ad,0xc(%esp)
  1054b7:	00 
  1054b8:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1054bf:	00 
  1054c0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1054c7:	00 
  1054c8:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1054cf:	e8 5d af ff ff       	call   100431 <__panic>
    assert(total == 0);
  1054d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1054d8:	74 24                	je     1054fe <default_check+0x68f>
  1054da:	c7 44 24 0c b8 71 10 	movl   $0x1071b8,0xc(%esp)
  1054e1:	00 
  1054e2:	c7 44 24 08 1e 6e 10 	movl   $0x106e1e,0x8(%esp)
  1054e9:	00 
  1054ea:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1054f1:	00 
  1054f2:	c7 04 24 33 6e 10 00 	movl   $0x106e33,(%esp)
  1054f9:	e8 33 af ff ff       	call   100431 <__panic>
}
  1054fe:	90                   	nop
  1054ff:	c9                   	leave  
  105500:	c3                   	ret    

00105501 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105501:	f3 0f 1e fb          	endbr32 
  105505:	55                   	push   %ebp
  105506:	89 e5                	mov    %esp,%ebp
  105508:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10550b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105512:	eb 03                	jmp    105517 <strlen+0x16>
        cnt ++;
  105514:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105517:	8b 45 08             	mov    0x8(%ebp),%eax
  10551a:	8d 50 01             	lea    0x1(%eax),%edx
  10551d:	89 55 08             	mov    %edx,0x8(%ebp)
  105520:	0f b6 00             	movzbl (%eax),%eax
  105523:	84 c0                	test   %al,%al
  105525:	75 ed                	jne    105514 <strlen+0x13>
    }
    return cnt;
  105527:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10552a:	c9                   	leave  
  10552b:	c3                   	ret    

0010552c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10552c:	f3 0f 1e fb          	endbr32 
  105530:	55                   	push   %ebp
  105531:	89 e5                	mov    %esp,%ebp
  105533:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10553d:	eb 03                	jmp    105542 <strnlen+0x16>
        cnt ++;
  10553f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105542:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105545:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105548:	73 10                	jae    10555a <strnlen+0x2e>
  10554a:	8b 45 08             	mov    0x8(%ebp),%eax
  10554d:	8d 50 01             	lea    0x1(%eax),%edx
  105550:	89 55 08             	mov    %edx,0x8(%ebp)
  105553:	0f b6 00             	movzbl (%eax),%eax
  105556:	84 c0                	test   %al,%al
  105558:	75 e5                	jne    10553f <strnlen+0x13>
    }
    return cnt;
  10555a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10555d:	c9                   	leave  
  10555e:	c3                   	ret    

0010555f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10555f:	f3 0f 1e fb          	endbr32 
  105563:	55                   	push   %ebp
  105564:	89 e5                	mov    %esp,%ebp
  105566:	57                   	push   %edi
  105567:	56                   	push   %esi
  105568:	83 ec 20             	sub    $0x20,%esp
  10556b:	8b 45 08             	mov    0x8(%ebp),%eax
  10556e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105571:	8b 45 0c             	mov    0xc(%ebp),%eax
  105574:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10557a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10557d:	89 d1                	mov    %edx,%ecx
  10557f:	89 c2                	mov    %eax,%edx
  105581:	89 ce                	mov    %ecx,%esi
  105583:	89 d7                	mov    %edx,%edi
  105585:	ac                   	lods   %ds:(%esi),%al
  105586:	aa                   	stos   %al,%es:(%edi)
  105587:	84 c0                	test   %al,%al
  105589:	75 fa                	jne    105585 <strcpy+0x26>
  10558b:	89 fa                	mov    %edi,%edx
  10558d:	89 f1                	mov    %esi,%ecx
  10558f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105592:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10559b:	83 c4 20             	add    $0x20,%esp
  10559e:	5e                   	pop    %esi
  10559f:	5f                   	pop    %edi
  1055a0:	5d                   	pop    %ebp
  1055a1:	c3                   	ret    

001055a2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1055a2:	f3 0f 1e fb          	endbr32 
  1055a6:	55                   	push   %ebp
  1055a7:	89 e5                	mov    %esp,%ebp
  1055a9:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1055ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1055af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1055b2:	eb 1e                	jmp    1055d2 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  1055b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055b7:	0f b6 10             	movzbl (%eax),%edx
  1055ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055bd:	88 10                	mov    %dl,(%eax)
  1055bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055c2:	0f b6 00             	movzbl (%eax),%eax
  1055c5:	84 c0                	test   %al,%al
  1055c7:	74 03                	je     1055cc <strncpy+0x2a>
            src ++;
  1055c9:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1055cc:	ff 45 fc             	incl   -0x4(%ebp)
  1055cf:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1055d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1055d6:	75 dc                	jne    1055b4 <strncpy+0x12>
    }
    return dst;
  1055d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1055db:	c9                   	leave  
  1055dc:	c3                   	ret    

001055dd <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1055dd:	f3 0f 1e fb          	endbr32 
  1055e1:	55                   	push   %ebp
  1055e2:	89 e5                	mov    %esp,%ebp
  1055e4:	57                   	push   %edi
  1055e5:	56                   	push   %esi
  1055e6:	83 ec 20             	sub    $0x20,%esp
  1055e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1055f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1055f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055fb:	89 d1                	mov    %edx,%ecx
  1055fd:	89 c2                	mov    %eax,%edx
  1055ff:	89 ce                	mov    %ecx,%esi
  105601:	89 d7                	mov    %edx,%edi
  105603:	ac                   	lods   %ds:(%esi),%al
  105604:	ae                   	scas   %es:(%edi),%al
  105605:	75 08                	jne    10560f <strcmp+0x32>
  105607:	84 c0                	test   %al,%al
  105609:	75 f8                	jne    105603 <strcmp+0x26>
  10560b:	31 c0                	xor    %eax,%eax
  10560d:	eb 04                	jmp    105613 <strcmp+0x36>
  10560f:	19 c0                	sbb    %eax,%eax
  105611:	0c 01                	or     $0x1,%al
  105613:	89 fa                	mov    %edi,%edx
  105615:	89 f1                	mov    %esi,%ecx
  105617:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10561a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10561d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105620:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105623:	83 c4 20             	add    $0x20,%esp
  105626:	5e                   	pop    %esi
  105627:	5f                   	pop    %edi
  105628:	5d                   	pop    %ebp
  105629:	c3                   	ret    

0010562a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10562a:	f3 0f 1e fb          	endbr32 
  10562e:	55                   	push   %ebp
  10562f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105631:	eb 09                	jmp    10563c <strncmp+0x12>
        n --, s1 ++, s2 ++;
  105633:	ff 4d 10             	decl   0x10(%ebp)
  105636:	ff 45 08             	incl   0x8(%ebp)
  105639:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10563c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105640:	74 1a                	je     10565c <strncmp+0x32>
  105642:	8b 45 08             	mov    0x8(%ebp),%eax
  105645:	0f b6 00             	movzbl (%eax),%eax
  105648:	84 c0                	test   %al,%al
  10564a:	74 10                	je     10565c <strncmp+0x32>
  10564c:	8b 45 08             	mov    0x8(%ebp),%eax
  10564f:	0f b6 10             	movzbl (%eax),%edx
  105652:	8b 45 0c             	mov    0xc(%ebp),%eax
  105655:	0f b6 00             	movzbl (%eax),%eax
  105658:	38 c2                	cmp    %al,%dl
  10565a:	74 d7                	je     105633 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10565c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105660:	74 18                	je     10567a <strncmp+0x50>
  105662:	8b 45 08             	mov    0x8(%ebp),%eax
  105665:	0f b6 00             	movzbl (%eax),%eax
  105668:	0f b6 d0             	movzbl %al,%edx
  10566b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10566e:	0f b6 00             	movzbl (%eax),%eax
  105671:	0f b6 c0             	movzbl %al,%eax
  105674:	29 c2                	sub    %eax,%edx
  105676:	89 d0                	mov    %edx,%eax
  105678:	eb 05                	jmp    10567f <strncmp+0x55>
  10567a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10567f:	5d                   	pop    %ebp
  105680:	c3                   	ret    

00105681 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105681:	f3 0f 1e fb          	endbr32 
  105685:	55                   	push   %ebp
  105686:	89 e5                	mov    %esp,%ebp
  105688:	83 ec 04             	sub    $0x4,%esp
  10568b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10568e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105691:	eb 13                	jmp    1056a6 <strchr+0x25>
        if (*s == c) {
  105693:	8b 45 08             	mov    0x8(%ebp),%eax
  105696:	0f b6 00             	movzbl (%eax),%eax
  105699:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10569c:	75 05                	jne    1056a3 <strchr+0x22>
            return (char *)s;
  10569e:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a1:	eb 12                	jmp    1056b5 <strchr+0x34>
        }
        s ++;
  1056a3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1056a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a9:	0f b6 00             	movzbl (%eax),%eax
  1056ac:	84 c0                	test   %al,%al
  1056ae:	75 e3                	jne    105693 <strchr+0x12>
    }
    return NULL;
  1056b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1056b5:	c9                   	leave  
  1056b6:	c3                   	ret    

001056b7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1056b7:	f3 0f 1e fb          	endbr32 
  1056bb:	55                   	push   %ebp
  1056bc:	89 e5                	mov    %esp,%ebp
  1056be:	83 ec 04             	sub    $0x4,%esp
  1056c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056c4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1056c7:	eb 0e                	jmp    1056d7 <strfind+0x20>
        if (*s == c) {
  1056c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056cc:	0f b6 00             	movzbl (%eax),%eax
  1056cf:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1056d2:	74 0f                	je     1056e3 <strfind+0x2c>
            break;
        }
        s ++;
  1056d4:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1056d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056da:	0f b6 00             	movzbl (%eax),%eax
  1056dd:	84 c0                	test   %al,%al
  1056df:	75 e8                	jne    1056c9 <strfind+0x12>
  1056e1:	eb 01                	jmp    1056e4 <strfind+0x2d>
            break;
  1056e3:	90                   	nop
    }
    return (char *)s;
  1056e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1056e7:	c9                   	leave  
  1056e8:	c3                   	ret    

001056e9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1056e9:	f3 0f 1e fb          	endbr32 
  1056ed:	55                   	push   %ebp
  1056ee:	89 e5                	mov    %esp,%ebp
  1056f0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1056f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1056fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105701:	eb 03                	jmp    105706 <strtol+0x1d>
        s ++;
  105703:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105706:	8b 45 08             	mov    0x8(%ebp),%eax
  105709:	0f b6 00             	movzbl (%eax),%eax
  10570c:	3c 20                	cmp    $0x20,%al
  10570e:	74 f3                	je     105703 <strtol+0x1a>
  105710:	8b 45 08             	mov    0x8(%ebp),%eax
  105713:	0f b6 00             	movzbl (%eax),%eax
  105716:	3c 09                	cmp    $0x9,%al
  105718:	74 e9                	je     105703 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  10571a:	8b 45 08             	mov    0x8(%ebp),%eax
  10571d:	0f b6 00             	movzbl (%eax),%eax
  105720:	3c 2b                	cmp    $0x2b,%al
  105722:	75 05                	jne    105729 <strtol+0x40>
        s ++;
  105724:	ff 45 08             	incl   0x8(%ebp)
  105727:	eb 14                	jmp    10573d <strtol+0x54>
    }
    else if (*s == '-') {
  105729:	8b 45 08             	mov    0x8(%ebp),%eax
  10572c:	0f b6 00             	movzbl (%eax),%eax
  10572f:	3c 2d                	cmp    $0x2d,%al
  105731:	75 0a                	jne    10573d <strtol+0x54>
        s ++, neg = 1;
  105733:	ff 45 08             	incl   0x8(%ebp)
  105736:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10573d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105741:	74 06                	je     105749 <strtol+0x60>
  105743:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105747:	75 22                	jne    10576b <strtol+0x82>
  105749:	8b 45 08             	mov    0x8(%ebp),%eax
  10574c:	0f b6 00             	movzbl (%eax),%eax
  10574f:	3c 30                	cmp    $0x30,%al
  105751:	75 18                	jne    10576b <strtol+0x82>
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	40                   	inc    %eax
  105757:	0f b6 00             	movzbl (%eax),%eax
  10575a:	3c 78                	cmp    $0x78,%al
  10575c:	75 0d                	jne    10576b <strtol+0x82>
        s += 2, base = 16;
  10575e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105762:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105769:	eb 29                	jmp    105794 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  10576b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10576f:	75 16                	jne    105787 <strtol+0x9e>
  105771:	8b 45 08             	mov    0x8(%ebp),%eax
  105774:	0f b6 00             	movzbl (%eax),%eax
  105777:	3c 30                	cmp    $0x30,%al
  105779:	75 0c                	jne    105787 <strtol+0x9e>
        s ++, base = 8;
  10577b:	ff 45 08             	incl   0x8(%ebp)
  10577e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105785:	eb 0d                	jmp    105794 <strtol+0xab>
    }
    else if (base == 0) {
  105787:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10578b:	75 07                	jne    105794 <strtol+0xab>
        base = 10;
  10578d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105794:	8b 45 08             	mov    0x8(%ebp),%eax
  105797:	0f b6 00             	movzbl (%eax),%eax
  10579a:	3c 2f                	cmp    $0x2f,%al
  10579c:	7e 1b                	jle    1057b9 <strtol+0xd0>
  10579e:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a1:	0f b6 00             	movzbl (%eax),%eax
  1057a4:	3c 39                	cmp    $0x39,%al
  1057a6:	7f 11                	jg     1057b9 <strtol+0xd0>
            dig = *s - '0';
  1057a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ab:	0f b6 00             	movzbl (%eax),%eax
  1057ae:	0f be c0             	movsbl %al,%eax
  1057b1:	83 e8 30             	sub    $0x30,%eax
  1057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1057b7:	eb 48                	jmp    105801 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1057b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bc:	0f b6 00             	movzbl (%eax),%eax
  1057bf:	3c 60                	cmp    $0x60,%al
  1057c1:	7e 1b                	jle    1057de <strtol+0xf5>
  1057c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c6:	0f b6 00             	movzbl (%eax),%eax
  1057c9:	3c 7a                	cmp    $0x7a,%al
  1057cb:	7f 11                	jg     1057de <strtol+0xf5>
            dig = *s - 'a' + 10;
  1057cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d0:	0f b6 00             	movzbl (%eax),%eax
  1057d3:	0f be c0             	movsbl %al,%eax
  1057d6:	83 e8 57             	sub    $0x57,%eax
  1057d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1057dc:	eb 23                	jmp    105801 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1057de:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e1:	0f b6 00             	movzbl (%eax),%eax
  1057e4:	3c 40                	cmp    $0x40,%al
  1057e6:	7e 3b                	jle    105823 <strtol+0x13a>
  1057e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057eb:	0f b6 00             	movzbl (%eax),%eax
  1057ee:	3c 5a                	cmp    $0x5a,%al
  1057f0:	7f 31                	jg     105823 <strtol+0x13a>
            dig = *s - 'A' + 10;
  1057f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f5:	0f b6 00             	movzbl (%eax),%eax
  1057f8:	0f be c0             	movsbl %al,%eax
  1057fb:	83 e8 37             	sub    $0x37,%eax
  1057fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105804:	3b 45 10             	cmp    0x10(%ebp),%eax
  105807:	7d 19                	jge    105822 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  105809:	ff 45 08             	incl   0x8(%ebp)
  10580c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10580f:	0f af 45 10          	imul   0x10(%ebp),%eax
  105813:	89 c2                	mov    %eax,%edx
  105815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105818:	01 d0                	add    %edx,%eax
  10581a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  10581d:	e9 72 ff ff ff       	jmp    105794 <strtol+0xab>
            break;
  105822:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105827:	74 08                	je     105831 <strtol+0x148>
        *endptr = (char *) s;
  105829:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582c:	8b 55 08             	mov    0x8(%ebp),%edx
  10582f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105831:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105835:	74 07                	je     10583e <strtol+0x155>
  105837:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10583a:	f7 d8                	neg    %eax
  10583c:	eb 03                	jmp    105841 <strtol+0x158>
  10583e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105841:	c9                   	leave  
  105842:	c3                   	ret    

00105843 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105843:	f3 0f 1e fb          	endbr32 
  105847:	55                   	push   %ebp
  105848:	89 e5                	mov    %esp,%ebp
  10584a:	57                   	push   %edi
  10584b:	83 ec 24             	sub    $0x24,%esp
  10584e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105851:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105854:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105858:	8b 45 08             	mov    0x8(%ebp),%eax
  10585b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10585e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105861:	8b 45 10             	mov    0x10(%ebp),%eax
  105864:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105867:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10586a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10586e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105871:	89 d7                	mov    %edx,%edi
  105873:	f3 aa                	rep stos %al,%es:(%edi)
  105875:	89 fa                	mov    %edi,%edx
  105877:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10587a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10587d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105880:	83 c4 24             	add    $0x24,%esp
  105883:	5f                   	pop    %edi
  105884:	5d                   	pop    %ebp
  105885:	c3                   	ret    

00105886 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105886:	f3 0f 1e fb          	endbr32 
  10588a:	55                   	push   %ebp
  10588b:	89 e5                	mov    %esp,%ebp
  10588d:	57                   	push   %edi
  10588e:	56                   	push   %esi
  10588f:	53                   	push   %ebx
  105890:	83 ec 30             	sub    $0x30,%esp
  105893:	8b 45 08             	mov    0x8(%ebp),%eax
  105896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105899:	8b 45 0c             	mov    0xc(%ebp),%eax
  10589c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10589f:	8b 45 10             	mov    0x10(%ebp),%eax
  1058a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1058a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1058ab:	73 42                	jae    1058ef <memmove+0x69>
  1058ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1058bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058c2:	c1 e8 02             	shr    $0x2,%eax
  1058c5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1058c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058cd:	89 d7                	mov    %edx,%edi
  1058cf:	89 c6                	mov    %eax,%esi
  1058d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1058d3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1058d6:	83 e1 03             	and    $0x3,%ecx
  1058d9:	74 02                	je     1058dd <memmove+0x57>
  1058db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1058dd:	89 f0                	mov    %esi,%eax
  1058df:	89 fa                	mov    %edi,%edx
  1058e1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1058e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1058e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1058ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1058ed:	eb 36                	jmp    105925 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1058ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058f8:	01 c2                	add    %eax,%edx
  1058fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058fd:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105903:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105909:	89 c1                	mov    %eax,%ecx
  10590b:	89 d8                	mov    %ebx,%eax
  10590d:	89 d6                	mov    %edx,%esi
  10590f:	89 c7                	mov    %eax,%edi
  105911:	fd                   	std    
  105912:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105914:	fc                   	cld    
  105915:	89 f8                	mov    %edi,%eax
  105917:	89 f2                	mov    %esi,%edx
  105919:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10591c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10591f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105922:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105925:	83 c4 30             	add    $0x30,%esp
  105928:	5b                   	pop    %ebx
  105929:	5e                   	pop    %esi
  10592a:	5f                   	pop    %edi
  10592b:	5d                   	pop    %ebp
  10592c:	c3                   	ret    

0010592d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10592d:	f3 0f 1e fb          	endbr32 
  105931:	55                   	push   %ebp
  105932:	89 e5                	mov    %esp,%ebp
  105934:	57                   	push   %edi
  105935:	56                   	push   %esi
  105936:	83 ec 20             	sub    $0x20,%esp
  105939:	8b 45 08             	mov    0x8(%ebp),%eax
  10593c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10593f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105942:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105945:	8b 45 10             	mov    0x10(%ebp),%eax
  105948:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10594b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10594e:	c1 e8 02             	shr    $0x2,%eax
  105951:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105959:	89 d7                	mov    %edx,%edi
  10595b:	89 c6                	mov    %eax,%esi
  10595d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10595f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105962:	83 e1 03             	and    $0x3,%ecx
  105965:	74 02                	je     105969 <memcpy+0x3c>
  105967:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105969:	89 f0                	mov    %esi,%eax
  10596b:	89 fa                	mov    %edi,%edx
  10596d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105970:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105973:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105976:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105979:	83 c4 20             	add    $0x20,%esp
  10597c:	5e                   	pop    %esi
  10597d:	5f                   	pop    %edi
  10597e:	5d                   	pop    %ebp
  10597f:	c3                   	ret    

00105980 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105980:	f3 0f 1e fb          	endbr32 
  105984:	55                   	push   %ebp
  105985:	89 e5                	mov    %esp,%ebp
  105987:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10598a:	8b 45 08             	mov    0x8(%ebp),%eax
  10598d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105990:	8b 45 0c             	mov    0xc(%ebp),%eax
  105993:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105996:	eb 2e                	jmp    1059c6 <memcmp+0x46>
        if (*s1 != *s2) {
  105998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10599b:	0f b6 10             	movzbl (%eax),%edx
  10599e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059a1:	0f b6 00             	movzbl (%eax),%eax
  1059a4:	38 c2                	cmp    %al,%dl
  1059a6:	74 18                	je     1059c0 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1059a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059ab:	0f b6 00             	movzbl (%eax),%eax
  1059ae:	0f b6 d0             	movzbl %al,%edx
  1059b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059b4:	0f b6 00             	movzbl (%eax),%eax
  1059b7:	0f b6 c0             	movzbl %al,%eax
  1059ba:	29 c2                	sub    %eax,%edx
  1059bc:	89 d0                	mov    %edx,%eax
  1059be:	eb 18                	jmp    1059d8 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1059c0:	ff 45 fc             	incl   -0x4(%ebp)
  1059c3:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1059c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1059c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1059cf:	85 c0                	test   %eax,%eax
  1059d1:	75 c5                	jne    105998 <memcmp+0x18>
    }
    return 0;
  1059d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1059d8:	c9                   	leave  
  1059d9:	c3                   	ret    

001059da <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1059da:	f3 0f 1e fb          	endbr32 
  1059de:	55                   	push   %ebp
  1059df:	89 e5                	mov    %esp,%ebp
  1059e1:	83 ec 58             	sub    $0x58,%esp
  1059e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1059e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1059ea:	8b 45 14             	mov    0x14(%ebp),%eax
  1059ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1059f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1059f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1059f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1059fc:	8b 45 18             	mov    0x18(%ebp),%eax
  1059ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a0b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a18:	74 1c                	je     105a36 <printnum+0x5c>
  105a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  105a22:	f7 75 e4             	divl   -0x1c(%ebp)
  105a25:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  105a30:	f7 75 e4             	divl   -0x1c(%ebp)
  105a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a3c:	f7 75 e4             	divl   -0x1c(%ebp)
  105a3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a4e:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a54:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105a57:	8b 45 18             	mov    0x18(%ebp),%eax
  105a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  105a5f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105a62:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105a65:	19 d1                	sbb    %edx,%ecx
  105a67:	72 4c                	jb     105ab5 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105a69:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105a6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a6f:	8b 45 20             	mov    0x20(%ebp),%eax
  105a72:	89 44 24 18          	mov    %eax,0x18(%esp)
  105a76:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a7a:	8b 45 18             	mov    0x18(%ebp),%eax
  105a7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a87:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a96:	8b 45 08             	mov    0x8(%ebp),%eax
  105a99:	89 04 24             	mov    %eax,(%esp)
  105a9c:	e8 39 ff ff ff       	call   1059da <printnum>
  105aa1:	eb 1b                	jmp    105abe <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aaa:	8b 45 20             	mov    0x20(%ebp),%eax
  105aad:	89 04 24             	mov    %eax,(%esp)
  105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab3:	ff d0                	call   *%eax
        while (-- width > 0)
  105ab5:	ff 4d 1c             	decl   0x1c(%ebp)
  105ab8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105abc:	7f e5                	jg     105aa3 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105abe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105ac1:	05 74 72 10 00       	add    $0x107274,%eax
  105ac6:	0f b6 00             	movzbl (%eax),%eax
  105ac9:	0f be c0             	movsbl %al,%eax
  105acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  105acf:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ad3:	89 04 24             	mov    %eax,(%esp)
  105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad9:	ff d0                	call   *%eax
}
  105adb:	90                   	nop
  105adc:	c9                   	leave  
  105add:	c3                   	ret    

00105ade <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105ade:	f3 0f 1e fb          	endbr32 
  105ae2:	55                   	push   %ebp
  105ae3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105ae9:	7e 14                	jle    105aff <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  105aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  105aee:	8b 00                	mov    (%eax),%eax
  105af0:	8d 48 08             	lea    0x8(%eax),%ecx
  105af3:	8b 55 08             	mov    0x8(%ebp),%edx
  105af6:	89 0a                	mov    %ecx,(%edx)
  105af8:	8b 50 04             	mov    0x4(%eax),%edx
  105afb:	8b 00                	mov    (%eax),%eax
  105afd:	eb 30                	jmp    105b2f <getuint+0x51>
    }
    else if (lflag) {
  105aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b03:	74 16                	je     105b1b <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  105b05:	8b 45 08             	mov    0x8(%ebp),%eax
  105b08:	8b 00                	mov    (%eax),%eax
  105b0a:	8d 48 04             	lea    0x4(%eax),%ecx
  105b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  105b10:	89 0a                	mov    %ecx,(%edx)
  105b12:	8b 00                	mov    (%eax),%eax
  105b14:	ba 00 00 00 00       	mov    $0x0,%edx
  105b19:	eb 14                	jmp    105b2f <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  105b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1e:	8b 00                	mov    (%eax),%eax
  105b20:	8d 48 04             	lea    0x4(%eax),%ecx
  105b23:	8b 55 08             	mov    0x8(%ebp),%edx
  105b26:	89 0a                	mov    %ecx,(%edx)
  105b28:	8b 00                	mov    (%eax),%eax
  105b2a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105b2f:	5d                   	pop    %ebp
  105b30:	c3                   	ret    

00105b31 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105b31:	f3 0f 1e fb          	endbr32 
  105b35:	55                   	push   %ebp
  105b36:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105b38:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105b3c:	7e 14                	jle    105b52 <getint+0x21>
        return va_arg(*ap, long long);
  105b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b41:	8b 00                	mov    (%eax),%eax
  105b43:	8d 48 08             	lea    0x8(%eax),%ecx
  105b46:	8b 55 08             	mov    0x8(%ebp),%edx
  105b49:	89 0a                	mov    %ecx,(%edx)
  105b4b:	8b 50 04             	mov    0x4(%eax),%edx
  105b4e:	8b 00                	mov    (%eax),%eax
  105b50:	eb 28                	jmp    105b7a <getint+0x49>
    }
    else if (lflag) {
  105b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b56:	74 12                	je     105b6a <getint+0x39>
        return va_arg(*ap, long);
  105b58:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5b:	8b 00                	mov    (%eax),%eax
  105b5d:	8d 48 04             	lea    0x4(%eax),%ecx
  105b60:	8b 55 08             	mov    0x8(%ebp),%edx
  105b63:	89 0a                	mov    %ecx,(%edx)
  105b65:	8b 00                	mov    (%eax),%eax
  105b67:	99                   	cltd   
  105b68:	eb 10                	jmp    105b7a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6d:	8b 00                	mov    (%eax),%eax
  105b6f:	8d 48 04             	lea    0x4(%eax),%ecx
  105b72:	8b 55 08             	mov    0x8(%ebp),%edx
  105b75:	89 0a                	mov    %ecx,(%edx)
  105b77:	8b 00                	mov    (%eax),%eax
  105b79:	99                   	cltd   
    }
}
  105b7a:	5d                   	pop    %ebp
  105b7b:	c3                   	ret    

00105b7c <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105b7c:	f3 0f 1e fb          	endbr32 
  105b80:	55                   	push   %ebp
  105b81:	89 e5                	mov    %esp,%ebp
  105b83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105b86:	8d 45 14             	lea    0x14(%ebp),%eax
  105b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b93:	8b 45 10             	mov    0x10(%ebp),%eax
  105b96:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba4:	89 04 24             	mov    %eax,(%esp)
  105ba7:	e8 03 00 00 00       	call   105baf <vprintfmt>
    va_end(ap);
}
  105bac:	90                   	nop
  105bad:	c9                   	leave  
  105bae:	c3                   	ret    

00105baf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105baf:	f3 0f 1e fb          	endbr32 
  105bb3:	55                   	push   %ebp
  105bb4:	89 e5                	mov    %esp,%ebp
  105bb6:	56                   	push   %esi
  105bb7:	53                   	push   %ebx
  105bb8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105bbb:	eb 17                	jmp    105bd4 <vprintfmt+0x25>
            if (ch == '\0') {
  105bbd:	85 db                	test   %ebx,%ebx
  105bbf:	0f 84 c0 03 00 00    	je     105f85 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bcc:	89 1c 24             	mov    %ebx,(%esp)
  105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  105bd7:	8d 50 01             	lea    0x1(%eax),%edx
  105bda:	89 55 10             	mov    %edx,0x10(%ebp)
  105bdd:	0f b6 00             	movzbl (%eax),%eax
  105be0:	0f b6 d8             	movzbl %al,%ebx
  105be3:	83 fb 25             	cmp    $0x25,%ebx
  105be6:	75 d5                	jne    105bbd <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105c00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c03:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105c06:	8b 45 10             	mov    0x10(%ebp),%eax
  105c09:	8d 50 01             	lea    0x1(%eax),%edx
  105c0c:	89 55 10             	mov    %edx,0x10(%ebp)
  105c0f:	0f b6 00             	movzbl (%eax),%eax
  105c12:	0f b6 d8             	movzbl %al,%ebx
  105c15:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105c18:	83 f8 55             	cmp    $0x55,%eax
  105c1b:	0f 87 38 03 00 00    	ja     105f59 <vprintfmt+0x3aa>
  105c21:	8b 04 85 98 72 10 00 	mov    0x107298(,%eax,4),%eax
  105c28:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105c2f:	eb d5                	jmp    105c06 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105c35:	eb cf                	jmp    105c06 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105c37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105c3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c41:	89 d0                	mov    %edx,%eax
  105c43:	c1 e0 02             	shl    $0x2,%eax
  105c46:	01 d0                	add    %edx,%eax
  105c48:	01 c0                	add    %eax,%eax
  105c4a:	01 d8                	add    %ebx,%eax
  105c4c:	83 e8 30             	sub    $0x30,%eax
  105c4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105c52:	8b 45 10             	mov    0x10(%ebp),%eax
  105c55:	0f b6 00             	movzbl (%eax),%eax
  105c58:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105c5b:	83 fb 2f             	cmp    $0x2f,%ebx
  105c5e:	7e 38                	jle    105c98 <vprintfmt+0xe9>
  105c60:	83 fb 39             	cmp    $0x39,%ebx
  105c63:	7f 33                	jg     105c98 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105c65:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105c68:	eb d4                	jmp    105c3e <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  105c6d:	8d 50 04             	lea    0x4(%eax),%edx
  105c70:	89 55 14             	mov    %edx,0x14(%ebp)
  105c73:	8b 00                	mov    (%eax),%eax
  105c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105c78:	eb 1f                	jmp    105c99 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105c7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c7e:	79 86                	jns    105c06 <vprintfmt+0x57>
                width = 0;
  105c80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105c87:	e9 7a ff ff ff       	jmp    105c06 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105c8c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105c93:	e9 6e ff ff ff       	jmp    105c06 <vprintfmt+0x57>
            goto process_precision;
  105c98:	90                   	nop

        process_precision:
            if (width < 0)
  105c99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c9d:	0f 89 63 ff ff ff    	jns    105c06 <vprintfmt+0x57>
                width = precision, precision = -1;
  105ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ca6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ca9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105cb0:	e9 51 ff ff ff       	jmp    105c06 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105cb5:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105cb8:	e9 49 ff ff ff       	jmp    105c06 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  105cc0:	8d 50 04             	lea    0x4(%eax),%edx
  105cc3:	89 55 14             	mov    %edx,0x14(%ebp)
  105cc6:	8b 00                	mov    (%eax),%eax
  105cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ccb:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ccf:	89 04 24             	mov    %eax,(%esp)
  105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd5:	ff d0                	call   *%eax
            break;
  105cd7:	e9 a4 02 00 00       	jmp    105f80 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  105cdf:	8d 50 04             	lea    0x4(%eax),%edx
  105ce2:	89 55 14             	mov    %edx,0x14(%ebp)
  105ce5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105ce7:	85 db                	test   %ebx,%ebx
  105ce9:	79 02                	jns    105ced <vprintfmt+0x13e>
                err = -err;
  105ceb:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105ced:	83 fb 06             	cmp    $0x6,%ebx
  105cf0:	7f 0b                	jg     105cfd <vprintfmt+0x14e>
  105cf2:	8b 34 9d 58 72 10 00 	mov    0x107258(,%ebx,4),%esi
  105cf9:	85 f6                	test   %esi,%esi
  105cfb:	75 23                	jne    105d20 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105cfd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105d01:	c7 44 24 08 85 72 10 	movl   $0x107285,0x8(%esp)
  105d08:	00 
  105d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d10:	8b 45 08             	mov    0x8(%ebp),%eax
  105d13:	89 04 24             	mov    %eax,(%esp)
  105d16:	e8 61 fe ff ff       	call   105b7c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105d1b:	e9 60 02 00 00       	jmp    105f80 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105d20:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105d24:	c7 44 24 08 8e 72 10 	movl   $0x10728e,0x8(%esp)
  105d2b:	00 
  105d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d33:	8b 45 08             	mov    0x8(%ebp),%eax
  105d36:	89 04 24             	mov    %eax,(%esp)
  105d39:	e8 3e fe ff ff       	call   105b7c <printfmt>
            break;
  105d3e:	e9 3d 02 00 00       	jmp    105f80 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105d43:	8b 45 14             	mov    0x14(%ebp),%eax
  105d46:	8d 50 04             	lea    0x4(%eax),%edx
  105d49:	89 55 14             	mov    %edx,0x14(%ebp)
  105d4c:	8b 30                	mov    (%eax),%esi
  105d4e:	85 f6                	test   %esi,%esi
  105d50:	75 05                	jne    105d57 <vprintfmt+0x1a8>
                p = "(null)";
  105d52:	be 91 72 10 00       	mov    $0x107291,%esi
            }
            if (width > 0 && padc != '-') {
  105d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d5b:	7e 76                	jle    105dd3 <vprintfmt+0x224>
  105d5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105d61:	74 70                	je     105dd3 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d6a:	89 34 24             	mov    %esi,(%esp)
  105d6d:	e8 ba f7 ff ff       	call   10552c <strnlen>
  105d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105d75:	29 c2                	sub    %eax,%edx
  105d77:	89 d0                	mov    %edx,%eax
  105d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d7c:	eb 16                	jmp    105d94 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105d7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d85:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d89:	89 04 24             	mov    %eax,(%esp)
  105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105d91:	ff 4d e8             	decl   -0x18(%ebp)
  105d94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d98:	7f e4                	jg     105d7e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105d9a:	eb 37                	jmp    105dd3 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105d9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105da0:	74 1f                	je     105dc1 <vprintfmt+0x212>
  105da2:	83 fb 1f             	cmp    $0x1f,%ebx
  105da5:	7e 05                	jle    105dac <vprintfmt+0x1fd>
  105da7:	83 fb 7e             	cmp    $0x7e,%ebx
  105daa:	7e 15                	jle    105dc1 <vprintfmt+0x212>
                    putch('?', putdat);
  105dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  105daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105db3:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105dba:	8b 45 08             	mov    0x8(%ebp),%eax
  105dbd:	ff d0                	call   *%eax
  105dbf:	eb 0f                	jmp    105dd0 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dc8:	89 1c 24             	mov    %ebx,(%esp)
  105dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  105dce:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105dd0:	ff 4d e8             	decl   -0x18(%ebp)
  105dd3:	89 f0                	mov    %esi,%eax
  105dd5:	8d 70 01             	lea    0x1(%eax),%esi
  105dd8:	0f b6 00             	movzbl (%eax),%eax
  105ddb:	0f be d8             	movsbl %al,%ebx
  105dde:	85 db                	test   %ebx,%ebx
  105de0:	74 27                	je     105e09 <vprintfmt+0x25a>
  105de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105de6:	78 b4                	js     105d9c <vprintfmt+0x1ed>
  105de8:	ff 4d e4             	decl   -0x1c(%ebp)
  105deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105def:	79 ab                	jns    105d9c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105df1:	eb 16                	jmp    105e09 <vprintfmt+0x25a>
                putch(' ', putdat);
  105df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dfa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105e01:	8b 45 08             	mov    0x8(%ebp),%eax
  105e04:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105e06:	ff 4d e8             	decl   -0x18(%ebp)
  105e09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e0d:	7f e4                	jg     105df3 <vprintfmt+0x244>
            }
            break;
  105e0f:	e9 6c 01 00 00       	jmp    105f80 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e17:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e1b:	8d 45 14             	lea    0x14(%ebp),%eax
  105e1e:	89 04 24             	mov    %eax,(%esp)
  105e21:	e8 0b fd ff ff       	call   105b31 <getint>
  105e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e32:	85 d2                	test   %edx,%edx
  105e34:	79 26                	jns    105e5c <vprintfmt+0x2ad>
                putch('-', putdat);
  105e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e39:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e3d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105e44:	8b 45 08             	mov    0x8(%ebp),%eax
  105e47:	ff d0                	call   *%eax
                num = -(long long)num;
  105e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e4f:	f7 d8                	neg    %eax
  105e51:	83 d2 00             	adc    $0x0,%edx
  105e54:	f7 da                	neg    %edx
  105e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e59:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105e5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105e63:	e9 a8 00 00 00       	jmp    105f10 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e6f:	8d 45 14             	lea    0x14(%ebp),%eax
  105e72:	89 04 24             	mov    %eax,(%esp)
  105e75:	e8 64 fc ff ff       	call   105ade <getuint>
  105e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105e80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105e87:	e9 84 00 00 00       	jmp    105f10 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e93:	8d 45 14             	lea    0x14(%ebp),%eax
  105e96:	89 04 24             	mov    %eax,(%esp)
  105e99:	e8 40 fc ff ff       	call   105ade <getuint>
  105e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ea1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105ea4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105eab:	eb 63                	jmp    105f10 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  105ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eb4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ebe:	ff d0                	call   *%eax
            putch('x', putdat);
  105ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ec7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105ece:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  105ed6:	8d 50 04             	lea    0x4(%eax),%edx
  105ed9:	89 55 14             	mov    %edx,0x14(%ebp)
  105edc:	8b 00                	mov    (%eax),%eax
  105ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ee8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105eef:	eb 1f                	jmp    105f10 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ef8:	8d 45 14             	lea    0x14(%ebp),%eax
  105efb:	89 04 24             	mov    %eax,(%esp)
  105efe:	e8 db fb ff ff       	call   105ade <getuint>
  105f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105f09:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105f10:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f17:	89 54 24 18          	mov    %edx,0x18(%esp)
  105f1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105f1e:	89 54 24 14          	mov    %edx,0x14(%esp)
  105f22:	89 44 24 10          	mov    %eax,0x10(%esp)
  105f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f30:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3e:	89 04 24             	mov    %eax,(%esp)
  105f41:	e8 94 fa ff ff       	call   1059da <printnum>
            break;
  105f46:	eb 38                	jmp    105f80 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f4f:	89 1c 24             	mov    %ebx,(%esp)
  105f52:	8b 45 08             	mov    0x8(%ebp),%eax
  105f55:	ff d0                	call   *%eax
            break;
  105f57:	eb 27                	jmp    105f80 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f60:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105f67:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105f6c:	ff 4d 10             	decl   0x10(%ebp)
  105f6f:	eb 03                	jmp    105f74 <vprintfmt+0x3c5>
  105f71:	ff 4d 10             	decl   0x10(%ebp)
  105f74:	8b 45 10             	mov    0x10(%ebp),%eax
  105f77:	48                   	dec    %eax
  105f78:	0f b6 00             	movzbl (%eax),%eax
  105f7b:	3c 25                	cmp    $0x25,%al
  105f7d:	75 f2                	jne    105f71 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  105f7f:	90                   	nop
    while (1) {
  105f80:	e9 36 fc ff ff       	jmp    105bbb <vprintfmt+0xc>
                return;
  105f85:	90                   	nop
        }
    }
}
  105f86:	83 c4 40             	add    $0x40,%esp
  105f89:	5b                   	pop    %ebx
  105f8a:	5e                   	pop    %esi
  105f8b:	5d                   	pop    %ebp
  105f8c:	c3                   	ret    

00105f8d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105f8d:	f3 0f 1e fb          	endbr32 
  105f91:	55                   	push   %ebp
  105f92:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f97:	8b 40 08             	mov    0x8(%eax),%eax
  105f9a:	8d 50 01             	lea    0x1(%eax),%edx
  105f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fa0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fa6:	8b 10                	mov    (%eax),%edx
  105fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fab:	8b 40 04             	mov    0x4(%eax),%eax
  105fae:	39 c2                	cmp    %eax,%edx
  105fb0:	73 12                	jae    105fc4 <sprintputch+0x37>
        *b->buf ++ = ch;
  105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fb5:	8b 00                	mov    (%eax),%eax
  105fb7:	8d 48 01             	lea    0x1(%eax),%ecx
  105fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  105fbd:	89 0a                	mov    %ecx,(%edx)
  105fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  105fc2:	88 10                	mov    %dl,(%eax)
    }
}
  105fc4:	90                   	nop
  105fc5:	5d                   	pop    %ebp
  105fc6:	c3                   	ret    

00105fc7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105fc7:	f3 0f 1e fb          	endbr32 
  105fcb:	55                   	push   %ebp
  105fcc:	89 e5                	mov    %esp,%ebp
  105fce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105fd1:	8d 45 14             	lea    0x14(%ebp),%eax
  105fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105fde:	8b 45 10             	mov    0x10(%ebp),%eax
  105fe1:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fec:	8b 45 08             	mov    0x8(%ebp),%eax
  105fef:	89 04 24             	mov    %eax,(%esp)
  105ff2:	e8 08 00 00 00       	call   105fff <vsnprintf>
  105ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ffd:	c9                   	leave  
  105ffe:	c3                   	ret    

00105fff <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105fff:	f3 0f 1e fb          	endbr32 
  106003:	55                   	push   %ebp
  106004:	89 e5                	mov    %esp,%ebp
  106006:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106009:	8b 45 08             	mov    0x8(%ebp),%eax
  10600c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10600f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106012:	8d 50 ff             	lea    -0x1(%eax),%edx
  106015:	8b 45 08             	mov    0x8(%ebp),%eax
  106018:	01 d0                	add    %edx,%eax
  10601a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10601d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106028:	74 0a                	je     106034 <vsnprintf+0x35>
  10602a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10602d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106030:	39 c2                	cmp    %eax,%edx
  106032:	76 07                	jbe    10603b <vsnprintf+0x3c>
        return -E_INVAL;
  106034:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106039:	eb 2a                	jmp    106065 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10603b:	8b 45 14             	mov    0x14(%ebp),%eax
  10603e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106042:	8b 45 10             	mov    0x10(%ebp),%eax
  106045:	89 44 24 08          	mov    %eax,0x8(%esp)
  106049:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10604c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106050:	c7 04 24 8d 5f 10 00 	movl   $0x105f8d,(%esp)
  106057:	e8 53 fb ff ff       	call   105baf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10605c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10605f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106062:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106065:	c9                   	leave  
  106066:	c3                   	ret    

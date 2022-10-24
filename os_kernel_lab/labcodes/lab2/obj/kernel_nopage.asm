
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 b0 11 40       	mov    $0x4011b000,%eax
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
  100020:	a3 00 b0 11 00       	mov    %eax,0x11b000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 a0 11 00       	mov    $0x11a000,%esp
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
  100040:	b8 88 df 11 00       	mov    $0x11df88,%eax
  100045:	2d 36 aa 11 00       	sub    $0x11aa36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 aa 11 00 	movl   $0x11aa36,(%esp)
  10005d:	e8 2b 5d 00 00       	call   105d8d <memset>

    cons_init();                // init the console
  100062:	e8 4b 16 00 00       	call   1016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 c0 65 10 00 	movl   $0x1065c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 dc 65 10 00 	movl   $0x1065dc,(%esp)
  10007c:	e8 44 02 00 00       	call   1002c5 <cprintf>

    print_kerninfo();
  100081:	e8 02 09 00 00       	call   100988 <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 18 36 00 00       	call   1036a8 <pmm_init>

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
  100169:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 e1 65 10 00 	movl   $0x1065e1,(%esp)
  10017d:	e8 43 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 ef 65 10 00 	movl   $0x1065ef,(%esp)
  10019c:	e8 24 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 fd 65 10 00 	movl   $0x1065fd,(%esp)
  1001bb:	e8 05 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1001da:	e8 e6 00 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 19 66 10 00 	movl   $0x106619,(%esp)
  1001f9:	e8 c7 00 00 00       	call   1002c5 <cprintf>
    round ++;
  1001fe:	a1 00 d0 11 00       	mov    0x11d000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 d0 11 00       	mov    %eax,0x11d000
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
  10023a:	c7 04 24 28 66 10 00 	movl   $0x106628,(%esp)
  100241:	e8 7f 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_user();
  100246:	e8 c1 ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  10024b:	e8 fa fe ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100250:	c7 04 24 48 66 10 00 	movl   $0x106648,(%esp)
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
  1002bb:	e8 39 5e 00 00       	call   1060f9 <vprintfmt>
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
  10038f:	c7 04 24 67 66 10 00 	movl   $0x106667,(%esp)
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
  1003dd:	88 90 20 d0 11 00    	mov    %dl,0x11d020(%eax)
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
  10041b:	05 20 d0 11 00       	add    $0x11d020,%eax
  100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100423:	b8 20 d0 11 00       	mov    $0x11d020,%eax
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
  10043b:	a1 20 d4 11 00       	mov    0x11d420,%eax
  100440:	85 c0                	test   %eax,%eax
  100442:	75 5b                	jne    10049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100444:	c7 05 20 d4 11 00 01 	movl   $0x1,0x11d420
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
  100462:	c7 04 24 6a 66 10 00 	movl   $0x10666a,(%esp)
  100469:	e8 57 fe ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  10046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100471:	89 44 24 04          	mov    %eax,0x4(%esp)
  100475:	8b 45 10             	mov    0x10(%ebp),%eax
  100478:	89 04 24             	mov    %eax,(%esp)
  10047b:	e8 0e fe ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  100480:	c7 04 24 86 66 10 00 	movl   $0x106686,(%esp)
  100487:	e8 39 fe ff ff       	call   1002c5 <cprintf>
    
    cprintf("stack trackback:\n");
  10048c:	c7 04 24 88 66 10 00 	movl   $0x106688,(%esp)
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
  1004d1:	c7 04 24 9a 66 10 00 	movl   $0x10669a,(%esp)
  1004d8:	e8 e8 fd ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  1004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e7:	89 04 24             	mov    %eax,(%esp)
  1004ea:	e8 9f fd ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  1004ef:	c7 04 24 86 66 10 00 	movl   $0x106686,(%esp)
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
  100505:	a1 20 d4 11 00       	mov    0x11d420,%eax
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
  10066b:	c7 00 b8 66 10 00    	movl   $0x1066b8,(%eax)
    info->eip_line = 0;
  100671:	8b 45 0c             	mov    0xc(%ebp),%eax
  100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067e:	c7 40 08 b8 66 10 00 	movl   $0x1066b8,0x8(%eax)
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
  1006a2:	c7 45 f4 50 79 10 00 	movl   $0x107950,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006a9:	c7 45 f0 a0 46 11 00 	movl   $0x1146a0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b0:	c7 45 ec a1 46 11 00 	movl   $0x1146a1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b7:	c7 45 e8 dd 71 11 00 	movl   $0x1171dd,-0x18(%ebp)

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
  10080a:	e8 f2 53 00 00       	call   105c01 <strfind>
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
  100992:	c7 04 24 c2 66 10 00 	movl   $0x1066c2,(%esp)
  100999:	e8 27 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10099e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009a5:	00 
  1009a6:	c7 04 24 db 66 10 00 	movl   $0x1066db,(%esp)
  1009ad:	e8 13 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b2:	c7 44 24 04 b1 65 10 	movl   $0x1065b1,0x4(%esp)
  1009b9:	00 
  1009ba:	c7 04 24 f3 66 10 00 	movl   $0x1066f3,(%esp)
  1009c1:	e8 ff f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c6:	c7 44 24 04 36 aa 11 	movl   $0x11aa36,0x4(%esp)
  1009cd:	00 
  1009ce:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1009d5:	e8 eb f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009da:	c7 44 24 04 88 df 11 	movl   $0x11df88,0x4(%esp)
  1009e1:	00 
  1009e2:	c7 04 24 23 67 10 00 	movl   $0x106723,(%esp)
  1009e9:	e8 d7 f8 ff ff       	call   1002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ee:	b8 88 df 11 00       	mov    $0x11df88,%eax
  1009f3:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a03:	85 c0                	test   %eax,%eax
  100a05:	0f 48 c2             	cmovs  %edx,%eax
  100a08:	c1 f8 0a             	sar    $0xa,%eax
  100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0f:	c7 04 24 3c 67 10 00 	movl   $0x10673c,(%esp)
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
  100a48:	c7 04 24 66 67 10 00 	movl   $0x106766,(%esp)
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
  100ab6:	c7 04 24 82 67 10 00 	movl   $0x106782,(%esp)
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
  100b0f:	c7 04 24 94 67 10 00 	movl   $0x106794,(%esp)
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
  100b51:	c7 04 24 ac 67 10 00 	movl   $0x1067ac,(%esp)
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
  100bcc:	c7 04 24 50 68 10 00 	movl   $0x106850,(%esp)
  100bd3:	e8 f3 4f 00 00       	call   105bcb <strchr>
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
  100bf4:	c7 04 24 55 68 10 00 	movl   $0x106855,(%esp)
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
  100c36:	c7 04 24 50 68 10 00 	movl   $0x106850,(%esp)
  100c3d:	e8 89 4f 00 00       	call   105bcb <strchr>
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
  100c99:	05 00 a0 11 00       	add    $0x11a000,%eax
  100c9e:	8b 00                	mov    (%eax),%eax
  100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca4:	89 04 24             	mov    %eax,(%esp)
  100ca7:	e8 7b 4e 00 00       	call   105b27 <strcmp>
  100cac:	85 c0                	test   %eax,%eax
  100cae:	75 31                	jne    100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb3:	89 d0                	mov    %edx,%eax
  100cb5:	01 c0                	add    %eax,%eax
  100cb7:	01 d0                	add    %edx,%eax
  100cb9:	c1 e0 02             	shl    $0x2,%eax
  100cbc:	05 08 a0 11 00       	add    $0x11a008,%eax
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
  100cf3:	c7 04 24 73 68 10 00 	movl   $0x106873,(%esp)
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
  100d14:	c7 04 24 8c 68 10 00 	movl   $0x10688c,(%esp)
  100d1b:	e8 a5 f5 ff ff       	call   1002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d20:	c7 04 24 b4 68 10 00 	movl   $0x1068b4,(%esp)
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
  100d3d:	c7 04 24 d9 68 10 00 	movl   $0x1068d9,(%esp)
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
  100d8d:	05 04 a0 11 00       	add    $0x11a004,%eax
  100d92:	8b 08                	mov    (%eax),%ecx
  100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d97:	89 d0                	mov    %edx,%eax
  100d99:	01 c0                	add    %eax,%eax
  100d9b:	01 d0                	add    %edx,%eax
  100d9d:	c1 e0 02             	shl    $0x2,%eax
  100da0:	05 00 a0 11 00       	add    $0x11a000,%eax
  100da5:	8b 00                	mov    (%eax),%eax
  100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100daf:	c7 04 24 dd 68 10 00 	movl   $0x1068dd,(%esp)
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
  100e3f:	c7 05 0c df 11 00 00 	movl   $0x0,0x11df0c
  100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e49:	c7 04 24 e6 68 10 00 	movl   $0x1068e6,(%esp)
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
  100f29:	66 c7 05 46 d4 11 00 	movw   $0x3b4,0x11d446
  100f30:	b4 03 
  100f32:	eb 13                	jmp    100f47 <cga_init+0x58>
    } else {
        *cp = was;
  100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f3e:	66 c7 05 46 d4 11 00 	movw   $0x3d4,0x11d446
  100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f47:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f60:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
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
  100f86:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f9d:	ee                   	out    %al,(%dx)
}
  100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f9f:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
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
  100fc5:	a3 40 d4 11 00       	mov    %eax,0x11d440
    crt_pos = pos;
  100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fcd:	0f b7 c0             	movzwl %ax,%eax
  100fd0:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
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
  10108b:	a3 48 d4 11 00       	mov    %eax,0x11d448
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
  1010b0:	a1 48 d4 11 00       	mov    0x11d448,%eax
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
  1011cd:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011d4:	85 c0                	test   %eax,%eax
  1011d6:	0f 84 af 00 00 00    	je     10128b <cga_putc+0xff>
            crt_pos --;
  1011dc:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011e3:	48                   	dec    %eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f0:	98                   	cwtl   
  1011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011f6:	98                   	cwtl   
  1011f7:	83 c8 20             	or     $0x20,%eax
  1011fa:	98                   	cwtl   
  1011fb:	8b 15 40 d4 11 00    	mov    0x11d440,%edx
  101201:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  101208:	01 c9                	add    %ecx,%ecx
  10120a:	01 ca                	add    %ecx,%edx
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101212:	eb 77                	jmp    10128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101214:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10121b:	83 c0 50             	add    $0x50,%eax
  10121e:	0f b7 c0             	movzwl %ax,%eax
  101221:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101227:	0f b7 1d 44 d4 11 00 	movzwl 0x11d444,%ebx
  10122e:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
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
  101259:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
        break;
  10125f:	eb 2b                	jmp    10128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101261:	8b 0d 40 d4 11 00    	mov    0x11d440,%ecx
  101267:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10126e:	8d 50 01             	lea    0x1(%eax),%edx
  101271:	0f b7 d2             	movzwl %dx,%edx
  101274:	66 89 15 44 d4 11 00 	mov    %dx,0x11d444
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
  10128c:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101298:	76 5d                	jbe    1012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10129a:	a1 40 d4 11 00       	mov    0x11d440,%eax
  10129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012a5:	a1 40 d4 11 00       	mov    0x11d440,%eax
  1012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012b1:	00 
  1012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012b6:	89 04 24             	mov    %eax,(%esp)
  1012b9:	e8 12 4b 00 00       	call   105dd0 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012c5:	eb 14                	jmp    1012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c7:	a1 40 d4 11 00       	mov    0x11d440,%eax
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
  1012e4:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1012eb:	83 e8 50             	sub    $0x50,%eax
  1012ee:	0f b7 c0             	movzwl %ax,%eax
  1012f1:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f7:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  1012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101310:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101317:	c1 e8 08             	shr    $0x8,%eax
  10131a:	0f b7 c0             	movzwl %ax,%eax
  10131d:	0f b6 c0             	movzbl %al,%eax
  101320:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
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
  10133c:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101353:	ee                   	out    %al,(%dx)
}
  101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101355:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
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
  101436:	a1 64 d6 11 00       	mov    0x11d664,%eax
  10143b:	8d 50 01             	lea    0x1(%eax),%edx
  10143e:	89 15 64 d6 11 00    	mov    %edx,0x11d664
  101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101447:	88 90 60 d4 11 00    	mov    %dl,0x11d460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10144d:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101452:	3d 00 02 00 00       	cmp    $0x200,%eax
  101457:	75 0a                	jne    101463 <cons_intr+0x3f>
                cons.wpos = 0;
  101459:	c7 05 64 d6 11 00 00 	movl   $0x0,0x11d664
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
  1014da:	a1 48 d4 11 00       	mov    0x11d448,%eax
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
  10153f:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101544:	83 c8 40             	or     $0x40,%eax
  101547:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  10154c:	b8 00 00 00 00       	mov    $0x0,%eax
  101551:	e9 23 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155a:	84 c0                	test   %al,%al
  10155c:	79 45                	jns    1015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10155e:	a1 68 d6 11 00       	mov    0x11d668,%eax
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
  10157d:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  101584:	0c 40                	or     $0x40,%al
  101586:	0f b6 c0             	movzbl %al,%eax
  101589:	f7 d0                	not    %eax
  10158b:	89 c2                	mov    %eax,%edx
  10158d:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101592:	21 d0                	and    %edx,%eax
  101594:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  101599:	b8 00 00 00 00       	mov    $0x0,%eax
  10159e:	e9 d6 00 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015a3:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1015a8:	83 e0 40             	and    $0x40,%eax
  1015ab:	85 c0                	test   %eax,%eax
  1015ad:	74 11                	je     1015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015b3:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1015b8:	83 e0 bf             	and    $0xffffffbf,%eax
  1015bb:	a3 68 d6 11 00       	mov    %eax,0x11d668
    }

    shift |= shiftcode[data];
  1015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c4:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1015cb:	0f b6 d0             	movzbl %al,%edx
  1015ce:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1015d3:	09 d0                	or     %edx,%eax
  1015d5:	a3 68 d6 11 00       	mov    %eax,0x11d668
    shift ^= togglecode[data];
  1015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015de:	0f b6 80 40 a1 11 00 	movzbl 0x11a140(%eax),%eax
  1015e5:	0f b6 d0             	movzbl %al,%edx
  1015e8:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1015ed:	31 d0                	xor    %edx,%eax
  1015ef:	a3 68 d6 11 00       	mov    %eax,0x11d668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015f4:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1015f9:	83 e0 03             	and    $0x3,%eax
  1015fc:	8b 14 85 40 a5 11 00 	mov    0x11a540(,%eax,4),%edx
  101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101607:	01 d0                	add    %edx,%eax
  101609:	0f b6 00             	movzbl (%eax),%eax
  10160c:	0f b6 c0             	movzbl %al,%eax
  10160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101612:	a1 68 d6 11 00       	mov    0x11d668,%eax
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
  101640:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101645:	f7 d0                	not    %eax
  101647:	83 e0 06             	and    $0x6,%eax
  10164a:	85 c0                	test   %eax,%eax
  10164c:	75 28                	jne    101676 <kbd_proc_data+0x184>
  10164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101655:	75 1f                	jne    101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101657:	c7 04 24 01 69 10 00 	movl   $0x106901,(%esp)
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
  1016cb:	a1 48 d4 11 00       	mov    0x11d448,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	75 0c                	jne    1016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016d4:	c7 04 24 0d 69 10 00 	movl   $0x10690d,(%esp)
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
  101747:	8b 15 60 d6 11 00    	mov    0x11d660,%edx
  10174d:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101752:	39 c2                	cmp    %eax,%edx
  101754:	74 31                	je     101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101756:	a1 60 d6 11 00       	mov    0x11d660,%eax
  10175b:	8d 50 01             	lea    0x1(%eax),%edx
  10175e:	89 15 60 d6 11 00    	mov    %edx,0x11d660
  101764:	0f b6 80 60 d4 11 00 	movzbl 0x11d460(%eax),%eax
  10176b:	0f b6 c0             	movzbl %al,%eax
  10176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101771:	a1 60 d6 11 00       	mov    0x11d660,%eax
  101776:	3d 00 02 00 00       	cmp    $0x200,%eax
  10177b:	75 0a                	jne    101787 <cons_getc+0x63>
                cons.rpos = 0;
  10177d:	c7 05 60 d6 11 00 00 	movl   $0x0,0x11d660
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
  1017ab:	66 a3 50 a5 11 00    	mov    %ax,0x11a550
    if (did_init) {
  1017b1:	a1 6c d6 11 00       	mov    0x11d66c,%eax
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
  101814:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
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
  101837:	c7 05 6c d6 11 00 01 	movl   $0x1,0x11d66c
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
  101959:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101965:	74 0f                	je     101976 <pic_init+0x149>
        pic_setmask(irq_mask);
  101967:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
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
  1019a3:	c7 04 24 40 69 10 00 	movl   $0x106940,(%esp)
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
  1019cb:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  1019d2:	0f b7 d0             	movzwl %ax,%edx
  1019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d8:	66 89 14 c5 80 d6 11 	mov    %dx,0x11d680(,%eax,8)
  1019df:	00 
  1019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e3:	66 c7 04 c5 82 d6 11 	movw   $0x8,0x11d682(,%eax,8)
  1019ea:	00 08 00 
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  1019f7:	00 
  1019f8:	80 e2 e0             	and    $0xe0,%dl
  1019fb:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  101a0c:	00 
  101a0d:	80 e2 1f             	and    $0x1f,%dl
  101a10:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1a:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101a21:	00 
  101a22:	80 e2 f0             	and    $0xf0,%dl
  101a25:	80 ca 0e             	or     $0xe,%dl
  101a28:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101a39:	00 
  101a3a:	80 e2 ef             	and    $0xef,%dl
  101a3d:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a47:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101a4e:	00 
  101a4f:	80 e2 9f             	and    $0x9f,%dl
  101a52:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5c:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101a63:	00 
  101a64:	80 ca 80             	or     $0x80,%dl
  101a67:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a71:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  101a78:	c1 e8 10             	shr    $0x10,%eax
  101a7b:	0f b7 d0             	movzwl %ax,%edx
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	66 89 14 c5 86 d6 11 	mov    %dx,0x11d686(,%eax,8)
  101a88:	00 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  101a89:	ff 45 fc             	incl   -0x4(%ebp)
  101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a94:	0f 86 2e ff ff ff    	jbe    1019c8 <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
  101a9a:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  101a9f:	0f b7 c0             	movzwl %ax,%eax
  101aa2:	66 a3 80 da 11 00    	mov    %ax,0x11da80
  101aa8:	66 c7 05 82 da 11 00 	movw   $0x8,0x11da82
  101aaf:	08 00 
  101ab1:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  101ab8:	24 e0                	and    $0xe0,%al
  101aba:	a2 84 da 11 00       	mov    %al,0x11da84
  101abf:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  101ac6:	24 1f                	and    $0x1f,%al
  101ac8:	a2 84 da 11 00       	mov    %al,0x11da84
  101acd:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101ad4:	0c 0f                	or     $0xf,%al
  101ad6:	a2 85 da 11 00       	mov    %al,0x11da85
  101adb:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101ae2:	24 ef                	and    $0xef,%al
  101ae4:	a2 85 da 11 00       	mov    %al,0x11da85
  101ae9:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101af0:	0c 60                	or     $0x60,%al
  101af2:	a2 85 da 11 00       	mov    %al,0x11da85
  101af7:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101afe:	0c 80                	or     $0x80,%al
  101b00:	a2 85 da 11 00       	mov    %al,0x11da85
  101b05:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  101b0a:	c1 e8 10             	shr    $0x10,%eax
  101b0d:	0f b7 c0             	movzwl %ax,%eax
  101b10:	66 a3 86 da 11 00    	mov    %ax,0x11da86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101b16:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101b1b:	0f b7 c0             	movzwl %ax,%eax
  101b1e:	66 a3 48 da 11 00    	mov    %ax,0x11da48
  101b24:	66 c7 05 4a da 11 00 	movw   $0x8,0x11da4a
  101b2b:	08 00 
  101b2d:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101b34:	24 e0                	and    $0xe0,%al
  101b36:	a2 4c da 11 00       	mov    %al,0x11da4c
  101b3b:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101b42:	24 1f                	and    $0x1f,%al
  101b44:	a2 4c da 11 00       	mov    %al,0x11da4c
  101b49:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101b50:	24 f0                	and    $0xf0,%al
  101b52:	0c 0e                	or     $0xe,%al
  101b54:	a2 4d da 11 00       	mov    %al,0x11da4d
  101b59:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101b60:	24 ef                	and    $0xef,%al
  101b62:	a2 4d da 11 00       	mov    %al,0x11da4d
  101b67:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101b6e:	0c 60                	or     $0x60,%al
  101b70:	a2 4d da 11 00       	mov    %al,0x11da4d
  101b75:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101b7c:	0c 80                	or     $0x80,%al
  101b7e:	a2 4d da 11 00       	mov    %al,0x11da4d
  101b83:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101b88:	c1 e8 10             	shr    $0x10,%eax
  101b8b:	0f b7 c0             	movzwl %ax,%eax
  101b8e:	66 a3 4e da 11 00    	mov    %ax,0x11da4e
  101b94:	c7 45 f8 60 a5 11 00 	movl   $0x11a560,-0x8(%ebp)
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
  101bb7:	8b 04 85 c0 6c 10 00 	mov    0x106cc0(,%eax,4),%eax
  101bbe:	eb 18                	jmp    101bd8 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101bc0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101bc4:	7e 0d                	jle    101bd3 <trapname+0x2e>
  101bc6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bca:	7f 07                	jg     101bd3 <trapname+0x2e>
        return "Hardware Interrupt";
  101bcc:	b8 4a 69 10 00       	mov    $0x10694a,%eax
  101bd1:	eb 05                	jmp    101bd8 <trapname+0x33>
    }
    return "(unknown trap)";
  101bd3:	b8 5d 69 10 00       	mov    $0x10695d,%eax
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
  101c04:	c7 04 24 9e 69 10 00 	movl   $0x10699e,(%esp)
  101c0b:	e8 b5 e6 ff ff       	call   1002c5 <cprintf>
    print_regs(&tf->tf_regs);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	89 04 24             	mov    %eax,(%esp)
  101c16:	e8 8d 01 00 00       	call   101da8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 af 69 10 00 	movl   $0x1069af,(%esp)
  101c2d:	e8 93 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3d:	c7 04 24 c2 69 10 00 	movl   $0x1069c2,(%esp)
  101c44:	e8 7c e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 d5 69 10 00 	movl   $0x1069d5,(%esp)
  101c5b:	e8 65 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 e8 69 10 00 	movl   $0x1069e8,(%esp)
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
  101c93:	c7 04 24 fb 69 10 00 	movl   $0x1069fb,(%esp)
  101c9a:	e8 26 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca2:	8b 40 34             	mov    0x34(%eax),%eax
  101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca9:	c7 04 24 0d 6a 10 00 	movl   $0x106a0d,(%esp)
  101cb0:	e8 10 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb8:	8b 40 38             	mov    0x38(%eax),%eax
  101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbf:	c7 04 24 1c 6a 10 00 	movl   $0x106a1c,(%esp)
  101cc6:	e8 fa e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd6:	c7 04 24 2b 6a 10 00 	movl   $0x106a2b,(%esp)
  101cdd:	e8 e3 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce5:	8b 40 40             	mov    0x40(%eax),%eax
  101ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cec:	c7 04 24 3e 6a 10 00 	movl   $0x106a3e,(%esp)
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
  101d1a:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101d21:	85 c0                	test   %eax,%eax
  101d23:	74 1a                	je     101d3f <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d28:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d33:	c7 04 24 4d 6a 10 00 	movl   $0x106a4d,(%esp)
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
  101d5d:	c7 04 24 51 6a 10 00 	movl   $0x106a51,(%esp)
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
  101d82:	c7 04 24 5a 6a 10 00 	movl   $0x106a5a,(%esp)
  101d89:	e8 37 e5 ff ff       	call   1002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d99:	c7 04 24 69 6a 10 00 	movl   $0x106a69,(%esp)
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
  101dbb:	c7 04 24 7c 6a 10 00 	movl   $0x106a7c,(%esp)
  101dc2:	e8 fe e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	8b 40 04             	mov    0x4(%eax),%eax
  101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd1:	c7 04 24 8b 6a 10 00 	movl   $0x106a8b,(%esp)
  101dd8:	e8 e8 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	8b 40 08             	mov    0x8(%eax),%eax
  101de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de7:	c7 04 24 9a 6a 10 00 	movl   $0x106a9a,(%esp)
  101dee:	e8 d2 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	8b 40 0c             	mov    0xc(%eax),%eax
  101df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dfd:	c7 04 24 a9 6a 10 00 	movl   $0x106aa9,(%esp)
  101e04:	e8 bc e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e09:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0c:	8b 40 10             	mov    0x10(%eax),%eax
  101e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e13:	c7 04 24 b8 6a 10 00 	movl   $0x106ab8,(%esp)
  101e1a:	e8 a6 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e22:	8b 40 14             	mov    0x14(%eax),%eax
  101e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e29:	c7 04 24 c7 6a 10 00 	movl   $0x106ac7,(%esp)
  101e30:	e8 90 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	8b 40 18             	mov    0x18(%eax),%eax
  101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e3f:	c7 04 24 d6 6a 10 00 	movl   $0x106ad6,(%esp)
  101e46:	e8 7a e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e55:	c7 04 24 e5 6a 10 00 	movl   $0x106ae5,(%esp)
  101e5c:	e8 64 e4 ff ff       	call   1002c5 <cprintf>
}
  101e61:	90                   	nop
  101e62:	c9                   	leave  
  101e63:	c3                   	ret    

00101e64 <trap_dispatch>:
}


/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e64:	f3 0f 1e fb          	endbr32 
  101e68:	55                   	push   %ebp
  101e69:	89 e5                	mov    %esp,%ebp
  101e6b:	57                   	push   %edi
  101e6c:	56                   	push   %esi
  101e6d:	53                   	push   %ebx
  101e6e:	83 ec 3c             	sub    $0x3c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e71:	8b 45 08             	mov    0x8(%ebp),%eax
  101e74:	8b 40 30             	mov    0x30(%eax),%eax
  101e77:	83 f8 79             	cmp    $0x79,%eax
  101e7a:	0f 84 ac 03 00 00    	je     10222c <trap_dispatch+0x3c8>
  101e80:	83 f8 79             	cmp    $0x79,%eax
  101e83:	0f 87 31 04 00 00    	ja     1022ba <trap_dispatch+0x456>
  101e89:	83 f8 78             	cmp    $0x78,%eax
  101e8c:	0f 84 af 02 00 00    	je     102141 <trap_dispatch+0x2dd>
  101e92:	83 f8 78             	cmp    $0x78,%eax
  101e95:	0f 87 1f 04 00 00    	ja     1022ba <trap_dispatch+0x456>
  101e9b:	83 f8 2f             	cmp    $0x2f,%eax
  101e9e:	0f 87 16 04 00 00    	ja     1022ba <trap_dispatch+0x456>
  101ea4:	83 f8 2e             	cmp    $0x2e,%eax
  101ea7:	0f 83 42 04 00 00    	jae    1022ef <trap_dispatch+0x48b>
  101ead:	83 f8 24             	cmp    $0x24,%eax
  101eb0:	74 5e                	je     101f10 <trap_dispatch+0xac>
  101eb2:	83 f8 24             	cmp    $0x24,%eax
  101eb5:	0f 87 ff 03 00 00    	ja     1022ba <trap_dispatch+0x456>
  101ebb:	83 f8 20             	cmp    $0x20,%eax
  101ebe:	74 0a                	je     101eca <trap_dispatch+0x66>
  101ec0:	83 f8 21             	cmp    $0x21,%eax
  101ec3:	74 74                	je     101f39 <trap_dispatch+0xd5>
  101ec5:	e9 f0 03 00 00       	jmp    1022ba <trap_dispatch+0x456>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101eca:	a1 0c df 11 00       	mov    0x11df0c,%eax
  101ecf:	40                   	inc    %eax
  101ed0:	a3 0c df 11 00       	mov    %eax,0x11df0c
        if(ticks%100==0){
  101ed5:	8b 0d 0c df 11 00    	mov    0x11df0c,%ecx
  101edb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ee0:	89 c8                	mov    %ecx,%eax
  101ee2:	f7 e2                	mul    %edx
  101ee4:	c1 ea 05             	shr    $0x5,%edx
  101ee7:	89 d0                	mov    %edx,%eax
  101ee9:	c1 e0 02             	shl    $0x2,%eax
  101eec:	01 d0                	add    %edx,%eax
  101eee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101ef5:	01 d0                	add    %edx,%eax
  101ef7:	c1 e0 02             	shl    $0x2,%eax
  101efa:	29 c1                	sub    %eax,%ecx
  101efc:	89 ca                	mov    %ecx,%edx
  101efe:	85 d2                	test   %edx,%edx
  101f00:	0f 85 ec 03 00 00    	jne    1022f2 <trap_dispatch+0x48e>
            print_ticks();
  101f06:	e8 86 fa ff ff       	call   101991 <print_ticks>
        }
        break;
  101f0b:	e9 e2 03 00 00       	jmp    1022f2 <trap_dispatch+0x48e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f10:	e8 0f f8 ff ff       	call   101724 <cons_getc>
  101f15:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f18:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101f1c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f20:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f28:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  101f2f:	e8 91 e3 ff ff       	call   1002c5 <cprintf>
        break;
  101f34:	e9 bd 03 00 00       	jmp    1022f6 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f39:	e8 e6 f7 ff ff       	call   101724 <cons_getc>
  101f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f41:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101f45:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f49:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f51:	c7 04 24 06 6b 10 00 	movl   $0x106b06,(%esp)
  101f58:	e8 68 e3 ff ff       	call   1002c5 <cprintf>
        if (c == '0'&&!trap_in_kernel(tf)) {
  101f5d:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101f61:	0f 85 bb 00 00 00    	jne    102022 <trap_dispatch+0x1be>
  101f67:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6a:	89 04 24             	mov    %eax,(%esp)
  101f6d:	e8 68 fc ff ff       	call   101bda <trap_in_kernel>
  101f72:	85 c0                	test   %eax,%eax
  101f74:	0f 85 a8 00 00 00    	jne    102022 <trap_dispatch+0x1be>
  101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  101f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f87:	83 f8 08             	cmp    $0x8,%eax
  101f8a:	74 79                	je     102005 <trap_dispatch+0x1a1>
        tf->tf_cs = KERNEL_CS;
  101f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f8f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  101f95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f98:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fa1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fa8:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101faf:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fb6:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fbd:	8b 40 40             	mov    0x40(%eax),%eax
  101fc0:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101fc5:	89 c2                	mov    %eax,%edx
  101fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fca:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fd0:	8b 40 44             	mov    0x44(%eax),%eax
  101fd3:	83 e8 44             	sub    $0x44,%eax
  101fd6:	a3 6c df 11 00       	mov    %eax,0x11df6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101fdb:	a1 6c df 11 00       	mov    0x11df6c,%eax
  101fe0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fe7:	00 
  101fe8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101feb:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fef:	89 04 24             	mov    %eax,(%esp)
  101ff2:	e8 d9 3d 00 00       	call   105dd0 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ff7:	8b 15 6c df 11 00    	mov    0x11df6c,%edx
  101ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102000:	83 e8 04             	sub    $0x4,%eax
  102003:	89 10                	mov    %edx,(%eax)
}
  102005:	90                   	nop
        //切换为内核态
        switch_to_kernel(tf);
        cprintf("user to kernel\n");
  102006:	c7 04 24 15 6b 10 00 	movl   $0x106b15,(%esp)
  10200d:	e8 b3 e2 ff ff       	call   1002c5 <cprintf>
        print_trapframe(tf);
  102012:	8b 45 08             	mov    0x8(%ebp),%eax
  102015:	89 04 24             	mov    %eax,(%esp)
  102018:	e8 d6 fb ff ff       	call   101bf3 <print_trapframe>
        //切换为用户态
        switch_to_user(tf);
        cprintf("kernel to user\n");
        print_trapframe(tf);
        }
        break;
  10201d:	e9 d3 02 00 00       	jmp    1022f5 <trap_dispatch+0x491>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
  102022:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  102026:	0f 85 c9 02 00 00    	jne    1022f5 <trap_dispatch+0x491>
  10202c:	8b 45 08             	mov    0x8(%ebp),%eax
  10202f:	89 04 24             	mov    %eax,(%esp)
  102032:	e8 a3 fb ff ff       	call   101bda <trap_in_kernel>
  102037:	85 c0                	test   %eax,%eax
  102039:	0f 84 b6 02 00 00    	je     1022f5 <trap_dispatch+0x491>
  10203f:	8b 45 08             	mov    0x8(%ebp),%eax
  102042:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (tf->tf_cs != USER_CS) {
  102045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102048:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10204c:	83 f8 1b             	cmp    $0x1b,%eax
  10204f:	0f 84 cf 00 00 00    	je     102124 <trap_dispatch+0x2c0>
        switchk2u = *tf;
  102055:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102058:	b8 20 df 11 00       	mov    $0x11df20,%eax
  10205d:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102062:	89 c1                	mov    %eax,%ecx
  102064:	83 e1 01             	and    $0x1,%ecx
  102067:	85 c9                	test   %ecx,%ecx
  102069:	74 0c                	je     102077 <trap_dispatch+0x213>
  10206b:	0f b6 0a             	movzbl (%edx),%ecx
  10206e:	88 08                	mov    %cl,(%eax)
  102070:	8d 40 01             	lea    0x1(%eax),%eax
  102073:	8d 52 01             	lea    0x1(%edx),%edx
  102076:	4b                   	dec    %ebx
  102077:	89 c1                	mov    %eax,%ecx
  102079:	83 e1 02             	and    $0x2,%ecx
  10207c:	85 c9                	test   %ecx,%ecx
  10207e:	74 0f                	je     10208f <trap_dispatch+0x22b>
  102080:	0f b7 0a             	movzwl (%edx),%ecx
  102083:	66 89 08             	mov    %cx,(%eax)
  102086:	8d 40 02             	lea    0x2(%eax),%eax
  102089:	8d 52 02             	lea    0x2(%edx),%edx
  10208c:	83 eb 02             	sub    $0x2,%ebx
  10208f:	89 df                	mov    %ebx,%edi
  102091:	83 e7 fc             	and    $0xfffffffc,%edi
  102094:	b9 00 00 00 00       	mov    $0x0,%ecx
  102099:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  10209c:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  10209f:	83 c1 04             	add    $0x4,%ecx
  1020a2:	39 f9                	cmp    %edi,%ecx
  1020a4:	72 f3                	jb     102099 <trap_dispatch+0x235>
  1020a6:	01 c8                	add    %ecx,%eax
  1020a8:	01 ca                	add    %ecx,%edx
  1020aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  1020af:	89 de                	mov    %ebx,%esi
  1020b1:	83 e6 02             	and    $0x2,%esi
  1020b4:	85 f6                	test   %esi,%esi
  1020b6:	74 0b                	je     1020c3 <trap_dispatch+0x25f>
  1020b8:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  1020bc:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  1020c0:	83 c1 02             	add    $0x2,%ecx
  1020c3:	83 e3 01             	and    $0x1,%ebx
  1020c6:	85 db                	test   %ebx,%ebx
  1020c8:	74 07                	je     1020d1 <trap_dispatch+0x26d>
  1020ca:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  1020ce:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  1020d1:	66 c7 05 5c df 11 00 	movw   $0x1b,0x11df5c
  1020d8:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  1020da:	66 c7 05 68 df 11 00 	movw   $0x23,0x11df68
  1020e1:	23 00 
  1020e3:	0f b7 05 68 df 11 00 	movzwl 0x11df68,%eax
  1020ea:	66 a3 48 df 11 00    	mov    %ax,0x11df48
  1020f0:	0f b7 05 48 df 11 00 	movzwl 0x11df48,%eax
  1020f7:	66 a3 4c df 11 00    	mov    %ax,0x11df4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  1020fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102100:	83 c0 4c             	add    $0x4c,%eax
  102103:	a3 64 df 11 00       	mov    %eax,0x11df64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  102108:	a1 60 df 11 00       	mov    0x11df60,%eax
  10210d:	0d 00 30 00 00       	or     $0x3000,%eax
  102112:	a3 60 df 11 00       	mov    %eax,0x11df60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102117:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10211a:	83 e8 04             	sub    $0x4,%eax
  10211d:	ba 20 df 11 00       	mov    $0x11df20,%edx
  102122:	89 10                	mov    %edx,(%eax)
}
  102124:	90                   	nop
        cprintf("kernel to user\n");
  102125:	c7 04 24 25 6b 10 00 	movl   $0x106b25,(%esp)
  10212c:	e8 94 e1 ff ff       	call   1002c5 <cprintf>
        print_trapframe(tf);
  102131:	8b 45 08             	mov    0x8(%ebp),%eax
  102134:	89 04 24             	mov    %eax,(%esp)
  102137:	e8 b7 fa ff ff       	call   101bf3 <print_trapframe>
        break;
  10213c:	e9 b4 01 00 00       	jmp    1022f5 <trap_dispatch+0x491>
  102141:	8b 45 08             	mov    0x8(%ebp),%eax
  102144:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (tf->tf_cs != USER_CS) {
  102147:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10214a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10214e:	83 f8 1b             	cmp    $0x1b,%eax
  102151:	0f 84 cf 00 00 00    	je     102226 <trap_dispatch+0x3c2>
        switchk2u = *tf;
  102157:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10215a:	b8 20 df 11 00       	mov    $0x11df20,%eax
  10215f:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102164:	89 c1                	mov    %eax,%ecx
  102166:	83 e1 01             	and    $0x1,%ecx
  102169:	85 c9                	test   %ecx,%ecx
  10216b:	74 0c                	je     102179 <trap_dispatch+0x315>
  10216d:	0f b6 0a             	movzbl (%edx),%ecx
  102170:	88 08                	mov    %cl,(%eax)
  102172:	8d 40 01             	lea    0x1(%eax),%eax
  102175:	8d 52 01             	lea    0x1(%edx),%edx
  102178:	4b                   	dec    %ebx
  102179:	89 c1                	mov    %eax,%ecx
  10217b:	83 e1 02             	and    $0x2,%ecx
  10217e:	85 c9                	test   %ecx,%ecx
  102180:	74 0f                	je     102191 <trap_dispatch+0x32d>
  102182:	0f b7 0a             	movzwl (%edx),%ecx
  102185:	66 89 08             	mov    %cx,(%eax)
  102188:	8d 40 02             	lea    0x2(%eax),%eax
  10218b:	8d 52 02             	lea    0x2(%edx),%edx
  10218e:	83 eb 02             	sub    $0x2,%ebx
  102191:	89 df                	mov    %ebx,%edi
  102193:	83 e7 fc             	and    $0xfffffffc,%edi
  102196:	b9 00 00 00 00       	mov    $0x0,%ecx
  10219b:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  10219e:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  1021a1:	83 c1 04             	add    $0x4,%ecx
  1021a4:	39 f9                	cmp    %edi,%ecx
  1021a6:	72 f3                	jb     10219b <trap_dispatch+0x337>
  1021a8:	01 c8                	add    %ecx,%eax
  1021aa:	01 ca                	add    %ecx,%edx
  1021ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  1021b1:	89 de                	mov    %ebx,%esi
  1021b3:	83 e6 02             	and    $0x2,%esi
  1021b6:	85 f6                	test   %esi,%esi
  1021b8:	74 0b                	je     1021c5 <trap_dispatch+0x361>
  1021ba:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  1021be:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  1021c2:	83 c1 02             	add    $0x2,%ecx
  1021c5:	83 e3 01             	and    $0x1,%ebx
  1021c8:	85 db                	test   %ebx,%ebx
  1021ca:	74 07                	je     1021d3 <trap_dispatch+0x36f>
  1021cc:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  1021d0:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  1021d3:	66 c7 05 5c df 11 00 	movw   $0x1b,0x11df5c
  1021da:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  1021dc:	66 c7 05 68 df 11 00 	movw   $0x23,0x11df68
  1021e3:	23 00 
  1021e5:	0f b7 05 68 df 11 00 	movzwl 0x11df68,%eax
  1021ec:	66 a3 48 df 11 00    	mov    %ax,0x11df48
  1021f2:	0f b7 05 48 df 11 00 	movzwl 0x11df48,%eax
  1021f9:	66 a3 4c df 11 00    	mov    %ax,0x11df4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  1021ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102202:	83 c0 4c             	add    $0x4c,%eax
  102205:	a3 64 df 11 00       	mov    %eax,0x11df64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  10220a:	a1 60 df 11 00       	mov    0x11df60,%eax
  10220f:	0d 00 30 00 00       	or     $0x3000,%eax
  102214:	a3 60 df 11 00       	mov    %eax,0x11df60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102219:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10221c:	83 e8 04             	sub    $0x4,%eax
  10221f:	ba 20 df 11 00       	mov    $0x11df20,%edx
  102224:	89 10                	mov    %edx,(%eax)
}
  102226:	90                   	nop
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switch_to_user(tf);
        break;
  102227:	e9 ca 00 00 00       	jmp    1022f6 <trap_dispatch+0x492>
  10222c:	8b 45 08             	mov    0x8(%ebp),%eax
  10222f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  102232:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102235:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102239:	83 f8 08             	cmp    $0x8,%eax
  10223c:	74 79                	je     1022b7 <trap_dispatch+0x453>
        tf->tf_cs = KERNEL_CS;
  10223e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102241:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  102247:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10224a:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  102250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102253:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  102257:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10225a:	66 89 50 28          	mov    %dx,0x28(%eax)
  10225e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102261:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102268:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  10226c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10226f:	8b 40 40             	mov    0x40(%eax),%eax
  102272:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  102277:	89 c2                	mov    %eax,%edx
  102279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10227c:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  10227f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102282:	8b 40 44             	mov    0x44(%eax),%eax
  102285:	83 e8 44             	sub    $0x44,%eax
  102288:	a3 6c df 11 00       	mov    %eax,0x11df6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  10228d:	a1 6c df 11 00       	mov    0x11df6c,%eax
  102292:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  102299:	00 
  10229a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10229d:	89 54 24 04          	mov    %edx,0x4(%esp)
  1022a1:	89 04 24             	mov    %eax,(%esp)
  1022a4:	e8 27 3b 00 00       	call   105dd0 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  1022a9:	8b 15 6c df 11 00    	mov    0x11df6c,%edx
  1022af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1022b2:	83 e8 04             	sub    $0x4,%eax
  1022b5:	89 10                	mov    %edx,(%eax)
}
  1022b7:	90                   	nop
    case T_SWITCH_TOK:
        switch_to_kernel(tf);
        break;
  1022b8:	eb 3c                	jmp    1022f6 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1022bd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1022c1:	83 e0 03             	and    $0x3,%eax
  1022c4:	85 c0                	test   %eax,%eax
  1022c6:	75 2e                	jne    1022f6 <trap_dispatch+0x492>
            print_trapframe(tf);
  1022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1022cb:	89 04 24             	mov    %eax,(%esp)
  1022ce:	e8 20 f9 ff ff       	call   101bf3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1022d3:	c7 44 24 08 35 6b 10 	movl   $0x106b35,0x8(%esp)
  1022da:	00 
  1022db:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1022e2:	00 
  1022e3:	c7 04 24 51 6b 10 00 	movl   $0x106b51,(%esp)
  1022ea:	e8 42 e1 ff ff       	call   100431 <__panic>
        break;
  1022ef:	90                   	nop
  1022f0:	eb 04                	jmp    1022f6 <trap_dispatch+0x492>
        break;
  1022f2:	90                   	nop
  1022f3:	eb 01                	jmp    1022f6 <trap_dispatch+0x492>
        break;
  1022f5:	90                   	nop
        }
    }
}
  1022f6:	90                   	nop
  1022f7:	83 c4 3c             	add    $0x3c,%esp
  1022fa:	5b                   	pop    %ebx
  1022fb:	5e                   	pop    %esi
  1022fc:	5f                   	pop    %edi
  1022fd:	5d                   	pop    %ebp
  1022fe:	c3                   	ret    

001022ff <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1022ff:	f3 0f 1e fb          	endbr32 
  102303:	55                   	push   %ebp
  102304:	89 e5                	mov    %esp,%ebp
  102306:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102309:	8b 45 08             	mov    0x8(%ebp),%eax
  10230c:	89 04 24             	mov    %eax,(%esp)
  10230f:	e8 50 fb ff ff       	call   101e64 <trap_dispatch>
}
  102314:	90                   	nop
  102315:	c9                   	leave  
  102316:	c3                   	ret    

00102317 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $0
  102319:	6a 00                	push   $0x0
  jmp __alltraps
  10231b:	e9 69 0a 00 00       	jmp    102d89 <__alltraps>

00102320 <vector1>:
.globl vector1
vector1:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $1
  102322:	6a 01                	push   $0x1
  jmp __alltraps
  102324:	e9 60 0a 00 00       	jmp    102d89 <__alltraps>

00102329 <vector2>:
.globl vector2
vector2:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $2
  10232b:	6a 02                	push   $0x2
  jmp __alltraps
  10232d:	e9 57 0a 00 00       	jmp    102d89 <__alltraps>

00102332 <vector3>:
.globl vector3
vector3:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $3
  102334:	6a 03                	push   $0x3
  jmp __alltraps
  102336:	e9 4e 0a 00 00       	jmp    102d89 <__alltraps>

0010233b <vector4>:
.globl vector4
vector4:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $4
  10233d:	6a 04                	push   $0x4
  jmp __alltraps
  10233f:	e9 45 0a 00 00       	jmp    102d89 <__alltraps>

00102344 <vector5>:
.globl vector5
vector5:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $5
  102346:	6a 05                	push   $0x5
  jmp __alltraps
  102348:	e9 3c 0a 00 00       	jmp    102d89 <__alltraps>

0010234d <vector6>:
.globl vector6
vector6:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $6
  10234f:	6a 06                	push   $0x6
  jmp __alltraps
  102351:	e9 33 0a 00 00       	jmp    102d89 <__alltraps>

00102356 <vector7>:
.globl vector7
vector7:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $7
  102358:	6a 07                	push   $0x7
  jmp __alltraps
  10235a:	e9 2a 0a 00 00       	jmp    102d89 <__alltraps>

0010235f <vector8>:
.globl vector8
vector8:
  pushl $8
  10235f:	6a 08                	push   $0x8
  jmp __alltraps
  102361:	e9 23 0a 00 00       	jmp    102d89 <__alltraps>

00102366 <vector9>:
.globl vector9
vector9:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $9
  102368:	6a 09                	push   $0x9
  jmp __alltraps
  10236a:	e9 1a 0a 00 00       	jmp    102d89 <__alltraps>

0010236f <vector10>:
.globl vector10
vector10:
  pushl $10
  10236f:	6a 0a                	push   $0xa
  jmp __alltraps
  102371:	e9 13 0a 00 00       	jmp    102d89 <__alltraps>

00102376 <vector11>:
.globl vector11
vector11:
  pushl $11
  102376:	6a 0b                	push   $0xb
  jmp __alltraps
  102378:	e9 0c 0a 00 00       	jmp    102d89 <__alltraps>

0010237d <vector12>:
.globl vector12
vector12:
  pushl $12
  10237d:	6a 0c                	push   $0xc
  jmp __alltraps
  10237f:	e9 05 0a 00 00       	jmp    102d89 <__alltraps>

00102384 <vector13>:
.globl vector13
vector13:
  pushl $13
  102384:	6a 0d                	push   $0xd
  jmp __alltraps
  102386:	e9 fe 09 00 00       	jmp    102d89 <__alltraps>

0010238b <vector14>:
.globl vector14
vector14:
  pushl $14
  10238b:	6a 0e                	push   $0xe
  jmp __alltraps
  10238d:	e9 f7 09 00 00       	jmp    102d89 <__alltraps>

00102392 <vector15>:
.globl vector15
vector15:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $15
  102394:	6a 0f                	push   $0xf
  jmp __alltraps
  102396:	e9 ee 09 00 00       	jmp    102d89 <__alltraps>

0010239b <vector16>:
.globl vector16
vector16:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $16
  10239d:	6a 10                	push   $0x10
  jmp __alltraps
  10239f:	e9 e5 09 00 00       	jmp    102d89 <__alltraps>

001023a4 <vector17>:
.globl vector17
vector17:
  pushl $17
  1023a4:	6a 11                	push   $0x11
  jmp __alltraps
  1023a6:	e9 de 09 00 00       	jmp    102d89 <__alltraps>

001023ab <vector18>:
.globl vector18
vector18:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $18
  1023ad:	6a 12                	push   $0x12
  jmp __alltraps
  1023af:	e9 d5 09 00 00       	jmp    102d89 <__alltraps>

001023b4 <vector19>:
.globl vector19
vector19:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $19
  1023b6:	6a 13                	push   $0x13
  jmp __alltraps
  1023b8:	e9 cc 09 00 00       	jmp    102d89 <__alltraps>

001023bd <vector20>:
.globl vector20
vector20:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $20
  1023bf:	6a 14                	push   $0x14
  jmp __alltraps
  1023c1:	e9 c3 09 00 00       	jmp    102d89 <__alltraps>

001023c6 <vector21>:
.globl vector21
vector21:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $21
  1023c8:	6a 15                	push   $0x15
  jmp __alltraps
  1023ca:	e9 ba 09 00 00       	jmp    102d89 <__alltraps>

001023cf <vector22>:
.globl vector22
vector22:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $22
  1023d1:	6a 16                	push   $0x16
  jmp __alltraps
  1023d3:	e9 b1 09 00 00       	jmp    102d89 <__alltraps>

001023d8 <vector23>:
.globl vector23
vector23:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $23
  1023da:	6a 17                	push   $0x17
  jmp __alltraps
  1023dc:	e9 a8 09 00 00       	jmp    102d89 <__alltraps>

001023e1 <vector24>:
.globl vector24
vector24:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $24
  1023e3:	6a 18                	push   $0x18
  jmp __alltraps
  1023e5:	e9 9f 09 00 00       	jmp    102d89 <__alltraps>

001023ea <vector25>:
.globl vector25
vector25:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $25
  1023ec:	6a 19                	push   $0x19
  jmp __alltraps
  1023ee:	e9 96 09 00 00       	jmp    102d89 <__alltraps>

001023f3 <vector26>:
.globl vector26
vector26:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $26
  1023f5:	6a 1a                	push   $0x1a
  jmp __alltraps
  1023f7:	e9 8d 09 00 00       	jmp    102d89 <__alltraps>

001023fc <vector27>:
.globl vector27
vector27:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $27
  1023fe:	6a 1b                	push   $0x1b
  jmp __alltraps
  102400:	e9 84 09 00 00       	jmp    102d89 <__alltraps>

00102405 <vector28>:
.globl vector28
vector28:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $28
  102407:	6a 1c                	push   $0x1c
  jmp __alltraps
  102409:	e9 7b 09 00 00       	jmp    102d89 <__alltraps>

0010240e <vector29>:
.globl vector29
vector29:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $29
  102410:	6a 1d                	push   $0x1d
  jmp __alltraps
  102412:	e9 72 09 00 00       	jmp    102d89 <__alltraps>

00102417 <vector30>:
.globl vector30
vector30:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $30
  102419:	6a 1e                	push   $0x1e
  jmp __alltraps
  10241b:	e9 69 09 00 00       	jmp    102d89 <__alltraps>

00102420 <vector31>:
.globl vector31
vector31:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $31
  102422:	6a 1f                	push   $0x1f
  jmp __alltraps
  102424:	e9 60 09 00 00       	jmp    102d89 <__alltraps>

00102429 <vector32>:
.globl vector32
vector32:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $32
  10242b:	6a 20                	push   $0x20
  jmp __alltraps
  10242d:	e9 57 09 00 00       	jmp    102d89 <__alltraps>

00102432 <vector33>:
.globl vector33
vector33:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $33
  102434:	6a 21                	push   $0x21
  jmp __alltraps
  102436:	e9 4e 09 00 00       	jmp    102d89 <__alltraps>

0010243b <vector34>:
.globl vector34
vector34:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $34
  10243d:	6a 22                	push   $0x22
  jmp __alltraps
  10243f:	e9 45 09 00 00       	jmp    102d89 <__alltraps>

00102444 <vector35>:
.globl vector35
vector35:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $35
  102446:	6a 23                	push   $0x23
  jmp __alltraps
  102448:	e9 3c 09 00 00       	jmp    102d89 <__alltraps>

0010244d <vector36>:
.globl vector36
vector36:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $36
  10244f:	6a 24                	push   $0x24
  jmp __alltraps
  102451:	e9 33 09 00 00       	jmp    102d89 <__alltraps>

00102456 <vector37>:
.globl vector37
vector37:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $37
  102458:	6a 25                	push   $0x25
  jmp __alltraps
  10245a:	e9 2a 09 00 00       	jmp    102d89 <__alltraps>

0010245f <vector38>:
.globl vector38
vector38:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $38
  102461:	6a 26                	push   $0x26
  jmp __alltraps
  102463:	e9 21 09 00 00       	jmp    102d89 <__alltraps>

00102468 <vector39>:
.globl vector39
vector39:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $39
  10246a:	6a 27                	push   $0x27
  jmp __alltraps
  10246c:	e9 18 09 00 00       	jmp    102d89 <__alltraps>

00102471 <vector40>:
.globl vector40
vector40:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $40
  102473:	6a 28                	push   $0x28
  jmp __alltraps
  102475:	e9 0f 09 00 00       	jmp    102d89 <__alltraps>

0010247a <vector41>:
.globl vector41
vector41:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $41
  10247c:	6a 29                	push   $0x29
  jmp __alltraps
  10247e:	e9 06 09 00 00       	jmp    102d89 <__alltraps>

00102483 <vector42>:
.globl vector42
vector42:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $42
  102485:	6a 2a                	push   $0x2a
  jmp __alltraps
  102487:	e9 fd 08 00 00       	jmp    102d89 <__alltraps>

0010248c <vector43>:
.globl vector43
vector43:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $43
  10248e:	6a 2b                	push   $0x2b
  jmp __alltraps
  102490:	e9 f4 08 00 00       	jmp    102d89 <__alltraps>

00102495 <vector44>:
.globl vector44
vector44:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $44
  102497:	6a 2c                	push   $0x2c
  jmp __alltraps
  102499:	e9 eb 08 00 00       	jmp    102d89 <__alltraps>

0010249e <vector45>:
.globl vector45
vector45:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $45
  1024a0:	6a 2d                	push   $0x2d
  jmp __alltraps
  1024a2:	e9 e2 08 00 00       	jmp    102d89 <__alltraps>

001024a7 <vector46>:
.globl vector46
vector46:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $46
  1024a9:	6a 2e                	push   $0x2e
  jmp __alltraps
  1024ab:	e9 d9 08 00 00       	jmp    102d89 <__alltraps>

001024b0 <vector47>:
.globl vector47
vector47:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $47
  1024b2:	6a 2f                	push   $0x2f
  jmp __alltraps
  1024b4:	e9 d0 08 00 00       	jmp    102d89 <__alltraps>

001024b9 <vector48>:
.globl vector48
vector48:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $48
  1024bb:	6a 30                	push   $0x30
  jmp __alltraps
  1024bd:	e9 c7 08 00 00       	jmp    102d89 <__alltraps>

001024c2 <vector49>:
.globl vector49
vector49:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $49
  1024c4:	6a 31                	push   $0x31
  jmp __alltraps
  1024c6:	e9 be 08 00 00       	jmp    102d89 <__alltraps>

001024cb <vector50>:
.globl vector50
vector50:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $50
  1024cd:	6a 32                	push   $0x32
  jmp __alltraps
  1024cf:	e9 b5 08 00 00       	jmp    102d89 <__alltraps>

001024d4 <vector51>:
.globl vector51
vector51:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $51
  1024d6:	6a 33                	push   $0x33
  jmp __alltraps
  1024d8:	e9 ac 08 00 00       	jmp    102d89 <__alltraps>

001024dd <vector52>:
.globl vector52
vector52:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $52
  1024df:	6a 34                	push   $0x34
  jmp __alltraps
  1024e1:	e9 a3 08 00 00       	jmp    102d89 <__alltraps>

001024e6 <vector53>:
.globl vector53
vector53:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $53
  1024e8:	6a 35                	push   $0x35
  jmp __alltraps
  1024ea:	e9 9a 08 00 00       	jmp    102d89 <__alltraps>

001024ef <vector54>:
.globl vector54
vector54:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $54
  1024f1:	6a 36                	push   $0x36
  jmp __alltraps
  1024f3:	e9 91 08 00 00       	jmp    102d89 <__alltraps>

001024f8 <vector55>:
.globl vector55
vector55:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $55
  1024fa:	6a 37                	push   $0x37
  jmp __alltraps
  1024fc:	e9 88 08 00 00       	jmp    102d89 <__alltraps>

00102501 <vector56>:
.globl vector56
vector56:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $56
  102503:	6a 38                	push   $0x38
  jmp __alltraps
  102505:	e9 7f 08 00 00       	jmp    102d89 <__alltraps>

0010250a <vector57>:
.globl vector57
vector57:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $57
  10250c:	6a 39                	push   $0x39
  jmp __alltraps
  10250e:	e9 76 08 00 00       	jmp    102d89 <__alltraps>

00102513 <vector58>:
.globl vector58
vector58:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $58
  102515:	6a 3a                	push   $0x3a
  jmp __alltraps
  102517:	e9 6d 08 00 00       	jmp    102d89 <__alltraps>

0010251c <vector59>:
.globl vector59
vector59:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $59
  10251e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102520:	e9 64 08 00 00       	jmp    102d89 <__alltraps>

00102525 <vector60>:
.globl vector60
vector60:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $60
  102527:	6a 3c                	push   $0x3c
  jmp __alltraps
  102529:	e9 5b 08 00 00       	jmp    102d89 <__alltraps>

0010252e <vector61>:
.globl vector61
vector61:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $61
  102530:	6a 3d                	push   $0x3d
  jmp __alltraps
  102532:	e9 52 08 00 00       	jmp    102d89 <__alltraps>

00102537 <vector62>:
.globl vector62
vector62:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $62
  102539:	6a 3e                	push   $0x3e
  jmp __alltraps
  10253b:	e9 49 08 00 00       	jmp    102d89 <__alltraps>

00102540 <vector63>:
.globl vector63
vector63:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $63
  102542:	6a 3f                	push   $0x3f
  jmp __alltraps
  102544:	e9 40 08 00 00       	jmp    102d89 <__alltraps>

00102549 <vector64>:
.globl vector64
vector64:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $64
  10254b:	6a 40                	push   $0x40
  jmp __alltraps
  10254d:	e9 37 08 00 00       	jmp    102d89 <__alltraps>

00102552 <vector65>:
.globl vector65
vector65:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $65
  102554:	6a 41                	push   $0x41
  jmp __alltraps
  102556:	e9 2e 08 00 00       	jmp    102d89 <__alltraps>

0010255b <vector66>:
.globl vector66
vector66:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $66
  10255d:	6a 42                	push   $0x42
  jmp __alltraps
  10255f:	e9 25 08 00 00       	jmp    102d89 <__alltraps>

00102564 <vector67>:
.globl vector67
vector67:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $67
  102566:	6a 43                	push   $0x43
  jmp __alltraps
  102568:	e9 1c 08 00 00       	jmp    102d89 <__alltraps>

0010256d <vector68>:
.globl vector68
vector68:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $68
  10256f:	6a 44                	push   $0x44
  jmp __alltraps
  102571:	e9 13 08 00 00       	jmp    102d89 <__alltraps>

00102576 <vector69>:
.globl vector69
vector69:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $69
  102578:	6a 45                	push   $0x45
  jmp __alltraps
  10257a:	e9 0a 08 00 00       	jmp    102d89 <__alltraps>

0010257f <vector70>:
.globl vector70
vector70:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $70
  102581:	6a 46                	push   $0x46
  jmp __alltraps
  102583:	e9 01 08 00 00       	jmp    102d89 <__alltraps>

00102588 <vector71>:
.globl vector71
vector71:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $71
  10258a:	6a 47                	push   $0x47
  jmp __alltraps
  10258c:	e9 f8 07 00 00       	jmp    102d89 <__alltraps>

00102591 <vector72>:
.globl vector72
vector72:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $72
  102593:	6a 48                	push   $0x48
  jmp __alltraps
  102595:	e9 ef 07 00 00       	jmp    102d89 <__alltraps>

0010259a <vector73>:
.globl vector73
vector73:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $73
  10259c:	6a 49                	push   $0x49
  jmp __alltraps
  10259e:	e9 e6 07 00 00       	jmp    102d89 <__alltraps>

001025a3 <vector74>:
.globl vector74
vector74:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $74
  1025a5:	6a 4a                	push   $0x4a
  jmp __alltraps
  1025a7:	e9 dd 07 00 00       	jmp    102d89 <__alltraps>

001025ac <vector75>:
.globl vector75
vector75:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $75
  1025ae:	6a 4b                	push   $0x4b
  jmp __alltraps
  1025b0:	e9 d4 07 00 00       	jmp    102d89 <__alltraps>

001025b5 <vector76>:
.globl vector76
vector76:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $76
  1025b7:	6a 4c                	push   $0x4c
  jmp __alltraps
  1025b9:	e9 cb 07 00 00       	jmp    102d89 <__alltraps>

001025be <vector77>:
.globl vector77
vector77:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $77
  1025c0:	6a 4d                	push   $0x4d
  jmp __alltraps
  1025c2:	e9 c2 07 00 00       	jmp    102d89 <__alltraps>

001025c7 <vector78>:
.globl vector78
vector78:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $78
  1025c9:	6a 4e                	push   $0x4e
  jmp __alltraps
  1025cb:	e9 b9 07 00 00       	jmp    102d89 <__alltraps>

001025d0 <vector79>:
.globl vector79
vector79:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $79
  1025d2:	6a 4f                	push   $0x4f
  jmp __alltraps
  1025d4:	e9 b0 07 00 00       	jmp    102d89 <__alltraps>

001025d9 <vector80>:
.globl vector80
vector80:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $80
  1025db:	6a 50                	push   $0x50
  jmp __alltraps
  1025dd:	e9 a7 07 00 00       	jmp    102d89 <__alltraps>

001025e2 <vector81>:
.globl vector81
vector81:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $81
  1025e4:	6a 51                	push   $0x51
  jmp __alltraps
  1025e6:	e9 9e 07 00 00       	jmp    102d89 <__alltraps>

001025eb <vector82>:
.globl vector82
vector82:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $82
  1025ed:	6a 52                	push   $0x52
  jmp __alltraps
  1025ef:	e9 95 07 00 00       	jmp    102d89 <__alltraps>

001025f4 <vector83>:
.globl vector83
vector83:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $83
  1025f6:	6a 53                	push   $0x53
  jmp __alltraps
  1025f8:	e9 8c 07 00 00       	jmp    102d89 <__alltraps>

001025fd <vector84>:
.globl vector84
vector84:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $84
  1025ff:	6a 54                	push   $0x54
  jmp __alltraps
  102601:	e9 83 07 00 00       	jmp    102d89 <__alltraps>

00102606 <vector85>:
.globl vector85
vector85:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $85
  102608:	6a 55                	push   $0x55
  jmp __alltraps
  10260a:	e9 7a 07 00 00       	jmp    102d89 <__alltraps>

0010260f <vector86>:
.globl vector86
vector86:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $86
  102611:	6a 56                	push   $0x56
  jmp __alltraps
  102613:	e9 71 07 00 00       	jmp    102d89 <__alltraps>

00102618 <vector87>:
.globl vector87
vector87:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $87
  10261a:	6a 57                	push   $0x57
  jmp __alltraps
  10261c:	e9 68 07 00 00       	jmp    102d89 <__alltraps>

00102621 <vector88>:
.globl vector88
vector88:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $88
  102623:	6a 58                	push   $0x58
  jmp __alltraps
  102625:	e9 5f 07 00 00       	jmp    102d89 <__alltraps>

0010262a <vector89>:
.globl vector89
vector89:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $89
  10262c:	6a 59                	push   $0x59
  jmp __alltraps
  10262e:	e9 56 07 00 00       	jmp    102d89 <__alltraps>

00102633 <vector90>:
.globl vector90
vector90:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $90
  102635:	6a 5a                	push   $0x5a
  jmp __alltraps
  102637:	e9 4d 07 00 00       	jmp    102d89 <__alltraps>

0010263c <vector91>:
.globl vector91
vector91:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $91
  10263e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102640:	e9 44 07 00 00       	jmp    102d89 <__alltraps>

00102645 <vector92>:
.globl vector92
vector92:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $92
  102647:	6a 5c                	push   $0x5c
  jmp __alltraps
  102649:	e9 3b 07 00 00       	jmp    102d89 <__alltraps>

0010264e <vector93>:
.globl vector93
vector93:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $93
  102650:	6a 5d                	push   $0x5d
  jmp __alltraps
  102652:	e9 32 07 00 00       	jmp    102d89 <__alltraps>

00102657 <vector94>:
.globl vector94
vector94:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $94
  102659:	6a 5e                	push   $0x5e
  jmp __alltraps
  10265b:	e9 29 07 00 00       	jmp    102d89 <__alltraps>

00102660 <vector95>:
.globl vector95
vector95:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $95
  102662:	6a 5f                	push   $0x5f
  jmp __alltraps
  102664:	e9 20 07 00 00       	jmp    102d89 <__alltraps>

00102669 <vector96>:
.globl vector96
vector96:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $96
  10266b:	6a 60                	push   $0x60
  jmp __alltraps
  10266d:	e9 17 07 00 00       	jmp    102d89 <__alltraps>

00102672 <vector97>:
.globl vector97
vector97:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $97
  102674:	6a 61                	push   $0x61
  jmp __alltraps
  102676:	e9 0e 07 00 00       	jmp    102d89 <__alltraps>

0010267b <vector98>:
.globl vector98
vector98:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $98
  10267d:	6a 62                	push   $0x62
  jmp __alltraps
  10267f:	e9 05 07 00 00       	jmp    102d89 <__alltraps>

00102684 <vector99>:
.globl vector99
vector99:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $99
  102686:	6a 63                	push   $0x63
  jmp __alltraps
  102688:	e9 fc 06 00 00       	jmp    102d89 <__alltraps>

0010268d <vector100>:
.globl vector100
vector100:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $100
  10268f:	6a 64                	push   $0x64
  jmp __alltraps
  102691:	e9 f3 06 00 00       	jmp    102d89 <__alltraps>

00102696 <vector101>:
.globl vector101
vector101:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $101
  102698:	6a 65                	push   $0x65
  jmp __alltraps
  10269a:	e9 ea 06 00 00       	jmp    102d89 <__alltraps>

0010269f <vector102>:
.globl vector102
vector102:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $102
  1026a1:	6a 66                	push   $0x66
  jmp __alltraps
  1026a3:	e9 e1 06 00 00       	jmp    102d89 <__alltraps>

001026a8 <vector103>:
.globl vector103
vector103:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $103
  1026aa:	6a 67                	push   $0x67
  jmp __alltraps
  1026ac:	e9 d8 06 00 00       	jmp    102d89 <__alltraps>

001026b1 <vector104>:
.globl vector104
vector104:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $104
  1026b3:	6a 68                	push   $0x68
  jmp __alltraps
  1026b5:	e9 cf 06 00 00       	jmp    102d89 <__alltraps>

001026ba <vector105>:
.globl vector105
vector105:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $105
  1026bc:	6a 69                	push   $0x69
  jmp __alltraps
  1026be:	e9 c6 06 00 00       	jmp    102d89 <__alltraps>

001026c3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $106
  1026c5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1026c7:	e9 bd 06 00 00       	jmp    102d89 <__alltraps>

001026cc <vector107>:
.globl vector107
vector107:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $107
  1026ce:	6a 6b                	push   $0x6b
  jmp __alltraps
  1026d0:	e9 b4 06 00 00       	jmp    102d89 <__alltraps>

001026d5 <vector108>:
.globl vector108
vector108:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $108
  1026d7:	6a 6c                	push   $0x6c
  jmp __alltraps
  1026d9:	e9 ab 06 00 00       	jmp    102d89 <__alltraps>

001026de <vector109>:
.globl vector109
vector109:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $109
  1026e0:	6a 6d                	push   $0x6d
  jmp __alltraps
  1026e2:	e9 a2 06 00 00       	jmp    102d89 <__alltraps>

001026e7 <vector110>:
.globl vector110
vector110:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $110
  1026e9:	6a 6e                	push   $0x6e
  jmp __alltraps
  1026eb:	e9 99 06 00 00       	jmp    102d89 <__alltraps>

001026f0 <vector111>:
.globl vector111
vector111:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $111
  1026f2:	6a 6f                	push   $0x6f
  jmp __alltraps
  1026f4:	e9 90 06 00 00       	jmp    102d89 <__alltraps>

001026f9 <vector112>:
.globl vector112
vector112:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $112
  1026fb:	6a 70                	push   $0x70
  jmp __alltraps
  1026fd:	e9 87 06 00 00       	jmp    102d89 <__alltraps>

00102702 <vector113>:
.globl vector113
vector113:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $113
  102704:	6a 71                	push   $0x71
  jmp __alltraps
  102706:	e9 7e 06 00 00       	jmp    102d89 <__alltraps>

0010270b <vector114>:
.globl vector114
vector114:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $114
  10270d:	6a 72                	push   $0x72
  jmp __alltraps
  10270f:	e9 75 06 00 00       	jmp    102d89 <__alltraps>

00102714 <vector115>:
.globl vector115
vector115:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $115
  102716:	6a 73                	push   $0x73
  jmp __alltraps
  102718:	e9 6c 06 00 00       	jmp    102d89 <__alltraps>

0010271d <vector116>:
.globl vector116
vector116:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $116
  10271f:	6a 74                	push   $0x74
  jmp __alltraps
  102721:	e9 63 06 00 00       	jmp    102d89 <__alltraps>

00102726 <vector117>:
.globl vector117
vector117:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $117
  102728:	6a 75                	push   $0x75
  jmp __alltraps
  10272a:	e9 5a 06 00 00       	jmp    102d89 <__alltraps>

0010272f <vector118>:
.globl vector118
vector118:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $118
  102731:	6a 76                	push   $0x76
  jmp __alltraps
  102733:	e9 51 06 00 00       	jmp    102d89 <__alltraps>

00102738 <vector119>:
.globl vector119
vector119:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $119
  10273a:	6a 77                	push   $0x77
  jmp __alltraps
  10273c:	e9 48 06 00 00       	jmp    102d89 <__alltraps>

00102741 <vector120>:
.globl vector120
vector120:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $120
  102743:	6a 78                	push   $0x78
  jmp __alltraps
  102745:	e9 3f 06 00 00       	jmp    102d89 <__alltraps>

0010274a <vector121>:
.globl vector121
vector121:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $121
  10274c:	6a 79                	push   $0x79
  jmp __alltraps
  10274e:	e9 36 06 00 00       	jmp    102d89 <__alltraps>

00102753 <vector122>:
.globl vector122
vector122:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $122
  102755:	6a 7a                	push   $0x7a
  jmp __alltraps
  102757:	e9 2d 06 00 00       	jmp    102d89 <__alltraps>

0010275c <vector123>:
.globl vector123
vector123:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $123
  10275e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102760:	e9 24 06 00 00       	jmp    102d89 <__alltraps>

00102765 <vector124>:
.globl vector124
vector124:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $124
  102767:	6a 7c                	push   $0x7c
  jmp __alltraps
  102769:	e9 1b 06 00 00       	jmp    102d89 <__alltraps>

0010276e <vector125>:
.globl vector125
vector125:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $125
  102770:	6a 7d                	push   $0x7d
  jmp __alltraps
  102772:	e9 12 06 00 00       	jmp    102d89 <__alltraps>

00102777 <vector126>:
.globl vector126
vector126:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $126
  102779:	6a 7e                	push   $0x7e
  jmp __alltraps
  10277b:	e9 09 06 00 00       	jmp    102d89 <__alltraps>

00102780 <vector127>:
.globl vector127
vector127:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $127
  102782:	6a 7f                	push   $0x7f
  jmp __alltraps
  102784:	e9 00 06 00 00       	jmp    102d89 <__alltraps>

00102789 <vector128>:
.globl vector128
vector128:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $128
  10278b:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102790:	e9 f4 05 00 00       	jmp    102d89 <__alltraps>

00102795 <vector129>:
.globl vector129
vector129:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $129
  102797:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10279c:	e9 e8 05 00 00       	jmp    102d89 <__alltraps>

001027a1 <vector130>:
.globl vector130
vector130:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $130
  1027a3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1027a8:	e9 dc 05 00 00       	jmp    102d89 <__alltraps>

001027ad <vector131>:
.globl vector131
vector131:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $131
  1027af:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1027b4:	e9 d0 05 00 00       	jmp    102d89 <__alltraps>

001027b9 <vector132>:
.globl vector132
vector132:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $132
  1027bb:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1027c0:	e9 c4 05 00 00       	jmp    102d89 <__alltraps>

001027c5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $133
  1027c7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1027cc:	e9 b8 05 00 00       	jmp    102d89 <__alltraps>

001027d1 <vector134>:
.globl vector134
vector134:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $134
  1027d3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1027d8:	e9 ac 05 00 00       	jmp    102d89 <__alltraps>

001027dd <vector135>:
.globl vector135
vector135:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $135
  1027df:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1027e4:	e9 a0 05 00 00       	jmp    102d89 <__alltraps>

001027e9 <vector136>:
.globl vector136
vector136:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $136
  1027eb:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1027f0:	e9 94 05 00 00       	jmp    102d89 <__alltraps>

001027f5 <vector137>:
.globl vector137
vector137:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $137
  1027f7:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1027fc:	e9 88 05 00 00       	jmp    102d89 <__alltraps>

00102801 <vector138>:
.globl vector138
vector138:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $138
  102803:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102808:	e9 7c 05 00 00       	jmp    102d89 <__alltraps>

0010280d <vector139>:
.globl vector139
vector139:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $139
  10280f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102814:	e9 70 05 00 00       	jmp    102d89 <__alltraps>

00102819 <vector140>:
.globl vector140
vector140:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $140
  10281b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102820:	e9 64 05 00 00       	jmp    102d89 <__alltraps>

00102825 <vector141>:
.globl vector141
vector141:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $141
  102827:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10282c:	e9 58 05 00 00       	jmp    102d89 <__alltraps>

00102831 <vector142>:
.globl vector142
vector142:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $142
  102833:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102838:	e9 4c 05 00 00       	jmp    102d89 <__alltraps>

0010283d <vector143>:
.globl vector143
vector143:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $143
  10283f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102844:	e9 40 05 00 00       	jmp    102d89 <__alltraps>

00102849 <vector144>:
.globl vector144
vector144:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $144
  10284b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102850:	e9 34 05 00 00       	jmp    102d89 <__alltraps>

00102855 <vector145>:
.globl vector145
vector145:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $145
  102857:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10285c:	e9 28 05 00 00       	jmp    102d89 <__alltraps>

00102861 <vector146>:
.globl vector146
vector146:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $146
  102863:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102868:	e9 1c 05 00 00       	jmp    102d89 <__alltraps>

0010286d <vector147>:
.globl vector147
vector147:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $147
  10286f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102874:	e9 10 05 00 00       	jmp    102d89 <__alltraps>

00102879 <vector148>:
.globl vector148
vector148:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $148
  10287b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102880:	e9 04 05 00 00       	jmp    102d89 <__alltraps>

00102885 <vector149>:
.globl vector149
vector149:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $149
  102887:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10288c:	e9 f8 04 00 00       	jmp    102d89 <__alltraps>

00102891 <vector150>:
.globl vector150
vector150:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $150
  102893:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102898:	e9 ec 04 00 00       	jmp    102d89 <__alltraps>

0010289d <vector151>:
.globl vector151
vector151:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $151
  10289f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1028a4:	e9 e0 04 00 00       	jmp    102d89 <__alltraps>

001028a9 <vector152>:
.globl vector152
vector152:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $152
  1028ab:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1028b0:	e9 d4 04 00 00       	jmp    102d89 <__alltraps>

001028b5 <vector153>:
.globl vector153
vector153:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $153
  1028b7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1028bc:	e9 c8 04 00 00       	jmp    102d89 <__alltraps>

001028c1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $154
  1028c3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1028c8:	e9 bc 04 00 00       	jmp    102d89 <__alltraps>

001028cd <vector155>:
.globl vector155
vector155:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $155
  1028cf:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1028d4:	e9 b0 04 00 00       	jmp    102d89 <__alltraps>

001028d9 <vector156>:
.globl vector156
vector156:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $156
  1028db:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1028e0:	e9 a4 04 00 00       	jmp    102d89 <__alltraps>

001028e5 <vector157>:
.globl vector157
vector157:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $157
  1028e7:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1028ec:	e9 98 04 00 00       	jmp    102d89 <__alltraps>

001028f1 <vector158>:
.globl vector158
vector158:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $158
  1028f3:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1028f8:	e9 8c 04 00 00       	jmp    102d89 <__alltraps>

001028fd <vector159>:
.globl vector159
vector159:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $159
  1028ff:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102904:	e9 80 04 00 00       	jmp    102d89 <__alltraps>

00102909 <vector160>:
.globl vector160
vector160:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $160
  10290b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102910:	e9 74 04 00 00       	jmp    102d89 <__alltraps>

00102915 <vector161>:
.globl vector161
vector161:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $161
  102917:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10291c:	e9 68 04 00 00       	jmp    102d89 <__alltraps>

00102921 <vector162>:
.globl vector162
vector162:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $162
  102923:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102928:	e9 5c 04 00 00       	jmp    102d89 <__alltraps>

0010292d <vector163>:
.globl vector163
vector163:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $163
  10292f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102934:	e9 50 04 00 00       	jmp    102d89 <__alltraps>

00102939 <vector164>:
.globl vector164
vector164:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $164
  10293b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102940:	e9 44 04 00 00       	jmp    102d89 <__alltraps>

00102945 <vector165>:
.globl vector165
vector165:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $165
  102947:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10294c:	e9 38 04 00 00       	jmp    102d89 <__alltraps>

00102951 <vector166>:
.globl vector166
vector166:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $166
  102953:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102958:	e9 2c 04 00 00       	jmp    102d89 <__alltraps>

0010295d <vector167>:
.globl vector167
vector167:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $167
  10295f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102964:	e9 20 04 00 00       	jmp    102d89 <__alltraps>

00102969 <vector168>:
.globl vector168
vector168:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $168
  10296b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102970:	e9 14 04 00 00       	jmp    102d89 <__alltraps>

00102975 <vector169>:
.globl vector169
vector169:
  pushl $0
  102975:	6a 00                	push   $0x0
  pushl $169
  102977:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10297c:	e9 08 04 00 00       	jmp    102d89 <__alltraps>

00102981 <vector170>:
.globl vector170
vector170:
  pushl $0
  102981:	6a 00                	push   $0x0
  pushl $170
  102983:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102988:	e9 fc 03 00 00       	jmp    102d89 <__alltraps>

0010298d <vector171>:
.globl vector171
vector171:
  pushl $0
  10298d:	6a 00                	push   $0x0
  pushl $171
  10298f:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102994:	e9 f0 03 00 00       	jmp    102d89 <__alltraps>

00102999 <vector172>:
.globl vector172
vector172:
  pushl $0
  102999:	6a 00                	push   $0x0
  pushl $172
  10299b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1029a0:	e9 e4 03 00 00       	jmp    102d89 <__alltraps>

001029a5 <vector173>:
.globl vector173
vector173:
  pushl $0
  1029a5:	6a 00                	push   $0x0
  pushl $173
  1029a7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1029ac:	e9 d8 03 00 00       	jmp    102d89 <__alltraps>

001029b1 <vector174>:
.globl vector174
vector174:
  pushl $0
  1029b1:	6a 00                	push   $0x0
  pushl $174
  1029b3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1029b8:	e9 cc 03 00 00       	jmp    102d89 <__alltraps>

001029bd <vector175>:
.globl vector175
vector175:
  pushl $0
  1029bd:	6a 00                	push   $0x0
  pushl $175
  1029bf:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1029c4:	e9 c0 03 00 00       	jmp    102d89 <__alltraps>

001029c9 <vector176>:
.globl vector176
vector176:
  pushl $0
  1029c9:	6a 00                	push   $0x0
  pushl $176
  1029cb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1029d0:	e9 b4 03 00 00       	jmp    102d89 <__alltraps>

001029d5 <vector177>:
.globl vector177
vector177:
  pushl $0
  1029d5:	6a 00                	push   $0x0
  pushl $177
  1029d7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1029dc:	e9 a8 03 00 00       	jmp    102d89 <__alltraps>

001029e1 <vector178>:
.globl vector178
vector178:
  pushl $0
  1029e1:	6a 00                	push   $0x0
  pushl $178
  1029e3:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1029e8:	e9 9c 03 00 00       	jmp    102d89 <__alltraps>

001029ed <vector179>:
.globl vector179
vector179:
  pushl $0
  1029ed:	6a 00                	push   $0x0
  pushl $179
  1029ef:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1029f4:	e9 90 03 00 00       	jmp    102d89 <__alltraps>

001029f9 <vector180>:
.globl vector180
vector180:
  pushl $0
  1029f9:	6a 00                	push   $0x0
  pushl $180
  1029fb:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102a00:	e9 84 03 00 00       	jmp    102d89 <__alltraps>

00102a05 <vector181>:
.globl vector181
vector181:
  pushl $0
  102a05:	6a 00                	push   $0x0
  pushl $181
  102a07:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102a0c:	e9 78 03 00 00       	jmp    102d89 <__alltraps>

00102a11 <vector182>:
.globl vector182
vector182:
  pushl $0
  102a11:	6a 00                	push   $0x0
  pushl $182
  102a13:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102a18:	e9 6c 03 00 00       	jmp    102d89 <__alltraps>

00102a1d <vector183>:
.globl vector183
vector183:
  pushl $0
  102a1d:	6a 00                	push   $0x0
  pushl $183
  102a1f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102a24:	e9 60 03 00 00       	jmp    102d89 <__alltraps>

00102a29 <vector184>:
.globl vector184
vector184:
  pushl $0
  102a29:	6a 00                	push   $0x0
  pushl $184
  102a2b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102a30:	e9 54 03 00 00       	jmp    102d89 <__alltraps>

00102a35 <vector185>:
.globl vector185
vector185:
  pushl $0
  102a35:	6a 00                	push   $0x0
  pushl $185
  102a37:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102a3c:	e9 48 03 00 00       	jmp    102d89 <__alltraps>

00102a41 <vector186>:
.globl vector186
vector186:
  pushl $0
  102a41:	6a 00                	push   $0x0
  pushl $186
  102a43:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102a48:	e9 3c 03 00 00       	jmp    102d89 <__alltraps>

00102a4d <vector187>:
.globl vector187
vector187:
  pushl $0
  102a4d:	6a 00                	push   $0x0
  pushl $187
  102a4f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102a54:	e9 30 03 00 00       	jmp    102d89 <__alltraps>

00102a59 <vector188>:
.globl vector188
vector188:
  pushl $0
  102a59:	6a 00                	push   $0x0
  pushl $188
  102a5b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102a60:	e9 24 03 00 00       	jmp    102d89 <__alltraps>

00102a65 <vector189>:
.globl vector189
vector189:
  pushl $0
  102a65:	6a 00                	push   $0x0
  pushl $189
  102a67:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102a6c:	e9 18 03 00 00       	jmp    102d89 <__alltraps>

00102a71 <vector190>:
.globl vector190
vector190:
  pushl $0
  102a71:	6a 00                	push   $0x0
  pushl $190
  102a73:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102a78:	e9 0c 03 00 00       	jmp    102d89 <__alltraps>

00102a7d <vector191>:
.globl vector191
vector191:
  pushl $0
  102a7d:	6a 00                	push   $0x0
  pushl $191
  102a7f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102a84:	e9 00 03 00 00       	jmp    102d89 <__alltraps>

00102a89 <vector192>:
.globl vector192
vector192:
  pushl $0
  102a89:	6a 00                	push   $0x0
  pushl $192
  102a8b:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102a90:	e9 f4 02 00 00       	jmp    102d89 <__alltraps>

00102a95 <vector193>:
.globl vector193
vector193:
  pushl $0
  102a95:	6a 00                	push   $0x0
  pushl $193
  102a97:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102a9c:	e9 e8 02 00 00       	jmp    102d89 <__alltraps>

00102aa1 <vector194>:
.globl vector194
vector194:
  pushl $0
  102aa1:	6a 00                	push   $0x0
  pushl $194
  102aa3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102aa8:	e9 dc 02 00 00       	jmp    102d89 <__alltraps>

00102aad <vector195>:
.globl vector195
vector195:
  pushl $0
  102aad:	6a 00                	push   $0x0
  pushl $195
  102aaf:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102ab4:	e9 d0 02 00 00       	jmp    102d89 <__alltraps>

00102ab9 <vector196>:
.globl vector196
vector196:
  pushl $0
  102ab9:	6a 00                	push   $0x0
  pushl $196
  102abb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102ac0:	e9 c4 02 00 00       	jmp    102d89 <__alltraps>

00102ac5 <vector197>:
.globl vector197
vector197:
  pushl $0
  102ac5:	6a 00                	push   $0x0
  pushl $197
  102ac7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102acc:	e9 b8 02 00 00       	jmp    102d89 <__alltraps>

00102ad1 <vector198>:
.globl vector198
vector198:
  pushl $0
  102ad1:	6a 00                	push   $0x0
  pushl $198
  102ad3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102ad8:	e9 ac 02 00 00       	jmp    102d89 <__alltraps>

00102add <vector199>:
.globl vector199
vector199:
  pushl $0
  102add:	6a 00                	push   $0x0
  pushl $199
  102adf:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102ae4:	e9 a0 02 00 00       	jmp    102d89 <__alltraps>

00102ae9 <vector200>:
.globl vector200
vector200:
  pushl $0
  102ae9:	6a 00                	push   $0x0
  pushl $200
  102aeb:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102af0:	e9 94 02 00 00       	jmp    102d89 <__alltraps>

00102af5 <vector201>:
.globl vector201
vector201:
  pushl $0
  102af5:	6a 00                	push   $0x0
  pushl $201
  102af7:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102afc:	e9 88 02 00 00       	jmp    102d89 <__alltraps>

00102b01 <vector202>:
.globl vector202
vector202:
  pushl $0
  102b01:	6a 00                	push   $0x0
  pushl $202
  102b03:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102b08:	e9 7c 02 00 00       	jmp    102d89 <__alltraps>

00102b0d <vector203>:
.globl vector203
vector203:
  pushl $0
  102b0d:	6a 00                	push   $0x0
  pushl $203
  102b0f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102b14:	e9 70 02 00 00       	jmp    102d89 <__alltraps>

00102b19 <vector204>:
.globl vector204
vector204:
  pushl $0
  102b19:	6a 00                	push   $0x0
  pushl $204
  102b1b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102b20:	e9 64 02 00 00       	jmp    102d89 <__alltraps>

00102b25 <vector205>:
.globl vector205
vector205:
  pushl $0
  102b25:	6a 00                	push   $0x0
  pushl $205
  102b27:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102b2c:	e9 58 02 00 00       	jmp    102d89 <__alltraps>

00102b31 <vector206>:
.globl vector206
vector206:
  pushl $0
  102b31:	6a 00                	push   $0x0
  pushl $206
  102b33:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102b38:	e9 4c 02 00 00       	jmp    102d89 <__alltraps>

00102b3d <vector207>:
.globl vector207
vector207:
  pushl $0
  102b3d:	6a 00                	push   $0x0
  pushl $207
  102b3f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102b44:	e9 40 02 00 00       	jmp    102d89 <__alltraps>

00102b49 <vector208>:
.globl vector208
vector208:
  pushl $0
  102b49:	6a 00                	push   $0x0
  pushl $208
  102b4b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102b50:	e9 34 02 00 00       	jmp    102d89 <__alltraps>

00102b55 <vector209>:
.globl vector209
vector209:
  pushl $0
  102b55:	6a 00                	push   $0x0
  pushl $209
  102b57:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102b5c:	e9 28 02 00 00       	jmp    102d89 <__alltraps>

00102b61 <vector210>:
.globl vector210
vector210:
  pushl $0
  102b61:	6a 00                	push   $0x0
  pushl $210
  102b63:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102b68:	e9 1c 02 00 00       	jmp    102d89 <__alltraps>

00102b6d <vector211>:
.globl vector211
vector211:
  pushl $0
  102b6d:	6a 00                	push   $0x0
  pushl $211
  102b6f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102b74:	e9 10 02 00 00       	jmp    102d89 <__alltraps>

00102b79 <vector212>:
.globl vector212
vector212:
  pushl $0
  102b79:	6a 00                	push   $0x0
  pushl $212
  102b7b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102b80:	e9 04 02 00 00       	jmp    102d89 <__alltraps>

00102b85 <vector213>:
.globl vector213
vector213:
  pushl $0
  102b85:	6a 00                	push   $0x0
  pushl $213
  102b87:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102b8c:	e9 f8 01 00 00       	jmp    102d89 <__alltraps>

00102b91 <vector214>:
.globl vector214
vector214:
  pushl $0
  102b91:	6a 00                	push   $0x0
  pushl $214
  102b93:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102b98:	e9 ec 01 00 00       	jmp    102d89 <__alltraps>

00102b9d <vector215>:
.globl vector215
vector215:
  pushl $0
  102b9d:	6a 00                	push   $0x0
  pushl $215
  102b9f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102ba4:	e9 e0 01 00 00       	jmp    102d89 <__alltraps>

00102ba9 <vector216>:
.globl vector216
vector216:
  pushl $0
  102ba9:	6a 00                	push   $0x0
  pushl $216
  102bab:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102bb0:	e9 d4 01 00 00       	jmp    102d89 <__alltraps>

00102bb5 <vector217>:
.globl vector217
vector217:
  pushl $0
  102bb5:	6a 00                	push   $0x0
  pushl $217
  102bb7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102bbc:	e9 c8 01 00 00       	jmp    102d89 <__alltraps>

00102bc1 <vector218>:
.globl vector218
vector218:
  pushl $0
  102bc1:	6a 00                	push   $0x0
  pushl $218
  102bc3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102bc8:	e9 bc 01 00 00       	jmp    102d89 <__alltraps>

00102bcd <vector219>:
.globl vector219
vector219:
  pushl $0
  102bcd:	6a 00                	push   $0x0
  pushl $219
  102bcf:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102bd4:	e9 b0 01 00 00       	jmp    102d89 <__alltraps>

00102bd9 <vector220>:
.globl vector220
vector220:
  pushl $0
  102bd9:	6a 00                	push   $0x0
  pushl $220
  102bdb:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102be0:	e9 a4 01 00 00       	jmp    102d89 <__alltraps>

00102be5 <vector221>:
.globl vector221
vector221:
  pushl $0
  102be5:	6a 00                	push   $0x0
  pushl $221
  102be7:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102bec:	e9 98 01 00 00       	jmp    102d89 <__alltraps>

00102bf1 <vector222>:
.globl vector222
vector222:
  pushl $0
  102bf1:	6a 00                	push   $0x0
  pushl $222
  102bf3:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102bf8:	e9 8c 01 00 00       	jmp    102d89 <__alltraps>

00102bfd <vector223>:
.globl vector223
vector223:
  pushl $0
  102bfd:	6a 00                	push   $0x0
  pushl $223
  102bff:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102c04:	e9 80 01 00 00       	jmp    102d89 <__alltraps>

00102c09 <vector224>:
.globl vector224
vector224:
  pushl $0
  102c09:	6a 00                	push   $0x0
  pushl $224
  102c0b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102c10:	e9 74 01 00 00       	jmp    102d89 <__alltraps>

00102c15 <vector225>:
.globl vector225
vector225:
  pushl $0
  102c15:	6a 00                	push   $0x0
  pushl $225
  102c17:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102c1c:	e9 68 01 00 00       	jmp    102d89 <__alltraps>

00102c21 <vector226>:
.globl vector226
vector226:
  pushl $0
  102c21:	6a 00                	push   $0x0
  pushl $226
  102c23:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102c28:	e9 5c 01 00 00       	jmp    102d89 <__alltraps>

00102c2d <vector227>:
.globl vector227
vector227:
  pushl $0
  102c2d:	6a 00                	push   $0x0
  pushl $227
  102c2f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102c34:	e9 50 01 00 00       	jmp    102d89 <__alltraps>

00102c39 <vector228>:
.globl vector228
vector228:
  pushl $0
  102c39:	6a 00                	push   $0x0
  pushl $228
  102c3b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102c40:	e9 44 01 00 00       	jmp    102d89 <__alltraps>

00102c45 <vector229>:
.globl vector229
vector229:
  pushl $0
  102c45:	6a 00                	push   $0x0
  pushl $229
  102c47:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102c4c:	e9 38 01 00 00       	jmp    102d89 <__alltraps>

00102c51 <vector230>:
.globl vector230
vector230:
  pushl $0
  102c51:	6a 00                	push   $0x0
  pushl $230
  102c53:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102c58:	e9 2c 01 00 00       	jmp    102d89 <__alltraps>

00102c5d <vector231>:
.globl vector231
vector231:
  pushl $0
  102c5d:	6a 00                	push   $0x0
  pushl $231
  102c5f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102c64:	e9 20 01 00 00       	jmp    102d89 <__alltraps>

00102c69 <vector232>:
.globl vector232
vector232:
  pushl $0
  102c69:	6a 00                	push   $0x0
  pushl $232
  102c6b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102c70:	e9 14 01 00 00       	jmp    102d89 <__alltraps>

00102c75 <vector233>:
.globl vector233
vector233:
  pushl $0
  102c75:	6a 00                	push   $0x0
  pushl $233
  102c77:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102c7c:	e9 08 01 00 00       	jmp    102d89 <__alltraps>

00102c81 <vector234>:
.globl vector234
vector234:
  pushl $0
  102c81:	6a 00                	push   $0x0
  pushl $234
  102c83:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102c88:	e9 fc 00 00 00       	jmp    102d89 <__alltraps>

00102c8d <vector235>:
.globl vector235
vector235:
  pushl $0
  102c8d:	6a 00                	push   $0x0
  pushl $235
  102c8f:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102c94:	e9 f0 00 00 00       	jmp    102d89 <__alltraps>

00102c99 <vector236>:
.globl vector236
vector236:
  pushl $0
  102c99:	6a 00                	push   $0x0
  pushl $236
  102c9b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102ca0:	e9 e4 00 00 00       	jmp    102d89 <__alltraps>

00102ca5 <vector237>:
.globl vector237
vector237:
  pushl $0
  102ca5:	6a 00                	push   $0x0
  pushl $237
  102ca7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102cac:	e9 d8 00 00 00       	jmp    102d89 <__alltraps>

00102cb1 <vector238>:
.globl vector238
vector238:
  pushl $0
  102cb1:	6a 00                	push   $0x0
  pushl $238
  102cb3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102cb8:	e9 cc 00 00 00       	jmp    102d89 <__alltraps>

00102cbd <vector239>:
.globl vector239
vector239:
  pushl $0
  102cbd:	6a 00                	push   $0x0
  pushl $239
  102cbf:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102cc4:	e9 c0 00 00 00       	jmp    102d89 <__alltraps>

00102cc9 <vector240>:
.globl vector240
vector240:
  pushl $0
  102cc9:	6a 00                	push   $0x0
  pushl $240
  102ccb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102cd0:	e9 b4 00 00 00       	jmp    102d89 <__alltraps>

00102cd5 <vector241>:
.globl vector241
vector241:
  pushl $0
  102cd5:	6a 00                	push   $0x0
  pushl $241
  102cd7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102cdc:	e9 a8 00 00 00       	jmp    102d89 <__alltraps>

00102ce1 <vector242>:
.globl vector242
vector242:
  pushl $0
  102ce1:	6a 00                	push   $0x0
  pushl $242
  102ce3:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102ce8:	e9 9c 00 00 00       	jmp    102d89 <__alltraps>

00102ced <vector243>:
.globl vector243
vector243:
  pushl $0
  102ced:	6a 00                	push   $0x0
  pushl $243
  102cef:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102cf4:	e9 90 00 00 00       	jmp    102d89 <__alltraps>

00102cf9 <vector244>:
.globl vector244
vector244:
  pushl $0
  102cf9:	6a 00                	push   $0x0
  pushl $244
  102cfb:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102d00:	e9 84 00 00 00       	jmp    102d89 <__alltraps>

00102d05 <vector245>:
.globl vector245
vector245:
  pushl $0
  102d05:	6a 00                	push   $0x0
  pushl $245
  102d07:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102d0c:	e9 78 00 00 00       	jmp    102d89 <__alltraps>

00102d11 <vector246>:
.globl vector246
vector246:
  pushl $0
  102d11:	6a 00                	push   $0x0
  pushl $246
  102d13:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102d18:	e9 6c 00 00 00       	jmp    102d89 <__alltraps>

00102d1d <vector247>:
.globl vector247
vector247:
  pushl $0
  102d1d:	6a 00                	push   $0x0
  pushl $247
  102d1f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102d24:	e9 60 00 00 00       	jmp    102d89 <__alltraps>

00102d29 <vector248>:
.globl vector248
vector248:
  pushl $0
  102d29:	6a 00                	push   $0x0
  pushl $248
  102d2b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102d30:	e9 54 00 00 00       	jmp    102d89 <__alltraps>

00102d35 <vector249>:
.globl vector249
vector249:
  pushl $0
  102d35:	6a 00                	push   $0x0
  pushl $249
  102d37:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102d3c:	e9 48 00 00 00       	jmp    102d89 <__alltraps>

00102d41 <vector250>:
.globl vector250
vector250:
  pushl $0
  102d41:	6a 00                	push   $0x0
  pushl $250
  102d43:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102d48:	e9 3c 00 00 00       	jmp    102d89 <__alltraps>

00102d4d <vector251>:
.globl vector251
vector251:
  pushl $0
  102d4d:	6a 00                	push   $0x0
  pushl $251
  102d4f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102d54:	e9 30 00 00 00       	jmp    102d89 <__alltraps>

00102d59 <vector252>:
.globl vector252
vector252:
  pushl $0
  102d59:	6a 00                	push   $0x0
  pushl $252
  102d5b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102d60:	e9 24 00 00 00       	jmp    102d89 <__alltraps>

00102d65 <vector253>:
.globl vector253
vector253:
  pushl $0
  102d65:	6a 00                	push   $0x0
  pushl $253
  102d67:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102d6c:	e9 18 00 00 00       	jmp    102d89 <__alltraps>

00102d71 <vector254>:
.globl vector254
vector254:
  pushl $0
  102d71:	6a 00                	push   $0x0
  pushl $254
  102d73:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102d78:	e9 0c 00 00 00       	jmp    102d89 <__alltraps>

00102d7d <vector255>:
.globl vector255
vector255:
  pushl $0
  102d7d:	6a 00                	push   $0x0
  pushl $255
  102d7f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102d84:	e9 00 00 00 00       	jmp    102d89 <__alltraps>

00102d89 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102d89:	1e                   	push   %ds
    pushl %es
  102d8a:	06                   	push   %es
    pushl %fs
  102d8b:	0f a0                	push   %fs
    pushl %gs
  102d8d:	0f a8                	push   %gs
    pushal
  102d8f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102d90:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102d95:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102d97:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102d99:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102d9a:	e8 60 f5 ff ff       	call   1022ff <trap>

    # pop the pushed stack pointer
    popl %esp
  102d9f:	5c                   	pop    %esp

00102da0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102da0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102da1:	0f a9                	pop    %gs
    popl %fs
  102da3:	0f a1                	pop    %fs
    popl %es
  102da5:	07                   	pop    %es
    popl %ds
  102da6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102da7:	83 c4 08             	add    $0x8,%esp
    iret
  102daa:	cf                   	iret   

00102dab <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102dab:	55                   	push   %ebp
  102dac:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102dae:	a1 78 df 11 00       	mov    0x11df78,%eax
  102db3:	8b 55 08             	mov    0x8(%ebp),%edx
  102db6:	29 c2                	sub    %eax,%edx
  102db8:	89 d0                	mov    %edx,%eax
  102dba:	c1 f8 02             	sar    $0x2,%eax
  102dbd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102dc3:	5d                   	pop    %ebp
  102dc4:	c3                   	ret    

00102dc5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102dc5:	55                   	push   %ebp
  102dc6:	89 e5                	mov    %esp,%ebp
  102dc8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dce:	89 04 24             	mov    %eax,(%esp)
  102dd1:	e8 d5 ff ff ff       	call   102dab <page2ppn>
  102dd6:	c1 e0 0c             	shl    $0xc,%eax
}
  102dd9:	c9                   	leave  
  102dda:	c3                   	ret    

00102ddb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102ddb:	55                   	push   %ebp
  102ddc:	89 e5                	mov    %esp,%ebp
  102dde:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102de1:	8b 45 08             	mov    0x8(%ebp),%eax
  102de4:	c1 e8 0c             	shr    $0xc,%eax
  102de7:	89 c2                	mov    %eax,%edx
  102de9:	a1 80 de 11 00       	mov    0x11de80,%eax
  102dee:	39 c2                	cmp    %eax,%edx
  102df0:	72 1c                	jb     102e0e <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102df2:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  102df9:	00 
  102dfa:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102e01:	00 
  102e02:	c7 04 24 2f 6d 10 00 	movl   $0x106d2f,(%esp)
  102e09:	e8 23 d6 ff ff       	call   100431 <__panic>
    }
    return &pages[PPN(pa)];
  102e0e:	8b 0d 78 df 11 00    	mov    0x11df78,%ecx
  102e14:	8b 45 08             	mov    0x8(%ebp),%eax
  102e17:	c1 e8 0c             	shr    $0xc,%eax
  102e1a:	89 c2                	mov    %eax,%edx
  102e1c:	89 d0                	mov    %edx,%eax
  102e1e:	c1 e0 02             	shl    $0x2,%eax
  102e21:	01 d0                	add    %edx,%eax
  102e23:	c1 e0 02             	shl    $0x2,%eax
  102e26:	01 c8                	add    %ecx,%eax
}
  102e28:	c9                   	leave  
  102e29:	c3                   	ret    

00102e2a <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102e2a:	55                   	push   %ebp
  102e2b:	89 e5                	mov    %esp,%ebp
  102e2d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102e30:	8b 45 08             	mov    0x8(%ebp),%eax
  102e33:	89 04 24             	mov    %eax,(%esp)
  102e36:	e8 8a ff ff ff       	call   102dc5 <page2pa>
  102e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e41:	c1 e8 0c             	shr    $0xc,%eax
  102e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e47:	a1 80 de 11 00       	mov    0x11de80,%eax
  102e4c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102e4f:	72 23                	jb     102e74 <page2kva+0x4a>
  102e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e58:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  102e5f:	00 
  102e60:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102e67:	00 
  102e68:	c7 04 24 2f 6d 10 00 	movl   $0x106d2f,(%esp)
  102e6f:	e8 bd d5 ff ff       	call   100431 <__panic>
  102e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e77:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102e7c:	c9                   	leave  
  102e7d:	c3                   	ret    

00102e7e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102e7e:	55                   	push   %ebp
  102e7f:	89 e5                	mov    %esp,%ebp
  102e81:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102e84:	8b 45 08             	mov    0x8(%ebp),%eax
  102e87:	83 e0 01             	and    $0x1,%eax
  102e8a:	85 c0                	test   %eax,%eax
  102e8c:	75 1c                	jne    102eaa <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102e8e:	c7 44 24 08 64 6d 10 	movl   $0x106d64,0x8(%esp)
  102e95:	00 
  102e96:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102e9d:	00 
  102e9e:	c7 04 24 2f 6d 10 00 	movl   $0x106d2f,(%esp)
  102ea5:	e8 87 d5 ff ff       	call   100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  102ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102eb2:	89 04 24             	mov    %eax,(%esp)
  102eb5:	e8 21 ff ff ff       	call   102ddb <pa2page>
}
  102eba:	c9                   	leave  
  102ebb:	c3                   	ret    

00102ebc <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102ebc:	55                   	push   %ebp
  102ebd:	89 e5                	mov    %esp,%ebp
  102ebf:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102eca:	89 04 24             	mov    %eax,(%esp)
  102ecd:	e8 09 ff ff ff       	call   102ddb <pa2page>
}
  102ed2:	c9                   	leave  
  102ed3:	c3                   	ret    

00102ed4 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102ed4:	55                   	push   %ebp
  102ed5:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eda:	8b 00                	mov    (%eax),%eax
}
  102edc:	5d                   	pop    %ebp
  102edd:	c3                   	ret    

00102ede <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102ede:	55                   	push   %ebp
  102edf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ee7:	89 10                	mov    %edx,(%eax)
}
  102ee9:	90                   	nop
  102eea:	5d                   	pop    %ebp
  102eeb:	c3                   	ret    

00102eec <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102eec:	55                   	push   %ebp
  102eed:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102eef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef2:	8b 00                	mov    (%eax),%eax
  102ef4:	8d 50 01             	lea    0x1(%eax),%edx
  102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  102efa:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102efc:	8b 45 08             	mov    0x8(%ebp),%eax
  102eff:	8b 00                	mov    (%eax),%eax
}
  102f01:	5d                   	pop    %ebp
  102f02:	c3                   	ret    

00102f03 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102f03:	55                   	push   %ebp
  102f04:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102f06:	8b 45 08             	mov    0x8(%ebp),%eax
  102f09:	8b 00                	mov    (%eax),%eax
  102f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f11:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102f13:	8b 45 08             	mov    0x8(%ebp),%eax
  102f16:	8b 00                	mov    (%eax),%eax
}
  102f18:	5d                   	pop    %ebp
  102f19:	c3                   	ret    

00102f1a <__intr_save>:
__intr_save(void) {
  102f1a:	55                   	push   %ebp
  102f1b:	89 e5                	mov    %esp,%ebp
  102f1d:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102f20:	9c                   	pushf  
  102f21:	58                   	pop    %eax
  102f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102f28:	25 00 02 00 00       	and    $0x200,%eax
  102f2d:	85 c0                	test   %eax,%eax
  102f2f:	74 0c                	je     102f3d <__intr_save+0x23>
        intr_disable();
  102f31:	e8 4f ea ff ff       	call   101985 <intr_disable>
        return 1;
  102f36:	b8 01 00 00 00       	mov    $0x1,%eax
  102f3b:	eb 05                	jmp    102f42 <__intr_save+0x28>
    return 0;
  102f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f42:	c9                   	leave  
  102f43:	c3                   	ret    

00102f44 <__intr_restore>:
__intr_restore(bool flag) {
  102f44:	55                   	push   %ebp
  102f45:	89 e5                	mov    %esp,%ebp
  102f47:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f4e:	74 05                	je     102f55 <__intr_restore+0x11>
        intr_enable();
  102f50:	e8 24 ea ff ff       	call   101979 <intr_enable>
}
  102f55:	90                   	nop
  102f56:	c9                   	leave  
  102f57:	c3                   	ret    

00102f58 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102f58:	55                   	push   %ebp
  102f59:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102f61:	b8 23 00 00 00       	mov    $0x23,%eax
  102f66:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102f68:	b8 23 00 00 00       	mov    $0x23,%eax
  102f6d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102f6f:	b8 10 00 00 00       	mov    $0x10,%eax
  102f74:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102f76:	b8 10 00 00 00       	mov    $0x10,%eax
  102f7b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102f7d:	b8 10 00 00 00       	mov    $0x10,%eax
  102f82:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102f84:	ea 8b 2f 10 00 08 00 	ljmp   $0x8,$0x102f8b
}
  102f8b:	90                   	nop
  102f8c:	5d                   	pop    %ebp
  102f8d:	c3                   	ret    

00102f8e <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102f8e:	f3 0f 1e fb          	endbr32 
  102f92:	55                   	push   %ebp
  102f93:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102f95:	8b 45 08             	mov    0x8(%ebp),%eax
  102f98:	a3 a4 de 11 00       	mov    %eax,0x11dea4
}
  102f9d:	90                   	nop
  102f9e:	5d                   	pop    %ebp
  102f9f:	c3                   	ret    

00102fa0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102fa0:	f3 0f 1e fb          	endbr32 
  102fa4:	55                   	push   %ebp
  102fa5:	89 e5                	mov    %esp,%ebp
  102fa7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102faa:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  102faf:	89 04 24             	mov    %eax,(%esp)
  102fb2:	e8 d7 ff ff ff       	call   102f8e <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102fb7:	66 c7 05 a8 de 11 00 	movw   $0x10,0x11dea8
  102fbe:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102fc0:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  102fc7:	68 00 
  102fc9:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  102fce:	0f b7 c0             	movzwl %ax,%eax
  102fd1:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  102fd7:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  102fdc:	c1 e8 10             	shr    $0x10,%eax
  102fdf:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  102fe4:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102feb:	24 f0                	and    $0xf0,%al
  102fed:	0c 09                	or     $0x9,%al
  102fef:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102ff4:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102ffb:	24 ef                	and    $0xef,%al
  102ffd:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  103002:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  103009:	24 9f                	and    $0x9f,%al
  10300b:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  103010:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  103017:	0c 80                	or     $0x80,%al
  103019:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  10301e:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  103025:	24 f0                	and    $0xf0,%al
  103027:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10302c:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  103033:	24 ef                	and    $0xef,%al
  103035:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  10303a:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  103041:	24 df                	and    $0xdf,%al
  103043:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  103048:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  10304f:	0c 40                	or     $0x40,%al
  103051:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  103056:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  10305d:	24 7f                	and    $0x7f,%al
  10305f:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  103064:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  103069:	c1 e8 18             	shr    $0x18,%eax
  10306c:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103071:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
  103078:	e8 db fe ff ff       	call   102f58 <lgdt>
  10307d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103083:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103087:	0f 00 d8             	ltr    %ax
}
  10308a:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  10308b:	90                   	nop
  10308c:	c9                   	leave  
  10308d:	c3                   	ret    

0010308e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  10308e:	f3 0f 1e fb          	endbr32 
  103092:	55                   	push   %ebp
  103093:	89 e5                	mov    %esp,%ebp
  103095:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103098:	c7 05 70 df 11 00 38 	movl   $0x107738,0x11df70
  10309f:	77 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  1030a2:	a1 70 df 11 00       	mov    0x11df70,%eax
  1030a7:	8b 00                	mov    (%eax),%eax
  1030a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030ad:	c7 04 24 90 6d 10 00 	movl   $0x106d90,(%esp)
  1030b4:	e8 0c d2 ff ff       	call   1002c5 <cprintf>
    pmm_manager->init();
  1030b9:	a1 70 df 11 00       	mov    0x11df70,%eax
  1030be:	8b 40 04             	mov    0x4(%eax),%eax
  1030c1:	ff d0                	call   *%eax
}
  1030c3:	90                   	nop
  1030c4:	c9                   	leave  
  1030c5:	c3                   	ret    

001030c6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  1030c6:	f3 0f 1e fb          	endbr32 
  1030ca:	55                   	push   %ebp
  1030cb:	89 e5                	mov    %esp,%ebp
  1030cd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  1030d0:	a1 70 df 11 00       	mov    0x11df70,%eax
  1030d5:	8b 40 08             	mov    0x8(%eax),%eax
  1030d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030db:	89 54 24 04          	mov    %edx,0x4(%esp)
  1030df:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e2:	89 14 24             	mov    %edx,(%esp)
  1030e5:	ff d0                	call   *%eax
}
  1030e7:	90                   	nop
  1030e8:	c9                   	leave  
  1030e9:	c3                   	ret    

001030ea <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  1030ea:	f3 0f 1e fb          	endbr32 
  1030ee:	55                   	push   %ebp
  1030ef:	89 e5                	mov    %esp,%ebp
  1030f1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  1030f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1030fb:	e8 1a fe ff ff       	call   102f1a <__intr_save>
  103100:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103103:	a1 70 df 11 00       	mov    0x11df70,%eax
  103108:	8b 40 0c             	mov    0xc(%eax),%eax
  10310b:	8b 55 08             	mov    0x8(%ebp),%edx
  10310e:	89 14 24             	mov    %edx,(%esp)
  103111:	ff d0                	call   *%eax
  103113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103119:	89 04 24             	mov    %eax,(%esp)
  10311c:	e8 23 fe ff ff       	call   102f44 <__intr_restore>
    return page;
  103121:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103124:	c9                   	leave  
  103125:	c3                   	ret    

00103126 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103126:	f3 0f 1e fb          	endbr32 
  10312a:	55                   	push   %ebp
  10312b:	89 e5                	mov    %esp,%ebp
  10312d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103130:	e8 e5 fd ff ff       	call   102f1a <__intr_save>
  103135:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103138:	a1 70 df 11 00       	mov    0x11df70,%eax
  10313d:	8b 40 10             	mov    0x10(%eax),%eax
  103140:	8b 55 0c             	mov    0xc(%ebp),%edx
  103143:	89 54 24 04          	mov    %edx,0x4(%esp)
  103147:	8b 55 08             	mov    0x8(%ebp),%edx
  10314a:	89 14 24             	mov    %edx,(%esp)
  10314d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  10314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103152:	89 04 24             	mov    %eax,(%esp)
  103155:	e8 ea fd ff ff       	call   102f44 <__intr_restore>
}
  10315a:	90                   	nop
  10315b:	c9                   	leave  
  10315c:	c3                   	ret    

0010315d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  10315d:	f3 0f 1e fb          	endbr32 
  103161:	55                   	push   %ebp
  103162:	89 e5                	mov    %esp,%ebp
  103164:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103167:	e8 ae fd ff ff       	call   102f1a <__intr_save>
  10316c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  10316f:	a1 70 df 11 00       	mov    0x11df70,%eax
  103174:	8b 40 14             	mov    0x14(%eax),%eax
  103177:	ff d0                	call   *%eax
  103179:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  10317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10317f:	89 04 24             	mov    %eax,(%esp)
  103182:	e8 bd fd ff ff       	call   102f44 <__intr_restore>
    return ret;
  103187:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10318a:	c9                   	leave  
  10318b:	c3                   	ret    

0010318c <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  10318c:	f3 0f 1e fb          	endbr32 
  103190:	55                   	push   %ebp
  103191:	89 e5                	mov    %esp,%ebp
  103193:	57                   	push   %edi
  103194:	56                   	push   %esi
  103195:	53                   	push   %ebx
  103196:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  10319c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1031a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1031aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1031b1:	c7 04 24 a7 6d 10 00 	movl   $0x106da7,(%esp)
  1031b8:	e8 08 d1 ff ff       	call   1002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1031bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1031c4:	e9 1a 01 00 00       	jmp    1032e3 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1031c9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031cf:	89 d0                	mov    %edx,%eax
  1031d1:	c1 e0 02             	shl    $0x2,%eax
  1031d4:	01 d0                	add    %edx,%eax
  1031d6:	c1 e0 02             	shl    $0x2,%eax
  1031d9:	01 c8                	add    %ecx,%eax
  1031db:	8b 50 08             	mov    0x8(%eax),%edx
  1031de:	8b 40 04             	mov    0x4(%eax),%eax
  1031e1:	89 45 a0             	mov    %eax,-0x60(%ebp)
  1031e4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  1031e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031ed:	89 d0                	mov    %edx,%eax
  1031ef:	c1 e0 02             	shl    $0x2,%eax
  1031f2:	01 d0                	add    %edx,%eax
  1031f4:	c1 e0 02             	shl    $0x2,%eax
  1031f7:	01 c8                	add    %ecx,%eax
  1031f9:	8b 48 0c             	mov    0xc(%eax),%ecx
  1031fc:	8b 58 10             	mov    0x10(%eax),%ebx
  1031ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103202:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103205:	01 c8                	add    %ecx,%eax
  103207:	11 da                	adc    %ebx,%edx
  103209:	89 45 98             	mov    %eax,-0x68(%ebp)
  10320c:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  10320f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103212:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103215:	89 d0                	mov    %edx,%eax
  103217:	c1 e0 02             	shl    $0x2,%eax
  10321a:	01 d0                	add    %edx,%eax
  10321c:	c1 e0 02             	shl    $0x2,%eax
  10321f:	01 c8                	add    %ecx,%eax
  103221:	83 c0 14             	add    $0x14,%eax
  103224:	8b 00                	mov    (%eax),%eax
  103226:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103229:	8b 45 98             	mov    -0x68(%ebp),%eax
  10322c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10322f:	83 c0 ff             	add    $0xffffffff,%eax
  103232:	83 d2 ff             	adc    $0xffffffff,%edx
  103235:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  10323b:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103241:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103244:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103247:	89 d0                	mov    %edx,%eax
  103249:	c1 e0 02             	shl    $0x2,%eax
  10324c:	01 d0                	add    %edx,%eax
  10324e:	c1 e0 02             	shl    $0x2,%eax
  103251:	01 c8                	add    %ecx,%eax
  103253:	8b 48 0c             	mov    0xc(%eax),%ecx
  103256:	8b 58 10             	mov    0x10(%eax),%ebx
  103259:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10325c:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103260:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103266:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10326c:	89 44 24 14          	mov    %eax,0x14(%esp)
  103270:	89 54 24 18          	mov    %edx,0x18(%esp)
  103274:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103277:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10327a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10327e:	89 54 24 10          	mov    %edx,0x10(%esp)
  103282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103286:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10328a:	c7 04 24 b4 6d 10 00 	movl   $0x106db4,(%esp)
  103291:	e8 2f d0 ff ff       	call   1002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103296:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103299:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10329c:	89 d0                	mov    %edx,%eax
  10329e:	c1 e0 02             	shl    $0x2,%eax
  1032a1:	01 d0                	add    %edx,%eax
  1032a3:	c1 e0 02             	shl    $0x2,%eax
  1032a6:	01 c8                	add    %ecx,%eax
  1032a8:	83 c0 14             	add    $0x14,%eax
  1032ab:	8b 00                	mov    (%eax),%eax
  1032ad:	83 f8 01             	cmp    $0x1,%eax
  1032b0:	75 2e                	jne    1032e0 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  1032b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032b8:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1032bb:	89 d0                	mov    %edx,%eax
  1032bd:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  1032c0:	73 1e                	jae    1032e0 <page_init+0x154>
  1032c2:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  1032cc:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  1032cf:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  1032d2:	72 0c                	jb     1032e0 <page_init+0x154>
                maxpa = end;
  1032d4:	8b 45 98             	mov    -0x68(%ebp),%eax
  1032d7:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1032da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  1032e0:	ff 45 dc             	incl   -0x24(%ebp)
  1032e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1032e6:	8b 00                	mov    (%eax),%eax
  1032e8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1032eb:	0f 8c d8 fe ff ff    	jl     1031c9 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  1032f1:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1032f6:	b8 00 00 00 00       	mov    $0x0,%eax
  1032fb:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  1032fe:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103301:	73 0e                	jae    103311 <page_init+0x185>
        maxpa = KMEMSIZE;
  103303:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10330a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103317:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10331b:	c1 ea 0c             	shr    $0xc,%edx
  10331e:	a3 80 de 11 00       	mov    %eax,0x11de80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103323:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  10332a:	b8 88 df 11 00       	mov    $0x11df88,%eax
  10332f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103335:	01 d0                	add    %edx,%eax
  103337:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10333a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10333d:	ba 00 00 00 00       	mov    $0x0,%edx
  103342:	f7 75 c0             	divl   -0x40(%ebp)
  103345:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103348:	29 d0                	sub    %edx,%eax
  10334a:	a3 78 df 11 00       	mov    %eax,0x11df78

    for (i = 0; i < npage; i ++) {
  10334f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103356:	eb 2f                	jmp    103387 <page_init+0x1fb>
        SetPageReserved(pages + i);
  103358:	8b 0d 78 df 11 00    	mov    0x11df78,%ecx
  10335e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103361:	89 d0                	mov    %edx,%eax
  103363:	c1 e0 02             	shl    $0x2,%eax
  103366:	01 d0                	add    %edx,%eax
  103368:	c1 e0 02             	shl    $0x2,%eax
  10336b:	01 c8                	add    %ecx,%eax
  10336d:	83 c0 04             	add    $0x4,%eax
  103370:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103377:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10337a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10337d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103380:	0f ab 10             	bts    %edx,(%eax)
}
  103383:	90                   	nop
    for (i = 0; i < npage; i ++) {
  103384:	ff 45 dc             	incl   -0x24(%ebp)
  103387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10338a:	a1 80 de 11 00       	mov    0x11de80,%eax
  10338f:	39 c2                	cmp    %eax,%edx
  103391:	72 c5                	jb     103358 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103393:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  103399:	89 d0                	mov    %edx,%eax
  10339b:	c1 e0 02             	shl    $0x2,%eax
  10339e:	01 d0                	add    %edx,%eax
  1033a0:	c1 e0 02             	shl    $0x2,%eax
  1033a3:	89 c2                	mov    %eax,%edx
  1033a5:	a1 78 df 11 00       	mov    0x11df78,%eax
  1033aa:	01 d0                	add    %edx,%eax
  1033ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1033af:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1033b6:	77 23                	ja     1033db <page_init+0x24f>
  1033b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1033bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033bf:	c7 44 24 08 e4 6d 10 	movl   $0x106de4,0x8(%esp)
  1033c6:	00 
  1033c7:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1033ce:	00 
  1033cf:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1033d6:	e8 56 d0 ff ff       	call   100431 <__panic>
  1033db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1033de:	05 00 00 00 40       	add    $0x40000000,%eax
  1033e3:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1033e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1033ed:	e9 4b 01 00 00       	jmp    10353d <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1033f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033f8:	89 d0                	mov    %edx,%eax
  1033fa:	c1 e0 02             	shl    $0x2,%eax
  1033fd:	01 d0                	add    %edx,%eax
  1033ff:	c1 e0 02             	shl    $0x2,%eax
  103402:	01 c8                	add    %ecx,%eax
  103404:	8b 50 08             	mov    0x8(%eax),%edx
  103407:	8b 40 04             	mov    0x4(%eax),%eax
  10340a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10340d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103410:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103413:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103416:	89 d0                	mov    %edx,%eax
  103418:	c1 e0 02             	shl    $0x2,%eax
  10341b:	01 d0                	add    %edx,%eax
  10341d:	c1 e0 02             	shl    $0x2,%eax
  103420:	01 c8                	add    %ecx,%eax
  103422:	8b 48 0c             	mov    0xc(%eax),%ecx
  103425:	8b 58 10             	mov    0x10(%eax),%ebx
  103428:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10342b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10342e:	01 c8                	add    %ecx,%eax
  103430:	11 da                	adc    %ebx,%edx
  103432:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103435:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103438:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10343b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10343e:	89 d0                	mov    %edx,%eax
  103440:	c1 e0 02             	shl    $0x2,%eax
  103443:	01 d0                	add    %edx,%eax
  103445:	c1 e0 02             	shl    $0x2,%eax
  103448:	01 c8                	add    %ecx,%eax
  10344a:	83 c0 14             	add    $0x14,%eax
  10344d:	8b 00                	mov    (%eax),%eax
  10344f:	83 f8 01             	cmp    $0x1,%eax
  103452:	0f 85 e2 00 00 00    	jne    10353a <page_init+0x3ae>
            if (begin < freemem) {
  103458:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10345b:	ba 00 00 00 00       	mov    $0x0,%edx
  103460:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103463:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103466:	19 d1                	sbb    %edx,%ecx
  103468:	73 0d                	jae    103477 <page_init+0x2eb>
                begin = freemem;
  10346a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10346d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103470:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103477:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10347c:	b8 00 00 00 00       	mov    $0x0,%eax
  103481:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103484:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103487:	73 0e                	jae    103497 <page_init+0x30b>
                end = KMEMSIZE;
  103489:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103490:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103497:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10349a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10349d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1034a0:	89 d0                	mov    %edx,%eax
  1034a2:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1034a5:	0f 83 8f 00 00 00    	jae    10353a <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  1034ab:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1034b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1034b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034b8:	01 d0                	add    %edx,%eax
  1034ba:	48                   	dec    %eax
  1034bb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1034be:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1034c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1034c6:	f7 75 b0             	divl   -0x50(%ebp)
  1034c9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1034cc:	29 d0                	sub    %edx,%eax
  1034ce:	ba 00 00 00 00       	mov    $0x0,%edx
  1034d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1034d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1034d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1034dc:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1034df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1034e2:	ba 00 00 00 00       	mov    $0x0,%edx
  1034e7:	89 c3                	mov    %eax,%ebx
  1034e9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1034ef:	89 de                	mov    %ebx,%esi
  1034f1:	89 d0                	mov    %edx,%eax
  1034f3:	83 e0 00             	and    $0x0,%eax
  1034f6:	89 c7                	mov    %eax,%edi
  1034f8:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1034fb:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1034fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103504:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103507:	89 d0                	mov    %edx,%eax
  103509:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10350c:	73 2c                	jae    10353a <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10350e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103511:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103514:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103517:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10351a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10351e:	c1 ea 0c             	shr    $0xc,%edx
  103521:	89 c3                	mov    %eax,%ebx
  103523:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103526:	89 04 24             	mov    %eax,(%esp)
  103529:	e8 ad f8 ff ff       	call   102ddb <pa2page>
  10352e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103532:	89 04 24             	mov    %eax,(%esp)
  103535:	e8 8c fb ff ff       	call   1030c6 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10353a:	ff 45 dc             	incl   -0x24(%ebp)
  10353d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103540:	8b 00                	mov    (%eax),%eax
  103542:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103545:	0f 8c a7 fe ff ff    	jl     1033f2 <page_init+0x266>
                }
            }
        }
    }
}
  10354b:	90                   	nop
  10354c:	90                   	nop
  10354d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103553:	5b                   	pop    %ebx
  103554:	5e                   	pop    %esi
  103555:	5f                   	pop    %edi
  103556:	5d                   	pop    %ebp
  103557:	c3                   	ret    

00103558 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103558:	f3 0f 1e fb          	endbr32 
  10355c:	55                   	push   %ebp
  10355d:	89 e5                	mov    %esp,%ebp
  10355f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103562:	8b 45 0c             	mov    0xc(%ebp),%eax
  103565:	33 45 14             	xor    0x14(%ebp),%eax
  103568:	25 ff 0f 00 00       	and    $0xfff,%eax
  10356d:	85 c0                	test   %eax,%eax
  10356f:	74 24                	je     103595 <boot_map_segment+0x3d>
  103571:	c7 44 24 0c 16 6e 10 	movl   $0x106e16,0xc(%esp)
  103578:	00 
  103579:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103580:	00 
  103581:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103588:	00 
  103589:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103590:	e8 9c ce ff ff       	call   100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103595:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10359c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10359f:	25 ff 0f 00 00       	and    $0xfff,%eax
  1035a4:	89 c2                	mov    %eax,%edx
  1035a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1035a9:	01 c2                	add    %eax,%edx
  1035ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ae:	01 d0                	add    %edx,%eax
  1035b0:	48                   	dec    %eax
  1035b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b7:	ba 00 00 00 00       	mov    $0x0,%edx
  1035bc:	f7 75 f0             	divl   -0x10(%ebp)
  1035bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c2:	29 d0                	sub    %edx,%eax
  1035c4:	c1 e8 0c             	shr    $0xc,%eax
  1035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1035ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1035d8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1035db:	8b 45 14             	mov    0x14(%ebp),%eax
  1035de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1035e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1035e9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1035ec:	eb 68                	jmp    103656 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1035ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1035f5:	00 
  1035f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103600:	89 04 24             	mov    %eax,(%esp)
  103603:	e8 8a 01 00 00       	call   103792 <get_pte>
  103608:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10360b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10360f:	75 24                	jne    103635 <boot_map_segment+0xdd>
  103611:	c7 44 24 0c 42 6e 10 	movl   $0x106e42,0xc(%esp)
  103618:	00 
  103619:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103620:	00 
  103621:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103628:	00 
  103629:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103630:	e8 fc cd ff ff       	call   100431 <__panic>
        *ptep = pa | PTE_P | perm;
  103635:	8b 45 14             	mov    0x14(%ebp),%eax
  103638:	0b 45 18             	or     0x18(%ebp),%eax
  10363b:	83 c8 01             	or     $0x1,%eax
  10363e:	89 c2                	mov    %eax,%edx
  103640:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103643:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103645:	ff 4d f4             	decl   -0xc(%ebp)
  103648:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10364f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10365a:	75 92                	jne    1035ee <boot_map_segment+0x96>
    }
}
  10365c:	90                   	nop
  10365d:	90                   	nop
  10365e:	c9                   	leave  
  10365f:	c3                   	ret    

00103660 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103660:	f3 0f 1e fb          	endbr32 
  103664:	55                   	push   %ebp
  103665:	89 e5                	mov    %esp,%ebp
  103667:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10366a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103671:	e8 74 fa ff ff       	call   1030ea <alloc_pages>
  103676:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10367d:	75 1c                	jne    10369b <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  10367f:	c7 44 24 08 4f 6e 10 	movl   $0x106e4f,0x8(%esp)
  103686:	00 
  103687:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10368e:	00 
  10368f:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103696:	e8 96 cd ff ff       	call   100431 <__panic>
    }
    return page2kva(p);
  10369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10369e:	89 04 24             	mov    %eax,(%esp)
  1036a1:	e8 84 f7 ff ff       	call   102e2a <page2kva>
}
  1036a6:	c9                   	leave  
  1036a7:	c3                   	ret    

001036a8 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1036a8:	f3 0f 1e fb          	endbr32 
  1036ac:	55                   	push   %ebp
  1036ad:	89 e5                	mov    %esp,%ebp
  1036af:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1036b2:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1036b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036ba:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1036c1:	77 23                	ja     1036e6 <pmm_init+0x3e>
  1036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ca:	c7 44 24 08 e4 6d 10 	movl   $0x106de4,0x8(%esp)
  1036d1:	00 
  1036d2:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1036d9:	00 
  1036da:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1036e1:	e8 4b cd ff ff       	call   100431 <__panic>
  1036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036e9:	05 00 00 00 40       	add    $0x40000000,%eax
  1036ee:	a3 74 df 11 00       	mov    %eax,0x11df74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1036f3:	e8 96 f9 ff ff       	call   10308e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1036f8:	e8 8f fa ff ff       	call   10318c <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1036fd:	e8 f3 03 00 00       	call   103af5 <check_alloc_page>

    check_pgdir();
  103702:	e8 11 04 00 00       	call   103b18 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103707:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10370c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10370f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103716:	77 23                	ja     10373b <pmm_init+0x93>
  103718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10371b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10371f:	c7 44 24 08 e4 6d 10 	movl   $0x106de4,0x8(%esp)
  103726:	00 
  103727:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10372e:	00 
  10372f:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103736:	e8 f6 cc ff ff       	call   100431 <__panic>
  10373b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10373e:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103744:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103749:	05 ac 0f 00 00       	add    $0xfac,%eax
  10374e:	83 ca 03             	or     $0x3,%edx
  103751:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103753:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103758:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10375f:	00 
  103760:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103767:	00 
  103768:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10376f:	38 
  103770:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103777:	c0 
  103778:	89 04 24             	mov    %eax,(%esp)
  10377b:	e8 d8 fd ff ff       	call   103558 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103780:	e8 1b f8 ff ff       	call   102fa0 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103785:	e8 2e 0a 00 00       	call   1041b8 <check_boot_pgdir>

    print_pgdir();
  10378a:	e8 b3 0e 00 00       	call   104642 <print_pgdir>

}
  10378f:	90                   	nop
  103790:	c9                   	leave  
  103791:	c3                   	ret    

00103792 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103792:	f3 0f 1e fb          	endbr32 
  103796:	55                   	push   %ebp
  103797:	89 e5                	mov    %esp,%ebp
  103799:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = &pgdir[PDX(la)];//获取页表
  10379c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10379f:	c1 e8 16             	shr    $0x16,%eax
  1037a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1037ac:	01 d0                	add    %edx,%eax
  1037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果页表不存在，尝试新建一个页表
  1037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037b4:	8b 00                	mov    (%eax),%eax
  1037b6:	83 e0 01             	and    $0x1,%eax
  1037b9:	85 c0                	test   %eax,%eax
  1037bb:	0f 85 af 00 00 00    	jne    103870 <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {//如果不需要创建或者分配失败，返回null
  1037c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1037c5:	74 15                	je     1037dc <get_pte+0x4a>
  1037c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037ce:	e8 17 f9 ff ff       	call   1030ea <alloc_pages>
  1037d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037da:	75 0a                	jne    1037e6 <get_pte+0x54>
            return NULL;
  1037dc:	b8 00 00 00 00       	mov    $0x0,%eax
  1037e1:	e9 e7 00 00 00       	jmp    1038cd <get_pte+0x13b>
        }
        set_page_ref(page, 1);//第一次创建，只有一个引用
  1037e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037ed:	00 
  1037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037f1:	89 04 24             	mov    %eax,(%esp)
  1037f4:	e8 e5 f6 ff ff       	call   102ede <set_page_ref>
        uintptr_t pa = page2pa(page);//转换成物理地址
  1037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037fc:	89 04 24             	mov    %eax,(%esp)
  1037ff:	e8 c1 f5 ff ff       	call   102dc5 <page2pa>
  103804:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//将对应物理地址置零
  103807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10380a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10380d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103810:	c1 e8 0c             	shr    $0xc,%eax
  103813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103816:	a1 80 de 11 00       	mov    0x11de80,%eax
  10381b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10381e:	72 23                	jb     103843 <get_pte+0xb1>
  103820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103823:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103827:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  10382e:	00 
  10382f:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
  103836:	00 
  103837:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10383e:	e8 ee cb ff ff       	call   100431 <__panic>
  103843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103846:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10384b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103852:	00 
  103853:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10385a:	00 
  10385b:	89 04 24             	mov    %eax,(%esp)
  10385e:	e8 2a 25 00 00       	call   105d8d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;//设置控制位
  103863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103866:	83 c8 07             	or     $0x7,%eax
  103869:	89 c2                	mov    %eax,%edx
  10386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10386e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  103870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103873:	8b 00                	mov    (%eax),%eax
  103875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10387a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10387d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103880:	c1 e8 0c             	shr    $0xc,%eax
  103883:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103886:	a1 80 de 11 00       	mov    0x11de80,%eax
  10388b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10388e:	72 23                	jb     1038b3 <get_pte+0x121>
  103890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103897:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  10389e:	00 
  10389f:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
  1038a6:	00 
  1038a7:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1038ae:	e8 7e cb ff ff       	call   100431 <__panic>
  1038b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1038bb:	89 c2                	mov    %eax,%edx
  1038bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038c0:	c1 e8 0c             	shr    $0xc,%eax
  1038c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  1038c8:	c1 e0 02             	shl    $0x2,%eax
  1038cb:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1038cd:	c9                   	leave  
  1038ce:	c3                   	ret    

001038cf <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1038cf:	f3 0f 1e fb          	endbr32 
  1038d3:	55                   	push   %ebp
  1038d4:	89 e5                	mov    %esp,%ebp
  1038d6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1038d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038e0:	00 
  1038e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1038eb:	89 04 24             	mov    %eax,(%esp)
  1038ee:	e8 9f fe ff ff       	call   103792 <get_pte>
  1038f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1038f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1038fa:	74 08                	je     103904 <get_page+0x35>
        *ptep_store = ptep;
  1038fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1038ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103902:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103908:	74 1b                	je     103925 <get_page+0x56>
  10390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10390d:	8b 00                	mov    (%eax),%eax
  10390f:	83 e0 01             	and    $0x1,%eax
  103912:	85 c0                	test   %eax,%eax
  103914:	74 0f                	je     103925 <get_page+0x56>
        return pte2page(*ptep);
  103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103919:	8b 00                	mov    (%eax),%eax
  10391b:	89 04 24             	mov    %eax,(%esp)
  10391e:	e8 5b f5 ff ff       	call   102e7e <pte2page>
  103923:	eb 05                	jmp    10392a <get_page+0x5b>
    }
    return NULL;
  103925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10392a:	c9                   	leave  
  10392b:	c3                   	ret    

0010392c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10392c:	55                   	push   %ebp
  10392d:	89 e5                	mov    %esp,%ebp
  10392f:	83 ec 28             	sub    $0x28,%esp
                                  //(3) decrease page reference
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    } */
    if (*ptep & PTE_P) {
  103932:	8b 45 10             	mov    0x10(%ebp),%eax
  103935:	8b 00                	mov    (%eax),%eax
  103937:	83 e0 01             	and    $0x1,%eax
  10393a:	85 c0                	test   %eax,%eax
  10393c:	74 4d                	je     10398b <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  10393e:	8b 45 10             	mov    0x10(%ebp),%eax
  103941:	8b 00                	mov    (%eax),%eax
  103943:	89 04 24             	mov    %eax,(%esp)
  103946:	e8 33 f5 ff ff       	call   102e7e <pte2page>
  10394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  10394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103951:	89 04 24             	mov    %eax,(%esp)
  103954:	e8 aa f5 ff ff       	call   102f03 <page_ref_dec>
  103959:	85 c0                	test   %eax,%eax
  10395b:	75 13                	jne    103970 <page_remove_pte+0x44>
            free_page(page);
  10395d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103964:	00 
  103965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103968:	89 04 24             	mov    %eax,(%esp)
  10396b:	e8 b6 f7 ff ff       	call   103126 <free_pages>
        }
        *ptep = 0;
  103970:	8b 45 10             	mov    0x10(%ebp),%eax
  103973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  103979:	8b 45 0c             	mov    0xc(%ebp),%eax
  10397c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103980:	8b 45 08             	mov    0x8(%ebp),%eax
  103983:	89 04 24             	mov    %eax,(%esp)
  103986:	e8 09 01 00 00       	call   103a94 <tlb_invalidate>
    }
}
  10398b:	90                   	nop
  10398c:	c9                   	leave  
  10398d:	c3                   	ret    

0010398e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10398e:	f3 0f 1e fb          	endbr32 
  103992:	55                   	push   %ebp
  103993:	89 e5                	mov    %esp,%ebp
  103995:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103998:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10399f:	00 
  1039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1039aa:	89 04 24             	mov    %eax,(%esp)
  1039ad:	e8 e0 fd ff ff       	call   103792 <get_pte>
  1039b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1039b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039b9:	74 19                	je     1039d4 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  1039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cc:	89 04 24             	mov    %eax,(%esp)
  1039cf:	e8 58 ff ff ff       	call   10392c <page_remove_pte>
    }
}
  1039d4:	90                   	nop
  1039d5:	c9                   	leave  
  1039d6:	c3                   	ret    

001039d7 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1039d7:	f3 0f 1e fb          	endbr32 
  1039db:	55                   	push   %ebp
  1039dc:	89 e5                	mov    %esp,%ebp
  1039de:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1039e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1039e8:	00 
  1039e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1039ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f3:	89 04 24             	mov    %eax,(%esp)
  1039f6:	e8 97 fd ff ff       	call   103792 <get_pte>
  1039fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1039fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a02:	75 0a                	jne    103a0e <page_insert+0x37>
        return -E_NO_MEM;
  103a04:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103a09:	e9 84 00 00 00       	jmp    103a92 <page_insert+0xbb>
    }
    page_ref_inc(page);
  103a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a11:	89 04 24             	mov    %eax,(%esp)
  103a14:	e8 d3 f4 ff ff       	call   102eec <page_ref_inc>
    if (*ptep & PTE_P) {
  103a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a1c:	8b 00                	mov    (%eax),%eax
  103a1e:	83 e0 01             	and    $0x1,%eax
  103a21:	85 c0                	test   %eax,%eax
  103a23:	74 3e                	je     103a63 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  103a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a28:	8b 00                	mov    (%eax),%eax
  103a2a:	89 04 24             	mov    %eax,(%esp)
  103a2d:	e8 4c f4 ff ff       	call   102e7e <pte2page>
  103a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a38:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103a3b:	75 0d                	jne    103a4a <page_insert+0x73>
            page_ref_dec(page);
  103a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a40:	89 04 24             	mov    %eax,(%esp)
  103a43:	e8 bb f4 ff ff       	call   102f03 <page_ref_dec>
  103a48:	eb 19                	jmp    103a63 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103a51:	8b 45 10             	mov    0x10(%ebp),%eax
  103a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a58:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5b:	89 04 24             	mov    %eax,(%esp)
  103a5e:	e8 c9 fe ff ff       	call   10392c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a66:	89 04 24             	mov    %eax,(%esp)
  103a69:	e8 57 f3 ff ff       	call   102dc5 <page2pa>
  103a6e:	0b 45 14             	or     0x14(%ebp),%eax
  103a71:	83 c8 01             	or     $0x1,%eax
  103a74:	89 c2                	mov    %eax,%edx
  103a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a79:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  103a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a82:	8b 45 08             	mov    0x8(%ebp),%eax
  103a85:	89 04 24             	mov    %eax,(%esp)
  103a88:	e8 07 00 00 00       	call   103a94 <tlb_invalidate>
    return 0;
  103a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a92:	c9                   	leave  
  103a93:	c3                   	ret    

00103a94 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103a94:	f3 0f 1e fb          	endbr32 
  103a98:	55                   	push   %ebp
  103a99:	89 e5                	mov    %esp,%ebp
  103a9b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103a9e:	0f 20 d8             	mov    %cr3,%eax
  103aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aad:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103ab4:	77 23                	ja     103ad9 <tlb_invalidate+0x45>
  103ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ab9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103abd:	c7 44 24 08 e4 6d 10 	movl   $0x106de4,0x8(%esp)
  103ac4:	00 
  103ac5:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  103acc:	00 
  103acd:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103ad4:	e8 58 c9 ff ff       	call   100431 <__panic>
  103ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103adc:	05 00 00 00 40       	add    $0x40000000,%eax
  103ae1:	39 d0                	cmp    %edx,%eax
  103ae3:	75 0d                	jne    103af2 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103aee:	0f 01 38             	invlpg (%eax)
}
  103af1:	90                   	nop
    }
}
  103af2:	90                   	nop
  103af3:	c9                   	leave  
  103af4:	c3                   	ret    

00103af5 <check_alloc_page>:

static void
check_alloc_page(void) {
  103af5:	f3 0f 1e fb          	endbr32 
  103af9:	55                   	push   %ebp
  103afa:	89 e5                	mov    %esp,%ebp
  103afc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103aff:	a1 70 df 11 00       	mov    0x11df70,%eax
  103b04:	8b 40 18             	mov    0x18(%eax),%eax
  103b07:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103b09:	c7 04 24 68 6e 10 00 	movl   $0x106e68,(%esp)
  103b10:	e8 b0 c7 ff ff       	call   1002c5 <cprintf>
}
  103b15:	90                   	nop
  103b16:	c9                   	leave  
  103b17:	c3                   	ret    

00103b18 <check_pgdir>:

static void
check_pgdir(void) {
  103b18:	f3 0f 1e fb          	endbr32 
  103b1c:	55                   	push   %ebp
  103b1d:	89 e5                	mov    %esp,%ebp
  103b1f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103b22:	a1 80 de 11 00       	mov    0x11de80,%eax
  103b27:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103b2c:	76 24                	jbe    103b52 <check_pgdir+0x3a>
  103b2e:	c7 44 24 0c 87 6e 10 	movl   $0x106e87,0xc(%esp)
  103b35:	00 
  103b36:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103b3d:	00 
  103b3e:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  103b45:	00 
  103b46:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103b4d:	e8 df c8 ff ff       	call   100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103b52:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b57:	85 c0                	test   %eax,%eax
  103b59:	74 0e                	je     103b69 <check_pgdir+0x51>
  103b5b:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b60:	25 ff 0f 00 00       	and    $0xfff,%eax
  103b65:	85 c0                	test   %eax,%eax
  103b67:	74 24                	je     103b8d <check_pgdir+0x75>
  103b69:	c7 44 24 0c a4 6e 10 	movl   $0x106ea4,0xc(%esp)
  103b70:	00 
  103b71:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103b78:	00 
  103b79:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  103b80:	00 
  103b81:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103b88:	e8 a4 c8 ff ff       	call   100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103b8d:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b99:	00 
  103b9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ba1:	00 
  103ba2:	89 04 24             	mov    %eax,(%esp)
  103ba5:	e8 25 fd ff ff       	call   1038cf <get_page>
  103baa:	85 c0                	test   %eax,%eax
  103bac:	74 24                	je     103bd2 <check_pgdir+0xba>
  103bae:	c7 44 24 0c dc 6e 10 	movl   $0x106edc,0xc(%esp)
  103bb5:	00 
  103bb6:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103bbd:	00 
  103bbe:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103bc5:	00 
  103bc6:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103bcd:	e8 5f c8 ff ff       	call   100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103bd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103bd9:	e8 0c f5 ff ff       	call   1030ea <alloc_pages>
  103bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103be1:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103be6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103bed:	00 
  103bee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bf5:	00 
  103bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103bf9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bfd:	89 04 24             	mov    %eax,(%esp)
  103c00:	e8 d2 fd ff ff       	call   1039d7 <page_insert>
  103c05:	85 c0                	test   %eax,%eax
  103c07:	74 24                	je     103c2d <check_pgdir+0x115>
  103c09:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  103c10:	00 
  103c11:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103c18:	00 
  103c19:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103c20:	00 
  103c21:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103c28:	e8 04 c8 ff ff       	call   100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103c2d:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c39:	00 
  103c3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c41:	00 
  103c42:	89 04 24             	mov    %eax,(%esp)
  103c45:	e8 48 fb ff ff       	call   103792 <get_pte>
  103c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c51:	75 24                	jne    103c77 <check_pgdir+0x15f>
  103c53:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  103c5a:	00 
  103c5b:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103c62:	00 
  103c63:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103c6a:	00 
  103c6b:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103c72:	e8 ba c7 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c7a:	8b 00                	mov    (%eax),%eax
  103c7c:	89 04 24             	mov    %eax,(%esp)
  103c7f:	e8 fa f1 ff ff       	call   102e7e <pte2page>
  103c84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c87:	74 24                	je     103cad <check_pgdir+0x195>
  103c89:	c7 44 24 0c 5d 6f 10 	movl   $0x106f5d,0xc(%esp)
  103c90:	00 
  103c91:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103c98:	00 
  103c99:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103ca0:	00 
  103ca1:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103ca8:	e8 84 c7 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 1);
  103cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb0:	89 04 24             	mov    %eax,(%esp)
  103cb3:	e8 1c f2 ff ff       	call   102ed4 <page_ref>
  103cb8:	83 f8 01             	cmp    $0x1,%eax
  103cbb:	74 24                	je     103ce1 <check_pgdir+0x1c9>
  103cbd:	c7 44 24 0c 73 6f 10 	movl   $0x106f73,0xc(%esp)
  103cc4:	00 
  103cc5:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103ccc:	00 
  103ccd:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103cd4:	00 
  103cd5:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103cdc:	e8 50 c7 ff ff       	call   100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103ce1:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103ce6:	8b 00                	mov    (%eax),%eax
  103ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cf3:	c1 e8 0c             	shr    $0xc,%eax
  103cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103cf9:	a1 80 de 11 00       	mov    0x11de80,%eax
  103cfe:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103d01:	72 23                	jb     103d26 <check_pgdir+0x20e>
  103d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d06:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d0a:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  103d11:	00 
  103d12:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103d19:	00 
  103d1a:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103d21:	e8 0b c7 ff ff       	call   100431 <__panic>
  103d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d29:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103d2e:	83 c0 04             	add    $0x4,%eax
  103d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103d34:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d40:	00 
  103d41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d48:	00 
  103d49:	89 04 24             	mov    %eax,(%esp)
  103d4c:	e8 41 fa ff ff       	call   103792 <get_pte>
  103d51:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103d54:	74 24                	je     103d7a <check_pgdir+0x262>
  103d56:	c7 44 24 0c 88 6f 10 	movl   $0x106f88,0xc(%esp)
  103d5d:	00 
  103d5e:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103d65:	00 
  103d66:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103d6d:	00 
  103d6e:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103d75:	e8 b7 c6 ff ff       	call   100431 <__panic>

    p2 = alloc_page();
  103d7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103d81:	e8 64 f3 ff ff       	call   1030ea <alloc_pages>
  103d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103d89:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d8e:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103d95:	00 
  103d96:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103d9d:	00 
  103d9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103da1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103da5:	89 04 24             	mov    %eax,(%esp)
  103da8:	e8 2a fc ff ff       	call   1039d7 <page_insert>
  103dad:	85 c0                	test   %eax,%eax
  103daf:	74 24                	je     103dd5 <check_pgdir+0x2bd>
  103db1:	c7 44 24 0c b0 6f 10 	movl   $0x106fb0,0xc(%esp)
  103db8:	00 
  103db9:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103dc0:	00 
  103dc1:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103dc8:	00 
  103dc9:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103dd0:	e8 5c c6 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103dd5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103dda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103de1:	00 
  103de2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103de9:	00 
  103dea:	89 04 24             	mov    %eax,(%esp)
  103ded:	e8 a0 f9 ff ff       	call   103792 <get_pte>
  103df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103df9:	75 24                	jne    103e1f <check_pgdir+0x307>
  103dfb:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  103e02:	00 
  103e03:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103e0a:	00 
  103e0b:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103e12:	00 
  103e13:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103e1a:	e8 12 c6 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_U);
  103e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e22:	8b 00                	mov    (%eax),%eax
  103e24:	83 e0 04             	and    $0x4,%eax
  103e27:	85 c0                	test   %eax,%eax
  103e29:	75 24                	jne    103e4f <check_pgdir+0x337>
  103e2b:	c7 44 24 0c 18 70 10 	movl   $0x107018,0xc(%esp)
  103e32:	00 
  103e33:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103e3a:	00 
  103e3b:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103e42:	00 
  103e43:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103e4a:	e8 e2 c5 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_W);
  103e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e52:	8b 00                	mov    (%eax),%eax
  103e54:	83 e0 02             	and    $0x2,%eax
  103e57:	85 c0                	test   %eax,%eax
  103e59:	75 24                	jne    103e7f <check_pgdir+0x367>
  103e5b:	c7 44 24 0c 26 70 10 	movl   $0x107026,0xc(%esp)
  103e62:	00 
  103e63:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103e6a:	00 
  103e6b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103e72:	00 
  103e73:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103e7a:	e8 b2 c5 ff ff       	call   100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103e7f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e84:	8b 00                	mov    (%eax),%eax
  103e86:	83 e0 04             	and    $0x4,%eax
  103e89:	85 c0                	test   %eax,%eax
  103e8b:	75 24                	jne    103eb1 <check_pgdir+0x399>
  103e8d:	c7 44 24 0c 34 70 10 	movl   $0x107034,0xc(%esp)
  103e94:	00 
  103e95:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103e9c:	00 
  103e9d:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103ea4:	00 
  103ea5:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103eac:	e8 80 c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 1);
  103eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103eb4:	89 04 24             	mov    %eax,(%esp)
  103eb7:	e8 18 f0 ff ff       	call   102ed4 <page_ref>
  103ebc:	83 f8 01             	cmp    $0x1,%eax
  103ebf:	74 24                	je     103ee5 <check_pgdir+0x3cd>
  103ec1:	c7 44 24 0c 4a 70 10 	movl   $0x10704a,0xc(%esp)
  103ec8:	00 
  103ec9:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103ed0:	00 
  103ed1:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103ed8:	00 
  103ed9:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103ee0:	e8 4c c5 ff ff       	call   100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103ee5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103eea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103ef1:	00 
  103ef2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103ef9:	00 
  103efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103efd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f01:	89 04 24             	mov    %eax,(%esp)
  103f04:	e8 ce fa ff ff       	call   1039d7 <page_insert>
  103f09:	85 c0                	test   %eax,%eax
  103f0b:	74 24                	je     103f31 <check_pgdir+0x419>
  103f0d:	c7 44 24 0c 5c 70 10 	movl   $0x10705c,0xc(%esp)
  103f14:	00 
  103f15:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103f1c:	00 
  103f1d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103f24:	00 
  103f25:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103f2c:	e8 00 c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 2);
  103f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f34:	89 04 24             	mov    %eax,(%esp)
  103f37:	e8 98 ef ff ff       	call   102ed4 <page_ref>
  103f3c:	83 f8 02             	cmp    $0x2,%eax
  103f3f:	74 24                	je     103f65 <check_pgdir+0x44d>
  103f41:	c7 44 24 0c 88 70 10 	movl   $0x107088,0xc(%esp)
  103f48:	00 
  103f49:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103f50:	00 
  103f51:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103f58:	00 
  103f59:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103f60:	e8 cc c4 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f68:	89 04 24             	mov    %eax,(%esp)
  103f6b:	e8 64 ef ff ff       	call   102ed4 <page_ref>
  103f70:	85 c0                	test   %eax,%eax
  103f72:	74 24                	je     103f98 <check_pgdir+0x480>
  103f74:	c7 44 24 0c 9a 70 10 	movl   $0x10709a,0xc(%esp)
  103f7b:	00 
  103f7c:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103f83:	00 
  103f84:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103f8b:	00 
  103f8c:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103f93:	e8 99 c4 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103f98:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103f9d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103fa4:	00 
  103fa5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103fac:	00 
  103fad:	89 04 24             	mov    %eax,(%esp)
  103fb0:	e8 dd f7 ff ff       	call   103792 <get_pte>
  103fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fbc:	75 24                	jne    103fe2 <check_pgdir+0x4ca>
  103fbe:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  103fc5:	00 
  103fc6:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  103fcd:	00 
  103fce:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103fd5:	00 
  103fd6:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  103fdd:	e8 4f c4 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fe5:	8b 00                	mov    (%eax),%eax
  103fe7:	89 04 24             	mov    %eax,(%esp)
  103fea:	e8 8f ee ff ff       	call   102e7e <pte2page>
  103fef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103ff2:	74 24                	je     104018 <check_pgdir+0x500>
  103ff4:	c7 44 24 0c 5d 6f 10 	movl   $0x106f5d,0xc(%esp)
  103ffb:	00 
  103ffc:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104003:	00 
  104004:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  10400b:	00 
  10400c:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104013:	e8 19 c4 ff ff       	call   100431 <__panic>
    assert((*ptep & PTE_U) == 0);
  104018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10401b:	8b 00                	mov    (%eax),%eax
  10401d:	83 e0 04             	and    $0x4,%eax
  104020:	85 c0                	test   %eax,%eax
  104022:	74 24                	je     104048 <check_pgdir+0x530>
  104024:	c7 44 24 0c ac 70 10 	movl   $0x1070ac,0xc(%esp)
  10402b:	00 
  10402c:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104033:	00 
  104034:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10403b:	00 
  10403c:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104043:	e8 e9 c3 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, 0x0);
  104048:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10404d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104054:	00 
  104055:	89 04 24             	mov    %eax,(%esp)
  104058:	e8 31 f9 ff ff       	call   10398e <page_remove>
    assert(page_ref(p1) == 1);
  10405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104060:	89 04 24             	mov    %eax,(%esp)
  104063:	e8 6c ee ff ff       	call   102ed4 <page_ref>
  104068:	83 f8 01             	cmp    $0x1,%eax
  10406b:	74 24                	je     104091 <check_pgdir+0x579>
  10406d:	c7 44 24 0c 73 6f 10 	movl   $0x106f73,0xc(%esp)
  104074:	00 
  104075:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10407c:	00 
  10407d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104084:	00 
  104085:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10408c:	e8 a0 c3 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  104091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104094:	89 04 24             	mov    %eax,(%esp)
  104097:	e8 38 ee ff ff       	call   102ed4 <page_ref>
  10409c:	85 c0                	test   %eax,%eax
  10409e:	74 24                	je     1040c4 <check_pgdir+0x5ac>
  1040a0:	c7 44 24 0c 9a 70 10 	movl   $0x10709a,0xc(%esp)
  1040a7:	00 
  1040a8:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  1040af:	00 
  1040b0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1040b7:	00 
  1040b8:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1040bf:	e8 6d c3 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1040c4:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1040c9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1040d0:	00 
  1040d1:	89 04 24             	mov    %eax,(%esp)
  1040d4:	e8 b5 f8 ff ff       	call   10398e <page_remove>
    assert(page_ref(p1) == 0);
  1040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040dc:	89 04 24             	mov    %eax,(%esp)
  1040df:	e8 f0 ed ff ff       	call   102ed4 <page_ref>
  1040e4:	85 c0                	test   %eax,%eax
  1040e6:	74 24                	je     10410c <check_pgdir+0x5f4>
  1040e8:	c7 44 24 0c c1 70 10 	movl   $0x1070c1,0xc(%esp)
  1040ef:	00 
  1040f0:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  1040f7:	00 
  1040f8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1040ff:	00 
  104100:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104107:	e8 25 c3 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  10410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10410f:	89 04 24             	mov    %eax,(%esp)
  104112:	e8 bd ed ff ff       	call   102ed4 <page_ref>
  104117:	85 c0                	test   %eax,%eax
  104119:	74 24                	je     10413f <check_pgdir+0x627>
  10411b:	c7 44 24 0c 9a 70 10 	movl   $0x10709a,0xc(%esp)
  104122:	00 
  104123:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10412a:	00 
  10412b:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104132:	00 
  104133:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10413a:	e8 f2 c2 ff ff       	call   100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  10413f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104144:	8b 00                	mov    (%eax),%eax
  104146:	89 04 24             	mov    %eax,(%esp)
  104149:	e8 6e ed ff ff       	call   102ebc <pde2page>
  10414e:	89 04 24             	mov    %eax,(%esp)
  104151:	e8 7e ed ff ff       	call   102ed4 <page_ref>
  104156:	83 f8 01             	cmp    $0x1,%eax
  104159:	74 24                	je     10417f <check_pgdir+0x667>
  10415b:	c7 44 24 0c d4 70 10 	movl   $0x1070d4,0xc(%esp)
  104162:	00 
  104163:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10416a:	00 
  10416b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104172:	00 
  104173:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10417a:	e8 b2 c2 ff ff       	call   100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  10417f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104184:	8b 00                	mov    (%eax),%eax
  104186:	89 04 24             	mov    %eax,(%esp)
  104189:	e8 2e ed ff ff       	call   102ebc <pde2page>
  10418e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104195:	00 
  104196:	89 04 24             	mov    %eax,(%esp)
  104199:	e8 88 ef ff ff       	call   103126 <free_pages>
    boot_pgdir[0] = 0;
  10419e:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1041a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1041a9:	c7 04 24 fb 70 10 00 	movl   $0x1070fb,(%esp)
  1041b0:	e8 10 c1 ff ff       	call   1002c5 <cprintf>
}
  1041b5:	90                   	nop
  1041b6:	c9                   	leave  
  1041b7:	c3                   	ret    

001041b8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1041b8:	f3 0f 1e fb          	endbr32 
  1041bc:	55                   	push   %ebp
  1041bd:	89 e5                	mov    %esp,%ebp
  1041bf:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1041c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041c9:	e9 ca 00 00 00       	jmp    104298 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041d7:	c1 e8 0c             	shr    $0xc,%eax
  1041da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1041dd:	a1 80 de 11 00       	mov    0x11de80,%eax
  1041e2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1041e5:	72 23                	jb     10420a <check_boot_pgdir+0x52>
  1041e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041ee:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  1041f5:	00 
  1041f6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  1041fd:	00 
  1041fe:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104205:	e8 27 c2 ff ff       	call   100431 <__panic>
  10420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10420d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104212:	89 c2                	mov    %eax,%edx
  104214:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104219:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104220:	00 
  104221:	89 54 24 04          	mov    %edx,0x4(%esp)
  104225:	89 04 24             	mov    %eax,(%esp)
  104228:	e8 65 f5 ff ff       	call   103792 <get_pte>
  10422d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104230:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104234:	75 24                	jne    10425a <check_boot_pgdir+0xa2>
  104236:	c7 44 24 0c 18 71 10 	movl   $0x107118,0xc(%esp)
  10423d:	00 
  10423e:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104245:	00 
  104246:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  10424d:	00 
  10424e:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104255:	e8 d7 c1 ff ff       	call   100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10425a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10425d:	8b 00                	mov    (%eax),%eax
  10425f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104264:	89 c2                	mov    %eax,%edx
  104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104269:	39 c2                	cmp    %eax,%edx
  10426b:	74 24                	je     104291 <check_boot_pgdir+0xd9>
  10426d:	c7 44 24 0c 55 71 10 	movl   $0x107155,0xc(%esp)
  104274:	00 
  104275:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10427c:	00 
  10427d:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104284:	00 
  104285:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10428c:	e8 a0 c1 ff ff       	call   100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104291:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10429b:	a1 80 de 11 00       	mov    0x11de80,%eax
  1042a0:	39 c2                	cmp    %eax,%edx
  1042a2:	0f 82 26 ff ff ff    	jb     1041ce <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1042a8:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042ad:	05 ac 0f 00 00       	add    $0xfac,%eax
  1042b2:	8b 00                	mov    (%eax),%eax
  1042b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042b9:	89 c2                	mov    %eax,%edx
  1042bb:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042c3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1042ca:	77 23                	ja     1042ef <check_boot_pgdir+0x137>
  1042cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1042d3:	c7 44 24 08 e4 6d 10 	movl   $0x106de4,0x8(%esp)
  1042da:	00 
  1042db:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  1042e2:	00 
  1042e3:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1042ea:	e8 42 c1 ff ff       	call   100431 <__panic>
  1042ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f2:	05 00 00 00 40       	add    $0x40000000,%eax
  1042f7:	39 d0                	cmp    %edx,%eax
  1042f9:	74 24                	je     10431f <check_boot_pgdir+0x167>
  1042fb:	c7 44 24 0c 6c 71 10 	movl   $0x10716c,0xc(%esp)
  104302:	00 
  104303:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10430a:	00 
  10430b:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104312:	00 
  104313:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10431a:	e8 12 c1 ff ff       	call   100431 <__panic>

    assert(boot_pgdir[0] == 0);
  10431f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104324:	8b 00                	mov    (%eax),%eax
  104326:	85 c0                	test   %eax,%eax
  104328:	74 24                	je     10434e <check_boot_pgdir+0x196>
  10432a:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  104331:	00 
  104332:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104339:	00 
  10433a:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104341:	00 
  104342:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104349:	e8 e3 c0 ff ff       	call   100431 <__panic>

    struct Page *p;
    p = alloc_page();
  10434e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104355:	e8 90 ed ff ff       	call   1030ea <alloc_pages>
  10435a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10435d:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104362:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104369:	00 
  10436a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104371:	00 
  104372:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104375:	89 54 24 04          	mov    %edx,0x4(%esp)
  104379:	89 04 24             	mov    %eax,(%esp)
  10437c:	e8 56 f6 ff ff       	call   1039d7 <page_insert>
  104381:	85 c0                	test   %eax,%eax
  104383:	74 24                	je     1043a9 <check_boot_pgdir+0x1f1>
  104385:	c7 44 24 0c b4 71 10 	movl   $0x1071b4,0xc(%esp)
  10438c:	00 
  10438d:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104394:	00 
  104395:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  10439c:	00 
  10439d:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1043a4:	e8 88 c0 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 1);
  1043a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043ac:	89 04 24             	mov    %eax,(%esp)
  1043af:	e8 20 eb ff ff       	call   102ed4 <page_ref>
  1043b4:	83 f8 01             	cmp    $0x1,%eax
  1043b7:	74 24                	je     1043dd <check_boot_pgdir+0x225>
  1043b9:	c7 44 24 0c e2 71 10 	movl   $0x1071e2,0xc(%esp)
  1043c0:	00 
  1043c1:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  1043c8:	00 
  1043c9:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  1043d0:	00 
  1043d1:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1043d8:	e8 54 c0 ff ff       	call   100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1043dd:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1043e2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1043e9:	00 
  1043ea:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1043f1:	00 
  1043f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1043f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1043f9:	89 04 24             	mov    %eax,(%esp)
  1043fc:	e8 d6 f5 ff ff       	call   1039d7 <page_insert>
  104401:	85 c0                	test   %eax,%eax
  104403:	74 24                	je     104429 <check_boot_pgdir+0x271>
  104405:	c7 44 24 0c f4 71 10 	movl   $0x1071f4,0xc(%esp)
  10440c:	00 
  10440d:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104414:	00 
  104415:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  10441c:	00 
  10441d:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104424:	e8 08 c0 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 2);
  104429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10442c:	89 04 24             	mov    %eax,(%esp)
  10442f:	e8 a0 ea ff ff       	call   102ed4 <page_ref>
  104434:	83 f8 02             	cmp    $0x2,%eax
  104437:	74 24                	je     10445d <check_boot_pgdir+0x2a5>
  104439:	c7 44 24 0c 2b 72 10 	movl   $0x10722b,0xc(%esp)
  104440:	00 
  104441:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  104448:	00 
  104449:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104450:	00 
  104451:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  104458:	e8 d4 bf ff ff       	call   100431 <__panic>

    const char *str = "ucore: Hello world!!";
  10445d:	c7 45 e8 3c 72 10 00 	movl   $0x10723c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104467:	89 44 24 04          	mov    %eax,0x4(%esp)
  10446b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104472:	e8 32 16 00 00       	call   105aa9 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104477:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10447e:	00 
  10447f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104486:	e8 9c 16 00 00       	call   105b27 <strcmp>
  10448b:	85 c0                	test   %eax,%eax
  10448d:	74 24                	je     1044b3 <check_boot_pgdir+0x2fb>
  10448f:	c7 44 24 0c 54 72 10 	movl   $0x107254,0xc(%esp)
  104496:	00 
  104497:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  10449e:	00 
  10449f:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  1044a6:	00 
  1044a7:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1044ae:	e8 7e bf ff ff       	call   100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1044b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044b6:	89 04 24             	mov    %eax,(%esp)
  1044b9:	e8 6c e9 ff ff       	call   102e2a <page2kva>
  1044be:	05 00 01 00 00       	add    $0x100,%eax
  1044c3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1044c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1044cd:	e8 79 15 00 00       	call   105a4b <strlen>
  1044d2:	85 c0                	test   %eax,%eax
  1044d4:	74 24                	je     1044fa <check_boot_pgdir+0x342>
  1044d6:	c7 44 24 0c 8c 72 10 	movl   $0x10728c,0xc(%esp)
  1044dd:	00 
  1044de:	c7 44 24 08 2d 6e 10 	movl   $0x106e2d,0x8(%esp)
  1044e5:	00 
  1044e6:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  1044ed:	00 
  1044ee:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  1044f5:	e8 37 bf ff ff       	call   100431 <__panic>

    free_page(p);
  1044fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104501:	00 
  104502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104505:	89 04 24             	mov    %eax,(%esp)
  104508:	e8 19 ec ff ff       	call   103126 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10450d:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104512:	8b 00                	mov    (%eax),%eax
  104514:	89 04 24             	mov    %eax,(%esp)
  104517:	e8 a0 e9 ff ff       	call   102ebc <pde2page>
  10451c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104523:	00 
  104524:	89 04 24             	mov    %eax,(%esp)
  104527:	e8 fa eb ff ff       	call   103126 <free_pages>
    boot_pgdir[0] = 0;
  10452c:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104537:	c7 04 24 b0 72 10 00 	movl   $0x1072b0,(%esp)
  10453e:	e8 82 bd ff ff       	call   1002c5 <cprintf>
}
  104543:	90                   	nop
  104544:	c9                   	leave  
  104545:	c3                   	ret    

00104546 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104546:	f3 0f 1e fb          	endbr32 
  10454a:	55                   	push   %ebp
  10454b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10454d:	8b 45 08             	mov    0x8(%ebp),%eax
  104550:	83 e0 04             	and    $0x4,%eax
  104553:	85 c0                	test   %eax,%eax
  104555:	74 04                	je     10455b <perm2str+0x15>
  104557:	b0 75                	mov    $0x75,%al
  104559:	eb 02                	jmp    10455d <perm2str+0x17>
  10455b:	b0 2d                	mov    $0x2d,%al
  10455d:	a2 08 df 11 00       	mov    %al,0x11df08
    str[1] = 'r';
  104562:	c6 05 09 df 11 00 72 	movb   $0x72,0x11df09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104569:	8b 45 08             	mov    0x8(%ebp),%eax
  10456c:	83 e0 02             	and    $0x2,%eax
  10456f:	85 c0                	test   %eax,%eax
  104571:	74 04                	je     104577 <perm2str+0x31>
  104573:	b0 77                	mov    $0x77,%al
  104575:	eb 02                	jmp    104579 <perm2str+0x33>
  104577:	b0 2d                	mov    $0x2d,%al
  104579:	a2 0a df 11 00       	mov    %al,0x11df0a
    str[3] = '\0';
  10457e:	c6 05 0b df 11 00 00 	movb   $0x0,0x11df0b
    return str;
  104585:	b8 08 df 11 00       	mov    $0x11df08,%eax
}
  10458a:	5d                   	pop    %ebp
  10458b:	c3                   	ret    

0010458c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10458c:	f3 0f 1e fb          	endbr32 
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104596:	8b 45 10             	mov    0x10(%ebp),%eax
  104599:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10459c:	72 0d                	jb     1045ab <get_pgtable_items+0x1f>
        return 0;
  10459e:	b8 00 00 00 00       	mov    $0x0,%eax
  1045a3:	e9 98 00 00 00       	jmp    104640 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1045a8:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1045ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045b1:	73 18                	jae    1045cb <get_pgtable_items+0x3f>
  1045b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1045b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045bd:	8b 45 14             	mov    0x14(%ebp),%eax
  1045c0:	01 d0                	add    %edx,%eax
  1045c2:	8b 00                	mov    (%eax),%eax
  1045c4:	83 e0 01             	and    $0x1,%eax
  1045c7:	85 c0                	test   %eax,%eax
  1045c9:	74 dd                	je     1045a8 <get_pgtable_items+0x1c>
    }
    if (start < right) {
  1045cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045d1:	73 68                	jae    10463b <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1045d3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1045d7:	74 08                	je     1045e1 <get_pgtable_items+0x55>
            *left_store = start;
  1045d9:	8b 45 18             	mov    0x18(%ebp),%eax
  1045dc:	8b 55 10             	mov    0x10(%ebp),%edx
  1045df:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1045e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1045e4:	8d 50 01             	lea    0x1(%eax),%edx
  1045e7:	89 55 10             	mov    %edx,0x10(%ebp)
  1045ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045f1:	8b 45 14             	mov    0x14(%ebp),%eax
  1045f4:	01 d0                	add    %edx,%eax
  1045f6:	8b 00                	mov    (%eax),%eax
  1045f8:	83 e0 07             	and    $0x7,%eax
  1045fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1045fe:	eb 03                	jmp    104603 <get_pgtable_items+0x77>
            start ++;
  104600:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104603:	8b 45 10             	mov    0x10(%ebp),%eax
  104606:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104609:	73 1d                	jae    104628 <get_pgtable_items+0x9c>
  10460b:	8b 45 10             	mov    0x10(%ebp),%eax
  10460e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104615:	8b 45 14             	mov    0x14(%ebp),%eax
  104618:	01 d0                	add    %edx,%eax
  10461a:	8b 00                	mov    (%eax),%eax
  10461c:	83 e0 07             	and    $0x7,%eax
  10461f:	89 c2                	mov    %eax,%edx
  104621:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104624:	39 c2                	cmp    %eax,%edx
  104626:	74 d8                	je     104600 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  104628:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10462c:	74 08                	je     104636 <get_pgtable_items+0xaa>
            *right_store = start;
  10462e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104631:	8b 55 10             	mov    0x10(%ebp),%edx
  104634:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104639:	eb 05                	jmp    104640 <get_pgtable_items+0xb4>
    }
    return 0;
  10463b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104640:	c9                   	leave  
  104641:	c3                   	ret    

00104642 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104642:	f3 0f 1e fb          	endbr32 
  104646:	55                   	push   %ebp
  104647:	89 e5                	mov    %esp,%ebp
  104649:	57                   	push   %edi
  10464a:	56                   	push   %esi
  10464b:	53                   	push   %ebx
  10464c:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10464f:	c7 04 24 d0 72 10 00 	movl   $0x1072d0,(%esp)
  104656:	e8 6a bc ff ff       	call   1002c5 <cprintf>
    size_t left, right = 0, perm;
  10465b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104662:	e9 fa 00 00 00       	jmp    104761 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10466a:	89 04 24             	mov    %eax,(%esp)
  10466d:	e8 d4 fe ff ff       	call   104546 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104675:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104678:	29 d1                	sub    %edx,%ecx
  10467a:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10467c:	89 d6                	mov    %edx,%esi
  10467e:	c1 e6 16             	shl    $0x16,%esi
  104681:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104684:	89 d3                	mov    %edx,%ebx
  104686:	c1 e3 16             	shl    $0x16,%ebx
  104689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10468c:	89 d1                	mov    %edx,%ecx
  10468e:	c1 e1 16             	shl    $0x16,%ecx
  104691:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104697:	29 d7                	sub    %edx,%edi
  104699:	89 fa                	mov    %edi,%edx
  10469b:	89 44 24 14          	mov    %eax,0x14(%esp)
  10469f:	89 74 24 10          	mov    %esi,0x10(%esp)
  1046a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1046a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1046ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046af:	c7 04 24 01 73 10 00 	movl   $0x107301,(%esp)
  1046b6:	e8 0a bc ff ff       	call   1002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1046bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046be:	c1 e0 0a             	shl    $0xa,%eax
  1046c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1046c4:	eb 54                	jmp    10471a <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1046c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046c9:	89 04 24             	mov    %eax,(%esp)
  1046cc:	e8 75 fe ff ff       	call   104546 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1046d1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1046d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046d7:	29 d1                	sub    %edx,%ecx
  1046d9:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1046db:	89 d6                	mov    %edx,%esi
  1046dd:	c1 e6 0c             	shl    $0xc,%esi
  1046e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1046e3:	89 d3                	mov    %edx,%ebx
  1046e5:	c1 e3 0c             	shl    $0xc,%ebx
  1046e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046eb:	89 d1                	mov    %edx,%ecx
  1046ed:	c1 e1 0c             	shl    $0xc,%ecx
  1046f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1046f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046f6:	29 d7                	sub    %edx,%edi
  1046f8:	89 fa                	mov    %edi,%edx
  1046fa:	89 44 24 14          	mov    %eax,0x14(%esp)
  1046fe:	89 74 24 10          	mov    %esi,0x10(%esp)
  104702:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104706:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10470a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10470e:	c7 04 24 20 73 10 00 	movl   $0x107320,(%esp)
  104715:	e8 ab bb ff ff       	call   1002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10471a:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  10471f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104722:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104725:	89 d3                	mov    %edx,%ebx
  104727:	c1 e3 0a             	shl    $0xa,%ebx
  10472a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10472d:	89 d1                	mov    %edx,%ecx
  10472f:	c1 e1 0a             	shl    $0xa,%ecx
  104732:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104735:	89 54 24 14          	mov    %edx,0x14(%esp)
  104739:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10473c:	89 54 24 10          	mov    %edx,0x10(%esp)
  104740:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104744:	89 44 24 08          	mov    %eax,0x8(%esp)
  104748:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10474c:	89 0c 24             	mov    %ecx,(%esp)
  10474f:	e8 38 fe ff ff       	call   10458c <get_pgtable_items>
  104754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10475b:	0f 85 65 ff ff ff    	jne    1046c6 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104761:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104766:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104769:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10476c:	89 54 24 14          	mov    %edx,0x14(%esp)
  104770:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104773:	89 54 24 10          	mov    %edx,0x10(%esp)
  104777:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10477b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10477f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104786:	00 
  104787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10478e:	e8 f9 fd ff ff       	call   10458c <get_pgtable_items>
  104793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10479a:	0f 85 c7 fe ff ff    	jne    104667 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1047a0:	c7 04 24 44 73 10 00 	movl   $0x107344,(%esp)
  1047a7:	e8 19 bb ff ff       	call   1002c5 <cprintf>
}
  1047ac:	90                   	nop
  1047ad:	83 c4 4c             	add    $0x4c,%esp
  1047b0:	5b                   	pop    %ebx
  1047b1:	5e                   	pop    %esi
  1047b2:	5f                   	pop    %edi
  1047b3:	5d                   	pop    %ebp
  1047b4:	c3                   	ret    

001047b5 <page2ppn>:
page2ppn(struct Page *page) {
  1047b5:	55                   	push   %ebp
  1047b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1047b8:	a1 78 df 11 00       	mov    0x11df78,%eax
  1047bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1047c0:	29 c2                	sub    %eax,%edx
  1047c2:	89 d0                	mov    %edx,%eax
  1047c4:	c1 f8 02             	sar    $0x2,%eax
  1047c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1047cd:	5d                   	pop    %ebp
  1047ce:	c3                   	ret    

001047cf <page2pa>:
page2pa(struct Page *page) {
  1047cf:	55                   	push   %ebp
  1047d0:	89 e5                	mov    %esp,%ebp
  1047d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1047d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d8:	89 04 24             	mov    %eax,(%esp)
  1047db:	e8 d5 ff ff ff       	call   1047b5 <page2ppn>
  1047e0:	c1 e0 0c             	shl    $0xc,%eax
}
  1047e3:	c9                   	leave  
  1047e4:	c3                   	ret    

001047e5 <page_ref>:
page_ref(struct Page *page) {
  1047e5:	55                   	push   %ebp
  1047e6:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1047e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1047eb:	8b 00                	mov    (%eax),%eax
}
  1047ed:	5d                   	pop    %ebp
  1047ee:	c3                   	ret    

001047ef <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1047ef:	55                   	push   %ebp
  1047f0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1047f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047f8:	89 10                	mov    %edx,(%eax)
}
  1047fa:	90                   	nop
  1047fb:	5d                   	pop    %ebp
  1047fc:	c3                   	ret    

001047fd <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1047fd:	f3 0f 1e fb          	endbr32 
  104801:	55                   	push   %ebp
  104802:	89 e5                	mov    %esp,%ebp
  104804:	83 ec 10             	sub    $0x10,%esp
  104807:	c7 45 fc 7c df 11 00 	movl   $0x11df7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10480e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104811:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104814:	89 50 04             	mov    %edx,0x4(%eax)
  104817:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10481a:	8b 50 04             	mov    0x4(%eax),%edx
  10481d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104820:	89 10                	mov    %edx,(%eax)
}
  104822:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  104823:	c7 05 84 df 11 00 00 	movl   $0x0,0x11df84
  10482a:	00 00 00 
}
  10482d:	90                   	nop
  10482e:	c9                   	leave  
  10482f:	c3                   	ret    

00104830 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104830:	f3 0f 1e fb          	endbr32 
  104834:	55                   	push   %ebp
  104835:	89 e5                	mov    %esp,%ebp
  104837:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10483a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10483e:	75 24                	jne    104864 <default_init_memmap+0x34>
  104840:	c7 44 24 0c 78 73 10 	movl   $0x107378,0xc(%esp)
  104847:	00 
  104848:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10484f:	00 
  104850:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  104857:	00 
  104858:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10485f:	e8 cd bb ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104864:	8b 45 08             	mov    0x8(%ebp),%eax
  104867:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10486a:	eb 7d                	jmp    1048e9 <default_init_memmap+0xb9>
        assert(PageReserved(p));
  10486c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486f:	83 c0 04             	add    $0x4,%eax
  104872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104879:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10487c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10487f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104882:	0f a3 10             	bt     %edx,(%eax)
  104885:	19 c0                	sbb    %eax,%eax
  104887:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10488a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10488e:	0f 95 c0             	setne  %al
  104891:	0f b6 c0             	movzbl %al,%eax
  104894:	85 c0                	test   %eax,%eax
  104896:	75 24                	jne    1048bc <default_init_memmap+0x8c>
  104898:	c7 44 24 0c a9 73 10 	movl   $0x1073a9,0xc(%esp)
  10489f:	00 
  1048a0:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1048a7:	00 
  1048a8:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1048af:	00 
  1048b0:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1048b7:	e8 75 bb ff ff       	call   100431 <__panic>
        p->flags = p->property = 0;
  1048bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c9:	8b 50 08             	mov    0x8(%eax),%edx
  1048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048cf:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1048d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048d9:	00 
  1048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048dd:	89 04 24             	mov    %eax,(%esp)
  1048e0:	e8 0a ff ff ff       	call   1047ef <set_page_ref>
    for (; p != base + n; p ++) {
  1048e5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1048e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048ec:	89 d0                	mov    %edx,%eax
  1048ee:	c1 e0 02             	shl    $0x2,%eax
  1048f1:	01 d0                	add    %edx,%eax
  1048f3:	c1 e0 02             	shl    $0x2,%eax
  1048f6:	89 c2                	mov    %eax,%edx
  1048f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048fb:	01 d0                	add    %edx,%eax
  1048fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104900:	0f 85 66 ff ff ff    	jne    10486c <default_init_memmap+0x3c>
    }
    base->property = n;
  104906:	8b 45 08             	mov    0x8(%ebp),%eax
  104909:	8b 55 0c             	mov    0xc(%ebp),%edx
  10490c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10490f:	8b 45 08             	mov    0x8(%ebp),%eax
  104912:	83 c0 04             	add    $0x4,%eax
  104915:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  10491c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10491f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104922:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104925:	0f ab 10             	bts    %edx,(%eax)
}
  104928:	90                   	nop
    nr_free += n;
  104929:	8b 15 84 df 11 00    	mov    0x11df84,%edx
  10492f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104932:	01 d0                	add    %edx,%eax
  104934:	a3 84 df 11 00       	mov    %eax,0x11df84
    list_add(&free_list, &(base->page_link));
  104939:	8b 45 08             	mov    0x8(%ebp),%eax
  10493c:	83 c0 0c             	add    $0xc,%eax
  10493f:	c7 45 e4 7c df 11 00 	movl   $0x11df7c,-0x1c(%ebp)
  104946:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10494c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10494f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104952:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104955:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104958:	8b 40 04             	mov    0x4(%eax),%eax
  10495b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10495e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104961:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104964:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104967:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10496a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10496d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104970:	89 10                	mov    %edx,(%eax)
  104972:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104975:	8b 10                	mov    (%eax),%edx
  104977:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10497a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10497d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104980:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104983:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104986:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104989:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10498c:	89 10                	mov    %edx,(%eax)
}
  10498e:	90                   	nop
}
  10498f:	90                   	nop
}
  104990:	90                   	nop
}
  104991:	90                   	nop
  104992:	c9                   	leave  
  104993:	c3                   	ret    

00104994 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104994:	f3 0f 1e fb          	endbr32 
  104998:	55                   	push   %ebp
  104999:	89 e5                	mov    %esp,%ebp
  10499b:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10499e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1049a2:	75 24                	jne    1049c8 <default_alloc_pages+0x34>
  1049a4:	c7 44 24 0c 78 73 10 	movl   $0x107378,0xc(%esp)
  1049ab:	00 
  1049ac:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1049b3:	00 
  1049b4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1049bb:	00 
  1049bc:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1049c3:	e8 69 ba ff ff       	call   100431 <__panic>
    if (n > nr_free) {
  1049c8:	a1 84 df 11 00       	mov    0x11df84,%eax
  1049cd:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049d0:	76 0a                	jbe    1049dc <default_alloc_pages+0x48>
        return NULL;
  1049d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1049d7:	e9 4e 01 00 00       	jmp    104b2a <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
  1049dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1049e3:	c7 45 f0 7c df 11 00 	movl   $0x11df7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1049ea:	eb 1c                	jmp    104a08 <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  1049ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049ef:	83 e8 0c             	sub    $0xc,%eax
  1049f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1049f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049f8:	8b 40 08             	mov    0x8(%eax),%eax
  1049fb:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049fe:	77 08                	ja     104a08 <default_alloc_pages+0x74>
            page = p;
  104a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
            //SetPageReserved(page);
            break;
  104a06:	eb 18                	jmp    104a20 <default_alloc_pages+0x8c>
  104a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a11:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a17:	81 7d f0 7c df 11 00 	cmpl   $0x11df7c,-0x10(%ebp)
  104a1e:	75 cc                	jne    1049ec <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  104a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a24:	0f 84 fd 00 00 00    	je     104b27 <default_alloc_pages+0x193>
        //list_del(&(page->page_link));
        if (page->property > n) {
  104a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a2d:	8b 40 08             	mov    0x8(%eax),%eax
  104a30:	39 45 08             	cmp    %eax,0x8(%ebp)
  104a33:	0f 83 9a 00 00 00    	jae    104ad3 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
  104a39:	8b 55 08             	mov    0x8(%ebp),%edx
  104a3c:	89 d0                	mov    %edx,%eax
  104a3e:	c1 e0 02             	shl    $0x2,%eax
  104a41:	01 d0                	add    %edx,%eax
  104a43:	c1 e0 02             	shl    $0x2,%eax
  104a46:	89 c2                	mov    %eax,%edx
  104a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a4b:	01 d0                	add    %edx,%eax
  104a4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a53:	8b 40 08             	mov    0x8(%eax),%eax
  104a56:	2b 45 08             	sub    0x8(%ebp),%eax
  104a59:	89 c2                	mov    %eax,%edx
  104a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a5e:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a64:	83 c0 04             	add    $0x4,%eax
  104a67:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104a6e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a71:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104a74:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104a77:	0f ab 10             	bts    %edx,(%eax)
}
  104a7a:	90                   	nop
            //ClearPageReserved(p);
            list_add(&free_list, &(p->page_link));
  104a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a7e:	83 c0 0c             	add    $0xc,%eax
  104a81:	c7 45 e0 7c df 11 00 	movl   $0x11df7c,-0x20(%ebp)
  104a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  104a97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104a9a:	8b 40 04             	mov    0x4(%eax),%eax
  104a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104aa0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104aa3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104aa6:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104aa9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  104aac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104aaf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104ab2:	89 10                	mov    %edx,(%eax)
  104ab4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104ab7:	8b 10                	mov    (%eax),%edx
  104ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104abc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104abf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ac2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104ac5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104ac8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104acb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104ace:	89 10                	mov    %edx,(%eax)
}
  104ad0:	90                   	nop
}
  104ad1:	90                   	nop
}
  104ad2:	90                   	nop
    }
        list_del(&(page->page_link));
  104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ad6:	83 c0 0c             	add    $0xc,%eax
  104ad9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104adc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104adf:	8b 40 04             	mov    0x4(%eax),%eax
  104ae2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104ae5:	8b 12                	mov    (%edx),%edx
  104ae7:	89 55 b0             	mov    %edx,-0x50(%ebp)
  104aea:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104aed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104af0:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104af3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104af6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104af9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104afc:	89 10                	mov    %edx,(%eax)
}
  104afe:	90                   	nop
}
  104aff:	90                   	nop
        nr_free -= n;
  104b00:	a1 84 df 11 00       	mov    0x11df84,%eax
  104b05:	2b 45 08             	sub    0x8(%ebp),%eax
  104b08:	a3 84 df 11 00       	mov    %eax,0x11df84
        ClearPageProperty(page);
  104b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b10:	83 c0 04             	add    $0x4,%eax
  104b13:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104b1a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104b20:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b23:	0f b3 10             	btr    %edx,(%eax)
}
  104b26:	90                   	nop
    }
    return page;
  104b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104b2a:	c9                   	leave  
  104b2b:	c3                   	ret    

00104b2c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104b2c:	f3 0f 1e fb          	endbr32 
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104b3d:	75 24                	jne    104b63 <default_free_pages+0x37>
  104b3f:	c7 44 24 0c 78 73 10 	movl   $0x107378,0xc(%esp)
  104b46:	00 
  104b47:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  104b56:	00 
  104b57:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104b5e:	e8 ce b8 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104b63:	8b 45 08             	mov    0x8(%ebp),%eax
  104b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104b69:	e9 9d 00 00 00       	jmp    104c0b <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b71:	83 c0 04             	add    $0x4,%eax
  104b74:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104b84:	0f a3 10             	bt     %edx,(%eax)
  104b87:	19 c0                	sbb    %eax,%eax
  104b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104b8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104b90:	0f 95 c0             	setne  %al
  104b93:	0f b6 c0             	movzbl %al,%eax
  104b96:	85 c0                	test   %eax,%eax
  104b98:	75 2c                	jne    104bc6 <default_free_pages+0x9a>
  104b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b9d:	83 c0 04             	add    $0x4,%eax
  104ba0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104bb0:	0f a3 10             	bt     %edx,(%eax)
  104bb3:	19 c0                	sbb    %eax,%eax
  104bb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104bb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104bbc:	0f 95 c0             	setne  %al
  104bbf:	0f b6 c0             	movzbl %al,%eax
  104bc2:	85 c0                	test   %eax,%eax
  104bc4:	74 24                	je     104bea <default_free_pages+0xbe>
  104bc6:	c7 44 24 0c bc 73 10 	movl   $0x1073bc,0xc(%esp)
  104bcd:	00 
  104bce:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104bd5:	00 
  104bd6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  104bdd:	00 
  104bde:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104be5:	e8 47 b8 ff ff       	call   100431 <__panic>
        p->flags = 0;
  104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104bf4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104bfb:	00 
  104bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bff:	89 04 24             	mov    %eax,(%esp)
  104c02:	e8 e8 fb ff ff       	call   1047ef <set_page_ref>
    for (; p != base + n; p ++) {
  104c07:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  104c0e:	89 d0                	mov    %edx,%eax
  104c10:	c1 e0 02             	shl    $0x2,%eax
  104c13:	01 d0                	add    %edx,%eax
  104c15:	c1 e0 02             	shl    $0x2,%eax
  104c18:	89 c2                	mov    %eax,%edx
  104c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  104c1d:	01 d0                	add    %edx,%eax
  104c1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104c22:	0f 85 46 ff ff ff    	jne    104b6e <default_free_pages+0x42>
    }
    base->property = n;
  104c28:	8b 45 08             	mov    0x8(%ebp),%eax
  104c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  104c2e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104c31:	8b 45 08             	mov    0x8(%ebp),%eax
  104c34:	83 c0 04             	add    $0x4,%eax
  104c37:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104c3e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104c41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c44:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104c47:	0f ab 10             	bts    %edx,(%eax)
}
  104c4a:	90                   	nop
  104c4b:	c7 45 d4 7c df 11 00 	movl   $0x11df7c,-0x2c(%ebp)
    return listelm->next;
  104c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104c55:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104c5b:	e9 0e 01 00 00       	jmp    104d6e <default_free_pages+0x242>
        p = le2page(le, page_link);
  104c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c63:	83 e8 0c             	sub    $0xc,%eax
  104c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c6c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104c6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c72:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104c78:	8b 45 08             	mov    0x8(%ebp),%eax
  104c7b:	8b 50 08             	mov    0x8(%eax),%edx
  104c7e:	89 d0                	mov    %edx,%eax
  104c80:	c1 e0 02             	shl    $0x2,%eax
  104c83:	01 d0                	add    %edx,%eax
  104c85:	c1 e0 02             	shl    $0x2,%eax
  104c88:	89 c2                	mov    %eax,%edx
  104c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  104c8d:	01 d0                	add    %edx,%eax
  104c8f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104c92:	75 5d                	jne    104cf1 <default_free_pages+0x1c5>
            base->property += p->property;
  104c94:	8b 45 08             	mov    0x8(%ebp),%eax
  104c97:	8b 50 08             	mov    0x8(%eax),%edx
  104c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c9d:	8b 40 08             	mov    0x8(%eax),%eax
  104ca0:	01 c2                	add    %eax,%edx
  104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  104ca5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cab:	83 c0 04             	add    $0x4,%eax
  104cae:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104cb5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104cb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104cbb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104cbe:	0f b3 10             	btr    %edx,(%eax)
}
  104cc1:	90                   	nop
            list_del(&(p->page_link));
  104cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cc5:	83 c0 0c             	add    $0xc,%eax
  104cc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104ccb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104cce:	8b 40 04             	mov    0x4(%eax),%eax
  104cd1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104cd4:	8b 12                	mov    (%edx),%edx
  104cd6:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104cd9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104cdc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104cdf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ce2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104ce5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104ce8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104ceb:	89 10                	mov    %edx,(%eax)
}
  104ced:	90                   	nop
}
  104cee:	90                   	nop
  104cef:	eb 7d                	jmp    104d6e <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cf4:	8b 50 08             	mov    0x8(%eax),%edx
  104cf7:	89 d0                	mov    %edx,%eax
  104cf9:	c1 e0 02             	shl    $0x2,%eax
  104cfc:	01 d0                	add    %edx,%eax
  104cfe:	c1 e0 02             	shl    $0x2,%eax
  104d01:	89 c2                	mov    %eax,%edx
  104d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d06:	01 d0                	add    %edx,%eax
  104d08:	39 45 08             	cmp    %eax,0x8(%ebp)
  104d0b:	75 61                	jne    104d6e <default_free_pages+0x242>
            p->property += base->property;
  104d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d10:	8b 50 08             	mov    0x8(%eax),%edx
  104d13:	8b 45 08             	mov    0x8(%ebp),%eax
  104d16:	8b 40 08             	mov    0x8(%eax),%eax
  104d19:	01 c2                	add    %eax,%edx
  104d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d1e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104d21:	8b 45 08             	mov    0x8(%ebp),%eax
  104d24:	83 c0 04             	add    $0x4,%eax
  104d27:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104d2e:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104d31:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104d34:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104d37:	0f b3 10             	btr    %edx,(%eax)
}
  104d3a:	90                   	nop
            base = p;
  104d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d3e:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d44:	83 c0 0c             	add    $0xc,%eax
  104d47:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104d4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104d4d:	8b 40 04             	mov    0x4(%eax),%eax
  104d50:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104d53:	8b 12                	mov    (%edx),%edx
  104d55:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104d58:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104d5b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104d5e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104d61:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104d64:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104d67:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104d6a:	89 10                	mov    %edx,(%eax)
}
  104d6c:	90                   	nop
}
  104d6d:	90                   	nop
    while (le != &free_list) {
  104d6e:	81 7d f0 7c df 11 00 	cmpl   $0x11df7c,-0x10(%ebp)
  104d75:	0f 85 e5 fe ff ff    	jne    104c60 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  104d7b:	8b 15 84 df 11 00    	mov    0x11df84,%edx
  104d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d84:	01 d0                	add    %edx,%eax
  104d86:	a3 84 df 11 00       	mov    %eax,0x11df84
  104d8b:	c7 45 9c 7c df 11 00 	movl   $0x11df7c,-0x64(%ebp)
    return listelm->next;
  104d92:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104d95:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104d9b:	eb 74                	jmp    104e11 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  104d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104da0:	83 e8 0c             	sub    $0xc,%eax
  104da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  104da6:	8b 45 08             	mov    0x8(%ebp),%eax
  104da9:	8b 50 08             	mov    0x8(%eax),%edx
  104dac:	89 d0                	mov    %edx,%eax
  104dae:	c1 e0 02             	shl    $0x2,%eax
  104db1:	01 d0                	add    %edx,%eax
  104db3:	c1 e0 02             	shl    $0x2,%eax
  104db6:	89 c2                	mov    %eax,%edx
  104db8:	8b 45 08             	mov    0x8(%ebp),%eax
  104dbb:	01 d0                	add    %edx,%eax
  104dbd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104dc0:	72 40                	jb     104e02 <default_free_pages+0x2d6>
            assert(base + base->property != p);
  104dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  104dc5:	8b 50 08             	mov    0x8(%eax),%edx
  104dc8:	89 d0                	mov    %edx,%eax
  104dca:	c1 e0 02             	shl    $0x2,%eax
  104dcd:	01 d0                	add    %edx,%eax
  104dcf:	c1 e0 02             	shl    $0x2,%eax
  104dd2:	89 c2                	mov    %eax,%edx
  104dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  104dd7:	01 d0                	add    %edx,%eax
  104dd9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ddc:	75 3e                	jne    104e1c <default_free_pages+0x2f0>
  104dde:	c7 44 24 0c e1 73 10 	movl   $0x1073e1,0xc(%esp)
  104de5:	00 
  104de6:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104ded:	00 
  104dee:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  104df5:	00 
  104df6:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104dfd:	e8 2f b6 ff ff       	call   100431 <__panic>
  104e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e05:	89 45 98             	mov    %eax,-0x68(%ebp)
  104e08:	8b 45 98             	mov    -0x68(%ebp),%eax
  104e0b:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104e11:	81 7d f0 7c df 11 00 	cmpl   $0x11df7c,-0x10(%ebp)
  104e18:	75 83                	jne    104d9d <default_free_pages+0x271>
  104e1a:	eb 01                	jmp    104e1d <default_free_pages+0x2f1>
            break;
  104e1c:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  104e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  104e20:	8d 50 0c             	lea    0xc(%eax),%edx
  104e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e26:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104e29:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104e2c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e2f:	8b 00                	mov    (%eax),%eax
  104e31:	8b 55 90             	mov    -0x70(%ebp),%edx
  104e34:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104e37:	89 45 88             	mov    %eax,-0x78(%ebp)
  104e3a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e3d:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104e40:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104e43:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104e46:	89 10                	mov    %edx,(%eax)
  104e48:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104e4b:	8b 10                	mov    (%eax),%edx
  104e4d:	8b 45 88             	mov    -0x78(%ebp),%eax
  104e50:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104e53:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104e56:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104e59:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104e5c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104e5f:	8b 55 88             	mov    -0x78(%ebp),%edx
  104e62:	89 10                	mov    %edx,(%eax)
}
  104e64:	90                   	nop
}
  104e65:	90                   	nop
}
  104e66:	90                   	nop
  104e67:	c9                   	leave  
  104e68:	c3                   	ret    

00104e69 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104e69:	f3 0f 1e fb          	endbr32 
  104e6d:	55                   	push   %ebp
  104e6e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104e70:	a1 84 df 11 00       	mov    0x11df84,%eax
}
  104e75:	5d                   	pop    %ebp
  104e76:	c3                   	ret    

00104e77 <basic_check>:

static void
basic_check(void) {
  104e77:	f3 0f 1e fb          	endbr32 
  104e7b:	55                   	push   %ebp
  104e7c:	89 e5                	mov    %esp,%ebp
  104e7e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104e94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e9b:	e8 4a e2 ff ff       	call   1030ea <alloc_pages>
  104ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104ea3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104ea7:	75 24                	jne    104ecd <basic_check+0x56>
  104ea9:	c7 44 24 0c fc 73 10 	movl   $0x1073fc,0xc(%esp)
  104eb0:	00 
  104eb1:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104eb8:	00 
  104eb9:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104ec0:	00 
  104ec1:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104ec8:	e8 64 b5 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104ecd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ed4:	e8 11 e2 ff ff       	call   1030ea <alloc_pages>
  104ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104edc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ee0:	75 24                	jne    104f06 <basic_check+0x8f>
  104ee2:	c7 44 24 0c 18 74 10 	movl   $0x107418,0xc(%esp)
  104ee9:	00 
  104eea:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104ef1:	00 
  104ef2:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104ef9:	00 
  104efa:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104f01:	e8 2b b5 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104f06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f0d:	e8 d8 e1 ff ff       	call   1030ea <alloc_pages>
  104f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104f19:	75 24                	jne    104f3f <basic_check+0xc8>
  104f1b:	c7 44 24 0c 34 74 10 	movl   $0x107434,0xc(%esp)
  104f22:	00 
  104f23:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104f2a:	00 
  104f2b:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104f32:	00 
  104f33:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104f3a:	e8 f2 b4 ff ff       	call   100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104f45:	74 10                	je     104f57 <basic_check+0xe0>
  104f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f4d:	74 08                	je     104f57 <basic_check+0xe0>
  104f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f55:	75 24                	jne    104f7b <basic_check+0x104>
  104f57:	c7 44 24 0c 50 74 10 	movl   $0x107450,0xc(%esp)
  104f5e:	00 
  104f5f:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104f66:	00 
  104f67:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104f6e:	00 
  104f6f:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104f76:	e8 b6 b4 ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f7e:	89 04 24             	mov    %eax,(%esp)
  104f81:	e8 5f f8 ff ff       	call   1047e5 <page_ref>
  104f86:	85 c0                	test   %eax,%eax
  104f88:	75 1e                	jne    104fa8 <basic_check+0x131>
  104f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f8d:	89 04 24             	mov    %eax,(%esp)
  104f90:	e8 50 f8 ff ff       	call   1047e5 <page_ref>
  104f95:	85 c0                	test   %eax,%eax
  104f97:	75 0f                	jne    104fa8 <basic_check+0x131>
  104f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f9c:	89 04 24             	mov    %eax,(%esp)
  104f9f:	e8 41 f8 ff ff       	call   1047e5 <page_ref>
  104fa4:	85 c0                	test   %eax,%eax
  104fa6:	74 24                	je     104fcc <basic_check+0x155>
  104fa8:	c7 44 24 0c 74 74 10 	movl   $0x107474,0xc(%esp)
  104faf:	00 
  104fb0:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104fb7:	00 
  104fb8:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104fbf:	00 
  104fc0:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  104fc7:	e8 65 b4 ff ff       	call   100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fcf:	89 04 24             	mov    %eax,(%esp)
  104fd2:	e8 f8 f7 ff ff       	call   1047cf <page2pa>
  104fd7:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  104fdd:	c1 e2 0c             	shl    $0xc,%edx
  104fe0:	39 d0                	cmp    %edx,%eax
  104fe2:	72 24                	jb     105008 <basic_check+0x191>
  104fe4:	c7 44 24 0c b0 74 10 	movl   $0x1074b0,0xc(%esp)
  104feb:	00 
  104fec:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  104ff3:	00 
  104ff4:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  104ffb:	00 
  104ffc:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105003:	e8 29 b4 ff ff       	call   100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  105008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10500b:	89 04 24             	mov    %eax,(%esp)
  10500e:	e8 bc f7 ff ff       	call   1047cf <page2pa>
  105013:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  105019:	c1 e2 0c             	shl    $0xc,%edx
  10501c:	39 d0                	cmp    %edx,%eax
  10501e:	72 24                	jb     105044 <basic_check+0x1cd>
  105020:	c7 44 24 0c cd 74 10 	movl   $0x1074cd,0xc(%esp)
  105027:	00 
  105028:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10502f:	00 
  105030:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  105037:	00 
  105038:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10503f:	e8 ed b3 ff ff       	call   100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  105044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105047:	89 04 24             	mov    %eax,(%esp)
  10504a:	e8 80 f7 ff ff       	call   1047cf <page2pa>
  10504f:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  105055:	c1 e2 0c             	shl    $0xc,%edx
  105058:	39 d0                	cmp    %edx,%eax
  10505a:	72 24                	jb     105080 <basic_check+0x209>
  10505c:	c7 44 24 0c ea 74 10 	movl   $0x1074ea,0xc(%esp)
  105063:	00 
  105064:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10506b:	00 
  10506c:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  105073:	00 
  105074:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10507b:	e8 b1 b3 ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  105080:	a1 7c df 11 00       	mov    0x11df7c,%eax
  105085:	8b 15 80 df 11 00    	mov    0x11df80,%edx
  10508b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10508e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105091:	c7 45 dc 7c df 11 00 	movl   $0x11df7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  105098:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10509b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10509e:	89 50 04             	mov    %edx,0x4(%eax)
  1050a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050a4:	8b 50 04             	mov    0x4(%eax),%edx
  1050a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050aa:	89 10                	mov    %edx,(%eax)
}
  1050ac:	90                   	nop
  1050ad:	c7 45 e0 7c df 11 00 	movl   $0x11df7c,-0x20(%ebp)
    return list->next == list;
  1050b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050b7:	8b 40 04             	mov    0x4(%eax),%eax
  1050ba:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1050bd:	0f 94 c0             	sete   %al
  1050c0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1050c3:	85 c0                	test   %eax,%eax
  1050c5:	75 24                	jne    1050eb <basic_check+0x274>
  1050c7:	c7 44 24 0c 07 75 10 	movl   $0x107507,0xc(%esp)
  1050ce:	00 
  1050cf:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1050d6:	00 
  1050d7:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  1050de:	00 
  1050df:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1050e6:	e8 46 b3 ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  1050eb:	a1 84 df 11 00       	mov    0x11df84,%eax
  1050f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1050f3:	c7 05 84 df 11 00 00 	movl   $0x0,0x11df84
  1050fa:	00 00 00 

    assert(alloc_page() == NULL);
  1050fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105104:	e8 e1 df ff ff       	call   1030ea <alloc_pages>
  105109:	85 c0                	test   %eax,%eax
  10510b:	74 24                	je     105131 <basic_check+0x2ba>
  10510d:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  105114:	00 
  105115:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10511c:	00 
  10511d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  105124:	00 
  105125:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10512c:	e8 00 b3 ff ff       	call   100431 <__panic>

    free_page(p0);
  105131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105138:	00 
  105139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10513c:	89 04 24             	mov    %eax,(%esp)
  10513f:	e8 e2 df ff ff       	call   103126 <free_pages>
    free_page(p1);
  105144:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10514b:	00 
  10514c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10514f:	89 04 24             	mov    %eax,(%esp)
  105152:	e8 cf df ff ff       	call   103126 <free_pages>
    free_page(p2);
  105157:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10515e:	00 
  10515f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105162:	89 04 24             	mov    %eax,(%esp)
  105165:	e8 bc df ff ff       	call   103126 <free_pages>
    assert(nr_free == 3);
  10516a:	a1 84 df 11 00       	mov    0x11df84,%eax
  10516f:	83 f8 03             	cmp    $0x3,%eax
  105172:	74 24                	je     105198 <basic_check+0x321>
  105174:	c7 44 24 0c 33 75 10 	movl   $0x107533,0xc(%esp)
  10517b:	00 
  10517c:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105183:	00 
  105184:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10518b:	00 
  10518c:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105193:	e8 99 b2 ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
  105198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10519f:	e8 46 df ff ff       	call   1030ea <alloc_pages>
  1051a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1051a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1051ab:	75 24                	jne    1051d1 <basic_check+0x35a>
  1051ad:	c7 44 24 0c fc 73 10 	movl   $0x1073fc,0xc(%esp)
  1051b4:	00 
  1051b5:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1051bc:	00 
  1051bd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1051c4:	00 
  1051c5:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1051cc:	e8 60 b2 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1051d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051d8:	e8 0d df ff ff       	call   1030ea <alloc_pages>
  1051dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1051e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1051e4:	75 24                	jne    10520a <basic_check+0x393>
  1051e6:	c7 44 24 0c 18 74 10 	movl   $0x107418,0xc(%esp)
  1051ed:	00 
  1051ee:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1051f5:	00 
  1051f6:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1051fd:	00 
  1051fe:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105205:	e8 27 b2 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10520a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105211:	e8 d4 de ff ff       	call   1030ea <alloc_pages>
  105216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10521d:	75 24                	jne    105243 <basic_check+0x3cc>
  10521f:	c7 44 24 0c 34 74 10 	movl   $0x107434,0xc(%esp)
  105226:	00 
  105227:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10522e:	00 
  10522f:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  105236:	00 
  105237:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10523e:	e8 ee b1 ff ff       	call   100431 <__panic>

    assert(alloc_page() == NULL);
  105243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10524a:	e8 9b de ff ff       	call   1030ea <alloc_pages>
  10524f:	85 c0                	test   %eax,%eax
  105251:	74 24                	je     105277 <basic_check+0x400>
  105253:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  10525a:	00 
  10525b:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105262:	00 
  105263:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  10526a:	00 
  10526b:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105272:	e8 ba b1 ff ff       	call   100431 <__panic>

    free_page(p0);
  105277:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10527e:	00 
  10527f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105282:	89 04 24             	mov    %eax,(%esp)
  105285:	e8 9c de ff ff       	call   103126 <free_pages>
  10528a:	c7 45 d8 7c df 11 00 	movl   $0x11df7c,-0x28(%ebp)
  105291:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105294:	8b 40 04             	mov    0x4(%eax),%eax
  105297:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10529a:	0f 94 c0             	sete   %al
  10529d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1052a0:	85 c0                	test   %eax,%eax
  1052a2:	74 24                	je     1052c8 <basic_check+0x451>
  1052a4:	c7 44 24 0c 40 75 10 	movl   $0x107540,0xc(%esp)
  1052ab:	00 
  1052ac:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1052b3:	00 
  1052b4:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  1052bb:	00 
  1052bc:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1052c3:	e8 69 b1 ff ff       	call   100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1052c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052cf:	e8 16 de ff ff       	call   1030ea <alloc_pages>
  1052d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1052dd:	74 24                	je     105303 <basic_check+0x48c>
  1052df:	c7 44 24 0c 58 75 10 	movl   $0x107558,0xc(%esp)
  1052e6:	00 
  1052e7:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1052ee:	00 
  1052ef:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1052f6:	00 
  1052f7:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1052fe:	e8 2e b1 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105303:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10530a:	e8 db dd ff ff       	call   1030ea <alloc_pages>
  10530f:	85 c0                	test   %eax,%eax
  105311:	74 24                	je     105337 <basic_check+0x4c0>
  105313:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  10531a:	00 
  10531b:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105322:	00 
  105323:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  10532a:	00 
  10532b:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105332:	e8 fa b0 ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  105337:	a1 84 df 11 00       	mov    0x11df84,%eax
  10533c:	85 c0                	test   %eax,%eax
  10533e:	74 24                	je     105364 <basic_check+0x4ed>
  105340:	c7 44 24 0c 71 75 10 	movl   $0x107571,0xc(%esp)
  105347:	00 
  105348:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10534f:	00 
  105350:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  105357:	00 
  105358:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10535f:	e8 cd b0 ff ff       	call   100431 <__panic>
    free_list = free_list_store;
  105364:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105367:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10536a:	a3 7c df 11 00       	mov    %eax,0x11df7c
  10536f:	89 15 80 df 11 00    	mov    %edx,0x11df80
    nr_free = nr_free_store;
  105375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105378:	a3 84 df 11 00       	mov    %eax,0x11df84

    free_page(p);
  10537d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105384:	00 
  105385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105388:	89 04 24             	mov    %eax,(%esp)
  10538b:	e8 96 dd ff ff       	call   103126 <free_pages>
    free_page(p1);
  105390:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105397:	00 
  105398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10539b:	89 04 24             	mov    %eax,(%esp)
  10539e:	e8 83 dd ff ff       	call   103126 <free_pages>
    free_page(p2);
  1053a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053aa:	00 
  1053ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053ae:	89 04 24             	mov    %eax,(%esp)
  1053b1:	e8 70 dd ff ff       	call   103126 <free_pages>
}
  1053b6:	90                   	nop
  1053b7:	c9                   	leave  
  1053b8:	c3                   	ret    

001053b9 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1053b9:	f3 0f 1e fb          	endbr32 
  1053bd:	55                   	push   %ebp
  1053be:	89 e5                	mov    %esp,%ebp
  1053c0:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1053c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1053cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1053d4:	c7 45 ec 7c df 11 00 	movl   $0x11df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1053db:	eb 6a                	jmp    105447 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  1053dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053e0:	83 e8 0c             	sub    $0xc,%eax
  1053e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1053e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053e9:	83 c0 04             	add    $0x4,%eax
  1053ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1053f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1053f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1053f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1053fc:	0f a3 10             	bt     %edx,(%eax)
  1053ff:	19 c0                	sbb    %eax,%eax
  105401:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  105404:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  105408:	0f 95 c0             	setne  %al
  10540b:	0f b6 c0             	movzbl %al,%eax
  10540e:	85 c0                	test   %eax,%eax
  105410:	75 24                	jne    105436 <default_check+0x7d>
  105412:	c7 44 24 0c 7e 75 10 	movl   $0x10757e,0xc(%esp)
  105419:	00 
  10541a:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105421:	00 
  105422:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  105429:	00 
  10542a:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105431:	e8 fb af ff ff       	call   100431 <__panic>
        count ++, total += p->property;
  105436:	ff 45 f4             	incl   -0xc(%ebp)
  105439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10543c:	8b 50 08             	mov    0x8(%eax),%edx
  10543f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105442:	01 d0                	add    %edx,%eax
  105444:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10544a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  10544d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105450:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105456:	81 7d ec 7c df 11 00 	cmpl   $0x11df7c,-0x14(%ebp)
  10545d:	0f 85 7a ff ff ff    	jne    1053dd <default_check+0x24>
    }
    assert(total == nr_free_pages());
  105463:	e8 f5 dc ff ff       	call   10315d <nr_free_pages>
  105468:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10546b:	39 d0                	cmp    %edx,%eax
  10546d:	74 24                	je     105493 <default_check+0xda>
  10546f:	c7 44 24 0c 8e 75 10 	movl   $0x10758e,0xc(%esp)
  105476:	00 
  105477:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10547e:	00 
  10547f:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  105486:	00 
  105487:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10548e:	e8 9e af ff ff       	call   100431 <__panic>

    basic_check();
  105493:	e8 df f9 ff ff       	call   104e77 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105498:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10549f:	e8 46 dc ff ff       	call   1030ea <alloc_pages>
  1054a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1054a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1054ab:	75 24                	jne    1054d1 <default_check+0x118>
  1054ad:	c7 44 24 0c a7 75 10 	movl   $0x1075a7,0xc(%esp)
  1054b4:	00 
  1054b5:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1054bc:	00 
  1054bd:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1054c4:	00 
  1054c5:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1054cc:	e8 60 af ff ff       	call   100431 <__panic>
    assert(!PageProperty(p0));
  1054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054d4:	83 c0 04             	add    $0x4,%eax
  1054d7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1054de:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1054e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1054e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1054e7:	0f a3 10             	bt     %edx,(%eax)
  1054ea:	19 c0                	sbb    %eax,%eax
  1054ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1054ef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1054f3:	0f 95 c0             	setne  %al
  1054f6:	0f b6 c0             	movzbl %al,%eax
  1054f9:	85 c0                	test   %eax,%eax
  1054fb:	74 24                	je     105521 <default_check+0x168>
  1054fd:	c7 44 24 0c b2 75 10 	movl   $0x1075b2,0xc(%esp)
  105504:	00 
  105505:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10550c:	00 
  10550d:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  105514:	00 
  105515:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10551c:	e8 10 af ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  105521:	a1 7c df 11 00       	mov    0x11df7c,%eax
  105526:	8b 15 80 df 11 00    	mov    0x11df80,%edx
  10552c:	89 45 80             	mov    %eax,-0x80(%ebp)
  10552f:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105532:	c7 45 b0 7c df 11 00 	movl   $0x11df7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105539:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10553c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10553f:	89 50 04             	mov    %edx,0x4(%eax)
  105542:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105545:	8b 50 04             	mov    0x4(%eax),%edx
  105548:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10554b:	89 10                	mov    %edx,(%eax)
}
  10554d:	90                   	nop
  10554e:	c7 45 b4 7c df 11 00 	movl   $0x11df7c,-0x4c(%ebp)
    return list->next == list;
  105555:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105558:	8b 40 04             	mov    0x4(%eax),%eax
  10555b:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  10555e:	0f 94 c0             	sete   %al
  105561:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105564:	85 c0                	test   %eax,%eax
  105566:	75 24                	jne    10558c <default_check+0x1d3>
  105568:	c7 44 24 0c 07 75 10 	movl   $0x107507,0xc(%esp)
  10556f:	00 
  105570:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105577:	00 
  105578:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  10557f:	00 
  105580:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105587:	e8 a5 ae ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  10558c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105593:	e8 52 db ff ff       	call   1030ea <alloc_pages>
  105598:	85 c0                	test   %eax,%eax
  10559a:	74 24                	je     1055c0 <default_check+0x207>
  10559c:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  1055a3:	00 
  1055a4:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1055ab:	00 
  1055ac:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1055b3:	00 
  1055b4:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1055bb:	e8 71 ae ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  1055c0:	a1 84 df 11 00       	mov    0x11df84,%eax
  1055c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1055c8:	c7 05 84 df 11 00 00 	movl   $0x0,0x11df84
  1055cf:	00 00 00 

    free_pages(p0 + 2, 3);
  1055d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055d5:	83 c0 28             	add    $0x28,%eax
  1055d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1055df:	00 
  1055e0:	89 04 24             	mov    %eax,(%esp)
  1055e3:	e8 3e db ff ff       	call   103126 <free_pages>
    assert(alloc_pages(4) == NULL);
  1055e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1055ef:	e8 f6 da ff ff       	call   1030ea <alloc_pages>
  1055f4:	85 c0                	test   %eax,%eax
  1055f6:	74 24                	je     10561c <default_check+0x263>
  1055f8:	c7 44 24 0c c4 75 10 	movl   $0x1075c4,0xc(%esp)
  1055ff:	00 
  105600:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105607:	00 
  105608:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10560f:	00 
  105610:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105617:	e8 15 ae ff ff       	call   100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10561c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10561f:	83 c0 28             	add    $0x28,%eax
  105622:	83 c0 04             	add    $0x4,%eax
  105625:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10562c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10562f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105632:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105635:	0f a3 10             	bt     %edx,(%eax)
  105638:	19 c0                	sbb    %eax,%eax
  10563a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10563d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105641:	0f 95 c0             	setne  %al
  105644:	0f b6 c0             	movzbl %al,%eax
  105647:	85 c0                	test   %eax,%eax
  105649:	74 0e                	je     105659 <default_check+0x2a0>
  10564b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10564e:	83 c0 28             	add    $0x28,%eax
  105651:	8b 40 08             	mov    0x8(%eax),%eax
  105654:	83 f8 03             	cmp    $0x3,%eax
  105657:	74 24                	je     10567d <default_check+0x2c4>
  105659:	c7 44 24 0c dc 75 10 	movl   $0x1075dc,0xc(%esp)
  105660:	00 
  105661:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105668:	00 
  105669:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105670:	00 
  105671:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105678:	e8 b4 ad ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10567d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105684:	e8 61 da ff ff       	call   1030ea <alloc_pages>
  105689:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10568c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105690:	75 24                	jne    1056b6 <default_check+0x2fd>
  105692:	c7 44 24 0c 08 76 10 	movl   $0x107608,0xc(%esp)
  105699:	00 
  10569a:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1056a1:	00 
  1056a2:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1056a9:	00 
  1056aa:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1056b1:	e8 7b ad ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  1056b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056bd:	e8 28 da ff ff       	call   1030ea <alloc_pages>
  1056c2:	85 c0                	test   %eax,%eax
  1056c4:	74 24                	je     1056ea <default_check+0x331>
  1056c6:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  1056cd:	00 
  1056ce:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1056d5:	00 
  1056d6:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  1056dd:	00 
  1056de:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1056e5:	e8 47 ad ff ff       	call   100431 <__panic>
    assert(p0 + 2 == p1);
  1056ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056ed:	83 c0 28             	add    $0x28,%eax
  1056f0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1056f3:	74 24                	je     105719 <default_check+0x360>
  1056f5:	c7 44 24 0c 26 76 10 	movl   $0x107626,0xc(%esp)
  1056fc:	00 
  1056fd:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105704:	00 
  105705:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  10570c:	00 
  10570d:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105714:	e8 18 ad ff ff       	call   100431 <__panic>

    p2 = p0 + 1;
  105719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10571c:	83 c0 14             	add    $0x14,%eax
  10571f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  105722:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105729:	00 
  10572a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10572d:	89 04 24             	mov    %eax,(%esp)
  105730:	e8 f1 d9 ff ff       	call   103126 <free_pages>
    free_pages(p1, 3);
  105735:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10573c:	00 
  10573d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105740:	89 04 24             	mov    %eax,(%esp)
  105743:	e8 de d9 ff ff       	call   103126 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10574b:	83 c0 04             	add    $0x4,%eax
  10574e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105755:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105758:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10575b:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10575e:	0f a3 10             	bt     %edx,(%eax)
  105761:	19 c0                	sbb    %eax,%eax
  105763:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105766:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10576a:	0f 95 c0             	setne  %al
  10576d:	0f b6 c0             	movzbl %al,%eax
  105770:	85 c0                	test   %eax,%eax
  105772:	74 0b                	je     10577f <default_check+0x3c6>
  105774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105777:	8b 40 08             	mov    0x8(%eax),%eax
  10577a:	83 f8 01             	cmp    $0x1,%eax
  10577d:	74 24                	je     1057a3 <default_check+0x3ea>
  10577f:	c7 44 24 0c 34 76 10 	movl   $0x107634,0xc(%esp)
  105786:	00 
  105787:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10578e:	00 
  10578f:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  105796:	00 
  105797:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10579e:	e8 8e ac ff ff       	call   100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1057a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057a6:	83 c0 04             	add    $0x4,%eax
  1057a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1057b0:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1057b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  1057b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1057b9:	0f a3 10             	bt     %edx,(%eax)
  1057bc:	19 c0                	sbb    %eax,%eax
  1057be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1057c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1057c5:	0f 95 c0             	setne  %al
  1057c8:	0f b6 c0             	movzbl %al,%eax
  1057cb:	85 c0                	test   %eax,%eax
  1057cd:	74 0b                	je     1057da <default_check+0x421>
  1057cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057d2:	8b 40 08             	mov    0x8(%eax),%eax
  1057d5:	83 f8 03             	cmp    $0x3,%eax
  1057d8:	74 24                	je     1057fe <default_check+0x445>
  1057da:	c7 44 24 0c 5c 76 10 	movl   $0x10765c,0xc(%esp)
  1057e1:	00 
  1057e2:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1057e9:	00 
  1057ea:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1057f1:	00 
  1057f2:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1057f9:	e8 33 ac ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1057fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105805:	e8 e0 d8 ff ff       	call   1030ea <alloc_pages>
  10580a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10580d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105810:	83 e8 14             	sub    $0x14,%eax
  105813:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105816:	74 24                	je     10583c <default_check+0x483>
  105818:	c7 44 24 0c 82 76 10 	movl   $0x107682,0xc(%esp)
  10581f:	00 
  105820:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105827:	00 
  105828:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  10582f:	00 
  105830:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105837:	e8 f5 ab ff ff       	call   100431 <__panic>
    free_page(p0);
  10583c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105843:	00 
  105844:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105847:	89 04 24             	mov    %eax,(%esp)
  10584a:	e8 d7 d8 ff ff       	call   103126 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10584f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105856:	e8 8f d8 ff ff       	call   1030ea <alloc_pages>
  10585b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10585e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105861:	83 c0 14             	add    $0x14,%eax
  105864:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105867:	74 24                	je     10588d <default_check+0x4d4>
  105869:	c7 44 24 0c a0 76 10 	movl   $0x1076a0,0xc(%esp)
  105870:	00 
  105871:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105878:	00 
  105879:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  105880:	00 
  105881:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105888:	e8 a4 ab ff ff       	call   100431 <__panic>

    free_pages(p0, 2);
  10588d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105894:	00 
  105895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105898:	89 04 24             	mov    %eax,(%esp)
  10589b:	e8 86 d8 ff ff       	call   103126 <free_pages>
    free_page(p2);
  1058a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1058a7:	00 
  1058a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058ab:	89 04 24             	mov    %eax,(%esp)
  1058ae:	e8 73 d8 ff ff       	call   103126 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1058b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1058ba:	e8 2b d8 ff ff       	call   1030ea <alloc_pages>
  1058bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058c6:	75 24                	jne    1058ec <default_check+0x533>
  1058c8:	c7 44 24 0c c0 76 10 	movl   $0x1076c0,0xc(%esp)
  1058cf:	00 
  1058d0:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1058d7:	00 
  1058d8:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1058df:	00 
  1058e0:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1058e7:	e8 45 ab ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  1058ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1058f3:	e8 f2 d7 ff ff       	call   1030ea <alloc_pages>
  1058f8:	85 c0                	test   %eax,%eax
  1058fa:	74 24                	je     105920 <default_check+0x567>
  1058fc:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  105903:	00 
  105904:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  10590b:	00 
  10590c:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  105913:	00 
  105914:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  10591b:	e8 11 ab ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  105920:	a1 84 df 11 00       	mov    0x11df84,%eax
  105925:	85 c0                	test   %eax,%eax
  105927:	74 24                	je     10594d <default_check+0x594>
  105929:	c7 44 24 0c 71 75 10 	movl   $0x107571,0xc(%esp)
  105930:	00 
  105931:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105938:	00 
  105939:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  105940:	00 
  105941:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105948:	e8 e4 aa ff ff       	call   100431 <__panic>
    nr_free = nr_free_store;
  10594d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105950:	a3 84 df 11 00       	mov    %eax,0x11df84

    free_list = free_list_store;
  105955:	8b 45 80             	mov    -0x80(%ebp),%eax
  105958:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10595b:	a3 7c df 11 00       	mov    %eax,0x11df7c
  105960:	89 15 80 df 11 00    	mov    %edx,0x11df80
    free_pages(p0, 5);
  105966:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10596d:	00 
  10596e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105971:	89 04 24             	mov    %eax,(%esp)
  105974:	e8 ad d7 ff ff       	call   103126 <free_pages>

    le = &free_list;
  105979:	c7 45 ec 7c df 11 00 	movl   $0x11df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105980:	eb 5a                	jmp    1059dc <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
  105982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105985:	8b 40 04             	mov    0x4(%eax),%eax
  105988:	8b 00                	mov    (%eax),%eax
  10598a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10598d:	75 0d                	jne    10599c <default_check+0x5e3>
  10598f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105992:	8b 00                	mov    (%eax),%eax
  105994:	8b 40 04             	mov    0x4(%eax),%eax
  105997:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10599a:	74 24                	je     1059c0 <default_check+0x607>
  10599c:	c7 44 24 0c e0 76 10 	movl   $0x1076e0,0xc(%esp)
  1059a3:	00 
  1059a4:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  1059ab:	00 
  1059ac:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1059b3:	00 
  1059b4:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  1059bb:	e8 71 aa ff ff       	call   100431 <__panic>
        struct Page *p = le2page(le, page_link);
  1059c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059c3:	83 e8 0c             	sub    $0xc,%eax
  1059c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  1059c9:	ff 4d f4             	decl   -0xc(%ebp)
  1059cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1059d2:	8b 40 08             	mov    0x8(%eax),%eax
  1059d5:	29 c2                	sub    %eax,%edx
  1059d7:	89 d0                	mov    %edx,%eax
  1059d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059df:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1059e2:	8b 45 88             	mov    -0x78(%ebp),%eax
  1059e5:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1059e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059eb:	81 7d ec 7c df 11 00 	cmpl   $0x11df7c,-0x14(%ebp)
  1059f2:	75 8e                	jne    105982 <default_check+0x5c9>
    }
    assert(count == 0);
  1059f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1059f8:	74 24                	je     105a1e <default_check+0x665>
  1059fa:	c7 44 24 0c 0d 77 10 	movl   $0x10770d,0xc(%esp)
  105a01:	00 
  105a02:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105a09:	00 
  105a0a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  105a11:	00 
  105a12:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105a19:	e8 13 aa ff ff       	call   100431 <__panic>
    assert(total == 0);
  105a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a22:	74 24                	je     105a48 <default_check+0x68f>
  105a24:	c7 44 24 0c 18 77 10 	movl   $0x107718,0xc(%esp)
  105a2b:	00 
  105a2c:	c7 44 24 08 7e 73 10 	movl   $0x10737e,0x8(%esp)
  105a33:	00 
  105a34:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  105a3b:	00 
  105a3c:	c7 04 24 93 73 10 00 	movl   $0x107393,(%esp)
  105a43:	e8 e9 a9 ff ff       	call   100431 <__panic>
}
  105a48:	90                   	nop
  105a49:	c9                   	leave  
  105a4a:	c3                   	ret    

00105a4b <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a4b:	f3 0f 1e fb          	endbr32 
  105a4f:	55                   	push   %ebp
  105a50:	89 e5                	mov    %esp,%ebp
  105a52:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105a5c:	eb 03                	jmp    105a61 <strlen+0x16>
        cnt ++;
  105a5e:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105a61:	8b 45 08             	mov    0x8(%ebp),%eax
  105a64:	8d 50 01             	lea    0x1(%eax),%edx
  105a67:	89 55 08             	mov    %edx,0x8(%ebp)
  105a6a:	0f b6 00             	movzbl (%eax),%eax
  105a6d:	84 c0                	test   %al,%al
  105a6f:	75 ed                	jne    105a5e <strlen+0x13>
    }
    return cnt;
  105a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a74:	c9                   	leave  
  105a75:	c3                   	ret    

00105a76 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105a76:	f3 0f 1e fb          	endbr32 
  105a7a:	55                   	push   %ebp
  105a7b:	89 e5                	mov    %esp,%ebp
  105a7d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105a87:	eb 03                	jmp    105a8c <strnlen+0x16>
        cnt ++;
  105a89:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105a92:	73 10                	jae    105aa4 <strnlen+0x2e>
  105a94:	8b 45 08             	mov    0x8(%ebp),%eax
  105a97:	8d 50 01             	lea    0x1(%eax),%edx
  105a9a:	89 55 08             	mov    %edx,0x8(%ebp)
  105a9d:	0f b6 00             	movzbl (%eax),%eax
  105aa0:	84 c0                	test   %al,%al
  105aa2:	75 e5                	jne    105a89 <strnlen+0x13>
    }
    return cnt;
  105aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105aa7:	c9                   	leave  
  105aa8:	c3                   	ret    

00105aa9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105aa9:	f3 0f 1e fb          	endbr32 
  105aad:	55                   	push   %ebp
  105aae:	89 e5                	mov    %esp,%ebp
  105ab0:	57                   	push   %edi
  105ab1:	56                   	push   %esi
  105ab2:	83 ec 20             	sub    $0x20,%esp
  105ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105ac1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ac7:	89 d1                	mov    %edx,%ecx
  105ac9:	89 c2                	mov    %eax,%edx
  105acb:	89 ce                	mov    %ecx,%esi
  105acd:	89 d7                	mov    %edx,%edi
  105acf:	ac                   	lods   %ds:(%esi),%al
  105ad0:	aa                   	stos   %al,%es:(%edi)
  105ad1:	84 c0                	test   %al,%al
  105ad3:	75 fa                	jne    105acf <strcpy+0x26>
  105ad5:	89 fa                	mov    %edi,%edx
  105ad7:	89 f1                	mov    %esi,%ecx
  105ad9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105adc:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105ae5:	83 c4 20             	add    $0x20,%esp
  105ae8:	5e                   	pop    %esi
  105ae9:	5f                   	pop    %edi
  105aea:	5d                   	pop    %ebp
  105aeb:	c3                   	ret    

00105aec <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105aec:	f3 0f 1e fb          	endbr32 
  105af0:	55                   	push   %ebp
  105af1:	89 e5                	mov    %esp,%ebp
  105af3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105af6:	8b 45 08             	mov    0x8(%ebp),%eax
  105af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105afc:	eb 1e                	jmp    105b1c <strncpy+0x30>
        if ((*p = *src) != '\0') {
  105afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b01:	0f b6 10             	movzbl (%eax),%edx
  105b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b07:	88 10                	mov    %dl,(%eax)
  105b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b0c:	0f b6 00             	movzbl (%eax),%eax
  105b0f:	84 c0                	test   %al,%al
  105b11:	74 03                	je     105b16 <strncpy+0x2a>
            src ++;
  105b13:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105b16:	ff 45 fc             	incl   -0x4(%ebp)
  105b19:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b20:	75 dc                	jne    105afe <strncpy+0x12>
    }
    return dst;
  105b22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b25:	c9                   	leave  
  105b26:	c3                   	ret    

00105b27 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b27:	f3 0f 1e fb          	endbr32 
  105b2b:	55                   	push   %ebp
  105b2c:	89 e5                	mov    %esp,%ebp
  105b2e:	57                   	push   %edi
  105b2f:	56                   	push   %esi
  105b30:	83 ec 20             	sub    $0x20,%esp
  105b33:	8b 45 08             	mov    0x8(%ebp),%eax
  105b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b45:	89 d1                	mov    %edx,%ecx
  105b47:	89 c2                	mov    %eax,%edx
  105b49:	89 ce                	mov    %ecx,%esi
  105b4b:	89 d7                	mov    %edx,%edi
  105b4d:	ac                   	lods   %ds:(%esi),%al
  105b4e:	ae                   	scas   %es:(%edi),%al
  105b4f:	75 08                	jne    105b59 <strcmp+0x32>
  105b51:	84 c0                	test   %al,%al
  105b53:	75 f8                	jne    105b4d <strcmp+0x26>
  105b55:	31 c0                	xor    %eax,%eax
  105b57:	eb 04                	jmp    105b5d <strcmp+0x36>
  105b59:	19 c0                	sbb    %eax,%eax
  105b5b:	0c 01                	or     $0x1,%al
  105b5d:	89 fa                	mov    %edi,%edx
  105b5f:	89 f1                	mov    %esi,%ecx
  105b61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b64:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b67:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b6d:	83 c4 20             	add    $0x20,%esp
  105b70:	5e                   	pop    %esi
  105b71:	5f                   	pop    %edi
  105b72:	5d                   	pop    %ebp
  105b73:	c3                   	ret    

00105b74 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105b74:	f3 0f 1e fb          	endbr32 
  105b78:	55                   	push   %ebp
  105b79:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b7b:	eb 09                	jmp    105b86 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  105b7d:	ff 4d 10             	decl   0x10(%ebp)
  105b80:	ff 45 08             	incl   0x8(%ebp)
  105b83:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b8a:	74 1a                	je     105ba6 <strncmp+0x32>
  105b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b8f:	0f b6 00             	movzbl (%eax),%eax
  105b92:	84 c0                	test   %al,%al
  105b94:	74 10                	je     105ba6 <strncmp+0x32>
  105b96:	8b 45 08             	mov    0x8(%ebp),%eax
  105b99:	0f b6 10             	movzbl (%eax),%edx
  105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9f:	0f b6 00             	movzbl (%eax),%eax
  105ba2:	38 c2                	cmp    %al,%dl
  105ba4:	74 d7                	je     105b7d <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105baa:	74 18                	je     105bc4 <strncmp+0x50>
  105bac:	8b 45 08             	mov    0x8(%ebp),%eax
  105baf:	0f b6 00             	movzbl (%eax),%eax
  105bb2:	0f b6 d0             	movzbl %al,%edx
  105bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb8:	0f b6 00             	movzbl (%eax),%eax
  105bbb:	0f b6 c0             	movzbl %al,%eax
  105bbe:	29 c2                	sub    %eax,%edx
  105bc0:	89 d0                	mov    %edx,%eax
  105bc2:	eb 05                	jmp    105bc9 <strncmp+0x55>
  105bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bc9:	5d                   	pop    %ebp
  105bca:	c3                   	ret    

00105bcb <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105bcb:	f3 0f 1e fb          	endbr32 
  105bcf:	55                   	push   %ebp
  105bd0:	89 e5                	mov    %esp,%ebp
  105bd2:	83 ec 04             	sub    $0x4,%esp
  105bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105bdb:	eb 13                	jmp    105bf0 <strchr+0x25>
        if (*s == c) {
  105bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  105be0:	0f b6 00             	movzbl (%eax),%eax
  105be3:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105be6:	75 05                	jne    105bed <strchr+0x22>
            return (char *)s;
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	eb 12                	jmp    105bff <strchr+0x34>
        }
        s ++;
  105bed:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf3:	0f b6 00             	movzbl (%eax),%eax
  105bf6:	84 c0                	test   %al,%al
  105bf8:	75 e3                	jne    105bdd <strchr+0x12>
    }
    return NULL;
  105bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bff:	c9                   	leave  
  105c00:	c3                   	ret    

00105c01 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c01:	f3 0f 1e fb          	endbr32 
  105c05:	55                   	push   %ebp
  105c06:	89 e5                	mov    %esp,%ebp
  105c08:	83 ec 04             	sub    $0x4,%esp
  105c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c11:	eb 0e                	jmp    105c21 <strfind+0x20>
        if (*s == c) {
  105c13:	8b 45 08             	mov    0x8(%ebp),%eax
  105c16:	0f b6 00             	movzbl (%eax),%eax
  105c19:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c1c:	74 0f                	je     105c2d <strfind+0x2c>
            break;
        }
        s ++;
  105c1e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105c21:	8b 45 08             	mov    0x8(%ebp),%eax
  105c24:	0f b6 00             	movzbl (%eax),%eax
  105c27:	84 c0                	test   %al,%al
  105c29:	75 e8                	jne    105c13 <strfind+0x12>
  105c2b:	eb 01                	jmp    105c2e <strfind+0x2d>
            break;
  105c2d:	90                   	nop
    }
    return (char *)s;
  105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c31:	c9                   	leave  
  105c32:	c3                   	ret    

00105c33 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c33:	f3 0f 1e fb          	endbr32 
  105c37:	55                   	push   %ebp
  105c38:	89 e5                	mov    %esp,%ebp
  105c3a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c4b:	eb 03                	jmp    105c50 <strtol+0x1d>
        s ++;
  105c4d:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105c50:	8b 45 08             	mov    0x8(%ebp),%eax
  105c53:	0f b6 00             	movzbl (%eax),%eax
  105c56:	3c 20                	cmp    $0x20,%al
  105c58:	74 f3                	je     105c4d <strtol+0x1a>
  105c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5d:	0f b6 00             	movzbl (%eax),%eax
  105c60:	3c 09                	cmp    $0x9,%al
  105c62:	74 e9                	je     105c4d <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  105c64:	8b 45 08             	mov    0x8(%ebp),%eax
  105c67:	0f b6 00             	movzbl (%eax),%eax
  105c6a:	3c 2b                	cmp    $0x2b,%al
  105c6c:	75 05                	jne    105c73 <strtol+0x40>
        s ++;
  105c6e:	ff 45 08             	incl   0x8(%ebp)
  105c71:	eb 14                	jmp    105c87 <strtol+0x54>
    }
    else if (*s == '-') {
  105c73:	8b 45 08             	mov    0x8(%ebp),%eax
  105c76:	0f b6 00             	movzbl (%eax),%eax
  105c79:	3c 2d                	cmp    $0x2d,%al
  105c7b:	75 0a                	jne    105c87 <strtol+0x54>
        s ++, neg = 1;
  105c7d:	ff 45 08             	incl   0x8(%ebp)
  105c80:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c8b:	74 06                	je     105c93 <strtol+0x60>
  105c8d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105c91:	75 22                	jne    105cb5 <strtol+0x82>
  105c93:	8b 45 08             	mov    0x8(%ebp),%eax
  105c96:	0f b6 00             	movzbl (%eax),%eax
  105c99:	3c 30                	cmp    $0x30,%al
  105c9b:	75 18                	jne    105cb5 <strtol+0x82>
  105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca0:	40                   	inc    %eax
  105ca1:	0f b6 00             	movzbl (%eax),%eax
  105ca4:	3c 78                	cmp    $0x78,%al
  105ca6:	75 0d                	jne    105cb5 <strtol+0x82>
        s += 2, base = 16;
  105ca8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105cac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105cb3:	eb 29                	jmp    105cde <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  105cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cb9:	75 16                	jne    105cd1 <strtol+0x9e>
  105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105cbe:	0f b6 00             	movzbl (%eax),%eax
  105cc1:	3c 30                	cmp    $0x30,%al
  105cc3:	75 0c                	jne    105cd1 <strtol+0x9e>
        s ++, base = 8;
  105cc5:	ff 45 08             	incl   0x8(%ebp)
  105cc8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105ccf:	eb 0d                	jmp    105cde <strtol+0xab>
    }
    else if (base == 0) {
  105cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cd5:	75 07                	jne    105cde <strtol+0xab>
        base = 10;
  105cd7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105cde:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce1:	0f b6 00             	movzbl (%eax),%eax
  105ce4:	3c 2f                	cmp    $0x2f,%al
  105ce6:	7e 1b                	jle    105d03 <strtol+0xd0>
  105ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ceb:	0f b6 00             	movzbl (%eax),%eax
  105cee:	3c 39                	cmp    $0x39,%al
  105cf0:	7f 11                	jg     105d03 <strtol+0xd0>
            dig = *s - '0';
  105cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf5:	0f b6 00             	movzbl (%eax),%eax
  105cf8:	0f be c0             	movsbl %al,%eax
  105cfb:	83 e8 30             	sub    $0x30,%eax
  105cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d01:	eb 48                	jmp    105d4b <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d03:	8b 45 08             	mov    0x8(%ebp),%eax
  105d06:	0f b6 00             	movzbl (%eax),%eax
  105d09:	3c 60                	cmp    $0x60,%al
  105d0b:	7e 1b                	jle    105d28 <strtol+0xf5>
  105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d10:	0f b6 00             	movzbl (%eax),%eax
  105d13:	3c 7a                	cmp    $0x7a,%al
  105d15:	7f 11                	jg     105d28 <strtol+0xf5>
            dig = *s - 'a' + 10;
  105d17:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1a:	0f b6 00             	movzbl (%eax),%eax
  105d1d:	0f be c0             	movsbl %al,%eax
  105d20:	83 e8 57             	sub    $0x57,%eax
  105d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d26:	eb 23                	jmp    105d4b <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d28:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2b:	0f b6 00             	movzbl (%eax),%eax
  105d2e:	3c 40                	cmp    $0x40,%al
  105d30:	7e 3b                	jle    105d6d <strtol+0x13a>
  105d32:	8b 45 08             	mov    0x8(%ebp),%eax
  105d35:	0f b6 00             	movzbl (%eax),%eax
  105d38:	3c 5a                	cmp    $0x5a,%al
  105d3a:	7f 31                	jg     105d6d <strtol+0x13a>
            dig = *s - 'A' + 10;
  105d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3f:	0f b6 00             	movzbl (%eax),%eax
  105d42:	0f be c0             	movsbl %al,%eax
  105d45:	83 e8 37             	sub    $0x37,%eax
  105d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d4e:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d51:	7d 19                	jge    105d6c <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  105d53:	ff 45 08             	incl   0x8(%ebp)
  105d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d59:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d5d:	89 c2                	mov    %eax,%edx
  105d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d62:	01 d0                	add    %edx,%eax
  105d64:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105d67:	e9 72 ff ff ff       	jmp    105cde <strtol+0xab>
            break;
  105d6c:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d71:	74 08                	je     105d7b <strtol+0x148>
        *endptr = (char *) s;
  105d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d76:	8b 55 08             	mov    0x8(%ebp),%edx
  105d79:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105d7f:	74 07                	je     105d88 <strtol+0x155>
  105d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d84:	f7 d8                	neg    %eax
  105d86:	eb 03                	jmp    105d8b <strtol+0x158>
  105d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105d8b:	c9                   	leave  
  105d8c:	c3                   	ret    

00105d8d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105d8d:	f3 0f 1e fb          	endbr32 
  105d91:	55                   	push   %ebp
  105d92:	89 e5                	mov    %esp,%ebp
  105d94:	57                   	push   %edi
  105d95:	83 ec 24             	sub    $0x24,%esp
  105d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105d9e:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105da2:	8b 45 08             	mov    0x8(%ebp),%eax
  105da5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105da8:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105dab:	8b 45 10             	mov    0x10(%ebp),%eax
  105dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105db1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105db4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105db8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105dbb:	89 d7                	mov    %edx,%edi
  105dbd:	f3 aa                	rep stos %al,%es:(%edi)
  105dbf:	89 fa                	mov    %edi,%edx
  105dc1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105dc4:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105dca:	83 c4 24             	add    $0x24,%esp
  105dcd:	5f                   	pop    %edi
  105dce:	5d                   	pop    %ebp
  105dcf:	c3                   	ret    

00105dd0 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105dd0:	f3 0f 1e fb          	endbr32 
  105dd4:	55                   	push   %ebp
  105dd5:	89 e5                	mov    %esp,%ebp
  105dd7:	57                   	push   %edi
  105dd8:	56                   	push   %esi
  105dd9:	53                   	push   %ebx
  105dda:	83 ec 30             	sub    $0x30,%esp
  105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  105de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105de9:	8b 45 10             	mov    0x10(%ebp),%eax
  105dec:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105df2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105df5:	73 42                	jae    105e39 <memmove+0x69>
  105df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e06:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e0c:	c1 e8 02             	shr    $0x2,%eax
  105e0f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e17:	89 d7                	mov    %edx,%edi
  105e19:	89 c6                	mov    %eax,%esi
  105e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e1d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e20:	83 e1 03             	and    $0x3,%ecx
  105e23:	74 02                	je     105e27 <memmove+0x57>
  105e25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e27:	89 f0                	mov    %esi,%eax
  105e29:	89 fa                	mov    %edi,%edx
  105e2b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e31:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105e37:	eb 36                	jmp    105e6f <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e42:	01 c2                	add    %eax,%edx
  105e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e47:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e4d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e53:	89 c1                	mov    %eax,%ecx
  105e55:	89 d8                	mov    %ebx,%eax
  105e57:	89 d6                	mov    %edx,%esi
  105e59:	89 c7                	mov    %eax,%edi
  105e5b:	fd                   	std    
  105e5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e5e:	fc                   	cld    
  105e5f:	89 f8                	mov    %edi,%eax
  105e61:	89 f2                	mov    %esi,%edx
  105e63:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e66:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105e6f:	83 c4 30             	add    $0x30,%esp
  105e72:	5b                   	pop    %ebx
  105e73:	5e                   	pop    %esi
  105e74:	5f                   	pop    %edi
  105e75:	5d                   	pop    %ebp
  105e76:	c3                   	ret    

00105e77 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105e77:	f3 0f 1e fb          	endbr32 
  105e7b:	55                   	push   %ebp
  105e7c:	89 e5                	mov    %esp,%ebp
  105e7e:	57                   	push   %edi
  105e7f:	56                   	push   %esi
  105e80:	83 ec 20             	sub    $0x20,%esp
  105e83:	8b 45 08             	mov    0x8(%ebp),%eax
  105e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  105e92:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e98:	c1 e8 02             	shr    $0x2,%eax
  105e9b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ea3:	89 d7                	mov    %edx,%edi
  105ea5:	89 c6                	mov    %eax,%esi
  105ea7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ea9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105eac:	83 e1 03             	and    $0x3,%ecx
  105eaf:	74 02                	je     105eb3 <memcpy+0x3c>
  105eb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105eb3:	89 f0                	mov    %esi,%eax
  105eb5:	89 fa                	mov    %edi,%edx
  105eb7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105eba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105ec3:	83 c4 20             	add    $0x20,%esp
  105ec6:	5e                   	pop    %esi
  105ec7:	5f                   	pop    %edi
  105ec8:	5d                   	pop    %ebp
  105ec9:	c3                   	ret    

00105eca <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105eca:	f3 0f 1e fb          	endbr32 
  105ece:	55                   	push   %ebp
  105ecf:	89 e5                	mov    %esp,%ebp
  105ed1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  105edd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105ee0:	eb 2e                	jmp    105f10 <memcmp+0x46>
        if (*s1 != *s2) {
  105ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ee5:	0f b6 10             	movzbl (%eax),%edx
  105ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105eeb:	0f b6 00             	movzbl (%eax),%eax
  105eee:	38 c2                	cmp    %al,%dl
  105ef0:	74 18                	je     105f0a <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ef5:	0f b6 00             	movzbl (%eax),%eax
  105ef8:	0f b6 d0             	movzbl %al,%edx
  105efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105efe:	0f b6 00             	movzbl (%eax),%eax
  105f01:	0f b6 c0             	movzbl %al,%eax
  105f04:	29 c2                	sub    %eax,%edx
  105f06:	89 d0                	mov    %edx,%eax
  105f08:	eb 18                	jmp    105f22 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105f0a:	ff 45 fc             	incl   -0x4(%ebp)
  105f0d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105f10:	8b 45 10             	mov    0x10(%ebp),%eax
  105f13:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f16:	89 55 10             	mov    %edx,0x10(%ebp)
  105f19:	85 c0                	test   %eax,%eax
  105f1b:	75 c5                	jne    105ee2 <memcmp+0x18>
    }
    return 0;
  105f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f22:	c9                   	leave  
  105f23:	c3                   	ret    

00105f24 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105f24:	f3 0f 1e fb          	endbr32 
  105f28:	55                   	push   %ebp
  105f29:	89 e5                	mov    %esp,%ebp
  105f2b:	83 ec 58             	sub    $0x58,%esp
  105f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  105f31:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105f34:	8b 45 14             	mov    0x14(%ebp),%eax
  105f37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105f3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105f43:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105f46:	8b 45 18             	mov    0x18(%ebp),%eax
  105f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f55:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105f62:	74 1c                	je     105f80 <printnum+0x5c>
  105f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f67:	ba 00 00 00 00       	mov    $0x0,%edx
  105f6c:	f7 75 e4             	divl   -0x1c(%ebp)
  105f6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f75:	ba 00 00 00 00       	mov    $0x0,%edx
  105f7a:	f7 75 e4             	divl   -0x1c(%ebp)
  105f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f86:	f7 75 e4             	divl   -0x1c(%ebp)
  105f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105f95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105f98:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f9e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105fa1:	8b 45 18             	mov    0x18(%ebp),%eax
  105fa4:	ba 00 00 00 00       	mov    $0x0,%edx
  105fa9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105fac:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105faf:	19 d1                	sbb    %edx,%ecx
  105fb1:	72 4c                	jb     105fff <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105fb3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  105fb9:	8b 45 20             	mov    0x20(%ebp),%eax
  105fbc:	89 44 24 18          	mov    %eax,0x18(%esp)
  105fc0:	89 54 24 14          	mov    %edx,0x14(%esp)
  105fc4:	8b 45 18             	mov    0x18(%ebp),%eax
  105fc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  105fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105fd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fd5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe3:	89 04 24             	mov    %eax,(%esp)
  105fe6:	e8 39 ff ff ff       	call   105f24 <printnum>
  105feb:	eb 1b                	jmp    106008 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ff4:	8b 45 20             	mov    0x20(%ebp),%eax
  105ff7:	89 04 24             	mov    %eax,(%esp)
  105ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffd:	ff d0                	call   *%eax
        while (-- width > 0)
  105fff:	ff 4d 1c             	decl   0x1c(%ebp)
  106002:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106006:	7f e5                	jg     105fed <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106008:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10600b:	05 d4 77 10 00       	add    $0x1077d4,%eax
  106010:	0f b6 00             	movzbl (%eax),%eax
  106013:	0f be c0             	movsbl %al,%eax
  106016:	8b 55 0c             	mov    0xc(%ebp),%edx
  106019:	89 54 24 04          	mov    %edx,0x4(%esp)
  10601d:	89 04 24             	mov    %eax,(%esp)
  106020:	8b 45 08             	mov    0x8(%ebp),%eax
  106023:	ff d0                	call   *%eax
}
  106025:	90                   	nop
  106026:	c9                   	leave  
  106027:	c3                   	ret    

00106028 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  106028:	f3 0f 1e fb          	endbr32 
  10602c:	55                   	push   %ebp
  10602d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10602f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106033:	7e 14                	jle    106049 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  106035:	8b 45 08             	mov    0x8(%ebp),%eax
  106038:	8b 00                	mov    (%eax),%eax
  10603a:	8d 48 08             	lea    0x8(%eax),%ecx
  10603d:	8b 55 08             	mov    0x8(%ebp),%edx
  106040:	89 0a                	mov    %ecx,(%edx)
  106042:	8b 50 04             	mov    0x4(%eax),%edx
  106045:	8b 00                	mov    (%eax),%eax
  106047:	eb 30                	jmp    106079 <getuint+0x51>
    }
    else if (lflag) {
  106049:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10604d:	74 16                	je     106065 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  10604f:	8b 45 08             	mov    0x8(%ebp),%eax
  106052:	8b 00                	mov    (%eax),%eax
  106054:	8d 48 04             	lea    0x4(%eax),%ecx
  106057:	8b 55 08             	mov    0x8(%ebp),%edx
  10605a:	89 0a                	mov    %ecx,(%edx)
  10605c:	8b 00                	mov    (%eax),%eax
  10605e:	ba 00 00 00 00       	mov    $0x0,%edx
  106063:	eb 14                	jmp    106079 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  106065:	8b 45 08             	mov    0x8(%ebp),%eax
  106068:	8b 00                	mov    (%eax),%eax
  10606a:	8d 48 04             	lea    0x4(%eax),%ecx
  10606d:	8b 55 08             	mov    0x8(%ebp),%edx
  106070:	89 0a                	mov    %ecx,(%edx)
  106072:	8b 00                	mov    (%eax),%eax
  106074:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106079:	5d                   	pop    %ebp
  10607a:	c3                   	ret    

0010607b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10607b:	f3 0f 1e fb          	endbr32 
  10607f:	55                   	push   %ebp
  106080:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106082:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106086:	7e 14                	jle    10609c <getint+0x21>
        return va_arg(*ap, long long);
  106088:	8b 45 08             	mov    0x8(%ebp),%eax
  10608b:	8b 00                	mov    (%eax),%eax
  10608d:	8d 48 08             	lea    0x8(%eax),%ecx
  106090:	8b 55 08             	mov    0x8(%ebp),%edx
  106093:	89 0a                	mov    %ecx,(%edx)
  106095:	8b 50 04             	mov    0x4(%eax),%edx
  106098:	8b 00                	mov    (%eax),%eax
  10609a:	eb 28                	jmp    1060c4 <getint+0x49>
    }
    else if (lflag) {
  10609c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1060a0:	74 12                	je     1060b4 <getint+0x39>
        return va_arg(*ap, long);
  1060a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1060a5:	8b 00                	mov    (%eax),%eax
  1060a7:	8d 48 04             	lea    0x4(%eax),%ecx
  1060aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1060ad:	89 0a                	mov    %ecx,(%edx)
  1060af:	8b 00                	mov    (%eax),%eax
  1060b1:	99                   	cltd   
  1060b2:	eb 10                	jmp    1060c4 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  1060b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1060b7:	8b 00                	mov    (%eax),%eax
  1060b9:	8d 48 04             	lea    0x4(%eax),%ecx
  1060bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1060bf:	89 0a                	mov    %ecx,(%edx)
  1060c1:	8b 00                	mov    (%eax),%eax
  1060c3:	99                   	cltd   
    }
}
  1060c4:	5d                   	pop    %ebp
  1060c5:	c3                   	ret    

001060c6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1060c6:	f3 0f 1e fb          	endbr32 
  1060ca:	55                   	push   %ebp
  1060cb:	89 e5                	mov    %esp,%ebp
  1060cd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1060d0:	8d 45 14             	lea    0x14(%ebp),%eax
  1060d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1060e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ee:	89 04 24             	mov    %eax,(%esp)
  1060f1:	e8 03 00 00 00       	call   1060f9 <vprintfmt>
    va_end(ap);
}
  1060f6:	90                   	nop
  1060f7:	c9                   	leave  
  1060f8:	c3                   	ret    

001060f9 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1060f9:	f3 0f 1e fb          	endbr32 
  1060fd:	55                   	push   %ebp
  1060fe:	89 e5                	mov    %esp,%ebp
  106100:	56                   	push   %esi
  106101:	53                   	push   %ebx
  106102:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106105:	eb 17                	jmp    10611e <vprintfmt+0x25>
            if (ch == '\0') {
  106107:	85 db                	test   %ebx,%ebx
  106109:	0f 84 c0 03 00 00    	je     1064cf <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10610f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106112:	89 44 24 04          	mov    %eax,0x4(%esp)
  106116:	89 1c 24             	mov    %ebx,(%esp)
  106119:	8b 45 08             	mov    0x8(%ebp),%eax
  10611c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10611e:	8b 45 10             	mov    0x10(%ebp),%eax
  106121:	8d 50 01             	lea    0x1(%eax),%edx
  106124:	89 55 10             	mov    %edx,0x10(%ebp)
  106127:	0f b6 00             	movzbl (%eax),%eax
  10612a:	0f b6 d8             	movzbl %al,%ebx
  10612d:	83 fb 25             	cmp    $0x25,%ebx
  106130:	75 d5                	jne    106107 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106132:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106136:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10613d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106140:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106143:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10614a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10614d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  106150:	8b 45 10             	mov    0x10(%ebp),%eax
  106153:	8d 50 01             	lea    0x1(%eax),%edx
  106156:	89 55 10             	mov    %edx,0x10(%ebp)
  106159:	0f b6 00             	movzbl (%eax),%eax
  10615c:	0f b6 d8             	movzbl %al,%ebx
  10615f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106162:	83 f8 55             	cmp    $0x55,%eax
  106165:	0f 87 38 03 00 00    	ja     1064a3 <vprintfmt+0x3aa>
  10616b:	8b 04 85 f8 77 10 00 	mov    0x1077f8(,%eax,4),%eax
  106172:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106175:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106179:	eb d5                	jmp    106150 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10617b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10617f:	eb cf                	jmp    106150 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106181:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10618b:	89 d0                	mov    %edx,%eax
  10618d:	c1 e0 02             	shl    $0x2,%eax
  106190:	01 d0                	add    %edx,%eax
  106192:	01 c0                	add    %eax,%eax
  106194:	01 d8                	add    %ebx,%eax
  106196:	83 e8 30             	sub    $0x30,%eax
  106199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10619c:	8b 45 10             	mov    0x10(%ebp),%eax
  10619f:	0f b6 00             	movzbl (%eax),%eax
  1061a2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1061a5:	83 fb 2f             	cmp    $0x2f,%ebx
  1061a8:	7e 38                	jle    1061e2 <vprintfmt+0xe9>
  1061aa:	83 fb 39             	cmp    $0x39,%ebx
  1061ad:	7f 33                	jg     1061e2 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1061af:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1061b2:	eb d4                	jmp    106188 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1061b4:	8b 45 14             	mov    0x14(%ebp),%eax
  1061b7:	8d 50 04             	lea    0x4(%eax),%edx
  1061ba:	89 55 14             	mov    %edx,0x14(%ebp)
  1061bd:	8b 00                	mov    (%eax),%eax
  1061bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1061c2:	eb 1f                	jmp    1061e3 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1061c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1061c8:	79 86                	jns    106150 <vprintfmt+0x57>
                width = 0;
  1061ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1061d1:	e9 7a ff ff ff       	jmp    106150 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  1061d6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1061dd:	e9 6e ff ff ff       	jmp    106150 <vprintfmt+0x57>
            goto process_precision;
  1061e2:	90                   	nop

        process_precision:
            if (width < 0)
  1061e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1061e7:	0f 89 63 ff ff ff    	jns    106150 <vprintfmt+0x57>
                width = precision, precision = -1;
  1061ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1061f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1061f3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1061fa:	e9 51 ff ff ff       	jmp    106150 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1061ff:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  106202:	e9 49 ff ff ff       	jmp    106150 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106207:	8b 45 14             	mov    0x14(%ebp),%eax
  10620a:	8d 50 04             	lea    0x4(%eax),%edx
  10620d:	89 55 14             	mov    %edx,0x14(%ebp)
  106210:	8b 00                	mov    (%eax),%eax
  106212:	8b 55 0c             	mov    0xc(%ebp),%edx
  106215:	89 54 24 04          	mov    %edx,0x4(%esp)
  106219:	89 04 24             	mov    %eax,(%esp)
  10621c:	8b 45 08             	mov    0x8(%ebp),%eax
  10621f:	ff d0                	call   *%eax
            break;
  106221:	e9 a4 02 00 00       	jmp    1064ca <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106226:	8b 45 14             	mov    0x14(%ebp),%eax
  106229:	8d 50 04             	lea    0x4(%eax),%edx
  10622c:	89 55 14             	mov    %edx,0x14(%ebp)
  10622f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106231:	85 db                	test   %ebx,%ebx
  106233:	79 02                	jns    106237 <vprintfmt+0x13e>
                err = -err;
  106235:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106237:	83 fb 06             	cmp    $0x6,%ebx
  10623a:	7f 0b                	jg     106247 <vprintfmt+0x14e>
  10623c:	8b 34 9d b8 77 10 00 	mov    0x1077b8(,%ebx,4),%esi
  106243:	85 f6                	test   %esi,%esi
  106245:	75 23                	jne    10626a <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  106247:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10624b:	c7 44 24 08 e5 77 10 	movl   $0x1077e5,0x8(%esp)
  106252:	00 
  106253:	8b 45 0c             	mov    0xc(%ebp),%eax
  106256:	89 44 24 04          	mov    %eax,0x4(%esp)
  10625a:	8b 45 08             	mov    0x8(%ebp),%eax
  10625d:	89 04 24             	mov    %eax,(%esp)
  106260:	e8 61 fe ff ff       	call   1060c6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  106265:	e9 60 02 00 00       	jmp    1064ca <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10626a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10626e:	c7 44 24 08 ee 77 10 	movl   $0x1077ee,0x8(%esp)
  106275:	00 
  106276:	8b 45 0c             	mov    0xc(%ebp),%eax
  106279:	89 44 24 04          	mov    %eax,0x4(%esp)
  10627d:	8b 45 08             	mov    0x8(%ebp),%eax
  106280:	89 04 24             	mov    %eax,(%esp)
  106283:	e8 3e fe ff ff       	call   1060c6 <printfmt>
            break;
  106288:	e9 3d 02 00 00       	jmp    1064ca <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10628d:	8b 45 14             	mov    0x14(%ebp),%eax
  106290:	8d 50 04             	lea    0x4(%eax),%edx
  106293:	89 55 14             	mov    %edx,0x14(%ebp)
  106296:	8b 30                	mov    (%eax),%esi
  106298:	85 f6                	test   %esi,%esi
  10629a:	75 05                	jne    1062a1 <vprintfmt+0x1a8>
                p = "(null)";
  10629c:	be f1 77 10 00       	mov    $0x1077f1,%esi
            }
            if (width > 0 && padc != '-') {
  1062a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1062a5:	7e 76                	jle    10631d <vprintfmt+0x224>
  1062a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1062ab:	74 70                	je     10631d <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1062ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062b4:	89 34 24             	mov    %esi,(%esp)
  1062b7:	e8 ba f7 ff ff       	call   105a76 <strnlen>
  1062bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1062bf:	29 c2                	sub    %eax,%edx
  1062c1:	89 d0                	mov    %edx,%eax
  1062c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1062c6:	eb 16                	jmp    1062de <vprintfmt+0x1e5>
                    putch(padc, putdat);
  1062c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1062cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1062cf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1062d3:	89 04 24             	mov    %eax,(%esp)
  1062d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1062d9:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1062db:	ff 4d e8             	decl   -0x18(%ebp)
  1062de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1062e2:	7f e4                	jg     1062c8 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1062e4:	eb 37                	jmp    10631d <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1062e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1062ea:	74 1f                	je     10630b <vprintfmt+0x212>
  1062ec:	83 fb 1f             	cmp    $0x1f,%ebx
  1062ef:	7e 05                	jle    1062f6 <vprintfmt+0x1fd>
  1062f1:	83 fb 7e             	cmp    $0x7e,%ebx
  1062f4:	7e 15                	jle    10630b <vprintfmt+0x212>
                    putch('?', putdat);
  1062f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062fd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106304:	8b 45 08             	mov    0x8(%ebp),%eax
  106307:	ff d0                	call   *%eax
  106309:	eb 0f                	jmp    10631a <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  10630b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10630e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106312:	89 1c 24             	mov    %ebx,(%esp)
  106315:	8b 45 08             	mov    0x8(%ebp),%eax
  106318:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10631a:	ff 4d e8             	decl   -0x18(%ebp)
  10631d:	89 f0                	mov    %esi,%eax
  10631f:	8d 70 01             	lea    0x1(%eax),%esi
  106322:	0f b6 00             	movzbl (%eax),%eax
  106325:	0f be d8             	movsbl %al,%ebx
  106328:	85 db                	test   %ebx,%ebx
  10632a:	74 27                	je     106353 <vprintfmt+0x25a>
  10632c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106330:	78 b4                	js     1062e6 <vprintfmt+0x1ed>
  106332:	ff 4d e4             	decl   -0x1c(%ebp)
  106335:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106339:	79 ab                	jns    1062e6 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  10633b:	eb 16                	jmp    106353 <vprintfmt+0x25a>
                putch(' ', putdat);
  10633d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106340:	89 44 24 04          	mov    %eax,0x4(%esp)
  106344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10634b:	8b 45 08             	mov    0x8(%ebp),%eax
  10634e:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  106350:	ff 4d e8             	decl   -0x18(%ebp)
  106353:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106357:	7f e4                	jg     10633d <vprintfmt+0x244>
            }
            break;
  106359:	e9 6c 01 00 00       	jmp    1064ca <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10635e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106361:	89 44 24 04          	mov    %eax,0x4(%esp)
  106365:	8d 45 14             	lea    0x14(%ebp),%eax
  106368:	89 04 24             	mov    %eax,(%esp)
  10636b:	e8 0b fd ff ff       	call   10607b <getint>
  106370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106373:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10637c:	85 d2                	test   %edx,%edx
  10637e:	79 26                	jns    1063a6 <vprintfmt+0x2ad>
                putch('-', putdat);
  106380:	8b 45 0c             	mov    0xc(%ebp),%eax
  106383:	89 44 24 04          	mov    %eax,0x4(%esp)
  106387:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10638e:	8b 45 08             	mov    0x8(%ebp),%eax
  106391:	ff d0                	call   *%eax
                num = -(long long)num;
  106393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106399:	f7 d8                	neg    %eax
  10639b:	83 d2 00             	adc    $0x0,%edx
  10639e:	f7 da                	neg    %edx
  1063a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1063a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1063a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1063ad:	e9 a8 00 00 00       	jmp    10645a <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1063b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1063b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063b9:	8d 45 14             	lea    0x14(%ebp),%eax
  1063bc:	89 04 24             	mov    %eax,(%esp)
  1063bf:	e8 64 fc ff ff       	call   106028 <getuint>
  1063c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1063c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1063ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1063d1:	e9 84 00 00 00       	jmp    10645a <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1063d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1063d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063dd:	8d 45 14             	lea    0x14(%ebp),%eax
  1063e0:	89 04 24             	mov    %eax,(%esp)
  1063e3:	e8 40 fc ff ff       	call   106028 <getuint>
  1063e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1063eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1063ee:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1063f5:	eb 63                	jmp    10645a <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1063f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1063fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063fe:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106405:	8b 45 08             	mov    0x8(%ebp),%eax
  106408:	ff d0                	call   *%eax
            putch('x', putdat);
  10640a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10640d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106411:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106418:	8b 45 08             	mov    0x8(%ebp),%eax
  10641b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10641d:	8b 45 14             	mov    0x14(%ebp),%eax
  106420:	8d 50 04             	lea    0x4(%eax),%edx
  106423:	89 55 14             	mov    %edx,0x14(%ebp)
  106426:	8b 00                	mov    (%eax),%eax
  106428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10642b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106432:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106439:	eb 1f                	jmp    10645a <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10643b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10643e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106442:	8d 45 14             	lea    0x14(%ebp),%eax
  106445:	89 04 24             	mov    %eax,(%esp)
  106448:	e8 db fb ff ff       	call   106028 <getuint>
  10644d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106450:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106453:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10645a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10645e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106461:	89 54 24 18          	mov    %edx,0x18(%esp)
  106465:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106468:	89 54 24 14          	mov    %edx,0x14(%esp)
  10646c:	89 44 24 10          	mov    %eax,0x10(%esp)
  106470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106476:	89 44 24 08          	mov    %eax,0x8(%esp)
  10647a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10647e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106481:	89 44 24 04          	mov    %eax,0x4(%esp)
  106485:	8b 45 08             	mov    0x8(%ebp),%eax
  106488:	89 04 24             	mov    %eax,(%esp)
  10648b:	e8 94 fa ff ff       	call   105f24 <printnum>
            break;
  106490:	eb 38                	jmp    1064ca <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106492:	8b 45 0c             	mov    0xc(%ebp),%eax
  106495:	89 44 24 04          	mov    %eax,0x4(%esp)
  106499:	89 1c 24             	mov    %ebx,(%esp)
  10649c:	8b 45 08             	mov    0x8(%ebp),%eax
  10649f:	ff d0                	call   *%eax
            break;
  1064a1:	eb 27                	jmp    1064ca <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1064a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064aa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1064b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1064b4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1064b6:	ff 4d 10             	decl   0x10(%ebp)
  1064b9:	eb 03                	jmp    1064be <vprintfmt+0x3c5>
  1064bb:	ff 4d 10             	decl   0x10(%ebp)
  1064be:	8b 45 10             	mov    0x10(%ebp),%eax
  1064c1:	48                   	dec    %eax
  1064c2:	0f b6 00             	movzbl (%eax),%eax
  1064c5:	3c 25                	cmp    $0x25,%al
  1064c7:	75 f2                	jne    1064bb <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  1064c9:	90                   	nop
    while (1) {
  1064ca:	e9 36 fc ff ff       	jmp    106105 <vprintfmt+0xc>
                return;
  1064cf:	90                   	nop
        }
    }
}
  1064d0:	83 c4 40             	add    $0x40,%esp
  1064d3:	5b                   	pop    %ebx
  1064d4:	5e                   	pop    %esi
  1064d5:	5d                   	pop    %ebp
  1064d6:	c3                   	ret    

001064d7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1064d7:	f3 0f 1e fb          	endbr32 
  1064db:	55                   	push   %ebp
  1064dc:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1064de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064e1:	8b 40 08             	mov    0x8(%eax),%eax
  1064e4:	8d 50 01             	lea    0x1(%eax),%edx
  1064e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064ea:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1064ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064f0:	8b 10                	mov    (%eax),%edx
  1064f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064f5:	8b 40 04             	mov    0x4(%eax),%eax
  1064f8:	39 c2                	cmp    %eax,%edx
  1064fa:	73 12                	jae    10650e <sprintputch+0x37>
        *b->buf ++ = ch;
  1064fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064ff:	8b 00                	mov    (%eax),%eax
  106501:	8d 48 01             	lea    0x1(%eax),%ecx
  106504:	8b 55 0c             	mov    0xc(%ebp),%edx
  106507:	89 0a                	mov    %ecx,(%edx)
  106509:	8b 55 08             	mov    0x8(%ebp),%edx
  10650c:	88 10                	mov    %dl,(%eax)
    }
}
  10650e:	90                   	nop
  10650f:	5d                   	pop    %ebp
  106510:	c3                   	ret    

00106511 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106511:	f3 0f 1e fb          	endbr32 
  106515:	55                   	push   %ebp
  106516:	89 e5                	mov    %esp,%ebp
  106518:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10651b:	8d 45 14             	lea    0x14(%ebp),%eax
  10651e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106524:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106528:	8b 45 10             	mov    0x10(%ebp),%eax
  10652b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10652f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106532:	89 44 24 04          	mov    %eax,0x4(%esp)
  106536:	8b 45 08             	mov    0x8(%ebp),%eax
  106539:	89 04 24             	mov    %eax,(%esp)
  10653c:	e8 08 00 00 00       	call   106549 <vsnprintf>
  106541:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106547:	c9                   	leave  
  106548:	c3                   	ret    

00106549 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106549:	f3 0f 1e fb          	endbr32 
  10654d:	55                   	push   %ebp
  10654e:	89 e5                	mov    %esp,%ebp
  106550:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106553:	8b 45 08             	mov    0x8(%ebp),%eax
  106556:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106559:	8b 45 0c             	mov    0xc(%ebp),%eax
  10655c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10655f:	8b 45 08             	mov    0x8(%ebp),%eax
  106562:	01 d0                	add    %edx,%eax
  106564:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10656e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106572:	74 0a                	je     10657e <vsnprintf+0x35>
  106574:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10657a:	39 c2                	cmp    %eax,%edx
  10657c:	76 07                	jbe    106585 <vsnprintf+0x3c>
        return -E_INVAL;
  10657e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106583:	eb 2a                	jmp    1065af <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106585:	8b 45 14             	mov    0x14(%ebp),%eax
  106588:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10658c:	8b 45 10             	mov    0x10(%ebp),%eax
  10658f:	89 44 24 08          	mov    %eax,0x8(%esp)
  106593:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106596:	89 44 24 04          	mov    %eax,0x4(%esp)
  10659a:	c7 04 24 d7 64 10 00 	movl   $0x1064d7,(%esp)
  1065a1:	e8 53 fb ff ff       	call   1060f9 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1065a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1065a9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1065ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1065af:	c9                   	leave  
  1065b0:	c3                   	ret    

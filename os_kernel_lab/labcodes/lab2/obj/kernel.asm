
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 b0 11 00       	mov    $0x11b000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 b0 11 c0       	mov    %eax,0xc011b000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c0100045:	2d 00 d0 11 c0       	sub    $0xc011d000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 d0 11 c0 	movl   $0xc011d000,(%esp)
c010005d:	e8 2b 5d 00 00       	call   c0105d8d <memset>

    cons_init();                // init the console
c0100062:	e8 4b 16 00 00       	call   c01016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 c0 65 10 c0 	movl   $0xc01065c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 dc 65 10 c0 	movl   $0xc01065dc,(%esp)
c010007c:	e8 44 02 00 00       	call   c01002c5 <cprintf>

    print_kerninfo();
c0100081:	e8 02 09 00 00       	call   c0100988 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 18 36 00 00       	call   c01036a8 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 98 17 00 00       	call   c010182d <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 18 19 00 00       	call   c01019b2 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 5a 0d 00 00       	call   c0100df9 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 d5 18 00 00       	call   c0101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	f3 0f 1e fb          	endbr32 
c01000aa:	55                   	push   %ebp
c01000ab:	89 e5                	mov    %esp,%ebp
c01000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b7:	00 
c01000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bf:	00 
c01000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c7:	e8 17 0d 00 00       	call   c0100de3 <mon_backtrace>
}
c01000cc:	90                   	nop
c01000cd:	c9                   	leave  
c01000ce:	c3                   	ret    

c01000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cf:	f3 0f 1e fb          	endbr32 
c01000d3:	55                   	push   %ebp
c01000d4:	89 e5                	mov    %esp,%ebp
c01000d6:	53                   	push   %ebx
c01000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f2:	89 04 24             	mov    %eax,(%esp)
c01000f5:	e8 ac ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000fa:	90                   	nop
c01000fb:	83 c4 14             	add    $0x14,%esp
c01000fe:	5b                   	pop    %ebx
c01000ff:	5d                   	pop    %ebp
c0100100:	c3                   	ret    

c0100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100101:	f3 0f 1e fb          	endbr32 
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010b:	8b 45 10             	mov    0x10(%ebp),%eax
c010010e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100112:	8b 45 08             	mov    0x8(%ebp),%eax
c0100115:	89 04 24             	mov    %eax,(%esp)
c0100118:	e8 b2 ff ff ff       	call   c01000cf <grade_backtrace1>
}
c010011d:	90                   	nop
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	f3 0f 1e fb          	endbr32 
c0100124:	55                   	push   %ebp
c0100125:	89 e5                	mov    %esp,%ebp
c0100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100136:	ff 
c0100137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100142:	e8 ba ff ff ff       	call   c0100101 <grade_backtrace0>
}
c0100147:	90                   	nop
c0100148:	c9                   	leave  
c0100149:	c3                   	ret    

c010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014a:	f3 0f 1e fb          	endbr32 
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 e1 65 10 c0 	movl   $0xc01065e1,(%esp)
c010017d:	e8 43 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 ef 65 10 c0 	movl   $0xc01065ef,(%esp)
c010019c:	e8 24 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 fd 65 10 c0 	movl   $0xc01065fd,(%esp)
c01001bb:	e8 05 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01001da:	e8 e6 00 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 19 66 10 c0 	movl   $0xc0106619,(%esp)
c01001f9:	e8 c7 00 00 00       	call   c01002c5 <cprintf>
    round ++;
c01001fe:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 d0 11 c0       	mov    %eax,0xc011d000
}
c0100209:	90                   	nop
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	f3 0f 1e fb          	endbr32 
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
c0100213:	83 ec 08             	sub    $0x8,%esp
c0100216:	cd 78                	int    $0x78
c0100218:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
        "movl %%ebp, %%esp\n"
		:
		:"i" (T_SWITCH_TOU)
	);
}
c010021a:	90                   	nop
c010021b:	5d                   	pop    %ebp
c010021c:	c3                   	ret    

c010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010021d:	f3 0f 1e fb          	endbr32 
c0100221:	55                   	push   %ebp
c0100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    __asm__ __volatile__(
c0100224:	cd 79                	int    $0x79
c0100226:	89 ec                	mov    %ebp,%esp
    	"int %0 \n"
    	"movl %%ebp,%%esp \n" 
    	:
    	:"i"(T_SWITCH_TOK)
    );
}
c0100228:	90                   	nop
c0100229:	5d                   	pop    %ebp
c010022a:	c3                   	ret    

c010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010022b:	f3 0f 1e fb          	endbr32 
c010022f:	55                   	push   %ebp
c0100230:	89 e5                	mov    %esp,%ebp
c0100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100235:	e8 10 ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010023a:	c7 04 24 28 66 10 c0 	movl   $0xc0106628,(%esp)
c0100241:	e8 7f 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_user();
c0100246:	e8 c1 ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c010024b:	e8 fa fe ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100250:	c7 04 24 48 66 10 c0 	movl   $0xc0106648,(%esp)
c0100257:	e8 69 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_kernel();
c010025c:	e8 bc ff ff ff       	call   c010021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100261:	e8 e4 fe ff ff       	call   c010014a <lab1_print_cur_status>
}
c0100266:	90                   	nop
c0100267:	c9                   	leave  
c0100268:	c3                   	ret    

c0100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100269:	f3 0f 1e fb          	endbr32 
c010026d:	55                   	push   %ebp
c010026e:	89 e5                	mov    %esp,%ebp
c0100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100273:	8b 45 08             	mov    0x8(%ebp),%eax
c0100276:	89 04 24             	mov    %eax,(%esp)
c0100279:	e8 65 14 00 00       	call   c01016e3 <cons_putc>
    (*cnt) ++;
c010027e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100281:	8b 00                	mov    (%eax),%eax
c0100283:	8d 50 01             	lea    0x1(%eax),%edx
c0100286:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100289:	89 10                	mov    %edx,(%eax)
}
c010028b:	90                   	nop
c010028c:	c9                   	leave  
c010028d:	c3                   	ret    

c010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010028e:	f3 0f 1e fb          	endbr32 
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010029f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b4:	c7 04 24 69 02 10 c0 	movl   $0xc0100269,(%esp)
c01002bb:	e8 39 5e 00 00       	call   c01060f9 <vprintfmt>
    return cnt;
c01002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c3:	c9                   	leave  
c01002c4:	c3                   	ret    

c01002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002c5:	f3 0f 1e fb          	endbr32 
c01002c9:	55                   	push   %ebp
c01002ca:	89 e5                	mov    %esp,%ebp
c01002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 a7 ff ff ff       	call   c010028e <vcprintf>
c01002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002ed:	c9                   	leave  
c01002ee:	c3                   	ret    

c01002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002ef:	f3 0f 1e fb          	endbr32 
c01002f3:	55                   	push   %ebp
c01002f4:	89 e5                	mov    %esp,%ebp
c01002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fc:	89 04 24             	mov    %eax,(%esp)
c01002ff:	e8 df 13 00 00       	call   c01016e3 <cons_putc>
}
c0100304:	90                   	nop
c0100305:	c9                   	leave  
c0100306:	c3                   	ret    

c0100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100307:	f3 0f 1e fb          	endbr32 
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100318:	eb 13                	jmp    c010032d <cputs+0x26>
        cputch(c, &cnt);
c010031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100321:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100325:	89 04 24             	mov    %eax,(%esp)
c0100328:	e8 3c ff ff ff       	call   c0100269 <cputch>
    while ((c = *str ++) != '\0') {
c010032d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100330:	8d 50 01             	lea    0x1(%eax),%edx
c0100333:	89 55 08             	mov    %edx,0x8(%ebp)
c0100336:	0f b6 00             	movzbl (%eax),%eax
c0100339:	88 45 f7             	mov    %al,-0x9(%ebp)
c010033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100340:	75 d8                	jne    c010031a <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100345:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100350:	e8 14 ff ff ff       	call   c0100269 <cputch>
    return cnt;
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100358:	c9                   	leave  
c0100359:	c3                   	ret    

c010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010035a:	f3 0f 1e fb          	endbr32 
c010035e:	55                   	push   %ebp
c010035f:	89 e5                	mov    %esp,%ebp
c0100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100364:	90                   	nop
c0100365:	e8 ba 13 00 00       	call   c0101724 <cons_getc>
c010036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100371:	74 f2                	je     c0100365 <getchar+0xb>
        /* do nothing */;
    return c;
c0100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100376:	c9                   	leave  
c0100377:	c3                   	ret    

c0100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100378:	f3 0f 1e fb          	endbr32 
c010037c:	55                   	push   %ebp
c010037d:	89 e5                	mov    %esp,%ebp
c010037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100386:	74 13                	je     c010039b <readline+0x23>
        cprintf("%s", prompt);
c0100388:	8b 45 08             	mov    0x8(%ebp),%eax
c010038b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010038f:	c7 04 24 67 66 10 c0 	movl   $0xc0106667,(%esp)
c0100396:	e8 2a ff ff ff       	call   c01002c5 <cprintf>
    }
    int i = 0, c;
c010039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003a2:	e8 b3 ff ff ff       	call   c010035a <getchar>
c01003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003ae:	79 07                	jns    c01003b7 <readline+0x3f>
            return NULL;
c01003b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01003b5:	eb 78                	jmp    c010042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003bb:	7e 28                	jle    c01003e5 <readline+0x6d>
c01003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003c4:	7f 1f                	jg     c01003e5 <readline+0x6d>
            cputchar(c);
c01003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c9:	89 04 24             	mov    %eax,(%esp)
c01003cc:	e8 1e ff ff ff       	call   c01002ef <cputchar>
            buf[i ++] = c;
c01003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d4:	8d 50 01             	lea    0x1(%eax),%edx
c01003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003dd:	88 90 20 d0 11 c0    	mov    %dl,-0x3fee2fe0(%eax)
c01003e3:	eb 45                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003e9:	75 16                	jne    c0100401 <readline+0x89>
c01003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ef:	7e 10                	jle    c0100401 <readline+0x89>
            cputchar(c);
c01003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003f4:	89 04 24             	mov    %eax,(%esp)
c01003f7:	e8 f3 fe ff ff       	call   c01002ef <cputchar>
            i --;
c01003fc:	ff 4d f4             	decl   -0xc(%ebp)
c01003ff:	eb 29                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100405:	74 06                	je     c010040d <readline+0x95>
c0100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010040b:	75 95                	jne    c01003a2 <readline+0x2a>
            cputchar(c);
c010040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100410:	89 04 24             	mov    %eax,(%esp)
c0100413:	e8 d7 fe ff ff       	call   c01002ef <cputchar>
            buf[i] = '\0';
c0100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041b:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100423:	b8 20 d0 11 c0       	mov    $0xc011d020,%eax
c0100428:	eb 05                	jmp    c010042f <readline+0xb7>
        c = getchar();
c010042a:	e9 73 ff ff ff       	jmp    c01003a2 <readline+0x2a>
        }
    }
}
c010042f:	c9                   	leave  
c0100430:	c3                   	ret    

c0100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100431:	f3 0f 1e fb          	endbr32 
c0100435:	55                   	push   %ebp
c0100436:	89 e5                	mov    %esp,%ebp
c0100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c010043b:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
c0100440:	85 c0                	test   %eax,%eax
c0100442:	75 5b                	jne    c010049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100444:	c7 05 20 d4 11 c0 01 	movl   $0x1,0xc011d420
c010044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010044e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100457:	89 44 24 08          	mov    %eax,0x8(%esp)
c010045b:	8b 45 08             	mov    0x8(%ebp),%eax
c010045e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100462:	c7 04 24 6a 66 10 c0 	movl   $0xc010666a,(%esp)
c0100469:	e8 57 fe ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c010046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100475:	8b 45 10             	mov    0x10(%ebp),%eax
c0100478:	89 04 24             	mov    %eax,(%esp)
c010047b:	e8 0e fe ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c0100480:	c7 04 24 86 66 10 c0 	movl   $0xc0106686,(%esp)
c0100487:	e8 39 fe ff ff       	call   c01002c5 <cprintf>
    
    cprintf("stack trackback:\n");
c010048c:	c7 04 24 88 66 10 c0 	movl   $0xc0106688,(%esp)
c0100493:	e8 2d fe ff ff       	call   c01002c5 <cprintf>
    print_stackframe();
c0100498:	e8 3d 06 00 00       	call   c0100ada <print_stackframe>
c010049d:	eb 01                	jmp    c01004a0 <__panic+0x6f>
        goto panic_dead;
c010049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004a0:	e8 e0 14 00 00       	call   c0101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004ac:	e8 59 08 00 00       	call   c0100d0a <kmonitor>
c01004b1:	eb f2                	jmp    c01004a5 <__panic+0x74>

c01004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004b3:	f3 0f 1e fb          	endbr32 
c01004b7:	55                   	push   %ebp
c01004b8:	89 e5                	mov    %esp,%ebp
c01004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d1:	c7 04 24 9a 66 10 c0 	movl   $0xc010669a,(%esp)
c01004d8:	e8 e8 fd ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c01004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e7:	89 04 24             	mov    %eax,(%esp)
c01004ea:	e8 9f fd ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c01004ef:	c7 04 24 86 66 10 c0 	movl   $0xc0106686,(%esp)
c01004f6:	e8 ca fd ff ff       	call   c01002c5 <cprintf>
    va_end(ap);
}
c01004fb:	90                   	nop
c01004fc:	c9                   	leave  
c01004fd:	c3                   	ret    

c01004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004fe:	f3 0f 1e fb          	endbr32 
c0100502:	55                   	push   %ebp
c0100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100505:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
}
c010050a:	5d                   	pop    %ebp
c010050b:	c3                   	ret    

c010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010050c:	f3 0f 1e fb          	endbr32 
c0100510:	55                   	push   %ebp
c0100511:	89 e5                	mov    %esp,%ebp
c0100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100516:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100519:	8b 00                	mov    (%eax),%eax
c010051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010051e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100521:	8b 00                	mov    (%eax),%eax
c0100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010052d:	e9 ca 00 00 00       	jmp    c01005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100538:	01 d0                	add    %edx,%eax
c010053a:	89 c2                	mov    %eax,%edx
c010053c:	c1 ea 1f             	shr    $0x1f,%edx
c010053f:	01 d0                	add    %edx,%eax
c0100541:	d1 f8                	sar    %eax
c0100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010054c:	eb 03                	jmp    c0100551 <stab_binsearch+0x45>
            m --;
c010054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100557:	7c 1f                	jl     c0100578 <stab_binsearch+0x6c>
c0100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010055c:	89 d0                	mov    %edx,%eax
c010055e:	01 c0                	add    %eax,%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	c1 e0 02             	shl    $0x2,%eax
c0100565:	89 c2                	mov    %eax,%edx
c0100567:	8b 45 08             	mov    0x8(%ebp),%eax
c010056a:	01 d0                	add    %edx,%eax
c010056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100570:	0f b6 c0             	movzbl %al,%eax
c0100573:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100576:	75 d6                	jne    c010054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c0100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010057e:	7d 09                	jge    c0100589 <stab_binsearch+0x7d>
            l = true_m + 1;
c0100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100583:	40                   	inc    %eax
c0100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100587:	eb 73                	jmp    c01005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c0100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100593:	89 d0                	mov    %edx,%eax
c0100595:	01 c0                	add    %eax,%eax
c0100597:	01 d0                	add    %edx,%eax
c0100599:	c1 e0 02             	shl    $0x2,%eax
c010059c:	89 c2                	mov    %eax,%edx
c010059e:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a1:	01 d0                	add    %edx,%eax
c01005a3:	8b 40 08             	mov    0x8(%eax),%eax
c01005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005a9:	76 11                	jbe    c01005bc <stab_binsearch+0xb0>
            *region_left = m;
c01005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005b6:	40                   	inc    %eax
c01005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005ba:	eb 40                	jmp    c01005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bf:	89 d0                	mov    %edx,%eax
c01005c1:	01 c0                	add    %eax,%eax
c01005c3:	01 d0                	add    %edx,%eax
c01005c5:	c1 e0 02             	shl    $0x2,%eax
c01005c8:	89 c2                	mov    %eax,%edx
c01005ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01005cd:	01 d0                	add    %edx,%eax
c01005cf:	8b 40 08             	mov    0x8(%eax),%eax
c01005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005d5:	73 14                	jae    c01005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e5:	48                   	dec    %eax
c01005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005e9:	eb 11                	jmp    c01005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100602:	0f 8e 2a ff ff ff    	jle    c0100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c0100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010060c:	75 0f                	jne    c010061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c010060e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100611:	8b 00                	mov    (%eax),%eax
c0100613:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100616:	8b 45 10             	mov    0x10(%ebp),%eax
c0100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010061b:	eb 3e                	jmp    c010065b <stab_binsearch+0x14f>
        l = *region_right;
c010061d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100620:	8b 00                	mov    (%eax),%eax
c0100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100625:	eb 03                	jmp    c010062a <stab_binsearch+0x11e>
c0100627:	ff 4d fc             	decl   -0x4(%ebp)
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	8b 00                	mov    (%eax),%eax
c010062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100632:	7e 1f                	jle    c0100653 <stab_binsearch+0x147>
c0100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100637:	89 d0                	mov    %edx,%eax
c0100639:	01 c0                	add    %eax,%eax
c010063b:	01 d0                	add    %edx,%eax
c010063d:	c1 e0 02             	shl    $0x2,%eax
c0100640:	89 c2                	mov    %eax,%edx
c0100642:	8b 45 08             	mov    0x8(%ebp),%eax
c0100645:	01 d0                	add    %edx,%eax
c0100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010064b:	0f b6 c0             	movzbl %al,%eax
c010064e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100651:	75 d4                	jne    c0100627 <stab_binsearch+0x11b>
        *region_left = l;
c0100653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100659:	89 10                	mov    %edx,(%eax)
}
c010065b:	90                   	nop
c010065c:	c9                   	leave  
c010065d:	c3                   	ret    

c010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010065e:	f3 0f 1e fb          	endbr32 
c0100662:	55                   	push   %ebp
c0100663:	89 e5                	mov    %esp,%ebp
c0100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100668:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066b:	c7 00 b8 66 10 c0    	movl   $0xc01066b8,(%eax)
    info->eip_line = 0;
c0100671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010067b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067e:	c7 40 08 b8 66 10 c0 	movl   $0xc01066b8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010068f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100692:	8b 55 08             	mov    0x8(%ebp),%edx
c0100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006a2:	c7 45 f4 50 79 10 c0 	movl   $0xc0107950,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006a9:	c7 45 f0 a0 46 11 c0 	movl   $0xc01146a0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006b0:	c7 45 ec a1 46 11 c0 	movl   $0xc01146a1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006b7:	c7 45 e8 dd 71 11 c0 	movl   $0xc01171dd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006c4:	76 0b                	jbe    c01006d1 <debuginfo_eip+0x73>
c01006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c9:	48                   	dec    %eax
c01006ca:	0f b6 00             	movzbl (%eax),%eax
c01006cd:	84 c0                	test   %al,%al
c01006cf:	74 0a                	je     c01006db <debuginfo_eip+0x7d>
        return -1;
c01006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d6:	e9 ab 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006e8:	c1 f8 02             	sar    $0x2,%eax
c01006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006f1:	48                   	dec    %eax
c01006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100703:	00 
c0100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100707:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010070e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100715:	89 04 24             	mov    %eax,(%esp)
c0100718:	e8 ef fd ff ff       	call   c010050c <stab_binsearch>
    if (lfile == 0)
c010071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100720:	85 c0                	test   %eax,%eax
c0100722:	75 0a                	jne    c010072e <debuginfo_eip+0xd0>
        return -1;
c0100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100729:	e9 58 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010073a:	8b 45 08             	mov    0x8(%ebp),%eax
c010073d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100748:	00 
c0100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010074c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100753:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075a:	89 04 24             	mov    %eax,(%esp)
c010075d:	e8 aa fd ff ff       	call   c010050c <stab_binsearch>

    if (lfun <= rfun) {
c0100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100768:	39 c2                	cmp    %eax,%edx
c010076a:	7f 78                	jg     c01007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	89 d0                	mov    %edx,%eax
c0100773:	01 c0                	add    %eax,%eax
c0100775:	01 d0                	add    %edx,%eax
c0100777:	c1 e0 02             	shl    $0x2,%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	8b 10                	mov    (%eax),%edx
c0100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	73 22                	jae    c01007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	89 d0                	mov    %edx,%eax
c0100794:	01 c0                	add    %eax,%eax
c0100796:	01 d0                	add    %edx,%eax
c0100798:	c1 e0 02             	shl    $0x2,%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	8b 10                	mov    (%eax),%edx
c01007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007a7:	01 c2                	add    %eax,%edx
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	8b 50 08             	mov    0x8(%eax),%edx
c01007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d0:	8b 40 10             	mov    0x10(%eax),%eax
c01007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007e2:	eb 15                	jmp    c01007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fc:	8b 40 08             	mov    0x8(%eax),%eax
c01007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100806:	00 
c0100807:	89 04 24             	mov    %eax,(%esp)
c010080a:	e8 f2 53 00 00       	call   c0105c01 <strfind>
c010080f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100812:	8b 52 08             	mov    0x8(%edx),%edx
c0100815:	29 d0                	sub    %edx,%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010081f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100822:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010082d:	00 
c010082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100831:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100838:	89 44 24 04          	mov    %eax,0x4(%esp)
c010083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083f:	89 04 24             	mov    %eax,(%esp)
c0100842:	e8 c5 fc ff ff       	call   c010050c <stab_binsearch>
    if (lline <= rline) {
c0100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010084d:	39 c2                	cmp    %eax,%edx
c010084f:	7f 23                	jg     c0100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100854:	89 c2                	mov    %eax,%edx
c0100856:	89 d0                	mov    %edx,%eax
c0100858:	01 c0                	add    %eax,%eax
c010085a:	01 d0                	add    %edx,%eax
c010085c:	c1 e0 02             	shl    $0x2,%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100872:	eb 11                	jmp    c0100885 <debuginfo_eip+0x227>
        return -1;
c0100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100879:	e9 08 01 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100881:	48                   	dec    %eax
c0100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088b:	39 c2                	cmp    %eax,%edx
c010088d:	7c 56                	jl     c01008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c010088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	89 d0                	mov    %edx,%eax
c0100896:	01 c0                	add    %eax,%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	c1 e0 02             	shl    $0x2,%eax
c010089d:	89 c2                	mov    %eax,%edx
c010089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a2:	01 d0                	add    %edx,%eax
c01008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008a8:	3c 84                	cmp    $0x84,%al
c01008aa:	74 39                	je     c01008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008af:	89 c2                	mov    %eax,%edx
c01008b1:	89 d0                	mov    %edx,%eax
c01008b3:	01 c0                	add    %eax,%eax
c01008b5:	01 d0                	add    %edx,%eax
c01008b7:	c1 e0 02             	shl    $0x2,%eax
c01008ba:	89 c2                	mov    %eax,%edx
c01008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008bf:	01 d0                	add    %edx,%eax
c01008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008c5:	3c 64                	cmp    $0x64,%al
c01008c7:	75 b5                	jne    c010087e <debuginfo_eip+0x220>
c01008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008cc:	89 c2                	mov    %eax,%edx
c01008ce:	89 d0                	mov    %edx,%eax
c01008d0:	01 c0                	add    %eax,%eax
c01008d2:	01 d0                	add    %edx,%eax
c01008d4:	c1 e0 02             	shl    $0x2,%eax
c01008d7:	89 c2                	mov    %eax,%edx
c01008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008dc:	01 d0                	add    %edx,%eax
c01008de:	8b 40 08             	mov    0x8(%eax),%eax
c01008e1:	85 c0                	test   %eax,%eax
c01008e3:	74 99                	je     c010087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008eb:	39 c2                	cmp    %eax,%edx
c01008ed:	7c 42                	jl     c0100931 <debuginfo_eip+0x2d3>
c01008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	89 d0                	mov    %edx,%eax
c01008f6:	01 c0                	add    %eax,%eax
c01008f8:	01 d0                	add    %edx,%eax
c01008fa:	c1 e0 02             	shl    $0x2,%eax
c01008fd:	89 c2                	mov    %eax,%edx
c01008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100902:	01 d0                	add    %edx,%eax
c0100904:	8b 10                	mov    (%eax),%edx
c0100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010090c:	39 c2                	cmp    %eax,%edx
c010090e:	73 21                	jae    c0100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	89 d0                	mov    %edx,%eax
c0100917:	01 c0                	add    %eax,%eax
c0100919:	01 d0                	add    %edx,%eax
c010091b:	c1 e0 02             	shl    $0x2,%eax
c010091e:	89 c2                	mov    %eax,%edx
c0100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100923:	01 d0                	add    %edx,%eax
c0100925:	8b 10                	mov    (%eax),%edx
c0100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092a:	01 c2                	add    %eax,%edx
c010092c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100937:	39 c2                	cmp    %eax,%edx
c0100939:	7d 46                	jge    c0100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c010093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010093e:	40                   	inc    %eax
c010093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100942:	eb 16                	jmp    c010095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100944:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100947:	8b 40 14             	mov    0x14(%eax),%eax
c010094a:	8d 50 01             	lea    0x1(%eax),%edx
c010094d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100956:	40                   	inc    %eax
c0100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100960:	39 c2                	cmp    %eax,%edx
c0100962:	7d 1d                	jge    c0100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	89 d0                	mov    %edx,%eax
c010096b:	01 c0                	add    %eax,%eax
c010096d:	01 d0                	add    %edx,%eax
c010096f:	c1 e0 02             	shl    $0x2,%eax
c0100972:	89 c2                	mov    %eax,%edx
c0100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100977:	01 d0                	add    %edx,%eax
c0100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010097d:	3c a0                	cmp    $0xa0,%al
c010097f:	74 c3                	je     c0100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100986:	c9                   	leave  
c0100987:	c3                   	ret    

c0100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100988:	f3 0f 1e fb          	endbr32 
c010098c:	55                   	push   %ebp
c010098d:	89 e5                	mov    %esp,%ebp
c010098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100992:	c7 04 24 c2 66 10 c0 	movl   $0xc01066c2,(%esp)
c0100999:	e8 27 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010099e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009a5:	c0 
c01009a6:	c7 04 24 db 66 10 c0 	movl   $0xc01066db,(%esp)
c01009ad:	e8 13 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009b2:	c7 44 24 04 b1 65 10 	movl   $0xc01065b1,0x4(%esp)
c01009b9:	c0 
c01009ba:	c7 04 24 f3 66 10 c0 	movl   $0xc01066f3,(%esp)
c01009c1:	e8 ff f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009c6:	c7 44 24 04 00 d0 11 	movl   $0xc011d000,0x4(%esp)
c01009cd:	c0 
c01009ce:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01009d5:	e8 eb f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009da:	c7 44 24 04 88 df 11 	movl   $0xc011df88,0x4(%esp)
c01009e1:	c0 
c01009e2:	c7 04 24 23 67 10 c0 	movl   $0xc0106723,(%esp)
c01009e9:	e8 d7 f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ee:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c01009f3:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a03:	85 c0                	test   %eax,%eax
c0100a05:	0f 48 c2             	cmovs  %edx,%eax
c0100a08:	c1 f8 0a             	sar    $0xa,%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 3c 67 10 c0 	movl   $0xc010673c,(%esp)
c0100a16:	e8 aa f8 ff ff       	call   c01002c5 <cprintf>
}
c0100a1b:	90                   	nop
c0100a1c:	c9                   	leave  
c0100a1d:	c3                   	ret    

c0100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a1e:	f3 0f 1e fb          	endbr32 
c0100a22:	55                   	push   %ebp
c0100a23:	89 e5                	mov    %esp,%ebp
c0100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a35:	89 04 24             	mov    %eax,(%esp)
c0100a38:	e8 21 fc ff ff       	call   c010065e <debuginfo_eip>
c0100a3d:	85 c0                	test   %eax,%eax
c0100a3f:	74 15                	je     c0100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a48:	c7 04 24 66 67 10 c0 	movl   $0xc0106766,(%esp)
c0100a4f:	e8 71 f8 ff ff       	call   c01002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a54:	eb 6c                	jmp    c0100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a5d:	eb 1b                	jmp    c0100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	01 d0                	add    %edx,%eax
c0100a67:	0f b6 10             	movzbl (%eax),%edx
c0100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a73:	01 c8                	add    %ecx,%eax
c0100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a77:	ff 45 f4             	incl   -0xc(%ebp)
c0100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a80:	7c dd                	jl     c0100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8b:	01 d0                	add    %edx,%eax
c0100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a93:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a96:	89 d1                	mov    %edx,%ecx
c0100a98:	29 c1                	sub    %eax,%ecx
c0100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 82 67 10 c0 	movl   $0xc0106782,(%esp)
c0100abd:	e8 03 f8 ff ff       	call   c01002c5 <cprintf>
}
c0100ac2:	90                   	nop
c0100ac3:	c9                   	leave  
c0100ac4:	c3                   	ret    

c0100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ac5:	f3 0f 1e fb          	endbr32 
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100acf:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ad8:	c9                   	leave  
c0100ad9:	c3                   	ret    

c0100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ada:	f3 0f 1e fb          	endbr32 
c0100ade:	55                   	push   %ebp
c0100adf:	89 e5                	mov    %esp,%ebp
c0100ae1:	53                   	push   %ebx
c0100ae2:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ae5:	89 e8                	mov    %ebp,%eax
c0100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
c0100aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
c0100af0:	e8 d0 ff ff ff       	call   c0100ac5 <read_eip>
c0100af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
c0100af8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aff:	eb 7e                	jmp    c0100b7f <print_stackframe+0xa5>
	{
		cprintf("ebp:0x%08x eip:0x%08x\n",ebp,eip);
c0100b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0f:	c7 04 24 94 67 10 c0 	movl   $0xc0106794,(%esp)
c0100b16:	e8 aa f7 ff ff       	call   c01002c5 <cprintf>
		uint32_t *args=(uint32_t *)ebp+2;
c0100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1e:	83 c0 08             	add    $0x8,%eax
c0100b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));//依次打印调用函数的参数1 2 3 4
c0100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b27:	83 c0 0c             	add    $0xc,%eax
c0100b2a:	8b 18                	mov    (%eax),%ebx
c0100b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b2f:	83 c0 08             	add    $0x8,%eax
c0100b32:	8b 08                	mov    (%eax),%ecx
c0100b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b37:	83 c0 04             	add    $0x4,%eax
c0100b3a:	8b 10                	mov    (%eax),%edx
c0100b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b3f:	8b 00                	mov    (%eax),%eax
c0100b41:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100b45:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100b49:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b51:	c7 04 24 ac 67 10 c0 	movl   $0xc01067ac,(%esp)
c0100b58:	e8 68 f7 ff ff       	call   c01002c5 <cprintf>
 
 
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。

		print_debuginfo(eip-1);
c0100b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b60:	48                   	dec    %eax
c0100b61:	89 04 24             	mov    %eax,(%esp)
c0100b64:	e8 b5 fe ff ff       	call   c0100a1e <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
c0100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6c:	83 c0 04             	add    $0x4,%eax
c0100b6f:	8b 00                	mov    (%eax),%eax
c0100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
c0100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b77:	8b 00                	mov    (%eax),%eax
c0100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
c0100b7c:	ff 45 ec             	incl   -0x14(%ebp)
c0100b7f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b83:	7f 0a                	jg     c0100b8f <print_stackframe+0xb5>
c0100b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b89:	0f 85 72 ff ff ff    	jne    c0100b01 <print_stackframe+0x27>
    }
}
c0100b8f:	90                   	nop
c0100b90:	83 c4 44             	add    $0x44,%esp
c0100b93:	5b                   	pop    %ebx
c0100b94:	5d                   	pop    %ebp
c0100b95:	c3                   	ret    

c0100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b96:	f3 0f 1e fb          	endbr32 
c0100b9a:	55                   	push   %ebp
c0100b9b:	89 e5                	mov    %esp,%ebp
c0100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba7:	eb 0c                	jmp    c0100bb5 <parse+0x1f>
            *buf ++ = '\0';
c0100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bac:	8d 50 01             	lea    0x1(%eax),%edx
c0100baf:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb8:	0f b6 00             	movzbl (%eax),%eax
c0100bbb:	84 c0                	test   %al,%al
c0100bbd:	74 1d                	je     c0100bdc <parse+0x46>
c0100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc2:	0f b6 00             	movzbl (%eax),%eax
c0100bc5:	0f be c0             	movsbl %al,%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 50 68 10 c0 	movl   $0xc0106850,(%esp)
c0100bd3:	e8 f3 4f 00 00       	call   c0105bcb <strchr>
c0100bd8:	85 c0                	test   %eax,%eax
c0100bda:	75 cd                	jne    c0100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdf:	0f b6 00             	movzbl (%eax),%eax
c0100be2:	84 c0                	test   %al,%al
c0100be4:	74 65                	je     c0100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bea:	75 14                	jne    c0100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bf3:	00 
c0100bf4:	c7 04 24 55 68 10 c0 	movl   $0xc0106855,(%esp)
c0100bfb:	e8 c5 f6 ff ff       	call   c01002c5 <cprintf>
        }
        argv[argc ++] = buf;
c0100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c03:	8d 50 01             	lea    0x1(%eax),%edx
c0100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c13:	01 c2                	add    %eax,%edx
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1a:	eb 03                	jmp    c0100c1f <parse+0x89>
            buf ++;
c0100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	0f b6 00             	movzbl (%eax),%eax
c0100c25:	84 c0                	test   %al,%al
c0100c27:	74 8c                	je     c0100bb5 <parse+0x1f>
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	0f b6 00             	movzbl (%eax),%eax
c0100c2f:	0f be c0             	movsbl %al,%eax
c0100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c36:	c7 04 24 50 68 10 c0 	movl   $0xc0106850,(%esp)
c0100c3d:	e8 89 4f 00 00       	call   c0105bcb <strchr>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	74 d6                	je     c0100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c46:	e9 6a ff ff ff       	jmp    c0100bb5 <parse+0x1f>
            break;
c0100c4b:	90                   	nop
        }
    }
    return argc;
c0100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c4f:	c9                   	leave  
c0100c50:	c3                   	ret    

c0100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c51:	f3 0f 1e fb          	endbr32 
c0100c55:	55                   	push   %ebp
c0100c56:	89 e5                	mov    %esp,%ebp
c0100c58:	53                   	push   %ebx
c0100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c63:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c66:	89 04 24             	mov    %eax,(%esp)
c0100c69:	e8 28 ff ff ff       	call   c0100b96 <parse>
c0100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c75:	75 0a                	jne    c0100c81 <runcmd+0x30>
        return 0;
c0100c77:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c7c:	e9 83 00 00 00       	jmp    c0100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c88:	eb 5a                	jmp    c0100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c90:	89 d0                	mov    %edx,%eax
c0100c92:	01 c0                	add    %eax,%eax
c0100c94:	01 d0                	add    %edx,%eax
c0100c96:	c1 e0 02             	shl    $0x2,%eax
c0100c99:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100c9e:	8b 00                	mov    (%eax),%eax
c0100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ca4:	89 04 24             	mov    %eax,(%esp)
c0100ca7:	e8 7b 4e 00 00       	call   c0105b27 <strcmp>
c0100cac:	85 c0                	test   %eax,%eax
c0100cae:	75 31                	jne    c0100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cb3:	89 d0                	mov    %edx,%eax
c0100cb5:	01 c0                	add    %eax,%eax
c0100cb7:	01 d0                	add    %edx,%eax
c0100cb9:	c1 e0 02             	shl    $0x2,%eax
c0100cbc:	05 08 a0 11 c0       	add    $0xc011a008,%eax
c0100cc1:	8b 10                	mov    (%eax),%edx
c0100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cc6:	83 c0 04             	add    $0x4,%eax
c0100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cda:	89 1c 24             	mov    %ebx,(%esp)
c0100cdd:	ff d2                	call   *%edx
c0100cdf:	eb 23                	jmp    c0100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce1:	ff 45 f4             	incl   -0xc(%ebp)
c0100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce7:	83 f8 02             	cmp    $0x2,%eax
c0100cea:	76 9e                	jbe    c0100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf3:	c7 04 24 73 68 10 c0 	movl   $0xc0106873,(%esp)
c0100cfa:	e8 c6 f5 ff ff       	call   c01002c5 <cprintf>
    return 0;
c0100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d04:	83 c4 64             	add    $0x64,%esp
c0100d07:	5b                   	pop    %ebx
c0100d08:	5d                   	pop    %ebp
c0100d09:	c3                   	ret    

c0100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d0a:	f3 0f 1e fb          	endbr32 
c0100d0e:	55                   	push   %ebp
c0100d0f:	89 e5                	mov    %esp,%ebp
c0100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d14:	c7 04 24 8c 68 10 c0 	movl   $0xc010688c,(%esp)
c0100d1b:	e8 a5 f5 ff ff       	call   c01002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d20:	c7 04 24 b4 68 10 c0 	movl   $0xc01068b4,(%esp)
c0100d27:	e8 99 f5 ff ff       	call   c01002c5 <cprintf>

    if (tf != NULL) {
c0100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d30:	74 0b                	je     c0100d3d <kmonitor+0x33>
        print_trapframe(tf);
c0100d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d35:	89 04 24             	mov    %eax,(%esp)
c0100d38:	e8 b6 0e 00 00       	call   c0101bf3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d3d:	c7 04 24 d9 68 10 c0 	movl   $0xc01068d9,(%esp)
c0100d44:	e8 2f f6 ff ff       	call   c0100378 <readline>
c0100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d50:	74 eb                	je     c0100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5c:	89 04 24             	mov    %eax,(%esp)
c0100d5f:	e8 ed fe ff ff       	call   c0100c51 <runcmd>
c0100d64:	85 c0                	test   %eax,%eax
c0100d66:	78 02                	js     c0100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d68:	eb d3                	jmp    c0100d3d <kmonitor+0x33>
                break;
c0100d6a:	90                   	nop
            }
        }
    }
}
c0100d6b:	90                   	nop
c0100d6c:	c9                   	leave  
c0100d6d:	c3                   	ret    

c0100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d6e:	f3 0f 1e fb          	endbr32 
c0100d72:	55                   	push   %ebp
c0100d73:	89 e5                	mov    %esp,%ebp
c0100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d7f:	eb 3d                	jmp    c0100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d84:	89 d0                	mov    %edx,%eax
c0100d86:	01 c0                	add    %eax,%eax
c0100d88:	01 d0                	add    %edx,%eax
c0100d8a:	c1 e0 02             	shl    $0x2,%eax
c0100d8d:	05 04 a0 11 c0       	add    $0xc011a004,%eax
c0100d92:	8b 08                	mov    (%eax),%ecx
c0100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d97:	89 d0                	mov    %edx,%eax
c0100d99:	01 c0                	add    %eax,%eax
c0100d9b:	01 d0                	add    %edx,%eax
c0100d9d:	c1 e0 02             	shl    $0x2,%eax
c0100da0:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100da5:	8b 00                	mov    (%eax),%eax
c0100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100daf:	c7 04 24 dd 68 10 c0 	movl   $0xc01068dd,(%esp)
c0100db6:	e8 0a f5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100dbb:	ff 45 f4             	incl   -0xc(%ebp)
c0100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dc1:	83 f8 02             	cmp    $0x2,%eax
c0100dc4:	76 bb                	jbe    c0100d81 <mon_help+0x13>
    }
    return 0;
c0100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dcb:	c9                   	leave  
c0100dcc:	c3                   	ret    

c0100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dcd:	f3 0f 1e fb          	endbr32 
c0100dd1:	55                   	push   %ebp
c0100dd2:	89 e5                	mov    %esp,%ebp
c0100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dd7:	e8 ac fb ff ff       	call   c0100988 <print_kerninfo>
    return 0;
c0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100de3:	f3 0f 1e fb          	endbr32 
c0100de7:	55                   	push   %ebp
c0100de8:	89 e5                	mov    %esp,%ebp
c0100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ded:	e8 e8 fc ff ff       	call   c0100ada <print_stackframe>
    return 0;
c0100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df7:	c9                   	leave  
c0100df8:	c3                   	ret    

c0100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100df9:	f3 0f 1e fb          	endbr32 
c0100dfd:	55                   	push   %ebp
c0100dfe:	89 e5                	mov    %esp,%ebp
c0100e00:	83 ec 28             	sub    $0x28,%esp
c0100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e15:	ee                   	out    %al,(%dx)
}
c0100e16:	90                   	nop
c0100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e29:	ee                   	out    %al,(%dx)
}
c0100e2a:	90                   	nop
c0100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e3d:	ee                   	out    %al,(%dx)
}
c0100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e3f:	c7 05 0c df 11 c0 00 	movl   $0x0,0xc011df0c
c0100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e49:	c7 04 24 e6 68 10 c0 	movl   $0xc01068e6,(%esp)
c0100e50:	e8 70 f4 ff ff       	call   c01002c5 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e5c:	e8 95 09 00 00       	call   c01017f6 <pic_enable>
}
c0100e61:	90                   	nop
c0100e62:	c9                   	leave  
c0100e63:	c3                   	ret    

c0100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e6a:	9c                   	pushf  
c0100e6b:	58                   	pop    %eax
c0100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e72:	25 00 02 00 00       	and    $0x200,%eax
c0100e77:	85 c0                	test   %eax,%eax
c0100e79:	74 0c                	je     c0100e87 <__intr_save+0x23>
        intr_disable();
c0100e7b:	e8 05 0b 00 00       	call   c0101985 <intr_disable>
        return 1;
c0100e80:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e85:	eb 05                	jmp    c0100e8c <__intr_save+0x28>
    }
    return 0;
c0100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e8e:	55                   	push   %ebp
c0100e8f:	89 e5                	mov    %esp,%ebp
c0100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e98:	74 05                	je     c0100e9f <__intr_restore+0x11>
        intr_enable();
c0100e9a:	e8 da 0a 00 00       	call   c0101979 <intr_enable>
    }
}
c0100e9f:	90                   	nop
c0100ea0:	c9                   	leave  
c0100ea1:	c3                   	ret    

c0100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100ea2:	f3 0f 1e fb          	endbr32 
c0100ea6:	55                   	push   %ebp
c0100ea7:	89 e5                	mov    %esp,%ebp
c0100ea9:	83 ec 10             	sub    $0x10,%esp
c0100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eb6:	89 c2                	mov    %eax,%edx
c0100eb8:	ec                   	in     (%dx),%al
c0100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ec6:	89 c2                	mov    %eax,%edx
c0100ec8:	ec                   	in     (%dx),%al
c0100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ed6:	89 c2                	mov    %eax,%edx
c0100ed8:	ec                   	in     (%dx),%al
c0100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ee6:	89 c2                	mov    %eax,%edx
c0100ee8:	ec                   	in     (%dx),%al
c0100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eec:	90                   	nop
c0100eed:	c9                   	leave  
c0100eee:	c3                   	ret    

c0100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eef:	f3 0f 1e fb          	endbr32 
c0100ef3:	55                   	push   %ebp
c0100ef4:	89 e5                	mov    %esp,%ebp
c0100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f03:	0f b7 00             	movzwl (%eax),%eax
c0100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f15:	0f b7 00             	movzwl (%eax),%eax
c0100f18:	0f b7 c0             	movzwl %ax,%eax
c0100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f20:	74 12                	je     c0100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f29:	66 c7 05 46 d4 11 c0 	movw   $0x3b4,0xc011d446
c0100f30:	b4 03 
c0100f32:	eb 13                	jmp    c0100f47 <cga_init+0x58>
    } else {
        *cp = was;
c0100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f3e:	66 c7 05 46 d4 11 c0 	movw   $0x3d4,0xc011d446
c0100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f47:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f5e:	ee                   	out    %al,(%dx)
}
c0100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f60:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f67:	40                   	inc    %eax
c0100f68:	0f b7 c0             	movzwl %ax,%eax
c0100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f73:	89 c2                	mov    %eax,%edx
c0100f75:	ec                   	in     (%dx),%al
c0100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f7d:	0f b6 c0             	movzbl %al,%eax
c0100f80:	c1 e0 08             	shl    $0x8,%eax
c0100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f86:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
}
c0100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f9f:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100fa6:	40                   	inc    %eax
c0100fa7:	0f b7 c0             	movzwl %ax,%eax
c0100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fb2:	89 c2                	mov    %eax,%edx
c0100fb4:	ec                   	in     (%dx),%al
c0100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fbc:	0f b6 c0             	movzbl %al,%eax
c0100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fc5:	a3 40 d4 11 c0       	mov    %eax,0xc011d440
    crt_pos = pos;
c0100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fcd:	0f b7 c0             	movzwl %ax,%eax
c0100fd0:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
}
c0100fd6:	90                   	nop
c0100fd7:	c9                   	leave  
c0100fd8:	c3                   	ret    

c0100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fd9:	f3 0f 1e fb          	endbr32 
c0100fdd:	55                   	push   %ebp
c0100fde:	89 e5                	mov    %esp,%ebp
c0100fe0:	83 ec 48             	sub    $0x48,%esp
c0100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100ff5:	ee                   	out    %al,(%dx)
}
c0100ff6:	90                   	nop
c0100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101009:	ee                   	out    %al,(%dx)
}
c010100a:	90                   	nop
c010100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010101d:	ee                   	out    %al,(%dx)
}
c010101e:	90                   	nop
c010101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101031:	ee                   	out    %al,(%dx)
}
c0101032:	90                   	nop
c0101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101045:	ee                   	out    %al,(%dx)
}
c0101046:	90                   	nop
c0101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101059:	ee                   	out    %al,(%dx)
}
c010105a:	90                   	nop
c010105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010106d:	ee                   	out    %al,(%dx)
}
c010106e:	90                   	nop
c010106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101079:	89 c2                	mov    %eax,%edx
c010107b:	ec                   	in     (%dx),%al
c010107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101083:	3c ff                	cmp    $0xff,%al
c0101085:	0f 95 c0             	setne  %al
c0101088:	0f b6 c0             	movzbl %al,%eax
c010108b:	a3 48 d4 11 c0       	mov    %eax,0xc011d448
c0101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010109a:	89 c2                	mov    %eax,%edx
c010109c:	ec                   	in     (%dx),%al
c010109d:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010aa:	89 c2                	mov    %eax,%edx
c01010ac:	ec                   	in     (%dx),%al
c01010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010b0:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01010b5:	85 c0                	test   %eax,%eax
c01010b7:	74 0c                	je     c01010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010c0:	e8 31 07 00 00       	call   c01017f6 <pic_enable>
    }
}
c01010c5:	90                   	nop
c01010c6:	c9                   	leave  
c01010c7:	c3                   	ret    

c01010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010c8:	f3 0f 1e fb          	endbr32 
c01010cc:	55                   	push   %ebp
c01010cd:	89 e5                	mov    %esp,%ebp
c01010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010d9:	eb 08                	jmp    c01010e3 <lpt_putc_sub+0x1b>
        delay();
c01010db:	e8 c2 fd ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010e0:	ff 45 fc             	incl   -0x4(%ebp)
c01010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010ed:	89 c2                	mov    %eax,%edx
c01010ef:	ec                   	in     (%dx),%al
c01010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010f7:	84 c0                	test   %al,%al
c01010f9:	78 09                	js     c0101104 <lpt_putc_sub+0x3c>
c01010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101102:	7e d7                	jle    c01010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c0101104:	8b 45 08             	mov    0x8(%ebp),%eax
c0101107:	0f b6 c0             	movzbl %al,%eax
c010110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010111b:	ee                   	out    %al,(%dx)
}
c010111c:	90                   	nop
c010111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010112f:	ee                   	out    %al,(%dx)
}
c0101130:	90                   	nop
c0101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101143:	ee                   	out    %al,(%dx)
}
c0101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101145:	90                   	nop
c0101146:	c9                   	leave  
c0101147:	c3                   	ret    

c0101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101148:	f3 0f 1e fb          	endbr32 
c010114c:	55                   	push   %ebp
c010114d:	89 e5                	mov    %esp,%ebp
c010114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101156:	74 0d                	je     c0101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101158:	8b 45 08             	mov    0x8(%ebp),%eax
c010115b:	89 04 24             	mov    %eax,(%esp)
c010115e:	e8 65 ff ff ff       	call   c01010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101163:	eb 24                	jmp    c0101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c0101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010116c:	e8 57 ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101178:	e8 4b ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101184:	e8 3f ff ff ff       	call   c01010c8 <lpt_putc_sub>
}
c0101189:	90                   	nop
c010118a:	c9                   	leave  
c010118b:	c3                   	ret    

c010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010118c:	f3 0f 1e fb          	endbr32 
c0101190:	55                   	push   %ebp
c0101191:	89 e5                	mov    %esp,%ebp
c0101193:	53                   	push   %ebx
c0101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101197:	8b 45 08             	mov    0x8(%ebp),%eax
c010119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010119f:	85 c0                	test   %eax,%eax
c01011a1:	75 07                	jne    c01011aa <cga_putc+0x1e>
        c |= 0x0700;
c01011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ad:	0f b6 c0             	movzbl %al,%eax
c01011b0:	83 f8 0d             	cmp    $0xd,%eax
c01011b3:	74 72                	je     c0101227 <cga_putc+0x9b>
c01011b5:	83 f8 0d             	cmp    $0xd,%eax
c01011b8:	0f 8f a3 00 00 00    	jg     c0101261 <cga_putc+0xd5>
c01011be:	83 f8 08             	cmp    $0x8,%eax
c01011c1:	74 0a                	je     c01011cd <cga_putc+0x41>
c01011c3:	83 f8 0a             	cmp    $0xa,%eax
c01011c6:	74 4c                	je     c0101214 <cga_putc+0x88>
c01011c8:	e9 94 00 00 00       	jmp    c0101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011cd:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011d4:	85 c0                	test   %eax,%eax
c01011d6:	0f 84 af 00 00 00    	je     c010128b <cga_putc+0xff>
            crt_pos --;
c01011dc:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011e3:	48                   	dec    %eax
c01011e4:	0f b7 c0             	movzwl %ax,%eax
c01011e7:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f0:	98                   	cwtl   
c01011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011f6:	98                   	cwtl   
c01011f7:	83 c8 20             	or     $0x20,%eax
c01011fa:	98                   	cwtl   
c01011fb:	8b 15 40 d4 11 c0    	mov    0xc011d440,%edx
c0101201:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c0101208:	01 c9                	add    %ecx,%ecx
c010120a:	01 ca                	add    %ecx,%edx
c010120c:	0f b7 c0             	movzwl %ax,%eax
c010120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101212:	eb 77                	jmp    c010128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c0101214:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010121b:	83 c0 50             	add    $0x50,%eax
c010121e:	0f b7 c0             	movzwl %ax,%eax
c0101221:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101227:	0f b7 1d 44 d4 11 c0 	movzwl 0xc011d444,%ebx
c010122e:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c0101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010123a:	89 c8                	mov    %ecx,%eax
c010123c:	f7 e2                	mul    %edx
c010123e:	c1 ea 06             	shr    $0x6,%edx
c0101241:	89 d0                	mov    %edx,%eax
c0101243:	c1 e0 02             	shl    $0x2,%eax
c0101246:	01 d0                	add    %edx,%eax
c0101248:	c1 e0 04             	shl    $0x4,%eax
c010124b:	29 c1                	sub    %eax,%ecx
c010124d:	89 c8                	mov    %ecx,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	29 c3                	sub    %eax,%ebx
c0101254:	89 d8                	mov    %ebx,%eax
c0101256:	0f b7 c0             	movzwl %ax,%eax
c0101259:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
        break;
c010125f:	eb 2b                	jmp    c010128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101261:	8b 0d 40 d4 11 c0    	mov    0xc011d440,%ecx
c0101267:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010126e:	8d 50 01             	lea    0x1(%eax),%edx
c0101271:	0f b7 d2             	movzwl %dx,%edx
c0101274:	66 89 15 44 d4 11 c0 	mov    %dx,0xc011d444
c010127b:	01 c0                	add    %eax,%eax
c010127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101280:	8b 45 08             	mov    0x8(%ebp),%eax
c0101283:	0f b7 c0             	movzwl %ax,%eax
c0101286:	66 89 02             	mov    %ax,(%edx)
        break;
c0101289:	eb 01                	jmp    c010128c <cga_putc+0x100>
        break;
c010128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010128c:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101298:	76 5d                	jbe    c01012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010129a:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c010129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012a5:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012b1:	00 
c01012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012b6:	89 04 24             	mov    %eax,(%esp)
c01012b9:	e8 12 4b 00 00       	call   c0105dd0 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012c5:	eb 14                	jmp    c01012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012c7:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cf:	01 d2                	add    %edx,%edx
c01012d1:	01 d0                	add    %edx,%eax
c01012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012d8:	ff 45 f4             	incl   -0xc(%ebp)
c01012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012e2:	7e e3                	jle    c01012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012e4:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01012eb:	83 e8 50             	sub    $0x50,%eax
c01012ee:	0f b7 c0             	movzwl %ax,%eax
c01012f1:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012f7:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c01012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010130e:	ee                   	out    %al,(%dx)
}
c010130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101310:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101317:	c1 e8 08             	shr    $0x8,%eax
c010131a:	0f b7 c0             	movzwl %ax,%eax
c010131d:	0f b6 c0             	movzbl %al,%eax
c0101320:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c0101327:	42                   	inc    %edx
c0101328:	0f b7 d2             	movzwl %dx,%edx
c010132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010133a:	ee                   	out    %al,(%dx)
}
c010133b:	90                   	nop
    outb(addr_6845, 15);
c010133c:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101353:	ee                   	out    %al,(%dx)
}
c0101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101355:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010135c:	0f b6 c0             	movzbl %al,%eax
c010135f:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c0101366:	42                   	inc    %edx
c0101367:	0f b7 d2             	movzwl %dx,%edx
c010136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101379:	ee                   	out    %al,(%dx)
}
c010137a:	90                   	nop
}
c010137b:	90                   	nop
c010137c:	83 c4 34             	add    $0x34,%esp
c010137f:	5b                   	pop    %ebx
c0101380:	5d                   	pop    %ebp
c0101381:	c3                   	ret    

c0101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101382:	f3 0f 1e fb          	endbr32 
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101393:	eb 08                	jmp    c010139d <serial_putc_sub+0x1b>
        delay();
c0101395:	e8 08 fb ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010139a:	ff 45 fc             	incl   -0x4(%ebp)
c010139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a7:	89 c2                	mov    %eax,%edx
c01013a9:	ec                   	in     (%dx),%al
c01013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013b1:	0f b6 c0             	movzbl %al,%eax
c01013b4:	83 e0 20             	and    $0x20,%eax
c01013b7:	85 c0                	test   %eax,%eax
c01013b9:	75 09                	jne    c01013c4 <serial_putc_sub+0x42>
c01013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013c2:	7e d1                	jle    c0101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c7:	0f b6 c0             	movzbl %al,%eax
c01013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013db:	ee                   	out    %al,(%dx)
}
c01013dc:	90                   	nop
}
c01013dd:	90                   	nop
c01013de:	c9                   	leave  
c01013df:	c3                   	ret    

c01013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013e0:	f3 0f 1e fb          	endbr32 
c01013e4:	55                   	push   %ebp
c01013e5:	89 e5                	mov    %esp,%ebp
c01013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013ee:	74 0d                	je     c01013fd <serial_putc+0x1d>
        serial_putc_sub(c);
c01013f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f3:	89 04 24             	mov    %eax,(%esp)
c01013f6:	e8 87 ff ff ff       	call   c0101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013fb:	eb 24                	jmp    c0101421 <serial_putc+0x41>
        serial_putc_sub('\b');
c01013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101404:	e8 79 ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub(' ');
c0101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101410:	e8 6d ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub('\b');
c0101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010141c:	e8 61 ff ff ff       	call   c0101382 <serial_putc_sub>
}
c0101421:	90                   	nop
c0101422:	c9                   	leave  
c0101423:	c3                   	ret    

c0101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101424:	f3 0f 1e fb          	endbr32 
c0101428:	55                   	push   %ebp
c0101429:	89 e5                	mov    %esp,%ebp
c010142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010142e:	eb 33                	jmp    c0101463 <cons_intr+0x3f>
        if (c != 0) {
c0101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101434:	74 2d                	je     c0101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c0101436:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c010143b:	8d 50 01             	lea    0x1(%eax),%edx
c010143e:	89 15 64 d6 11 c0    	mov    %edx,0xc011d664
c0101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101447:	88 90 60 d4 11 c0    	mov    %dl,-0x3fee2ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010144d:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101452:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101457:	75 0a                	jne    c0101463 <cons_intr+0x3f>
                cons.wpos = 0;
c0101459:	c7 05 64 d6 11 c0 00 	movl   $0x0,0xc011d664
c0101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101463:	8b 45 08             	mov    0x8(%ebp),%eax
c0101466:	ff d0                	call   *%eax
c0101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010146f:	75 bf                	jne    c0101430 <cons_intr+0xc>
            }
        }
    }
}
c0101471:	90                   	nop
c0101472:	90                   	nop
c0101473:	c9                   	leave  
c0101474:	c3                   	ret    

c0101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101475:	f3 0f 1e fb          	endbr32 
c0101479:	55                   	push   %ebp
c010147a:	89 e5                	mov    %esp,%ebp
c010147c:	83 ec 10             	sub    $0x10,%esp
c010147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101489:	89 c2                	mov    %eax,%edx
c010148b:	ec                   	in     (%dx),%al
c010148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101493:	0f b6 c0             	movzbl %al,%eax
c0101496:	83 e0 01             	and    $0x1,%eax
c0101499:	85 c0                	test   %eax,%eax
c010149b:	75 07                	jne    c01014a4 <serial_proc_data+0x2f>
        return -1;
c010149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014a2:	eb 2a                	jmp    c01014ce <serial_proc_data+0x59>
c01014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014ae:	89 c2                	mov    %eax,%edx
c01014b0:	ec                   	in     (%dx),%al
c01014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014b8:	0f b6 c0             	movzbl %al,%eax
c01014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014c2:	75 07                	jne    c01014cb <serial_proc_data+0x56>
        c = '\b';
c01014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014ce:	c9                   	leave  
c01014cf:	c3                   	ret    

c01014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014d0:	f3 0f 1e fb          	endbr32 
c01014d4:	55                   	push   %ebp
c01014d5:	89 e5                	mov    %esp,%ebp
c01014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014da:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01014df:	85 c0                	test   %eax,%eax
c01014e1:	74 0c                	je     c01014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014e3:	c7 04 24 75 14 10 c0 	movl   $0xc0101475,(%esp)
c01014ea:	e8 35 ff ff ff       	call   c0101424 <cons_intr>
    }
}
c01014ef:	90                   	nop
c01014f0:	c9                   	leave  
c01014f1:	c3                   	ret    

c01014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014f2:	f3 0f 1e fb          	endbr32 
c01014f6:	55                   	push   %ebp
c01014f7:	89 e5                	mov    %esp,%ebp
c01014f9:	83 ec 38             	sub    $0x38,%esp
c01014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101505:	89 c2                	mov    %eax,%edx
c0101507:	ec                   	in     (%dx),%al
c0101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010150f:	0f b6 c0             	movzbl %al,%eax
c0101512:	83 e0 01             	and    $0x1,%eax
c0101515:	85 c0                	test   %eax,%eax
c0101517:	75 0a                	jne    c0101523 <kbd_proc_data+0x31>
        return -1;
c0101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010151e:	e9 56 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
c0101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010152c:	89 c2                	mov    %eax,%edx
c010152e:	ec                   	in     (%dx),%al
c010152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010153d:	75 17                	jne    c0101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c010153f:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101544:	83 c8 40             	or     $0x40,%eax
c0101547:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c010154c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101551:	e9 23 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155a:	84 c0                	test   %al,%al
c010155c:	79 45                	jns    c01015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010155e:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101563:	83 e0 40             	and    $0x40,%eax
c0101566:	85 c0                	test   %eax,%eax
c0101568:	75 08                	jne    c0101572 <kbd_proc_data+0x80>
c010156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156e:	24 7f                	and    $0x7f,%al
c0101570:	eb 04                	jmp    c0101576 <kbd_proc_data+0x84>
c0101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157d:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c0101584:	0c 40                	or     $0x40,%al
c0101586:	0f b6 c0             	movzbl %al,%eax
c0101589:	f7 d0                	not    %eax
c010158b:	89 c2                	mov    %eax,%edx
c010158d:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101592:	21 d0                	and    %edx,%eax
c0101594:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c0101599:	b8 00 00 00 00       	mov    $0x0,%eax
c010159e:	e9 d6 00 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015a3:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015a8:	83 e0 40             	and    $0x40,%eax
c01015ab:	85 c0                	test   %eax,%eax
c01015ad:	74 11                	je     c01015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015b3:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015b8:	83 e0 bf             	and    $0xffffffbf,%eax
c01015bb:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    }

    shift |= shiftcode[data];
c01015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c4:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c01015cb:	0f b6 d0             	movzbl %al,%edx
c01015ce:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015d3:	09 d0                	or     %edx,%eax
c01015d5:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    shift ^= togglecode[data];
c01015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015de:	0f b6 80 40 a1 11 c0 	movzbl -0x3fee5ec0(%eax),%eax
c01015e5:	0f b6 d0             	movzbl %al,%edx
c01015e8:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015ed:	31 d0                	xor    %edx,%eax
c01015ef:	a3 68 d6 11 c0       	mov    %eax,0xc011d668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015f4:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015f9:	83 e0 03             	and    $0x3,%eax
c01015fc:	8b 14 85 40 a5 11 c0 	mov    -0x3fee5ac0(,%eax,4),%edx
c0101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101607:	01 d0                	add    %edx,%eax
c0101609:	0f b6 00             	movzbl (%eax),%eax
c010160c:	0f b6 c0             	movzbl %al,%eax
c010160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101612:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101617:	83 e0 08             	and    $0x8,%eax
c010161a:	85 c0                	test   %eax,%eax
c010161c:	74 22                	je     c0101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101622:	7e 0c                	jle    c0101630 <kbd_proc_data+0x13e>
c0101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101628:	7f 06                	jg     c0101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010162e:	eb 10                	jmp    c0101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101634:	7e 0a                	jle    c0101640 <kbd_proc_data+0x14e>
c0101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010163a:	7f 04                	jg     c0101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101640:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101645:	f7 d0                	not    %eax
c0101647:	83 e0 06             	and    $0x6,%eax
c010164a:	85 c0                	test   %eax,%eax
c010164c:	75 28                	jne    c0101676 <kbd_proc_data+0x184>
c010164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101655:	75 1f                	jne    c0101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101657:	c7 04 24 01 69 10 c0 	movl   $0xc0106901,(%esp)
c010165e:	e8 62 ec ff ff       	call   c01002c5 <cprintf>
c0101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101674:	ee                   	out    %al,(%dx)
}
c0101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101679:	c9                   	leave  
c010167a:	c3                   	ret    

c010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010167b:	f3 0f 1e fb          	endbr32 
c010167f:	55                   	push   %ebp
c0101680:	89 e5                	mov    %esp,%ebp
c0101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101685:	c7 04 24 f2 14 10 c0 	movl   $0xc01014f2,(%esp)
c010168c:	e8 93 fd ff ff       	call   c0101424 <cons_intr>
}
c0101691:	90                   	nop
c0101692:	c9                   	leave  
c0101693:	c3                   	ret    

c0101694 <kbd_init>:

static void
kbd_init(void) {
c0101694:	f3 0f 1e fb          	endbr32 
c0101698:	55                   	push   %ebp
c0101699:	89 e5                	mov    %esp,%ebp
c010169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010169e:	e8 d8 ff ff ff       	call   c010167b <kbd_intr>
    pic_enable(IRQ_KBD);
c01016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016aa:	e8 47 01 00 00       	call   c01017f6 <pic_enable>
}
c01016af:	90                   	nop
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016b2:	f3 0f 1e fb          	endbr32 
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016bc:	e8 2e f8 ff ff       	call   c0100eef <cga_init>
    serial_init();
c01016c1:	e8 13 f9 ff ff       	call   c0100fd9 <serial_init>
    kbd_init();
c01016c6:	e8 c9 ff ff ff       	call   c0101694 <kbd_init>
    if (!serial_exists) {
c01016cb:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01016d0:	85 c0                	test   %eax,%eax
c01016d2:	75 0c                	jne    c01016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016d4:	c7 04 24 0d 69 10 c0 	movl   $0xc010690d,(%esp)
c01016db:	e8 e5 eb ff ff       	call   c01002c5 <cprintf>
    }
}
c01016e0:	90                   	nop
c01016e1:	c9                   	leave  
c01016e2:	c3                   	ret    

c01016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016e3:	f3 0f 1e fb          	endbr32 
c01016e7:	55                   	push   %ebp
c01016e8:	89 e5                	mov    %esp,%ebp
c01016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016ed:	e8 72 f7 ff ff       	call   c0100e64 <__intr_save>
c01016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f8:	89 04 24             	mov    %eax,(%esp)
c01016fb:	e8 48 fa ff ff       	call   c0101148 <lpt_putc>
        cga_putc(c);
c0101700:	8b 45 08             	mov    0x8(%ebp),%eax
c0101703:	89 04 24             	mov    %eax,(%esp)
c0101706:	e8 81 fa ff ff       	call   c010118c <cga_putc>
        serial_putc(c);
c010170b:	8b 45 08             	mov    0x8(%ebp),%eax
c010170e:	89 04 24             	mov    %eax,(%esp)
c0101711:	e8 ca fc ff ff       	call   c01013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101719:	89 04 24             	mov    %eax,(%esp)
c010171c:	e8 6d f7 ff ff       	call   c0100e8e <__intr_restore>
}
c0101721:	90                   	nop
c0101722:	c9                   	leave  
c0101723:	c3                   	ret    

c0101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101724:	f3 0f 1e fb          	endbr32 
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
c010172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101735:	e8 2a f7 ff ff       	call   c0100e64 <__intr_save>
c010173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010173d:	e8 8e fd ff ff       	call   c01014d0 <serial_intr>
        kbd_intr();
c0101742:	e8 34 ff ff ff       	call   c010167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101747:	8b 15 60 d6 11 c0    	mov    0xc011d660,%edx
c010174d:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101752:	39 c2                	cmp    %eax,%edx
c0101754:	74 31                	je     c0101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c0101756:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c010175b:	8d 50 01             	lea    0x1(%eax),%edx
c010175e:	89 15 60 d6 11 c0    	mov    %edx,0xc011d660
c0101764:	0f b6 80 60 d4 11 c0 	movzbl -0x3fee2ba0(%eax),%eax
c010176b:	0f b6 c0             	movzbl %al,%eax
c010176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101771:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c0101776:	3d 00 02 00 00       	cmp    $0x200,%eax
c010177b:	75 0a                	jne    c0101787 <cons_getc+0x63>
                cons.rpos = 0;
c010177d:	c7 05 60 d6 11 c0 00 	movl   $0x0,0xc011d660
c0101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010178a:	89 04 24             	mov    %eax,(%esp)
c010178d:	e8 fc f6 ff ff       	call   c0100e8e <__intr_restore>
    return c;
c0101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101795:	c9                   	leave  
c0101796:	c3                   	ret    

c0101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101797:	f3 0f 1e fb          	endbr32 
c010179b:	55                   	push   %ebp
c010179c:	89 e5                	mov    %esp,%ebp
c010179e:	83 ec 14             	sub    $0x14,%esp
c01017a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017ab:	66 a3 50 a5 11 c0    	mov    %ax,0xc011a550
    if (did_init) {
c01017b1:	a1 6c d6 11 c0       	mov    0xc011d66c,%eax
c01017b6:	85 c0                	test   %eax,%eax
c01017b8:	74 39                	je     c01017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017bd:	0f b6 c0             	movzbl %al,%eax
c01017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017d1:	ee                   	out    %al,(%dx)
}
c01017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d7:	c1 e8 08             	shr    $0x8,%eax
c01017da:	0f b7 c0             	movzwl %ax,%eax
c01017dd:	0f b6 c0             	movzbl %al,%eax
c01017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017f1:	ee                   	out    %al,(%dx)
}
c01017f2:	90                   	nop
    }
}
c01017f3:	90                   	nop
c01017f4:	c9                   	leave  
c01017f5:	c3                   	ret    

c01017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017f6:	f3 0f 1e fb          	endbr32 
c01017fa:	55                   	push   %ebp
c01017fb:	89 e5                	mov    %esp,%ebp
c01017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101800:	8b 45 08             	mov    0x8(%ebp),%eax
c0101803:	ba 01 00 00 00       	mov    $0x1,%edx
c0101808:	88 c1                	mov    %al,%cl
c010180a:	d3 e2                	shl    %cl,%edx
c010180c:	89 d0                	mov    %edx,%eax
c010180e:	98                   	cwtl   
c010180f:	f7 d0                	not    %eax
c0101811:	0f bf d0             	movswl %ax,%edx
c0101814:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010181b:	98                   	cwtl   
c010181c:	21 d0                	and    %edx,%eax
c010181e:	98                   	cwtl   
c010181f:	0f b7 c0             	movzwl %ax,%eax
c0101822:	89 04 24             	mov    %eax,(%esp)
c0101825:	e8 6d ff ff ff       	call   c0101797 <pic_setmask>
}
c010182a:	90                   	nop
c010182b:	c9                   	leave  
c010182c:	c3                   	ret    

c010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010182d:	f3 0f 1e fb          	endbr32 
c0101831:	55                   	push   %ebp
c0101832:	89 e5                	mov    %esp,%ebp
c0101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101837:	c7 05 6c d6 11 c0 01 	movl   $0x1,0xc011d66c
c010183e:	00 00 00 
c0101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
}
c0101854:	90                   	nop
c0101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101867:	ee                   	out    %al,(%dx)
}
c0101868:	90                   	nop
c0101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
}
c010187c:	90                   	nop
c010187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010188f:	ee                   	out    %al,(%dx)
}
c0101890:	90                   	nop
c0101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018a3:	ee                   	out    %al,(%dx)
}
c01018a4:	90                   	nop
c01018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018b7:	ee                   	out    %al,(%dx)
}
c01018b8:	90                   	nop
c01018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018cb:	ee                   	out    %al,(%dx)
}
c01018cc:	90                   	nop
c01018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018df:	ee                   	out    %al,(%dx)
}
c01018e0:	90                   	nop
c01018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018f3:	ee                   	out    %al,(%dx)
}
c01018f4:	90                   	nop
c01018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101907:	ee                   	out    %al,(%dx)
}
c0101908:	90                   	nop
c0101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010191b:	ee                   	out    %al,(%dx)
}
c010191c:	90                   	nop
c010191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010192f:	ee                   	out    %al,(%dx)
}
c0101930:	90                   	nop
c0101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101943:	ee                   	out    %al,(%dx)
}
c0101944:	90                   	nop
c0101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101957:	ee                   	out    %al,(%dx)
}
c0101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101959:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101965:	74 0f                	je     c0101976 <pic_init+0x149>
        pic_setmask(irq_mask);
c0101967:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010196e:	89 04 24             	mov    %eax,(%esp)
c0101971:	e8 21 fe ff ff       	call   c0101797 <pic_setmask>
    }
}
c0101976:	90                   	nop
c0101977:	c9                   	leave  
c0101978:	c3                   	ret    

c0101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101979:	f3 0f 1e fb          	endbr32 
c010197d:	55                   	push   %ebp
c010197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101980:	fb                   	sti    
}
c0101981:	90                   	nop
    sti();
}
c0101982:	90                   	nop
c0101983:	5d                   	pop    %ebp
c0101984:	c3                   	ret    

c0101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101985:	f3 0f 1e fb          	endbr32 
c0101989:	55                   	push   %ebp
c010198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010198c:	fa                   	cli    
}
c010198d:	90                   	nop
    cli();
}
c010198e:	90                   	nop
c010198f:	5d                   	pop    %ebp
c0101990:	c3                   	ret    

c0101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101991:	f3 0f 1e fb          	endbr32 
c0101995:	55                   	push   %ebp
c0101996:	89 e5                	mov    %esp,%ebp
c0101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01019a2:	00 
c01019a3:	c7 04 24 40 69 10 c0 	movl   $0xc0106940,(%esp)
c01019aa:	e8 16 e9 ff ff       	call   c01002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01019af:	90                   	nop
c01019b0:	c9                   	leave  
c01019b1:	c3                   	ret    

c01019b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019b2:	f3 0f 1e fb          	endbr32 
c01019b6:	55                   	push   %ebp
c01019b7:	89 e5                	mov    %esp,%ebp
c01019b9:	83 ec 10             	sub    $0x10,%esp
      */
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
c01019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019c3:	e9 c4 00 00 00       	jmp    c0101a8c <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c01019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cb:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c01019d2:	0f b7 d0             	movzwl %ax,%edx
c01019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d8:	66 89 14 c5 80 d6 11 	mov    %dx,-0x3fee2980(,%eax,8)
c01019df:	c0 
c01019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e3:	66 c7 04 c5 82 d6 11 	movw   $0x8,-0x3fee297e(,%eax,8)
c01019ea:	c0 08 00 
c01019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f0:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c01019f7:	c0 
c01019f8:	80 e2 e0             	and    $0xe0,%dl
c01019fb:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a05:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c0101a0c:	c0 
c0101a0d:	80 e2 1f             	and    $0x1f,%dl
c0101a10:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1a:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a21:	c0 
c0101a22:	80 e2 f0             	and    $0xf0,%dl
c0101a25:	80 ca 0e             	or     $0xe,%dl
c0101a28:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a39:	c0 
c0101a3a:	80 e2 ef             	and    $0xef,%dl
c0101a3d:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a47:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a4e:	c0 
c0101a4f:	80 e2 9f             	and    $0x9f,%dl
c0101a52:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5c:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a63:	c0 
c0101a64:	80 ca 80             	or     $0x80,%dl
c0101a67:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a71:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c0101a78:	c1 e8 10             	shr    $0x10,%eax
c0101a7b:	0f b7 d0             	movzwl %ax,%edx
c0101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a81:	66 89 14 c5 86 d6 11 	mov    %dx,-0x3fee297a(,%eax,8)
c0101a88:	c0 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
c0101a89:	ff 45 fc             	incl   -0x4(%ebp)
c0101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a94:	0f 86 2e ff ff ff    	jbe    c01019c8 <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
c0101a9a:	a1 e0 a7 11 c0       	mov    0xc011a7e0,%eax
c0101a9f:	0f b7 c0             	movzwl %ax,%eax
c0101aa2:	66 a3 80 da 11 c0    	mov    %ax,0xc011da80
c0101aa8:	66 c7 05 82 da 11 c0 	movw   $0x8,0xc011da82
c0101aaf:	08 00 
c0101ab1:	0f b6 05 84 da 11 c0 	movzbl 0xc011da84,%eax
c0101ab8:	24 e0                	and    $0xe0,%al
c0101aba:	a2 84 da 11 c0       	mov    %al,0xc011da84
c0101abf:	0f b6 05 84 da 11 c0 	movzbl 0xc011da84,%eax
c0101ac6:	24 1f                	and    $0x1f,%al
c0101ac8:	a2 84 da 11 c0       	mov    %al,0xc011da84
c0101acd:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101ad4:	0c 0f                	or     $0xf,%al
c0101ad6:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101adb:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101ae2:	24 ef                	and    $0xef,%al
c0101ae4:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101ae9:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101af0:	0c 60                	or     $0x60,%al
c0101af2:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101af7:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101afe:	0c 80                	or     $0x80,%al
c0101b00:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101b05:	a1 e0 a7 11 c0       	mov    0xc011a7e0,%eax
c0101b0a:	c1 e8 10             	shr    $0x10,%eax
c0101b0d:	0f b7 c0             	movzwl %ax,%eax
c0101b10:	66 a3 86 da 11 c0    	mov    %ax,0xc011da86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
c0101b16:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101b1b:	0f b7 c0             	movzwl %ax,%eax
c0101b1e:	66 a3 48 da 11 c0    	mov    %ax,0xc011da48
c0101b24:	66 c7 05 4a da 11 c0 	movw   $0x8,0xc011da4a
c0101b2b:	08 00 
c0101b2d:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101b34:	24 e0                	and    $0xe0,%al
c0101b36:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101b3b:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101b42:	24 1f                	and    $0x1f,%al
c0101b44:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101b49:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b50:	24 f0                	and    $0xf0,%al
c0101b52:	0c 0e                	or     $0xe,%al
c0101b54:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b59:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b60:	24 ef                	and    $0xef,%al
c0101b62:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b67:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b6e:	0c 60                	or     $0x60,%al
c0101b70:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b75:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b7c:	0c 80                	or     $0x80,%al
c0101b7e:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b83:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101b88:	c1 e8 10             	shr    $0x10,%eax
c0101b8b:	0f b7 c0             	movzwl %ax,%eax
c0101b8e:	66 a3 4e da 11 c0    	mov    %ax,0xc011da4e
c0101b94:	c7 45 f8 60 a5 11 c0 	movl   $0xc011a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b9e:	0f 01 18             	lidtl  (%eax)
}
c0101ba1:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
c0101ba2:	90                   	nop
c0101ba3:	c9                   	leave  
c0101ba4:	c3                   	ret    

c0101ba5 <trapname>:

static const char *
trapname(int trapno) {
c0101ba5:	f3 0f 1e fb          	endbr32 
c0101ba9:	55                   	push   %ebp
c0101baa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101baf:	83 f8 13             	cmp    $0x13,%eax
c0101bb2:	77 0c                	ja     c0101bc0 <trapname+0x1b>
        return excnames[trapno];
c0101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb7:	8b 04 85 c0 6c 10 c0 	mov    -0x3fef9340(,%eax,4),%eax
c0101bbe:	eb 18                	jmp    c0101bd8 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101bc0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101bc4:	7e 0d                	jle    c0101bd3 <trapname+0x2e>
c0101bc6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101bca:	7f 07                	jg     c0101bd3 <trapname+0x2e>
        return "Hardware Interrupt";
c0101bcc:	b8 4a 69 10 c0       	mov    $0xc010694a,%eax
c0101bd1:	eb 05                	jmp    c0101bd8 <trapname+0x33>
    }
    return "(unknown trap)";
c0101bd3:	b8 5d 69 10 c0       	mov    $0xc010695d,%eax
}
c0101bd8:	5d                   	pop    %ebp
c0101bd9:	c3                   	ret    

c0101bda <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bda:	f3 0f 1e fb          	endbr32 
c0101bde:	55                   	push   %ebp
c0101bdf:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101be8:	83 f8 08             	cmp    $0x8,%eax
c0101beb:	0f 94 c0             	sete   %al
c0101bee:	0f b6 c0             	movzbl %al,%eax
}
c0101bf1:	5d                   	pop    %ebp
c0101bf2:	c3                   	ret    

c0101bf3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101bf3:	f3 0f 1e fb          	endbr32 
c0101bf7:	55                   	push   %ebp
c0101bf8:	89 e5                	mov    %esp,%ebp
c0101bfa:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c04:	c7 04 24 9e 69 10 c0 	movl   $0xc010699e,(%esp)
c0101c0b:	e8 b5 e6 ff ff       	call   c01002c5 <cprintf>
    print_regs(&tf->tf_regs);
c0101c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c13:	89 04 24             	mov    %eax,(%esp)
c0101c16:	e8 8d 01 00 00       	call   c0101da8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 af 69 10 c0 	movl   $0xc01069af,(%esp)
c0101c2d:	e8 93 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3d:	c7 04 24 c2 69 10 c0 	movl   $0xc01069c2,(%esp)
c0101c44:	e8 7c e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c54:	c7 04 24 d5 69 10 c0 	movl   $0xc01069d5,(%esp)
c0101c5b:	e8 65 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6b:	c7 04 24 e8 69 10 c0 	movl   $0xc01069e8,(%esp)
c0101c72:	e8 4e e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c7d:	89 04 24             	mov    %eax,(%esp)
c0101c80:	e8 20 ff ff ff       	call   c0101ba5 <trapname>
c0101c85:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c88:	8b 52 30             	mov    0x30(%edx),%edx
c0101c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c93:	c7 04 24 fb 69 10 c0 	movl   $0xc01069fb,(%esp)
c0101c9a:	e8 26 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca2:	8b 40 34             	mov    0x34(%eax),%eax
c0101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca9:	c7 04 24 0d 6a 10 c0 	movl   $0xc0106a0d,(%esp)
c0101cb0:	e8 10 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb8:	8b 40 38             	mov    0x38(%eax),%eax
c0101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbf:	c7 04 24 1c 6a 10 c0 	movl   $0xc0106a1c,(%esp)
c0101cc6:	e8 fa e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd6:	c7 04 24 2b 6a 10 c0 	movl   $0xc0106a2b,(%esp)
c0101cdd:	e8 e3 e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce5:	8b 40 40             	mov    0x40(%eax),%eax
c0101ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cec:	c7 04 24 3e 6a 10 c0 	movl   $0xc0106a3e,(%esp)
c0101cf3:	e8 cd e5 ff ff       	call   c01002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101cff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101d06:	eb 3d                	jmp    c0101d45 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0b:	8b 50 40             	mov    0x40(%eax),%edx
c0101d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d11:	21 d0                	and    %edx,%eax
c0101d13:	85 c0                	test   %eax,%eax
c0101d15:	74 28                	je     c0101d3f <print_trapframe+0x14c>
c0101d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d1a:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101d21:	85 c0                	test   %eax,%eax
c0101d23:	74 1a                	je     c0101d3f <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d28:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d33:	c7 04 24 4d 6a 10 c0 	movl   $0xc0106a4d,(%esp)
c0101d3a:	e8 86 e5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d3f:	ff 45 f4             	incl   -0xc(%ebp)
c0101d42:	d1 65 f0             	shll   -0x10(%ebp)
c0101d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d48:	83 f8 17             	cmp    $0x17,%eax
c0101d4b:	76 bb                	jbe    c0101d08 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d50:	8b 40 40             	mov    0x40(%eax),%eax
c0101d53:	c1 e8 0c             	shr    $0xc,%eax
c0101d56:	83 e0 03             	and    $0x3,%eax
c0101d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5d:	c7 04 24 51 6a 10 c0 	movl   $0xc0106a51,(%esp)
c0101d64:	e8 5c e5 ff ff       	call   c01002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6c:	89 04 24             	mov    %eax,(%esp)
c0101d6f:	e8 66 fe ff ff       	call   c0101bda <trap_in_kernel>
c0101d74:	85 c0                	test   %eax,%eax
c0101d76:	75 2d                	jne    c0101da5 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7b:	8b 40 44             	mov    0x44(%eax),%eax
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 5a 6a 10 c0 	movl   $0xc0106a5a,(%esp)
c0101d89:	e8 37 e5 ff ff       	call   c01002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d99:	c7 04 24 69 6a 10 c0 	movl   $0xc0106a69,(%esp)
c0101da0:	e8 20 e5 ff ff       	call   c01002c5 <cprintf>
    }
}
c0101da5:	90                   	nop
c0101da6:	c9                   	leave  
c0101da7:	c3                   	ret    

c0101da8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101da8:	f3 0f 1e fb          	endbr32 
c0101dac:	55                   	push   %ebp
c0101dad:	89 e5                	mov    %esp,%ebp
c0101daf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db5:	8b 00                	mov    (%eax),%eax
c0101db7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dbb:	c7 04 24 7c 6a 10 c0 	movl   $0xc0106a7c,(%esp)
c0101dc2:	e8 fe e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dca:	8b 40 04             	mov    0x4(%eax),%eax
c0101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd1:	c7 04 24 8b 6a 10 c0 	movl   $0xc0106a8b,(%esp)
c0101dd8:	e8 e8 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	8b 40 08             	mov    0x8(%eax),%eax
c0101de3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de7:	c7 04 24 9a 6a 10 c0 	movl   $0xc0106a9a,(%esp)
c0101dee:	e8 d2 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df6:	8b 40 0c             	mov    0xc(%eax),%eax
c0101df9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dfd:	c7 04 24 a9 6a 10 c0 	movl   $0xc0106aa9,(%esp)
c0101e04:	e8 bc e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0c:	8b 40 10             	mov    0x10(%eax),%eax
c0101e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e13:	c7 04 24 b8 6a 10 c0 	movl   $0xc0106ab8,(%esp)
c0101e1a:	e8 a6 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e22:	8b 40 14             	mov    0x14(%eax),%eax
c0101e25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e29:	c7 04 24 c7 6a 10 c0 	movl   $0xc0106ac7,(%esp)
c0101e30:	e8 90 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e38:	8b 40 18             	mov    0x18(%eax),%eax
c0101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e3f:	c7 04 24 d6 6a 10 c0 	movl   $0xc0106ad6,(%esp)
c0101e46:	e8 7a e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e55:	c7 04 24 e5 6a 10 c0 	movl   $0xc0106ae5,(%esp)
c0101e5c:	e8 64 e4 ff ff       	call   c01002c5 <cprintf>
}
c0101e61:	90                   	nop
c0101e62:	c9                   	leave  
c0101e63:	c3                   	ret    

c0101e64 <trap_dispatch>:
}


/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e64:	f3 0f 1e fb          	endbr32 
c0101e68:	55                   	push   %ebp
c0101e69:	89 e5                	mov    %esp,%ebp
c0101e6b:	57                   	push   %edi
c0101e6c:	56                   	push   %esi
c0101e6d:	53                   	push   %ebx
c0101e6e:	83 ec 3c             	sub    $0x3c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e74:	8b 40 30             	mov    0x30(%eax),%eax
c0101e77:	83 f8 79             	cmp    $0x79,%eax
c0101e7a:	0f 84 ac 03 00 00    	je     c010222c <trap_dispatch+0x3c8>
c0101e80:	83 f8 79             	cmp    $0x79,%eax
c0101e83:	0f 87 31 04 00 00    	ja     c01022ba <trap_dispatch+0x456>
c0101e89:	83 f8 78             	cmp    $0x78,%eax
c0101e8c:	0f 84 af 02 00 00    	je     c0102141 <trap_dispatch+0x2dd>
c0101e92:	83 f8 78             	cmp    $0x78,%eax
c0101e95:	0f 87 1f 04 00 00    	ja     c01022ba <trap_dispatch+0x456>
c0101e9b:	83 f8 2f             	cmp    $0x2f,%eax
c0101e9e:	0f 87 16 04 00 00    	ja     c01022ba <trap_dispatch+0x456>
c0101ea4:	83 f8 2e             	cmp    $0x2e,%eax
c0101ea7:	0f 83 42 04 00 00    	jae    c01022ef <trap_dispatch+0x48b>
c0101ead:	83 f8 24             	cmp    $0x24,%eax
c0101eb0:	74 5e                	je     c0101f10 <trap_dispatch+0xac>
c0101eb2:	83 f8 24             	cmp    $0x24,%eax
c0101eb5:	0f 87 ff 03 00 00    	ja     c01022ba <trap_dispatch+0x456>
c0101ebb:	83 f8 20             	cmp    $0x20,%eax
c0101ebe:	74 0a                	je     c0101eca <trap_dispatch+0x66>
c0101ec0:	83 f8 21             	cmp    $0x21,%eax
c0101ec3:	74 74                	je     c0101f39 <trap_dispatch+0xd5>
c0101ec5:	e9 f0 03 00 00       	jmp    c01022ba <trap_dispatch+0x456>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101eca:	a1 0c df 11 c0       	mov    0xc011df0c,%eax
c0101ecf:	40                   	inc    %eax
c0101ed0:	a3 0c df 11 c0       	mov    %eax,0xc011df0c
        if(ticks%100==0){
c0101ed5:	8b 0d 0c df 11 c0    	mov    0xc011df0c,%ecx
c0101edb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101ee0:	89 c8                	mov    %ecx,%eax
c0101ee2:	f7 e2                	mul    %edx
c0101ee4:	c1 ea 05             	shr    $0x5,%edx
c0101ee7:	89 d0                	mov    %edx,%eax
c0101ee9:	c1 e0 02             	shl    $0x2,%eax
c0101eec:	01 d0                	add    %edx,%eax
c0101eee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101ef5:	01 d0                	add    %edx,%eax
c0101ef7:	c1 e0 02             	shl    $0x2,%eax
c0101efa:	29 c1                	sub    %eax,%ecx
c0101efc:	89 ca                	mov    %ecx,%edx
c0101efe:	85 d2                	test   %edx,%edx
c0101f00:	0f 85 ec 03 00 00    	jne    c01022f2 <trap_dispatch+0x48e>
            print_ticks();
c0101f06:	e8 86 fa ff ff       	call   c0101991 <print_ticks>
        }
        break;
c0101f0b:	e9 e2 03 00 00       	jmp    c01022f2 <trap_dispatch+0x48e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101f10:	e8 0f f8 ff ff       	call   c0101724 <cons_getc>
c0101f15:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101f18:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101f1c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101f20:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f28:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0101f2f:	e8 91 e3 ff ff       	call   c01002c5 <cprintf>
        break;
c0101f34:	e9 bd 03 00 00       	jmp    c01022f6 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101f39:	e8 e6 f7 ff ff       	call   c0101724 <cons_getc>
c0101f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101f41:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101f45:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101f49:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f51:	c7 04 24 06 6b 10 c0 	movl   $0xc0106b06,(%esp)
c0101f58:	e8 68 e3 ff ff       	call   c01002c5 <cprintf>
        if (c == '0'&&!trap_in_kernel(tf)) {
c0101f5d:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
c0101f61:	0f 85 bb 00 00 00    	jne    c0102022 <trap_dispatch+0x1be>
c0101f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f6a:	89 04 24             	mov    %eax,(%esp)
c0101f6d:	e8 68 fc ff ff       	call   c0101bda <trap_in_kernel>
c0101f72:	85 c0                	test   %eax,%eax
c0101f74:	0f 85 a8 00 00 00    	jne    c0102022 <trap_dispatch+0x1be>
c0101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
c0101f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f87:	83 f8 08             	cmp    $0x8,%eax
c0101f8a:	74 79                	je     c0102005 <trap_dispatch+0x1a1>
        tf->tf_cs = KERNEL_CS;
c0101f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f8f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
c0101f95:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f98:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fa1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fa8:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101faf:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fb6:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0101fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fbd:	8b 40 40             	mov    0x40(%eax),%eax
c0101fc0:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101fc5:	89 c2                	mov    %eax,%edx
c0101fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fca:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fd0:	8b 40 44             	mov    0x44(%eax),%eax
c0101fd3:	83 e8 44             	sub    $0x44,%eax
c0101fd6:	a3 6c df 11 c0       	mov    %eax,0xc011df6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101fdb:	a1 6c df 11 c0       	mov    0xc011df6c,%eax
c0101fe0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101fe7:	00 
c0101fe8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101feb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101fef:	89 04 24             	mov    %eax,(%esp)
c0101ff2:	e8 d9 3d 00 00       	call   c0105dd0 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101ff7:	8b 15 6c df 11 c0    	mov    0xc011df6c,%edx
c0101ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102000:	83 e8 04             	sub    $0x4,%eax
c0102003:	89 10                	mov    %edx,(%eax)
}
c0102005:	90                   	nop
        //切换为内核态
        switch_to_kernel(tf);
        cprintf("user to kernel\n");
c0102006:	c7 04 24 15 6b 10 c0 	movl   $0xc0106b15,(%esp)
c010200d:	e8 b3 e2 ff ff       	call   c01002c5 <cprintf>
        print_trapframe(tf);
c0102012:	8b 45 08             	mov    0x8(%ebp),%eax
c0102015:	89 04 24             	mov    %eax,(%esp)
c0102018:	e8 d6 fb ff ff       	call   c0101bf3 <print_trapframe>
        //切换为用户态
        switch_to_user(tf);
        cprintf("kernel to user\n");
        print_trapframe(tf);
        }
        break;
c010201d:	e9 d3 02 00 00       	jmp    c01022f5 <trap_dispatch+0x491>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
c0102022:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
c0102026:	0f 85 c9 02 00 00    	jne    c01022f5 <trap_dispatch+0x491>
c010202c:	8b 45 08             	mov    0x8(%ebp),%eax
c010202f:	89 04 24             	mov    %eax,(%esp)
c0102032:	e8 a3 fb ff ff       	call   c0101bda <trap_in_kernel>
c0102037:	85 c0                	test   %eax,%eax
c0102039:	0f 84 b6 02 00 00    	je     c01022f5 <trap_dispatch+0x491>
c010203f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102042:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (tf->tf_cs != USER_CS) {
c0102045:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102048:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010204c:	83 f8 1b             	cmp    $0x1b,%eax
c010204f:	0f 84 cf 00 00 00    	je     c0102124 <trap_dispatch+0x2c0>
        switchk2u = *tf;
c0102055:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102058:	b8 20 df 11 c0       	mov    $0xc011df20,%eax
c010205d:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0102062:	89 c1                	mov    %eax,%ecx
c0102064:	83 e1 01             	and    $0x1,%ecx
c0102067:	85 c9                	test   %ecx,%ecx
c0102069:	74 0c                	je     c0102077 <trap_dispatch+0x213>
c010206b:	0f b6 0a             	movzbl (%edx),%ecx
c010206e:	88 08                	mov    %cl,(%eax)
c0102070:	8d 40 01             	lea    0x1(%eax),%eax
c0102073:	8d 52 01             	lea    0x1(%edx),%edx
c0102076:	4b                   	dec    %ebx
c0102077:	89 c1                	mov    %eax,%ecx
c0102079:	83 e1 02             	and    $0x2,%ecx
c010207c:	85 c9                	test   %ecx,%ecx
c010207e:	74 0f                	je     c010208f <trap_dispatch+0x22b>
c0102080:	0f b7 0a             	movzwl (%edx),%ecx
c0102083:	66 89 08             	mov    %cx,(%eax)
c0102086:	8d 40 02             	lea    0x2(%eax),%eax
c0102089:	8d 52 02             	lea    0x2(%edx),%edx
c010208c:	83 eb 02             	sub    $0x2,%ebx
c010208f:	89 df                	mov    %ebx,%edi
c0102091:	83 e7 fc             	and    $0xfffffffc,%edi
c0102094:	b9 00 00 00 00       	mov    $0x0,%ecx
c0102099:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c010209c:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c010209f:	83 c1 04             	add    $0x4,%ecx
c01020a2:	39 f9                	cmp    %edi,%ecx
c01020a4:	72 f3                	jb     c0102099 <trap_dispatch+0x235>
c01020a6:	01 c8                	add    %ecx,%eax
c01020a8:	01 ca                	add    %ecx,%edx
c01020aa:	b9 00 00 00 00       	mov    $0x0,%ecx
c01020af:	89 de                	mov    %ebx,%esi
c01020b1:	83 e6 02             	and    $0x2,%esi
c01020b4:	85 f6                	test   %esi,%esi
c01020b6:	74 0b                	je     c01020c3 <trap_dispatch+0x25f>
c01020b8:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c01020bc:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c01020c0:	83 c1 02             	add    $0x2,%ecx
c01020c3:	83 e3 01             	and    $0x1,%ebx
c01020c6:	85 db                	test   %ebx,%ebx
c01020c8:	74 07                	je     c01020d1 <trap_dispatch+0x26d>
c01020ca:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c01020ce:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
c01020d1:	66 c7 05 5c df 11 c0 	movw   $0x1b,0xc011df5c
c01020d8:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c01020da:	66 c7 05 68 df 11 c0 	movw   $0x23,0xc011df68
c01020e1:	23 00 
c01020e3:	0f b7 05 68 df 11 c0 	movzwl 0xc011df68,%eax
c01020ea:	66 a3 48 df 11 c0    	mov    %ax,0xc011df48
c01020f0:	0f b7 05 48 df 11 c0 	movzwl 0xc011df48,%eax
c01020f7:	66 a3 4c df 11 c0    	mov    %ax,0xc011df4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
c01020fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102100:	83 c0 4c             	add    $0x4c,%eax
c0102103:	a3 64 df 11 c0       	mov    %eax,0xc011df64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102108:	a1 60 df 11 c0       	mov    0xc011df60,%eax
c010210d:	0d 00 30 00 00       	or     $0x3000,%eax
c0102112:	a3 60 df 11 c0       	mov    %eax,0xc011df60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0102117:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010211a:	83 e8 04             	sub    $0x4,%eax
c010211d:	ba 20 df 11 c0       	mov    $0xc011df20,%edx
c0102122:	89 10                	mov    %edx,(%eax)
}
c0102124:	90                   	nop
        cprintf("kernel to user\n");
c0102125:	c7 04 24 25 6b 10 c0 	movl   $0xc0106b25,(%esp)
c010212c:	e8 94 e1 ff ff       	call   c01002c5 <cprintf>
        print_trapframe(tf);
c0102131:	8b 45 08             	mov    0x8(%ebp),%eax
c0102134:	89 04 24             	mov    %eax,(%esp)
c0102137:	e8 b7 fa ff ff       	call   c0101bf3 <print_trapframe>
        break;
c010213c:	e9 b4 01 00 00       	jmp    c01022f5 <trap_dispatch+0x491>
c0102141:	8b 45 08             	mov    0x8(%ebp),%eax
c0102144:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (tf->tf_cs != USER_CS) {
c0102147:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010214a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010214e:	83 f8 1b             	cmp    $0x1b,%eax
c0102151:	0f 84 cf 00 00 00    	je     c0102226 <trap_dispatch+0x3c2>
        switchk2u = *tf;
c0102157:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010215a:	b8 20 df 11 c0       	mov    $0xc011df20,%eax
c010215f:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0102164:	89 c1                	mov    %eax,%ecx
c0102166:	83 e1 01             	and    $0x1,%ecx
c0102169:	85 c9                	test   %ecx,%ecx
c010216b:	74 0c                	je     c0102179 <trap_dispatch+0x315>
c010216d:	0f b6 0a             	movzbl (%edx),%ecx
c0102170:	88 08                	mov    %cl,(%eax)
c0102172:	8d 40 01             	lea    0x1(%eax),%eax
c0102175:	8d 52 01             	lea    0x1(%edx),%edx
c0102178:	4b                   	dec    %ebx
c0102179:	89 c1                	mov    %eax,%ecx
c010217b:	83 e1 02             	and    $0x2,%ecx
c010217e:	85 c9                	test   %ecx,%ecx
c0102180:	74 0f                	je     c0102191 <trap_dispatch+0x32d>
c0102182:	0f b7 0a             	movzwl (%edx),%ecx
c0102185:	66 89 08             	mov    %cx,(%eax)
c0102188:	8d 40 02             	lea    0x2(%eax),%eax
c010218b:	8d 52 02             	lea    0x2(%edx),%edx
c010218e:	83 eb 02             	sub    $0x2,%ebx
c0102191:	89 df                	mov    %ebx,%edi
c0102193:	83 e7 fc             	and    $0xfffffffc,%edi
c0102196:	b9 00 00 00 00       	mov    $0x0,%ecx
c010219b:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c010219e:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c01021a1:	83 c1 04             	add    $0x4,%ecx
c01021a4:	39 f9                	cmp    %edi,%ecx
c01021a6:	72 f3                	jb     c010219b <trap_dispatch+0x337>
c01021a8:	01 c8                	add    %ecx,%eax
c01021aa:	01 ca                	add    %ecx,%edx
c01021ac:	b9 00 00 00 00       	mov    $0x0,%ecx
c01021b1:	89 de                	mov    %ebx,%esi
c01021b3:	83 e6 02             	and    $0x2,%esi
c01021b6:	85 f6                	test   %esi,%esi
c01021b8:	74 0b                	je     c01021c5 <trap_dispatch+0x361>
c01021ba:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c01021be:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c01021c2:	83 c1 02             	add    $0x2,%ecx
c01021c5:	83 e3 01             	and    $0x1,%ebx
c01021c8:	85 db                	test   %ebx,%ebx
c01021ca:	74 07                	je     c01021d3 <trap_dispatch+0x36f>
c01021cc:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c01021d0:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
c01021d3:	66 c7 05 5c df 11 c0 	movw   $0x1b,0xc011df5c
c01021da:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c01021dc:	66 c7 05 68 df 11 c0 	movw   $0x23,0xc011df68
c01021e3:	23 00 
c01021e5:	0f b7 05 68 df 11 c0 	movzwl 0xc011df68,%eax
c01021ec:	66 a3 48 df 11 c0    	mov    %ax,0xc011df48
c01021f2:	0f b7 05 48 df 11 c0 	movzwl 0xc011df48,%eax
c01021f9:	66 a3 4c df 11 c0    	mov    %ax,0xc011df4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
c01021ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102202:	83 c0 4c             	add    $0x4c,%eax
c0102205:	a3 64 df 11 c0       	mov    %eax,0xc011df64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
c010220a:	a1 60 df 11 c0       	mov    0xc011df60,%eax
c010220f:	0d 00 30 00 00       	or     $0x3000,%eax
c0102214:	a3 60 df 11 c0       	mov    %eax,0xc011df60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0102219:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010221c:	83 e8 04             	sub    $0x4,%eax
c010221f:	ba 20 df 11 c0       	mov    $0xc011df20,%edx
c0102224:	89 10                	mov    %edx,(%eax)
}
c0102226:	90                   	nop
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switch_to_user(tf);
        break;
c0102227:	e9 ca 00 00 00       	jmp    c01022f6 <trap_dispatch+0x492>
c010222c:	8b 45 08             	mov    0x8(%ebp),%eax
c010222f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
c0102232:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102235:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102239:	83 f8 08             	cmp    $0x8,%eax
c010223c:	74 79                	je     c01022b7 <trap_dispatch+0x453>
        tf->tf_cs = KERNEL_CS;
c010223e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102241:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
c0102247:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010224a:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0102250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102253:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0102257:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010225a:	66 89 50 28          	mov    %dx,0x28(%eax)
c010225e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102261:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0102265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102268:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c010226c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010226f:	8b 40 40             	mov    0x40(%eax),%eax
c0102272:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0102277:	89 c2                	mov    %eax,%edx
c0102279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010227c:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c010227f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102282:	8b 40 44             	mov    0x44(%eax),%eax
c0102285:	83 e8 44             	sub    $0x44,%eax
c0102288:	a3 6c df 11 c0       	mov    %eax,0xc011df6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c010228d:	a1 6c df 11 c0       	mov    0xc011df6c,%eax
c0102292:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0102299:	00 
c010229a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010229d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01022a1:	89 04 24             	mov    %eax,(%esp)
c01022a4:	e8 27 3b 00 00       	call   c0105dd0 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c01022a9:	8b 15 6c df 11 c0    	mov    0xc011df6c,%edx
c01022af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01022b2:	83 e8 04             	sub    $0x4,%eax
c01022b5:	89 10                	mov    %edx,(%eax)
}
c01022b7:	90                   	nop
    case T_SWITCH_TOK:
        switch_to_kernel(tf);
        break;
c01022b8:	eb 3c                	jmp    c01022f6 <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01022ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01022bd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022c1:	83 e0 03             	and    $0x3,%eax
c01022c4:	85 c0                	test   %eax,%eax
c01022c6:	75 2e                	jne    c01022f6 <trap_dispatch+0x492>
            print_trapframe(tf);
c01022c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cb:	89 04 24             	mov    %eax,(%esp)
c01022ce:	e8 20 f9 ff ff       	call   c0101bf3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01022d3:	c7 44 24 08 35 6b 10 	movl   $0xc0106b35,0x8(%esp)
c01022da:	c0 
c01022db:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01022e2:	00 
c01022e3:	c7 04 24 51 6b 10 c0 	movl   $0xc0106b51,(%esp)
c01022ea:	e8 42 e1 ff ff       	call   c0100431 <__panic>
        break;
c01022ef:	90                   	nop
c01022f0:	eb 04                	jmp    c01022f6 <trap_dispatch+0x492>
        break;
c01022f2:	90                   	nop
c01022f3:	eb 01                	jmp    c01022f6 <trap_dispatch+0x492>
        break;
c01022f5:	90                   	nop
        }
    }
}
c01022f6:	90                   	nop
c01022f7:	83 c4 3c             	add    $0x3c,%esp
c01022fa:	5b                   	pop    %ebx
c01022fb:	5e                   	pop    %esi
c01022fc:	5f                   	pop    %edi
c01022fd:	5d                   	pop    %ebp
c01022fe:	c3                   	ret    

c01022ff <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01022ff:	f3 0f 1e fb          	endbr32 
c0102303:	55                   	push   %ebp
c0102304:	89 e5                	mov    %esp,%ebp
c0102306:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102309:	8b 45 08             	mov    0x8(%ebp),%eax
c010230c:	89 04 24             	mov    %eax,(%esp)
c010230f:	e8 50 fb ff ff       	call   c0101e64 <trap_dispatch>
}
c0102314:	90                   	nop
c0102315:	c9                   	leave  
c0102316:	c3                   	ret    

c0102317 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $0
c0102319:	6a 00                	push   $0x0
  jmp __alltraps
c010231b:	e9 69 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102320 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $1
c0102322:	6a 01                	push   $0x1
  jmp __alltraps
c0102324:	e9 60 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102329 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $2
c010232b:	6a 02                	push   $0x2
  jmp __alltraps
c010232d:	e9 57 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102332 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $3
c0102334:	6a 03                	push   $0x3
  jmp __alltraps
c0102336:	e9 4e 0a 00 00       	jmp    c0102d89 <__alltraps>

c010233b <vector4>:
.globl vector4
vector4:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $4
c010233d:	6a 04                	push   $0x4
  jmp __alltraps
c010233f:	e9 45 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102344 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $5
c0102346:	6a 05                	push   $0x5
  jmp __alltraps
c0102348:	e9 3c 0a 00 00       	jmp    c0102d89 <__alltraps>

c010234d <vector6>:
.globl vector6
vector6:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $6
c010234f:	6a 06                	push   $0x6
  jmp __alltraps
c0102351:	e9 33 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102356 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $7
c0102358:	6a 07                	push   $0x7
  jmp __alltraps
c010235a:	e9 2a 0a 00 00       	jmp    c0102d89 <__alltraps>

c010235f <vector8>:
.globl vector8
vector8:
  pushl $8
c010235f:	6a 08                	push   $0x8
  jmp __alltraps
c0102361:	e9 23 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102366 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102366:	6a 00                	push   $0x0
  pushl $9
c0102368:	6a 09                	push   $0x9
  jmp __alltraps
c010236a:	e9 1a 0a 00 00       	jmp    c0102d89 <__alltraps>

c010236f <vector10>:
.globl vector10
vector10:
  pushl $10
c010236f:	6a 0a                	push   $0xa
  jmp __alltraps
c0102371:	e9 13 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102376 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102376:	6a 0b                	push   $0xb
  jmp __alltraps
c0102378:	e9 0c 0a 00 00       	jmp    c0102d89 <__alltraps>

c010237d <vector12>:
.globl vector12
vector12:
  pushl $12
c010237d:	6a 0c                	push   $0xc
  jmp __alltraps
c010237f:	e9 05 0a 00 00       	jmp    c0102d89 <__alltraps>

c0102384 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102384:	6a 0d                	push   $0xd
  jmp __alltraps
c0102386:	e9 fe 09 00 00       	jmp    c0102d89 <__alltraps>

c010238b <vector14>:
.globl vector14
vector14:
  pushl $14
c010238b:	6a 0e                	push   $0xe
  jmp __alltraps
c010238d:	e9 f7 09 00 00       	jmp    c0102d89 <__alltraps>

c0102392 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $15
c0102394:	6a 0f                	push   $0xf
  jmp __alltraps
c0102396:	e9 ee 09 00 00       	jmp    c0102d89 <__alltraps>

c010239b <vector16>:
.globl vector16
vector16:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $16
c010239d:	6a 10                	push   $0x10
  jmp __alltraps
c010239f:	e9 e5 09 00 00       	jmp    c0102d89 <__alltraps>

c01023a4 <vector17>:
.globl vector17
vector17:
  pushl $17
c01023a4:	6a 11                	push   $0x11
  jmp __alltraps
c01023a6:	e9 de 09 00 00       	jmp    c0102d89 <__alltraps>

c01023ab <vector18>:
.globl vector18
vector18:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $18
c01023ad:	6a 12                	push   $0x12
  jmp __alltraps
c01023af:	e9 d5 09 00 00       	jmp    c0102d89 <__alltraps>

c01023b4 <vector19>:
.globl vector19
vector19:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $19
c01023b6:	6a 13                	push   $0x13
  jmp __alltraps
c01023b8:	e9 cc 09 00 00       	jmp    c0102d89 <__alltraps>

c01023bd <vector20>:
.globl vector20
vector20:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $20
c01023bf:	6a 14                	push   $0x14
  jmp __alltraps
c01023c1:	e9 c3 09 00 00       	jmp    c0102d89 <__alltraps>

c01023c6 <vector21>:
.globl vector21
vector21:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $21
c01023c8:	6a 15                	push   $0x15
  jmp __alltraps
c01023ca:	e9 ba 09 00 00       	jmp    c0102d89 <__alltraps>

c01023cf <vector22>:
.globl vector22
vector22:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $22
c01023d1:	6a 16                	push   $0x16
  jmp __alltraps
c01023d3:	e9 b1 09 00 00       	jmp    c0102d89 <__alltraps>

c01023d8 <vector23>:
.globl vector23
vector23:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $23
c01023da:	6a 17                	push   $0x17
  jmp __alltraps
c01023dc:	e9 a8 09 00 00       	jmp    c0102d89 <__alltraps>

c01023e1 <vector24>:
.globl vector24
vector24:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $24
c01023e3:	6a 18                	push   $0x18
  jmp __alltraps
c01023e5:	e9 9f 09 00 00       	jmp    c0102d89 <__alltraps>

c01023ea <vector25>:
.globl vector25
vector25:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $25
c01023ec:	6a 19                	push   $0x19
  jmp __alltraps
c01023ee:	e9 96 09 00 00       	jmp    c0102d89 <__alltraps>

c01023f3 <vector26>:
.globl vector26
vector26:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $26
c01023f5:	6a 1a                	push   $0x1a
  jmp __alltraps
c01023f7:	e9 8d 09 00 00       	jmp    c0102d89 <__alltraps>

c01023fc <vector27>:
.globl vector27
vector27:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $27
c01023fe:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102400:	e9 84 09 00 00       	jmp    c0102d89 <__alltraps>

c0102405 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $28
c0102407:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102409:	e9 7b 09 00 00       	jmp    c0102d89 <__alltraps>

c010240e <vector29>:
.globl vector29
vector29:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $29
c0102410:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102412:	e9 72 09 00 00       	jmp    c0102d89 <__alltraps>

c0102417 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $30
c0102419:	6a 1e                	push   $0x1e
  jmp __alltraps
c010241b:	e9 69 09 00 00       	jmp    c0102d89 <__alltraps>

c0102420 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $31
c0102422:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102424:	e9 60 09 00 00       	jmp    c0102d89 <__alltraps>

c0102429 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $32
c010242b:	6a 20                	push   $0x20
  jmp __alltraps
c010242d:	e9 57 09 00 00       	jmp    c0102d89 <__alltraps>

c0102432 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $33
c0102434:	6a 21                	push   $0x21
  jmp __alltraps
c0102436:	e9 4e 09 00 00       	jmp    c0102d89 <__alltraps>

c010243b <vector34>:
.globl vector34
vector34:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $34
c010243d:	6a 22                	push   $0x22
  jmp __alltraps
c010243f:	e9 45 09 00 00       	jmp    c0102d89 <__alltraps>

c0102444 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $35
c0102446:	6a 23                	push   $0x23
  jmp __alltraps
c0102448:	e9 3c 09 00 00       	jmp    c0102d89 <__alltraps>

c010244d <vector36>:
.globl vector36
vector36:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $36
c010244f:	6a 24                	push   $0x24
  jmp __alltraps
c0102451:	e9 33 09 00 00       	jmp    c0102d89 <__alltraps>

c0102456 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102456:	6a 00                	push   $0x0
  pushl $37
c0102458:	6a 25                	push   $0x25
  jmp __alltraps
c010245a:	e9 2a 09 00 00       	jmp    c0102d89 <__alltraps>

c010245f <vector38>:
.globl vector38
vector38:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $38
c0102461:	6a 26                	push   $0x26
  jmp __alltraps
c0102463:	e9 21 09 00 00       	jmp    c0102d89 <__alltraps>

c0102468 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $39
c010246a:	6a 27                	push   $0x27
  jmp __alltraps
c010246c:	e9 18 09 00 00       	jmp    c0102d89 <__alltraps>

c0102471 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $40
c0102473:	6a 28                	push   $0x28
  jmp __alltraps
c0102475:	e9 0f 09 00 00       	jmp    c0102d89 <__alltraps>

c010247a <vector41>:
.globl vector41
vector41:
  pushl $0
c010247a:	6a 00                	push   $0x0
  pushl $41
c010247c:	6a 29                	push   $0x29
  jmp __alltraps
c010247e:	e9 06 09 00 00       	jmp    c0102d89 <__alltraps>

c0102483 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $42
c0102485:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102487:	e9 fd 08 00 00       	jmp    c0102d89 <__alltraps>

c010248c <vector43>:
.globl vector43
vector43:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $43
c010248e:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102490:	e9 f4 08 00 00       	jmp    c0102d89 <__alltraps>

c0102495 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $44
c0102497:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102499:	e9 eb 08 00 00       	jmp    c0102d89 <__alltraps>

c010249e <vector45>:
.globl vector45
vector45:
  pushl $0
c010249e:	6a 00                	push   $0x0
  pushl $45
c01024a0:	6a 2d                	push   $0x2d
  jmp __alltraps
c01024a2:	e9 e2 08 00 00       	jmp    c0102d89 <__alltraps>

c01024a7 <vector46>:
.globl vector46
vector46:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $46
c01024a9:	6a 2e                	push   $0x2e
  jmp __alltraps
c01024ab:	e9 d9 08 00 00       	jmp    c0102d89 <__alltraps>

c01024b0 <vector47>:
.globl vector47
vector47:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $47
c01024b2:	6a 2f                	push   $0x2f
  jmp __alltraps
c01024b4:	e9 d0 08 00 00       	jmp    c0102d89 <__alltraps>

c01024b9 <vector48>:
.globl vector48
vector48:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $48
c01024bb:	6a 30                	push   $0x30
  jmp __alltraps
c01024bd:	e9 c7 08 00 00       	jmp    c0102d89 <__alltraps>

c01024c2 <vector49>:
.globl vector49
vector49:
  pushl $0
c01024c2:	6a 00                	push   $0x0
  pushl $49
c01024c4:	6a 31                	push   $0x31
  jmp __alltraps
c01024c6:	e9 be 08 00 00       	jmp    c0102d89 <__alltraps>

c01024cb <vector50>:
.globl vector50
vector50:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $50
c01024cd:	6a 32                	push   $0x32
  jmp __alltraps
c01024cf:	e9 b5 08 00 00       	jmp    c0102d89 <__alltraps>

c01024d4 <vector51>:
.globl vector51
vector51:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $51
c01024d6:	6a 33                	push   $0x33
  jmp __alltraps
c01024d8:	e9 ac 08 00 00       	jmp    c0102d89 <__alltraps>

c01024dd <vector52>:
.globl vector52
vector52:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $52
c01024df:	6a 34                	push   $0x34
  jmp __alltraps
c01024e1:	e9 a3 08 00 00       	jmp    c0102d89 <__alltraps>

c01024e6 <vector53>:
.globl vector53
vector53:
  pushl $0
c01024e6:	6a 00                	push   $0x0
  pushl $53
c01024e8:	6a 35                	push   $0x35
  jmp __alltraps
c01024ea:	e9 9a 08 00 00       	jmp    c0102d89 <__alltraps>

c01024ef <vector54>:
.globl vector54
vector54:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $54
c01024f1:	6a 36                	push   $0x36
  jmp __alltraps
c01024f3:	e9 91 08 00 00       	jmp    c0102d89 <__alltraps>

c01024f8 <vector55>:
.globl vector55
vector55:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $55
c01024fa:	6a 37                	push   $0x37
  jmp __alltraps
c01024fc:	e9 88 08 00 00       	jmp    c0102d89 <__alltraps>

c0102501 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $56
c0102503:	6a 38                	push   $0x38
  jmp __alltraps
c0102505:	e9 7f 08 00 00       	jmp    c0102d89 <__alltraps>

c010250a <vector57>:
.globl vector57
vector57:
  pushl $0
c010250a:	6a 00                	push   $0x0
  pushl $57
c010250c:	6a 39                	push   $0x39
  jmp __alltraps
c010250e:	e9 76 08 00 00       	jmp    c0102d89 <__alltraps>

c0102513 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $58
c0102515:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102517:	e9 6d 08 00 00       	jmp    c0102d89 <__alltraps>

c010251c <vector59>:
.globl vector59
vector59:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $59
c010251e:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102520:	e9 64 08 00 00       	jmp    c0102d89 <__alltraps>

c0102525 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $60
c0102527:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102529:	e9 5b 08 00 00       	jmp    c0102d89 <__alltraps>

c010252e <vector61>:
.globl vector61
vector61:
  pushl $0
c010252e:	6a 00                	push   $0x0
  pushl $61
c0102530:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102532:	e9 52 08 00 00       	jmp    c0102d89 <__alltraps>

c0102537 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $62
c0102539:	6a 3e                	push   $0x3e
  jmp __alltraps
c010253b:	e9 49 08 00 00       	jmp    c0102d89 <__alltraps>

c0102540 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $63
c0102542:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102544:	e9 40 08 00 00       	jmp    c0102d89 <__alltraps>

c0102549 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $64
c010254b:	6a 40                	push   $0x40
  jmp __alltraps
c010254d:	e9 37 08 00 00       	jmp    c0102d89 <__alltraps>

c0102552 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102552:	6a 00                	push   $0x0
  pushl $65
c0102554:	6a 41                	push   $0x41
  jmp __alltraps
c0102556:	e9 2e 08 00 00       	jmp    c0102d89 <__alltraps>

c010255b <vector66>:
.globl vector66
vector66:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $66
c010255d:	6a 42                	push   $0x42
  jmp __alltraps
c010255f:	e9 25 08 00 00       	jmp    c0102d89 <__alltraps>

c0102564 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $67
c0102566:	6a 43                	push   $0x43
  jmp __alltraps
c0102568:	e9 1c 08 00 00       	jmp    c0102d89 <__alltraps>

c010256d <vector68>:
.globl vector68
vector68:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $68
c010256f:	6a 44                	push   $0x44
  jmp __alltraps
c0102571:	e9 13 08 00 00       	jmp    c0102d89 <__alltraps>

c0102576 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $69
c0102578:	6a 45                	push   $0x45
  jmp __alltraps
c010257a:	e9 0a 08 00 00       	jmp    c0102d89 <__alltraps>

c010257f <vector70>:
.globl vector70
vector70:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $70
c0102581:	6a 46                	push   $0x46
  jmp __alltraps
c0102583:	e9 01 08 00 00       	jmp    c0102d89 <__alltraps>

c0102588 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $71
c010258a:	6a 47                	push   $0x47
  jmp __alltraps
c010258c:	e9 f8 07 00 00       	jmp    c0102d89 <__alltraps>

c0102591 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $72
c0102593:	6a 48                	push   $0x48
  jmp __alltraps
c0102595:	e9 ef 07 00 00       	jmp    c0102d89 <__alltraps>

c010259a <vector73>:
.globl vector73
vector73:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $73
c010259c:	6a 49                	push   $0x49
  jmp __alltraps
c010259e:	e9 e6 07 00 00       	jmp    c0102d89 <__alltraps>

c01025a3 <vector74>:
.globl vector74
vector74:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $74
c01025a5:	6a 4a                	push   $0x4a
  jmp __alltraps
c01025a7:	e9 dd 07 00 00       	jmp    c0102d89 <__alltraps>

c01025ac <vector75>:
.globl vector75
vector75:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $75
c01025ae:	6a 4b                	push   $0x4b
  jmp __alltraps
c01025b0:	e9 d4 07 00 00       	jmp    c0102d89 <__alltraps>

c01025b5 <vector76>:
.globl vector76
vector76:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $76
c01025b7:	6a 4c                	push   $0x4c
  jmp __alltraps
c01025b9:	e9 cb 07 00 00       	jmp    c0102d89 <__alltraps>

c01025be <vector77>:
.globl vector77
vector77:
  pushl $0
c01025be:	6a 00                	push   $0x0
  pushl $77
c01025c0:	6a 4d                	push   $0x4d
  jmp __alltraps
c01025c2:	e9 c2 07 00 00       	jmp    c0102d89 <__alltraps>

c01025c7 <vector78>:
.globl vector78
vector78:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $78
c01025c9:	6a 4e                	push   $0x4e
  jmp __alltraps
c01025cb:	e9 b9 07 00 00       	jmp    c0102d89 <__alltraps>

c01025d0 <vector79>:
.globl vector79
vector79:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $79
c01025d2:	6a 4f                	push   $0x4f
  jmp __alltraps
c01025d4:	e9 b0 07 00 00       	jmp    c0102d89 <__alltraps>

c01025d9 <vector80>:
.globl vector80
vector80:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $80
c01025db:	6a 50                	push   $0x50
  jmp __alltraps
c01025dd:	e9 a7 07 00 00       	jmp    c0102d89 <__alltraps>

c01025e2 <vector81>:
.globl vector81
vector81:
  pushl $0
c01025e2:	6a 00                	push   $0x0
  pushl $81
c01025e4:	6a 51                	push   $0x51
  jmp __alltraps
c01025e6:	e9 9e 07 00 00       	jmp    c0102d89 <__alltraps>

c01025eb <vector82>:
.globl vector82
vector82:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $82
c01025ed:	6a 52                	push   $0x52
  jmp __alltraps
c01025ef:	e9 95 07 00 00       	jmp    c0102d89 <__alltraps>

c01025f4 <vector83>:
.globl vector83
vector83:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $83
c01025f6:	6a 53                	push   $0x53
  jmp __alltraps
c01025f8:	e9 8c 07 00 00       	jmp    c0102d89 <__alltraps>

c01025fd <vector84>:
.globl vector84
vector84:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $84
c01025ff:	6a 54                	push   $0x54
  jmp __alltraps
c0102601:	e9 83 07 00 00       	jmp    c0102d89 <__alltraps>

c0102606 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102606:	6a 00                	push   $0x0
  pushl $85
c0102608:	6a 55                	push   $0x55
  jmp __alltraps
c010260a:	e9 7a 07 00 00       	jmp    c0102d89 <__alltraps>

c010260f <vector86>:
.globl vector86
vector86:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $86
c0102611:	6a 56                	push   $0x56
  jmp __alltraps
c0102613:	e9 71 07 00 00       	jmp    c0102d89 <__alltraps>

c0102618 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $87
c010261a:	6a 57                	push   $0x57
  jmp __alltraps
c010261c:	e9 68 07 00 00       	jmp    c0102d89 <__alltraps>

c0102621 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $88
c0102623:	6a 58                	push   $0x58
  jmp __alltraps
c0102625:	e9 5f 07 00 00       	jmp    c0102d89 <__alltraps>

c010262a <vector89>:
.globl vector89
vector89:
  pushl $0
c010262a:	6a 00                	push   $0x0
  pushl $89
c010262c:	6a 59                	push   $0x59
  jmp __alltraps
c010262e:	e9 56 07 00 00       	jmp    c0102d89 <__alltraps>

c0102633 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $90
c0102635:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102637:	e9 4d 07 00 00       	jmp    c0102d89 <__alltraps>

c010263c <vector91>:
.globl vector91
vector91:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $91
c010263e:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102640:	e9 44 07 00 00       	jmp    c0102d89 <__alltraps>

c0102645 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $92
c0102647:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102649:	e9 3b 07 00 00       	jmp    c0102d89 <__alltraps>

c010264e <vector93>:
.globl vector93
vector93:
  pushl $0
c010264e:	6a 00                	push   $0x0
  pushl $93
c0102650:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102652:	e9 32 07 00 00       	jmp    c0102d89 <__alltraps>

c0102657 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $94
c0102659:	6a 5e                	push   $0x5e
  jmp __alltraps
c010265b:	e9 29 07 00 00       	jmp    c0102d89 <__alltraps>

c0102660 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $95
c0102662:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102664:	e9 20 07 00 00       	jmp    c0102d89 <__alltraps>

c0102669 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $96
c010266b:	6a 60                	push   $0x60
  jmp __alltraps
c010266d:	e9 17 07 00 00       	jmp    c0102d89 <__alltraps>

c0102672 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102672:	6a 00                	push   $0x0
  pushl $97
c0102674:	6a 61                	push   $0x61
  jmp __alltraps
c0102676:	e9 0e 07 00 00       	jmp    c0102d89 <__alltraps>

c010267b <vector98>:
.globl vector98
vector98:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $98
c010267d:	6a 62                	push   $0x62
  jmp __alltraps
c010267f:	e9 05 07 00 00       	jmp    c0102d89 <__alltraps>

c0102684 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $99
c0102686:	6a 63                	push   $0x63
  jmp __alltraps
c0102688:	e9 fc 06 00 00       	jmp    c0102d89 <__alltraps>

c010268d <vector100>:
.globl vector100
vector100:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $100
c010268f:	6a 64                	push   $0x64
  jmp __alltraps
c0102691:	e9 f3 06 00 00       	jmp    c0102d89 <__alltraps>

c0102696 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102696:	6a 00                	push   $0x0
  pushl $101
c0102698:	6a 65                	push   $0x65
  jmp __alltraps
c010269a:	e9 ea 06 00 00       	jmp    c0102d89 <__alltraps>

c010269f <vector102>:
.globl vector102
vector102:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $102
c01026a1:	6a 66                	push   $0x66
  jmp __alltraps
c01026a3:	e9 e1 06 00 00       	jmp    c0102d89 <__alltraps>

c01026a8 <vector103>:
.globl vector103
vector103:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $103
c01026aa:	6a 67                	push   $0x67
  jmp __alltraps
c01026ac:	e9 d8 06 00 00       	jmp    c0102d89 <__alltraps>

c01026b1 <vector104>:
.globl vector104
vector104:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $104
c01026b3:	6a 68                	push   $0x68
  jmp __alltraps
c01026b5:	e9 cf 06 00 00       	jmp    c0102d89 <__alltraps>

c01026ba <vector105>:
.globl vector105
vector105:
  pushl $0
c01026ba:	6a 00                	push   $0x0
  pushl $105
c01026bc:	6a 69                	push   $0x69
  jmp __alltraps
c01026be:	e9 c6 06 00 00       	jmp    c0102d89 <__alltraps>

c01026c3 <vector106>:
.globl vector106
vector106:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $106
c01026c5:	6a 6a                	push   $0x6a
  jmp __alltraps
c01026c7:	e9 bd 06 00 00       	jmp    c0102d89 <__alltraps>

c01026cc <vector107>:
.globl vector107
vector107:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $107
c01026ce:	6a 6b                	push   $0x6b
  jmp __alltraps
c01026d0:	e9 b4 06 00 00       	jmp    c0102d89 <__alltraps>

c01026d5 <vector108>:
.globl vector108
vector108:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $108
c01026d7:	6a 6c                	push   $0x6c
  jmp __alltraps
c01026d9:	e9 ab 06 00 00       	jmp    c0102d89 <__alltraps>

c01026de <vector109>:
.globl vector109
vector109:
  pushl $0
c01026de:	6a 00                	push   $0x0
  pushl $109
c01026e0:	6a 6d                	push   $0x6d
  jmp __alltraps
c01026e2:	e9 a2 06 00 00       	jmp    c0102d89 <__alltraps>

c01026e7 <vector110>:
.globl vector110
vector110:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $110
c01026e9:	6a 6e                	push   $0x6e
  jmp __alltraps
c01026eb:	e9 99 06 00 00       	jmp    c0102d89 <__alltraps>

c01026f0 <vector111>:
.globl vector111
vector111:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $111
c01026f2:	6a 6f                	push   $0x6f
  jmp __alltraps
c01026f4:	e9 90 06 00 00       	jmp    c0102d89 <__alltraps>

c01026f9 <vector112>:
.globl vector112
vector112:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $112
c01026fb:	6a 70                	push   $0x70
  jmp __alltraps
c01026fd:	e9 87 06 00 00       	jmp    c0102d89 <__alltraps>

c0102702 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102702:	6a 00                	push   $0x0
  pushl $113
c0102704:	6a 71                	push   $0x71
  jmp __alltraps
c0102706:	e9 7e 06 00 00       	jmp    c0102d89 <__alltraps>

c010270b <vector114>:
.globl vector114
vector114:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $114
c010270d:	6a 72                	push   $0x72
  jmp __alltraps
c010270f:	e9 75 06 00 00       	jmp    c0102d89 <__alltraps>

c0102714 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $115
c0102716:	6a 73                	push   $0x73
  jmp __alltraps
c0102718:	e9 6c 06 00 00       	jmp    c0102d89 <__alltraps>

c010271d <vector116>:
.globl vector116
vector116:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $116
c010271f:	6a 74                	push   $0x74
  jmp __alltraps
c0102721:	e9 63 06 00 00       	jmp    c0102d89 <__alltraps>

c0102726 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102726:	6a 00                	push   $0x0
  pushl $117
c0102728:	6a 75                	push   $0x75
  jmp __alltraps
c010272a:	e9 5a 06 00 00       	jmp    c0102d89 <__alltraps>

c010272f <vector118>:
.globl vector118
vector118:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $118
c0102731:	6a 76                	push   $0x76
  jmp __alltraps
c0102733:	e9 51 06 00 00       	jmp    c0102d89 <__alltraps>

c0102738 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $119
c010273a:	6a 77                	push   $0x77
  jmp __alltraps
c010273c:	e9 48 06 00 00       	jmp    c0102d89 <__alltraps>

c0102741 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $120
c0102743:	6a 78                	push   $0x78
  jmp __alltraps
c0102745:	e9 3f 06 00 00       	jmp    c0102d89 <__alltraps>

c010274a <vector121>:
.globl vector121
vector121:
  pushl $0
c010274a:	6a 00                	push   $0x0
  pushl $121
c010274c:	6a 79                	push   $0x79
  jmp __alltraps
c010274e:	e9 36 06 00 00       	jmp    c0102d89 <__alltraps>

c0102753 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $122
c0102755:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102757:	e9 2d 06 00 00       	jmp    c0102d89 <__alltraps>

c010275c <vector123>:
.globl vector123
vector123:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $123
c010275e:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102760:	e9 24 06 00 00       	jmp    c0102d89 <__alltraps>

c0102765 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $124
c0102767:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102769:	e9 1b 06 00 00       	jmp    c0102d89 <__alltraps>

c010276e <vector125>:
.globl vector125
vector125:
  pushl $0
c010276e:	6a 00                	push   $0x0
  pushl $125
c0102770:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102772:	e9 12 06 00 00       	jmp    c0102d89 <__alltraps>

c0102777 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $126
c0102779:	6a 7e                	push   $0x7e
  jmp __alltraps
c010277b:	e9 09 06 00 00       	jmp    c0102d89 <__alltraps>

c0102780 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $127
c0102782:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102784:	e9 00 06 00 00       	jmp    c0102d89 <__alltraps>

c0102789 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $128
c010278b:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102790:	e9 f4 05 00 00       	jmp    c0102d89 <__alltraps>

c0102795 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $129
c0102797:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010279c:	e9 e8 05 00 00       	jmp    c0102d89 <__alltraps>

c01027a1 <vector130>:
.globl vector130
vector130:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $130
c01027a3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01027a8:	e9 dc 05 00 00       	jmp    c0102d89 <__alltraps>

c01027ad <vector131>:
.globl vector131
vector131:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $131
c01027af:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01027b4:	e9 d0 05 00 00       	jmp    c0102d89 <__alltraps>

c01027b9 <vector132>:
.globl vector132
vector132:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $132
c01027bb:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01027c0:	e9 c4 05 00 00       	jmp    c0102d89 <__alltraps>

c01027c5 <vector133>:
.globl vector133
vector133:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $133
c01027c7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01027cc:	e9 b8 05 00 00       	jmp    c0102d89 <__alltraps>

c01027d1 <vector134>:
.globl vector134
vector134:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $134
c01027d3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01027d8:	e9 ac 05 00 00       	jmp    c0102d89 <__alltraps>

c01027dd <vector135>:
.globl vector135
vector135:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $135
c01027df:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01027e4:	e9 a0 05 00 00       	jmp    c0102d89 <__alltraps>

c01027e9 <vector136>:
.globl vector136
vector136:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $136
c01027eb:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01027f0:	e9 94 05 00 00       	jmp    c0102d89 <__alltraps>

c01027f5 <vector137>:
.globl vector137
vector137:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $137
c01027f7:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01027fc:	e9 88 05 00 00       	jmp    c0102d89 <__alltraps>

c0102801 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $138
c0102803:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102808:	e9 7c 05 00 00       	jmp    c0102d89 <__alltraps>

c010280d <vector139>:
.globl vector139
vector139:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $139
c010280f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102814:	e9 70 05 00 00       	jmp    c0102d89 <__alltraps>

c0102819 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $140
c010281b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102820:	e9 64 05 00 00       	jmp    c0102d89 <__alltraps>

c0102825 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $141
c0102827:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010282c:	e9 58 05 00 00       	jmp    c0102d89 <__alltraps>

c0102831 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $142
c0102833:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102838:	e9 4c 05 00 00       	jmp    c0102d89 <__alltraps>

c010283d <vector143>:
.globl vector143
vector143:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $143
c010283f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102844:	e9 40 05 00 00       	jmp    c0102d89 <__alltraps>

c0102849 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $144
c010284b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102850:	e9 34 05 00 00       	jmp    c0102d89 <__alltraps>

c0102855 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $145
c0102857:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010285c:	e9 28 05 00 00       	jmp    c0102d89 <__alltraps>

c0102861 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $146
c0102863:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102868:	e9 1c 05 00 00       	jmp    c0102d89 <__alltraps>

c010286d <vector147>:
.globl vector147
vector147:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $147
c010286f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102874:	e9 10 05 00 00       	jmp    c0102d89 <__alltraps>

c0102879 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $148
c010287b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102880:	e9 04 05 00 00       	jmp    c0102d89 <__alltraps>

c0102885 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $149
c0102887:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010288c:	e9 f8 04 00 00       	jmp    c0102d89 <__alltraps>

c0102891 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $150
c0102893:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102898:	e9 ec 04 00 00       	jmp    c0102d89 <__alltraps>

c010289d <vector151>:
.globl vector151
vector151:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $151
c010289f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01028a4:	e9 e0 04 00 00       	jmp    c0102d89 <__alltraps>

c01028a9 <vector152>:
.globl vector152
vector152:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $152
c01028ab:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01028b0:	e9 d4 04 00 00       	jmp    c0102d89 <__alltraps>

c01028b5 <vector153>:
.globl vector153
vector153:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $153
c01028b7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01028bc:	e9 c8 04 00 00       	jmp    c0102d89 <__alltraps>

c01028c1 <vector154>:
.globl vector154
vector154:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $154
c01028c3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01028c8:	e9 bc 04 00 00       	jmp    c0102d89 <__alltraps>

c01028cd <vector155>:
.globl vector155
vector155:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $155
c01028cf:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01028d4:	e9 b0 04 00 00       	jmp    c0102d89 <__alltraps>

c01028d9 <vector156>:
.globl vector156
vector156:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $156
c01028db:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01028e0:	e9 a4 04 00 00       	jmp    c0102d89 <__alltraps>

c01028e5 <vector157>:
.globl vector157
vector157:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $157
c01028e7:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01028ec:	e9 98 04 00 00       	jmp    c0102d89 <__alltraps>

c01028f1 <vector158>:
.globl vector158
vector158:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $158
c01028f3:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01028f8:	e9 8c 04 00 00       	jmp    c0102d89 <__alltraps>

c01028fd <vector159>:
.globl vector159
vector159:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $159
c01028ff:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102904:	e9 80 04 00 00       	jmp    c0102d89 <__alltraps>

c0102909 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $160
c010290b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102910:	e9 74 04 00 00       	jmp    c0102d89 <__alltraps>

c0102915 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $161
c0102917:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010291c:	e9 68 04 00 00       	jmp    c0102d89 <__alltraps>

c0102921 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $162
c0102923:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102928:	e9 5c 04 00 00       	jmp    c0102d89 <__alltraps>

c010292d <vector163>:
.globl vector163
vector163:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $163
c010292f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102934:	e9 50 04 00 00       	jmp    c0102d89 <__alltraps>

c0102939 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $164
c010293b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102940:	e9 44 04 00 00       	jmp    c0102d89 <__alltraps>

c0102945 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $165
c0102947:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010294c:	e9 38 04 00 00       	jmp    c0102d89 <__alltraps>

c0102951 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $166
c0102953:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102958:	e9 2c 04 00 00       	jmp    c0102d89 <__alltraps>

c010295d <vector167>:
.globl vector167
vector167:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $167
c010295f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102964:	e9 20 04 00 00       	jmp    c0102d89 <__alltraps>

c0102969 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $168
c010296b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102970:	e9 14 04 00 00       	jmp    c0102d89 <__alltraps>

c0102975 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $169
c0102977:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010297c:	e9 08 04 00 00       	jmp    c0102d89 <__alltraps>

c0102981 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $170
c0102983:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102988:	e9 fc 03 00 00       	jmp    c0102d89 <__alltraps>

c010298d <vector171>:
.globl vector171
vector171:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $171
c010298f:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102994:	e9 f0 03 00 00       	jmp    c0102d89 <__alltraps>

c0102999 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $172
c010299b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01029a0:	e9 e4 03 00 00       	jmp    c0102d89 <__alltraps>

c01029a5 <vector173>:
.globl vector173
vector173:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $173
c01029a7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01029ac:	e9 d8 03 00 00       	jmp    c0102d89 <__alltraps>

c01029b1 <vector174>:
.globl vector174
vector174:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $174
c01029b3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01029b8:	e9 cc 03 00 00       	jmp    c0102d89 <__alltraps>

c01029bd <vector175>:
.globl vector175
vector175:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $175
c01029bf:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01029c4:	e9 c0 03 00 00       	jmp    c0102d89 <__alltraps>

c01029c9 <vector176>:
.globl vector176
vector176:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $176
c01029cb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01029d0:	e9 b4 03 00 00       	jmp    c0102d89 <__alltraps>

c01029d5 <vector177>:
.globl vector177
vector177:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $177
c01029d7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01029dc:	e9 a8 03 00 00       	jmp    c0102d89 <__alltraps>

c01029e1 <vector178>:
.globl vector178
vector178:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $178
c01029e3:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01029e8:	e9 9c 03 00 00       	jmp    c0102d89 <__alltraps>

c01029ed <vector179>:
.globl vector179
vector179:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $179
c01029ef:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01029f4:	e9 90 03 00 00       	jmp    c0102d89 <__alltraps>

c01029f9 <vector180>:
.globl vector180
vector180:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $180
c01029fb:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102a00:	e9 84 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a05 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $181
c0102a07:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102a0c:	e9 78 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a11 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $182
c0102a13:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102a18:	e9 6c 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a1d <vector183>:
.globl vector183
vector183:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $183
c0102a1f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102a24:	e9 60 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a29 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $184
c0102a2b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102a30:	e9 54 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a35 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $185
c0102a37:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102a3c:	e9 48 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a41 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $186
c0102a43:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102a48:	e9 3c 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a4d <vector187>:
.globl vector187
vector187:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $187
c0102a4f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102a54:	e9 30 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a59 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $188
c0102a5b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102a60:	e9 24 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a65 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $189
c0102a67:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102a6c:	e9 18 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a71 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $190
c0102a73:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102a78:	e9 0c 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a7d <vector191>:
.globl vector191
vector191:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $191
c0102a7f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102a84:	e9 00 03 00 00       	jmp    c0102d89 <__alltraps>

c0102a89 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $192
c0102a8b:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102a90:	e9 f4 02 00 00       	jmp    c0102d89 <__alltraps>

c0102a95 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $193
c0102a97:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102a9c:	e9 e8 02 00 00       	jmp    c0102d89 <__alltraps>

c0102aa1 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $194
c0102aa3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102aa8:	e9 dc 02 00 00       	jmp    c0102d89 <__alltraps>

c0102aad <vector195>:
.globl vector195
vector195:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $195
c0102aaf:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102ab4:	e9 d0 02 00 00       	jmp    c0102d89 <__alltraps>

c0102ab9 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $196
c0102abb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ac0:	e9 c4 02 00 00       	jmp    c0102d89 <__alltraps>

c0102ac5 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $197
c0102ac7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102acc:	e9 b8 02 00 00       	jmp    c0102d89 <__alltraps>

c0102ad1 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $198
c0102ad3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102ad8:	e9 ac 02 00 00       	jmp    c0102d89 <__alltraps>

c0102add <vector199>:
.globl vector199
vector199:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $199
c0102adf:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102ae4:	e9 a0 02 00 00       	jmp    c0102d89 <__alltraps>

c0102ae9 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $200
c0102aeb:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102af0:	e9 94 02 00 00       	jmp    c0102d89 <__alltraps>

c0102af5 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $201
c0102af7:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102afc:	e9 88 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b01 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $202
c0102b03:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102b08:	e9 7c 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b0d <vector203>:
.globl vector203
vector203:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $203
c0102b0f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102b14:	e9 70 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b19 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $204
c0102b1b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102b20:	e9 64 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b25 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $205
c0102b27:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102b2c:	e9 58 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b31 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $206
c0102b33:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102b38:	e9 4c 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b3d <vector207>:
.globl vector207
vector207:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $207
c0102b3f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102b44:	e9 40 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b49 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $208
c0102b4b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102b50:	e9 34 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b55 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $209
c0102b57:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102b5c:	e9 28 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b61 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $210
c0102b63:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102b68:	e9 1c 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b6d <vector211>:
.globl vector211
vector211:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $211
c0102b6f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102b74:	e9 10 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b79 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $212
c0102b7b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102b80:	e9 04 02 00 00       	jmp    c0102d89 <__alltraps>

c0102b85 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $213
c0102b87:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102b8c:	e9 f8 01 00 00       	jmp    c0102d89 <__alltraps>

c0102b91 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $214
c0102b93:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102b98:	e9 ec 01 00 00       	jmp    c0102d89 <__alltraps>

c0102b9d <vector215>:
.globl vector215
vector215:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $215
c0102b9f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102ba4:	e9 e0 01 00 00       	jmp    c0102d89 <__alltraps>

c0102ba9 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102ba9:	6a 00                	push   $0x0
  pushl $216
c0102bab:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102bb0:	e9 d4 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bb5 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102bb5:	6a 00                	push   $0x0
  pushl $217
c0102bb7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102bbc:	e9 c8 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bc1 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $218
c0102bc3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102bc8:	e9 bc 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bcd <vector219>:
.globl vector219
vector219:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $219
c0102bcf:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102bd4:	e9 b0 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bd9 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $220
c0102bdb:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102be0:	e9 a4 01 00 00       	jmp    c0102d89 <__alltraps>

c0102be5 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102be5:	6a 00                	push   $0x0
  pushl $221
c0102be7:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102bec:	e9 98 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bf1 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $222
c0102bf3:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102bf8:	e9 8c 01 00 00       	jmp    c0102d89 <__alltraps>

c0102bfd <vector223>:
.globl vector223
vector223:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $223
c0102bff:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102c04:	e9 80 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c09 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102c09:	6a 00                	push   $0x0
  pushl $224
c0102c0b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102c10:	e9 74 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c15 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $225
c0102c17:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102c1c:	e9 68 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c21 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $226
c0102c23:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102c28:	e9 5c 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c2d <vector227>:
.globl vector227
vector227:
  pushl $0
c0102c2d:	6a 00                	push   $0x0
  pushl $227
c0102c2f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102c34:	e9 50 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c39 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $228
c0102c3b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102c40:	e9 44 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c45 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102c45:	6a 00                	push   $0x0
  pushl $229
c0102c47:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102c4c:	e9 38 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c51 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $230
c0102c53:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102c58:	e9 2c 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c5d <vector231>:
.globl vector231
vector231:
  pushl $0
c0102c5d:	6a 00                	push   $0x0
  pushl $231
c0102c5f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102c64:	e9 20 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c69 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102c69:	6a 00                	push   $0x0
  pushl $232
c0102c6b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102c70:	e9 14 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c75 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $233
c0102c77:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102c7c:	e9 08 01 00 00       	jmp    c0102d89 <__alltraps>

c0102c81 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102c81:	6a 00                	push   $0x0
  pushl $234
c0102c83:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102c88:	e9 fc 00 00 00       	jmp    c0102d89 <__alltraps>

c0102c8d <vector235>:
.globl vector235
vector235:
  pushl $0
c0102c8d:	6a 00                	push   $0x0
  pushl $235
c0102c8f:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102c94:	e9 f0 00 00 00       	jmp    c0102d89 <__alltraps>

c0102c99 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102c99:	6a 00                	push   $0x0
  pushl $236
c0102c9b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102ca0:	e9 e4 00 00 00       	jmp    c0102d89 <__alltraps>

c0102ca5 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102ca5:	6a 00                	push   $0x0
  pushl $237
c0102ca7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102cac:	e9 d8 00 00 00       	jmp    c0102d89 <__alltraps>

c0102cb1 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102cb1:	6a 00                	push   $0x0
  pushl $238
c0102cb3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102cb8:	e9 cc 00 00 00       	jmp    c0102d89 <__alltraps>

c0102cbd <vector239>:
.globl vector239
vector239:
  pushl $0
c0102cbd:	6a 00                	push   $0x0
  pushl $239
c0102cbf:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102cc4:	e9 c0 00 00 00       	jmp    c0102d89 <__alltraps>

c0102cc9 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102cc9:	6a 00                	push   $0x0
  pushl $240
c0102ccb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102cd0:	e9 b4 00 00 00       	jmp    c0102d89 <__alltraps>

c0102cd5 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102cd5:	6a 00                	push   $0x0
  pushl $241
c0102cd7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102cdc:	e9 a8 00 00 00       	jmp    c0102d89 <__alltraps>

c0102ce1 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102ce1:	6a 00                	push   $0x0
  pushl $242
c0102ce3:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102ce8:	e9 9c 00 00 00       	jmp    c0102d89 <__alltraps>

c0102ced <vector243>:
.globl vector243
vector243:
  pushl $0
c0102ced:	6a 00                	push   $0x0
  pushl $243
c0102cef:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102cf4:	e9 90 00 00 00       	jmp    c0102d89 <__alltraps>

c0102cf9 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102cf9:	6a 00                	push   $0x0
  pushl $244
c0102cfb:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102d00:	e9 84 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d05 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102d05:	6a 00                	push   $0x0
  pushl $245
c0102d07:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102d0c:	e9 78 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d11 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102d11:	6a 00                	push   $0x0
  pushl $246
c0102d13:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102d18:	e9 6c 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d1d <vector247>:
.globl vector247
vector247:
  pushl $0
c0102d1d:	6a 00                	push   $0x0
  pushl $247
c0102d1f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102d24:	e9 60 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d29 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102d29:	6a 00                	push   $0x0
  pushl $248
c0102d2b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102d30:	e9 54 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d35 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102d35:	6a 00                	push   $0x0
  pushl $249
c0102d37:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102d3c:	e9 48 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d41 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102d41:	6a 00                	push   $0x0
  pushl $250
c0102d43:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102d48:	e9 3c 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d4d <vector251>:
.globl vector251
vector251:
  pushl $0
c0102d4d:	6a 00                	push   $0x0
  pushl $251
c0102d4f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102d54:	e9 30 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d59 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102d59:	6a 00                	push   $0x0
  pushl $252
c0102d5b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102d60:	e9 24 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d65 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102d65:	6a 00                	push   $0x0
  pushl $253
c0102d67:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102d6c:	e9 18 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d71 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102d71:	6a 00                	push   $0x0
  pushl $254
c0102d73:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102d78:	e9 0c 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d7d <vector255>:
.globl vector255
vector255:
  pushl $0
c0102d7d:	6a 00                	push   $0x0
  pushl $255
c0102d7f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102d84:	e9 00 00 00 00       	jmp    c0102d89 <__alltraps>

c0102d89 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102d89:	1e                   	push   %ds
    pushl %es
c0102d8a:	06                   	push   %es
    pushl %fs
c0102d8b:	0f a0                	push   %fs
    pushl %gs
c0102d8d:	0f a8                	push   %gs
    pushal
c0102d8f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102d90:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102d95:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102d97:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102d99:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102d9a:	e8 60 f5 ff ff       	call   c01022ff <trap>

    # pop the pushed stack pointer
    popl %esp
c0102d9f:	5c                   	pop    %esp

c0102da0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102da0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102da1:	0f a9                	pop    %gs
    popl %fs
c0102da3:	0f a1                	pop    %fs
    popl %es
c0102da5:	07                   	pop    %es
    popl %ds
c0102da6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102da7:	83 c4 08             	add    $0x8,%esp
    iret
c0102daa:	cf                   	iret   

c0102dab <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102dab:	55                   	push   %ebp
c0102dac:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102dae:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c0102db3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102db6:	29 c2                	sub    %eax,%edx
c0102db8:	89 d0                	mov    %edx,%eax
c0102dba:	c1 f8 02             	sar    $0x2,%eax
c0102dbd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102dc3:	5d                   	pop    %ebp
c0102dc4:	c3                   	ret    

c0102dc5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102dc5:	55                   	push   %ebp
c0102dc6:	89 e5                	mov    %esp,%ebp
c0102dc8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dce:	89 04 24             	mov    %eax,(%esp)
c0102dd1:	e8 d5 ff ff ff       	call   c0102dab <page2ppn>
c0102dd6:	c1 e0 0c             	shl    $0xc,%eax
}
c0102dd9:	c9                   	leave  
c0102dda:	c3                   	ret    

c0102ddb <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102ddb:	55                   	push   %ebp
c0102ddc:	89 e5                	mov    %esp,%ebp
c0102dde:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102de1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de4:	c1 e8 0c             	shr    $0xc,%eax
c0102de7:	89 c2                	mov    %eax,%edx
c0102de9:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102dee:	39 c2                	cmp    %eax,%edx
c0102df0:	72 1c                	jb     c0102e0e <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102df2:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c0102df9:	c0 
c0102dfa:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102e01:	00 
c0102e02:	c7 04 24 2f 6d 10 c0 	movl   $0xc0106d2f,(%esp)
c0102e09:	e8 23 d6 ff ff       	call   c0100431 <__panic>
    }
    return &pages[PPN(pa)];
c0102e0e:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c0102e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e17:	c1 e8 0c             	shr    $0xc,%eax
c0102e1a:	89 c2                	mov    %eax,%edx
c0102e1c:	89 d0                	mov    %edx,%eax
c0102e1e:	c1 e0 02             	shl    $0x2,%eax
c0102e21:	01 d0                	add    %edx,%eax
c0102e23:	c1 e0 02             	shl    $0x2,%eax
c0102e26:	01 c8                	add    %ecx,%eax
}
c0102e28:	c9                   	leave  
c0102e29:	c3                   	ret    

c0102e2a <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102e2a:	55                   	push   %ebp
c0102e2b:	89 e5                	mov    %esp,%ebp
c0102e2d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102e30:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e33:	89 04 24             	mov    %eax,(%esp)
c0102e36:	e8 8a ff ff ff       	call   c0102dc5 <page2pa>
c0102e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e41:	c1 e8 0c             	shr    $0xc,%eax
c0102e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e47:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102e4c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102e4f:	72 23                	jb     c0102e74 <page2kva+0x4a>
c0102e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e58:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c0102e5f:	c0 
c0102e60:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102e67:	00 
c0102e68:	c7 04 24 2f 6d 10 c0 	movl   $0xc0106d2f,(%esp)
c0102e6f:	e8 bd d5 ff ff       	call   c0100431 <__panic>
c0102e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e77:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102e7c:	c9                   	leave  
c0102e7d:	c3                   	ret    

c0102e7e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102e7e:	55                   	push   %ebp
c0102e7f:	89 e5                	mov    %esp,%ebp
c0102e81:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102e84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e87:	83 e0 01             	and    $0x1,%eax
c0102e8a:	85 c0                	test   %eax,%eax
c0102e8c:	75 1c                	jne    c0102eaa <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102e8e:	c7 44 24 08 64 6d 10 	movl   $0xc0106d64,0x8(%esp)
c0102e95:	c0 
c0102e96:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102e9d:	00 
c0102e9e:	c7 04 24 2f 6d 10 c0 	movl   $0xc0106d2f,(%esp)
c0102ea5:	e8 87 d5 ff ff       	call   c0100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102eb2:	89 04 24             	mov    %eax,(%esp)
c0102eb5:	e8 21 ff ff ff       	call   c0102ddb <pa2page>
}
c0102eba:	c9                   	leave  
c0102ebb:	c3                   	ret    

c0102ebc <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102ebc:	55                   	push   %ebp
c0102ebd:	89 e5                	mov    %esp,%ebp
c0102ebf:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102eca:	89 04 24             	mov    %eax,(%esp)
c0102ecd:	e8 09 ff ff ff       	call   c0102ddb <pa2page>
}
c0102ed2:	c9                   	leave  
c0102ed3:	c3                   	ret    

c0102ed4 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102ed4:	55                   	push   %ebp
c0102ed5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102ed7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eda:	8b 00                	mov    (%eax),%eax
}
c0102edc:	5d                   	pop    %ebp
c0102edd:	c3                   	ret    

c0102ede <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102ede:	55                   	push   %ebp
c0102edf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ee7:	89 10                	mov    %edx,(%eax)
}
c0102ee9:	90                   	nop
c0102eea:	5d                   	pop    %ebp
c0102eeb:	c3                   	ret    

c0102eec <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102eec:	55                   	push   %ebp
c0102eed:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef2:	8b 00                	mov    (%eax),%eax
c0102ef4:	8d 50 01             	lea    0x1(%eax),%edx
c0102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102efa:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102efc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eff:	8b 00                	mov    (%eax),%eax
}
c0102f01:	5d                   	pop    %ebp
c0102f02:	c3                   	ret    

c0102f03 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102f03:	55                   	push   %ebp
c0102f04:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102f06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f09:	8b 00                	mov    (%eax),%eax
c0102f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102f0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f11:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f16:	8b 00                	mov    (%eax),%eax
}
c0102f18:	5d                   	pop    %ebp
c0102f19:	c3                   	ret    

c0102f1a <__intr_save>:
__intr_save(void) {
c0102f1a:	55                   	push   %ebp
c0102f1b:	89 e5                	mov    %esp,%ebp
c0102f1d:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102f20:	9c                   	pushf  
c0102f21:	58                   	pop    %eax
c0102f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102f28:	25 00 02 00 00       	and    $0x200,%eax
c0102f2d:	85 c0                	test   %eax,%eax
c0102f2f:	74 0c                	je     c0102f3d <__intr_save+0x23>
        intr_disable();
c0102f31:	e8 4f ea ff ff       	call   c0101985 <intr_disable>
        return 1;
c0102f36:	b8 01 00 00 00       	mov    $0x1,%eax
c0102f3b:	eb 05                	jmp    c0102f42 <__intr_save+0x28>
    return 0;
c0102f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102f42:	c9                   	leave  
c0102f43:	c3                   	ret    

c0102f44 <__intr_restore>:
__intr_restore(bool flag) {
c0102f44:	55                   	push   %ebp
c0102f45:	89 e5                	mov    %esp,%ebp
c0102f47:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102f4e:	74 05                	je     c0102f55 <__intr_restore+0x11>
        intr_enable();
c0102f50:	e8 24 ea ff ff       	call   c0101979 <intr_enable>
}
c0102f55:	90                   	nop
c0102f56:	c9                   	leave  
c0102f57:	c3                   	ret    

c0102f58 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102f58:	55                   	push   %ebp
c0102f59:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102f5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f5e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102f61:	b8 23 00 00 00       	mov    $0x23,%eax
c0102f66:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102f68:	b8 23 00 00 00       	mov    $0x23,%eax
c0102f6d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102f6f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f74:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102f76:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f7b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102f7d:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f82:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102f84:	ea 8b 2f 10 c0 08 00 	ljmp   $0x8,$0xc0102f8b
}
c0102f8b:	90                   	nop
c0102f8c:	5d                   	pop    %ebp
c0102f8d:	c3                   	ret    

c0102f8e <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102f8e:	f3 0f 1e fb          	endbr32 
c0102f92:	55                   	push   %ebp
c0102f93:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102f95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f98:	a3 a4 de 11 c0       	mov    %eax,0xc011dea4
}
c0102f9d:	90                   	nop
c0102f9e:	5d                   	pop    %ebp
c0102f9f:	c3                   	ret    

c0102fa0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102fa0:	f3 0f 1e fb          	endbr32 
c0102fa4:	55                   	push   %ebp
c0102fa5:	89 e5                	mov    %esp,%ebp
c0102fa7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102faa:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0102faf:	89 04 24             	mov    %eax,(%esp)
c0102fb2:	e8 d7 ff ff ff       	call   c0102f8e <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102fb7:	66 c7 05 a8 de 11 c0 	movw   $0x10,0xc011dea8
c0102fbe:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102fc0:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0102fc7:	68 00 
c0102fc9:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102fce:	0f b7 c0             	movzwl %ax,%eax
c0102fd1:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0102fd7:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102fdc:	c1 e8 10             	shr    $0x10,%eax
c0102fdf:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0102fe4:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102feb:	24 f0                	and    $0xf0,%al
c0102fed:	0c 09                	or     $0x9,%al
c0102fef:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102ff4:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102ffb:	24 ef                	and    $0xef,%al
c0102ffd:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0103002:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0103009:	24 9f                	and    $0x9f,%al
c010300b:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0103010:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0103017:	0c 80                	or     $0x80,%al
c0103019:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c010301e:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0103025:	24 f0                	and    $0xf0,%al
c0103027:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010302c:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0103033:	24 ef                	and    $0xef,%al
c0103035:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c010303a:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0103041:	24 df                	and    $0xdf,%al
c0103043:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0103048:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c010304f:	0c 40                	or     $0x40,%al
c0103051:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0103056:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c010305d:	24 7f                	and    $0x7f,%al
c010305f:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0103064:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0103069:	c1 e8 18             	shr    $0x18,%eax
c010306c:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103071:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c0103078:	e8 db fe ff ff       	call   c0102f58 <lgdt>
c010307d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103083:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103087:	0f 00 d8             	ltr    %ax
}
c010308a:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c010308b:	90                   	nop
c010308c:	c9                   	leave  
c010308d:	c3                   	ret    

c010308e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010308e:	f3 0f 1e fb          	endbr32 
c0103092:	55                   	push   %ebp
c0103093:	89 e5                	mov    %esp,%ebp
c0103095:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103098:	c7 05 70 df 11 c0 38 	movl   $0xc0107738,0xc011df70
c010309f:	77 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01030a2:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c01030a7:	8b 00                	mov    (%eax),%eax
c01030a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01030ad:	c7 04 24 90 6d 10 c0 	movl   $0xc0106d90,(%esp)
c01030b4:	e8 0c d2 ff ff       	call   c01002c5 <cprintf>
    pmm_manager->init();
c01030b9:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c01030be:	8b 40 04             	mov    0x4(%eax),%eax
c01030c1:	ff d0                	call   *%eax
}
c01030c3:	90                   	nop
c01030c4:	c9                   	leave  
c01030c5:	c3                   	ret    

c01030c6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01030c6:	f3 0f 1e fb          	endbr32 
c01030ca:	55                   	push   %ebp
c01030cb:	89 e5                	mov    %esp,%ebp
c01030cd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01030d0:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c01030d5:	8b 40 08             	mov    0x8(%eax),%eax
c01030d8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01030db:	89 54 24 04          	mov    %edx,0x4(%esp)
c01030df:	8b 55 08             	mov    0x8(%ebp),%edx
c01030e2:	89 14 24             	mov    %edx,(%esp)
c01030e5:	ff d0                	call   *%eax
}
c01030e7:	90                   	nop
c01030e8:	c9                   	leave  
c01030e9:	c3                   	ret    

c01030ea <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01030ea:	f3 0f 1e fb          	endbr32 
c01030ee:	55                   	push   %ebp
c01030ef:	89 e5                	mov    %esp,%ebp
c01030f1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01030f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01030fb:	e8 1a fe ff ff       	call   c0102f1a <__intr_save>
c0103100:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103103:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103108:	8b 40 0c             	mov    0xc(%eax),%eax
c010310b:	8b 55 08             	mov    0x8(%ebp),%edx
c010310e:	89 14 24             	mov    %edx,(%esp)
c0103111:	ff d0                	call   *%eax
c0103113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103116:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103119:	89 04 24             	mov    %eax,(%esp)
c010311c:	e8 23 fe ff ff       	call   c0102f44 <__intr_restore>
    return page;
c0103121:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103124:	c9                   	leave  
c0103125:	c3                   	ret    

c0103126 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103126:	f3 0f 1e fb          	endbr32 
c010312a:	55                   	push   %ebp
c010312b:	89 e5                	mov    %esp,%ebp
c010312d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103130:	e8 e5 fd ff ff       	call   c0102f1a <__intr_save>
c0103135:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103138:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c010313d:	8b 40 10             	mov    0x10(%eax),%eax
c0103140:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103143:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103147:	8b 55 08             	mov    0x8(%ebp),%edx
c010314a:	89 14 24             	mov    %edx,(%esp)
c010314d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103152:	89 04 24             	mov    %eax,(%esp)
c0103155:	e8 ea fd ff ff       	call   c0102f44 <__intr_restore>
}
c010315a:	90                   	nop
c010315b:	c9                   	leave  
c010315c:	c3                   	ret    

c010315d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010315d:	f3 0f 1e fb          	endbr32 
c0103161:	55                   	push   %ebp
c0103162:	89 e5                	mov    %esp,%ebp
c0103164:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103167:	e8 ae fd ff ff       	call   c0102f1a <__intr_save>
c010316c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010316f:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103174:	8b 40 14             	mov    0x14(%eax),%eax
c0103177:	ff d0                	call   *%eax
c0103179:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010317f:	89 04 24             	mov    %eax,(%esp)
c0103182:	e8 bd fd ff ff       	call   c0102f44 <__intr_restore>
    return ret;
c0103187:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010318a:	c9                   	leave  
c010318b:	c3                   	ret    

c010318c <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010318c:	f3 0f 1e fb          	endbr32 
c0103190:	55                   	push   %ebp
c0103191:	89 e5                	mov    %esp,%ebp
c0103193:	57                   	push   %edi
c0103194:	56                   	push   %esi
c0103195:	53                   	push   %ebx
c0103196:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010319c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01031a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01031aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01031b1:	c7 04 24 a7 6d 10 c0 	movl   $0xc0106da7,(%esp)
c01031b8:	e8 08 d1 ff ff       	call   c01002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01031bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01031c4:	e9 1a 01 00 00       	jmp    c01032e3 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01031c9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031cf:	89 d0                	mov    %edx,%eax
c01031d1:	c1 e0 02             	shl    $0x2,%eax
c01031d4:	01 d0                	add    %edx,%eax
c01031d6:	c1 e0 02             	shl    $0x2,%eax
c01031d9:	01 c8                	add    %ecx,%eax
c01031db:	8b 50 08             	mov    0x8(%eax),%edx
c01031de:	8b 40 04             	mov    0x4(%eax),%eax
c01031e1:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01031e4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01031e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031ed:	89 d0                	mov    %edx,%eax
c01031ef:	c1 e0 02             	shl    $0x2,%eax
c01031f2:	01 d0                	add    %edx,%eax
c01031f4:	c1 e0 02             	shl    $0x2,%eax
c01031f7:	01 c8                	add    %ecx,%eax
c01031f9:	8b 48 0c             	mov    0xc(%eax),%ecx
c01031fc:	8b 58 10             	mov    0x10(%eax),%ebx
c01031ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103202:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103205:	01 c8                	add    %ecx,%eax
c0103207:	11 da                	adc    %ebx,%edx
c0103209:	89 45 98             	mov    %eax,-0x68(%ebp)
c010320c:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010320f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103212:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103215:	89 d0                	mov    %edx,%eax
c0103217:	c1 e0 02             	shl    $0x2,%eax
c010321a:	01 d0                	add    %edx,%eax
c010321c:	c1 e0 02             	shl    $0x2,%eax
c010321f:	01 c8                	add    %ecx,%eax
c0103221:	83 c0 14             	add    $0x14,%eax
c0103224:	8b 00                	mov    (%eax),%eax
c0103226:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103229:	8b 45 98             	mov    -0x68(%ebp),%eax
c010322c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010322f:	83 c0 ff             	add    $0xffffffff,%eax
c0103232:	83 d2 ff             	adc    $0xffffffff,%edx
c0103235:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c010323b:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0103241:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103244:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103247:	89 d0                	mov    %edx,%eax
c0103249:	c1 e0 02             	shl    $0x2,%eax
c010324c:	01 d0                	add    %edx,%eax
c010324e:	c1 e0 02             	shl    $0x2,%eax
c0103251:	01 c8                	add    %ecx,%eax
c0103253:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103256:	8b 58 10             	mov    0x10(%eax),%ebx
c0103259:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010325c:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0103260:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103266:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010326c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103270:	89 54 24 18          	mov    %edx,0x18(%esp)
c0103274:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103277:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010327a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010327e:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103286:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010328a:	c7 04 24 b4 6d 10 c0 	movl   $0xc0106db4,(%esp)
c0103291:	e8 2f d0 ff ff       	call   c01002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103296:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103299:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010329c:	89 d0                	mov    %edx,%eax
c010329e:	c1 e0 02             	shl    $0x2,%eax
c01032a1:	01 d0                	add    %edx,%eax
c01032a3:	c1 e0 02             	shl    $0x2,%eax
c01032a6:	01 c8                	add    %ecx,%eax
c01032a8:	83 c0 14             	add    $0x14,%eax
c01032ab:	8b 00                	mov    (%eax),%eax
c01032ad:	83 f8 01             	cmp    $0x1,%eax
c01032b0:	75 2e                	jne    c01032e0 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c01032b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032b8:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01032bb:	89 d0                	mov    %edx,%eax
c01032bd:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c01032c0:	73 1e                	jae    c01032e0 <page_init+0x154>
c01032c2:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01032c7:	b8 00 00 00 00       	mov    $0x0,%eax
c01032cc:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c01032cf:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c01032d2:	72 0c                	jb     c01032e0 <page_init+0x154>
                maxpa = end;
c01032d4:	8b 45 98             	mov    -0x68(%ebp),%eax
c01032d7:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01032da:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01032dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c01032e0:	ff 45 dc             	incl   -0x24(%ebp)
c01032e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032e6:	8b 00                	mov    (%eax),%eax
c01032e8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032eb:	0f 8c d8 fe ff ff    	jl     c01031c9 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01032f1:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01032f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01032fb:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c01032fe:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103301:	73 0e                	jae    c0103311 <page_init+0x185>
        maxpa = KMEMSIZE;
c0103303:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010330a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103311:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103317:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010331b:	c1 ea 0c             	shr    $0xc,%edx
c010331e:	a3 80 de 11 c0       	mov    %eax,0xc011de80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103323:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c010332a:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c010332f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103332:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103335:	01 d0                	add    %edx,%eax
c0103337:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010333a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010333d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103342:	f7 75 c0             	divl   -0x40(%ebp)
c0103345:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103348:	29 d0                	sub    %edx,%eax
c010334a:	a3 78 df 11 c0       	mov    %eax,0xc011df78

    for (i = 0; i < npage; i ++) {
c010334f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103356:	eb 2f                	jmp    c0103387 <page_init+0x1fb>
        SetPageReserved(pages + i);
c0103358:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c010335e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103361:	89 d0                	mov    %edx,%eax
c0103363:	c1 e0 02             	shl    $0x2,%eax
c0103366:	01 d0                	add    %edx,%eax
c0103368:	c1 e0 02             	shl    $0x2,%eax
c010336b:	01 c8                	add    %ecx,%eax
c010336d:	83 c0 04             	add    $0x4,%eax
c0103370:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103377:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010337a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010337d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103380:	0f ab 10             	bts    %edx,(%eax)
}
c0103383:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103384:	ff 45 dc             	incl   -0x24(%ebp)
c0103387:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010338a:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010338f:	39 c2                	cmp    %eax,%edx
c0103391:	72 c5                	jb     c0103358 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103393:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0103399:	89 d0                	mov    %edx,%eax
c010339b:	c1 e0 02             	shl    $0x2,%eax
c010339e:	01 d0                	add    %edx,%eax
c01033a0:	c1 e0 02             	shl    $0x2,%eax
c01033a3:	89 c2                	mov    %eax,%edx
c01033a5:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c01033aa:	01 d0                	add    %edx,%eax
c01033ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01033af:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01033b6:	77 23                	ja     c01033db <page_init+0x24f>
c01033b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01033bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01033bf:	c7 44 24 08 e4 6d 10 	movl   $0xc0106de4,0x8(%esp)
c01033c6:	c0 
c01033c7:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01033ce:	00 
c01033cf:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01033d6:	e8 56 d0 ff ff       	call   c0100431 <__panic>
c01033db:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01033de:	05 00 00 00 40       	add    $0x40000000,%eax
c01033e3:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01033e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01033ed:	e9 4b 01 00 00       	jmp    c010353d <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01033f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033f8:	89 d0                	mov    %edx,%eax
c01033fa:	c1 e0 02             	shl    $0x2,%eax
c01033fd:	01 d0                	add    %edx,%eax
c01033ff:	c1 e0 02             	shl    $0x2,%eax
c0103402:	01 c8                	add    %ecx,%eax
c0103404:	8b 50 08             	mov    0x8(%eax),%edx
c0103407:	8b 40 04             	mov    0x4(%eax),%eax
c010340a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010340d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103410:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103413:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103416:	89 d0                	mov    %edx,%eax
c0103418:	c1 e0 02             	shl    $0x2,%eax
c010341b:	01 d0                	add    %edx,%eax
c010341d:	c1 e0 02             	shl    $0x2,%eax
c0103420:	01 c8                	add    %ecx,%eax
c0103422:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103425:	8b 58 10             	mov    0x10(%eax),%ebx
c0103428:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010342b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010342e:	01 c8                	add    %ecx,%eax
c0103430:	11 da                	adc    %ebx,%edx
c0103432:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103435:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103438:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010343b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010343e:	89 d0                	mov    %edx,%eax
c0103440:	c1 e0 02             	shl    $0x2,%eax
c0103443:	01 d0                	add    %edx,%eax
c0103445:	c1 e0 02             	shl    $0x2,%eax
c0103448:	01 c8                	add    %ecx,%eax
c010344a:	83 c0 14             	add    $0x14,%eax
c010344d:	8b 00                	mov    (%eax),%eax
c010344f:	83 f8 01             	cmp    $0x1,%eax
c0103452:	0f 85 e2 00 00 00    	jne    c010353a <page_init+0x3ae>
            if (begin < freemem) {
c0103458:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010345b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103460:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103463:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103466:	19 d1                	sbb    %edx,%ecx
c0103468:	73 0d                	jae    c0103477 <page_init+0x2eb>
                begin = freemem;
c010346a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010346d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103470:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103477:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010347c:	b8 00 00 00 00       	mov    $0x0,%eax
c0103481:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103484:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103487:	73 0e                	jae    c0103497 <page_init+0x30b>
                end = KMEMSIZE;
c0103489:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103490:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103497:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010349a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010349d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01034a0:	89 d0                	mov    %edx,%eax
c01034a2:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01034a5:	0f 83 8f 00 00 00    	jae    c010353a <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c01034ab:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01034b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034b8:	01 d0                	add    %edx,%eax
c01034ba:	48                   	dec    %eax
c01034bb:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01034be:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01034c6:	f7 75 b0             	divl   -0x50(%ebp)
c01034c9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034cc:	29 d0                	sub    %edx,%eax
c01034ce:	ba 00 00 00 00       	mov    $0x0,%edx
c01034d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01034d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01034d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034dc:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01034df:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01034e2:	ba 00 00 00 00       	mov    $0x0,%edx
c01034e7:	89 c3                	mov    %eax,%ebx
c01034e9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01034ef:	89 de                	mov    %ebx,%esi
c01034f1:	89 d0                	mov    %edx,%eax
c01034f3:	83 e0 00             	and    $0x0,%eax
c01034f6:	89 c7                	mov    %eax,%edi
c01034f8:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01034fb:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01034fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103501:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103504:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103507:	89 d0                	mov    %edx,%eax
c0103509:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010350c:	73 2c                	jae    c010353a <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010350e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103511:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103514:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103517:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010351a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010351e:	c1 ea 0c             	shr    $0xc,%edx
c0103521:	89 c3                	mov    %eax,%ebx
c0103523:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103526:	89 04 24             	mov    %eax,(%esp)
c0103529:	e8 ad f8 ff ff       	call   c0102ddb <pa2page>
c010352e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103532:	89 04 24             	mov    %eax,(%esp)
c0103535:	e8 8c fb ff ff       	call   c01030c6 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010353a:	ff 45 dc             	incl   -0x24(%ebp)
c010353d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103540:	8b 00                	mov    (%eax),%eax
c0103542:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103545:	0f 8c a7 fe ff ff    	jl     c01033f2 <page_init+0x266>
                }
            }
        }
    }
}
c010354b:	90                   	nop
c010354c:	90                   	nop
c010354d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103553:	5b                   	pop    %ebx
c0103554:	5e                   	pop    %esi
c0103555:	5f                   	pop    %edi
c0103556:	5d                   	pop    %ebp
c0103557:	c3                   	ret    

c0103558 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103558:	f3 0f 1e fb          	endbr32 
c010355c:	55                   	push   %ebp
c010355d:	89 e5                	mov    %esp,%ebp
c010355f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103565:	33 45 14             	xor    0x14(%ebp),%eax
c0103568:	25 ff 0f 00 00       	and    $0xfff,%eax
c010356d:	85 c0                	test   %eax,%eax
c010356f:	74 24                	je     c0103595 <boot_map_segment+0x3d>
c0103571:	c7 44 24 0c 16 6e 10 	movl   $0xc0106e16,0xc(%esp)
c0103578:	c0 
c0103579:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103580:	c0 
c0103581:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103588:	00 
c0103589:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103590:	e8 9c ce ff ff       	call   c0100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103595:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010359c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010359f:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035a4:	89 c2                	mov    %eax,%edx
c01035a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01035a9:	01 c2                	add    %eax,%edx
c01035ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ae:	01 d0                	add    %edx,%eax
c01035b0:	48                   	dec    %eax
c01035b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035b7:	ba 00 00 00 00       	mov    $0x0,%edx
c01035bc:	f7 75 f0             	divl   -0x10(%ebp)
c01035bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c2:	29 d0                	sub    %edx,%eax
c01035c4:	c1 e8 0c             	shr    $0xc,%eax
c01035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01035ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01035d8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01035db:	8b 45 14             	mov    0x14(%ebp),%eax
c01035de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01035e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01035e9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01035ec:	eb 68                	jmp    c0103656 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01035ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01035f5:	00 
c01035f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103600:	89 04 24             	mov    %eax,(%esp)
c0103603:	e8 8a 01 00 00       	call   c0103792 <get_pte>
c0103608:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010360b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010360f:	75 24                	jne    c0103635 <boot_map_segment+0xdd>
c0103611:	c7 44 24 0c 42 6e 10 	movl   $0xc0106e42,0xc(%esp)
c0103618:	c0 
c0103619:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103620:	c0 
c0103621:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103628:	00 
c0103629:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103630:	e8 fc cd ff ff       	call   c0100431 <__panic>
        *ptep = pa | PTE_P | perm;
c0103635:	8b 45 14             	mov    0x14(%ebp),%eax
c0103638:	0b 45 18             	or     0x18(%ebp),%eax
c010363b:	83 c8 01             	or     $0x1,%eax
c010363e:	89 c2                	mov    %eax,%edx
c0103640:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103643:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103645:	ff 4d f4             	decl   -0xc(%ebp)
c0103648:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010364f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010365a:	75 92                	jne    c01035ee <boot_map_segment+0x96>
    }
}
c010365c:	90                   	nop
c010365d:	90                   	nop
c010365e:	c9                   	leave  
c010365f:	c3                   	ret    

c0103660 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103660:	f3 0f 1e fb          	endbr32 
c0103664:	55                   	push   %ebp
c0103665:	89 e5                	mov    %esp,%ebp
c0103667:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010366a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103671:	e8 74 fa ff ff       	call   c01030ea <alloc_pages>
c0103676:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010367d:	75 1c                	jne    c010369b <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c010367f:	c7 44 24 08 4f 6e 10 	movl   $0xc0106e4f,0x8(%esp)
c0103686:	c0 
c0103687:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010368e:	00 
c010368f:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103696:	e8 96 cd ff ff       	call   c0100431 <__panic>
    }
    return page2kva(p);
c010369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010369e:	89 04 24             	mov    %eax,(%esp)
c01036a1:	e8 84 f7 ff ff       	call   c0102e2a <page2kva>
}
c01036a6:	c9                   	leave  
c01036a7:	c3                   	ret    

c01036a8 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01036a8:	f3 0f 1e fb          	endbr32 
c01036ac:	55                   	push   %ebp
c01036ad:	89 e5                	mov    %esp,%ebp
c01036af:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01036b2:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01036b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036ba:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01036c1:	77 23                	ja     c01036e6 <pmm_init+0x3e>
c01036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036ca:	c7 44 24 08 e4 6d 10 	movl   $0xc0106de4,0x8(%esp)
c01036d1:	c0 
c01036d2:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01036d9:	00 
c01036da:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01036e1:	e8 4b cd ff ff       	call   c0100431 <__panic>
c01036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e9:	05 00 00 00 40       	add    $0x40000000,%eax
c01036ee:	a3 74 df 11 c0       	mov    %eax,0xc011df74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01036f3:	e8 96 f9 ff ff       	call   c010308e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01036f8:	e8 8f fa ff ff       	call   c010318c <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01036fd:	e8 f3 03 00 00       	call   c0103af5 <check_alloc_page>

    check_pgdir();
c0103702:	e8 11 04 00 00       	call   c0103b18 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103707:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010370c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010370f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103716:	77 23                	ja     c010373b <pmm_init+0x93>
c0103718:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010371b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010371f:	c7 44 24 08 e4 6d 10 	movl   $0xc0106de4,0x8(%esp)
c0103726:	c0 
c0103727:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010372e:	00 
c010372f:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103736:	e8 f6 cc ff ff       	call   c0100431 <__panic>
c010373b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010373e:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103744:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103749:	05 ac 0f 00 00       	add    $0xfac,%eax
c010374e:	83 ca 03             	or     $0x3,%edx
c0103751:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103753:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103758:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010375f:	00 
c0103760:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103767:	00 
c0103768:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010376f:	38 
c0103770:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103777:	c0 
c0103778:	89 04 24             	mov    %eax,(%esp)
c010377b:	e8 d8 fd ff ff       	call   c0103558 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103780:	e8 1b f8 ff ff       	call   c0102fa0 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103785:	e8 2e 0a 00 00       	call   c01041b8 <check_boot_pgdir>

    print_pgdir();
c010378a:	e8 b3 0e 00 00       	call   c0104642 <print_pgdir>

}
c010378f:	90                   	nop
c0103790:	c9                   	leave  
c0103791:	c3                   	ret    

c0103792 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103792:	f3 0f 1e fb          	endbr32 
c0103796:	55                   	push   %ebp
c0103797:	89 e5                	mov    %esp,%ebp
c0103799:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = &pgdir[PDX(la)];//获取页表
c010379c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010379f:	c1 e8 16             	shr    $0x16,%eax
c01037a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01037a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ac:	01 d0                	add    %edx,%eax
c01037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果页表不存在，尝试新建一个页表
c01037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037b4:	8b 00                	mov    (%eax),%eax
c01037b6:	83 e0 01             	and    $0x1,%eax
c01037b9:	85 c0                	test   %eax,%eax
c01037bb:	0f 85 af 00 00 00    	jne    c0103870 <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {//如果不需要创建或者分配失败，返回null
c01037c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01037c5:	74 15                	je     c01037dc <get_pte+0x4a>
c01037c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037ce:	e8 17 f9 ff ff       	call   c01030ea <alloc_pages>
c01037d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037da:	75 0a                	jne    c01037e6 <get_pte+0x54>
            return NULL;
c01037dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01037e1:	e9 e7 00 00 00       	jmp    c01038cd <get_pte+0x13b>
        }
        set_page_ref(page, 1);//第一次创建，只有一个引用
c01037e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037ed:	00 
c01037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037f1:	89 04 24             	mov    %eax,(%esp)
c01037f4:	e8 e5 f6 ff ff       	call   c0102ede <set_page_ref>
        uintptr_t pa = page2pa(page);//转换成物理地址
c01037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037fc:	89 04 24             	mov    %eax,(%esp)
c01037ff:	e8 c1 f5 ff ff       	call   c0102dc5 <page2pa>
c0103804:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//将对应物理地址置零
c0103807:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010380a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010380d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103810:	c1 e8 0c             	shr    $0xc,%eax
c0103813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103816:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010381b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010381e:	72 23                	jb     c0103843 <get_pte+0xb1>
c0103820:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103823:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103827:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c010382e:	c0 
c010382f:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
c0103836:	00 
c0103837:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010383e:	e8 ee cb ff ff       	call   c0100431 <__panic>
c0103843:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103846:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010384b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103852:	00 
c0103853:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010385a:	00 
c010385b:	89 04 24             	mov    %eax,(%esp)
c010385e:	e8 2a 25 00 00       	call   c0105d8d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;//设置控制位
c0103863:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103866:	83 c8 07             	or     $0x7,%eax
c0103869:	89 c2                	mov    %eax,%edx
c010386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010386e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0103870:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103873:	8b 00                	mov    (%eax),%eax
c0103875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010387a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010387d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103880:	c1 e8 0c             	shr    $0xc,%eax
c0103883:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103886:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010388b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010388e:	72 23                	jb     c01038b3 <get_pte+0x121>
c0103890:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103893:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103897:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c010389e:	c0 
c010389f:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
c01038a6:	00 
c01038a7:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01038ae:	e8 7e cb ff ff       	call   c0100431 <__panic>
c01038b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01038bb:	89 c2                	mov    %eax,%edx
c01038bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038c0:	c1 e8 0c             	shr    $0xc,%eax
c01038c3:	25 ff 03 00 00       	and    $0x3ff,%eax
c01038c8:	c1 e0 02             	shl    $0x2,%eax
c01038cb:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01038cd:	c9                   	leave  
c01038ce:	c3                   	ret    

c01038cf <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01038cf:	f3 0f 1e fb          	endbr32 
c01038d3:	55                   	push   %ebp
c01038d4:	89 e5                	mov    %esp,%ebp
c01038d6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01038d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038e0:	00 
c01038e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01038eb:	89 04 24             	mov    %eax,(%esp)
c01038ee:	e8 9f fe ff ff       	call   c0103792 <get_pte>
c01038f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01038f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01038fa:	74 08                	je     c0103904 <get_page+0x35>
        *ptep_store = ptep;
c01038fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01038ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103902:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103908:	74 1b                	je     c0103925 <get_page+0x56>
c010390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010390d:	8b 00                	mov    (%eax),%eax
c010390f:	83 e0 01             	and    $0x1,%eax
c0103912:	85 c0                	test   %eax,%eax
c0103914:	74 0f                	je     c0103925 <get_page+0x56>
        return pte2page(*ptep);
c0103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103919:	8b 00                	mov    (%eax),%eax
c010391b:	89 04 24             	mov    %eax,(%esp)
c010391e:	e8 5b f5 ff ff       	call   c0102e7e <pte2page>
c0103923:	eb 05                	jmp    c010392a <get_page+0x5b>
    }
    return NULL;
c0103925:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010392a:	c9                   	leave  
c010392b:	c3                   	ret    

c010392c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010392c:	55                   	push   %ebp
c010392d:	89 e5                	mov    %esp,%ebp
c010392f:	83 ec 28             	sub    $0x28,%esp
                                  //(3) decrease page reference
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    } */
    if (*ptep & PTE_P) {
c0103932:	8b 45 10             	mov    0x10(%ebp),%eax
c0103935:	8b 00                	mov    (%eax),%eax
c0103937:	83 e0 01             	and    $0x1,%eax
c010393a:	85 c0                	test   %eax,%eax
c010393c:	74 4d                	je     c010398b <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c010393e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103941:	8b 00                	mov    (%eax),%eax
c0103943:	89 04 24             	mov    %eax,(%esp)
c0103946:	e8 33 f5 ff ff       	call   c0102e7e <pte2page>
c010394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103951:	89 04 24             	mov    %eax,(%esp)
c0103954:	e8 aa f5 ff ff       	call   c0102f03 <page_ref_dec>
c0103959:	85 c0                	test   %eax,%eax
c010395b:	75 13                	jne    c0103970 <page_remove_pte+0x44>
            free_page(page);
c010395d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103964:	00 
c0103965:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103968:	89 04 24             	mov    %eax,(%esp)
c010396b:	e8 b6 f7 ff ff       	call   c0103126 <free_pages>
        }
        *ptep = 0;
c0103970:	8b 45 10             	mov    0x10(%ebp),%eax
c0103973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0103979:	8b 45 0c             	mov    0xc(%ebp),%eax
c010397c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103980:	8b 45 08             	mov    0x8(%ebp),%eax
c0103983:	89 04 24             	mov    %eax,(%esp)
c0103986:	e8 09 01 00 00       	call   c0103a94 <tlb_invalidate>
    }
}
c010398b:	90                   	nop
c010398c:	c9                   	leave  
c010398d:	c3                   	ret    

c010398e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010398e:	f3 0f 1e fb          	endbr32 
c0103992:	55                   	push   %ebp
c0103993:	89 e5                	mov    %esp,%ebp
c0103995:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103998:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010399f:	00 
c01039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039aa:	89 04 24             	mov    %eax,(%esp)
c01039ad:	e8 e0 fd ff ff       	call   c0103792 <get_pte>
c01039b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01039b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039b9:	74 19                	je     c01039d4 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c01039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039be:	89 44 24 08          	mov    %eax,0x8(%esp)
c01039c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cc:	89 04 24             	mov    %eax,(%esp)
c01039cf:	e8 58 ff ff ff       	call   c010392c <page_remove_pte>
    }
}
c01039d4:	90                   	nop
c01039d5:	c9                   	leave  
c01039d6:	c3                   	ret    

c01039d7 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01039d7:	f3 0f 1e fb          	endbr32 
c01039db:	55                   	push   %ebp
c01039dc:	89 e5                	mov    %esp,%ebp
c01039de:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01039e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01039e8:	00 
c01039e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01039ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f3:	89 04 24             	mov    %eax,(%esp)
c01039f6:	e8 97 fd ff ff       	call   c0103792 <get_pte>
c01039fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01039fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a02:	75 0a                	jne    c0103a0e <page_insert+0x37>
        return -E_NO_MEM;
c0103a04:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103a09:	e9 84 00 00 00       	jmp    c0103a92 <page_insert+0xbb>
    }
    page_ref_inc(page);
c0103a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a11:	89 04 24             	mov    %eax,(%esp)
c0103a14:	e8 d3 f4 ff ff       	call   c0102eec <page_ref_inc>
    if (*ptep & PTE_P) {
c0103a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a1c:	8b 00                	mov    (%eax),%eax
c0103a1e:	83 e0 01             	and    $0x1,%eax
c0103a21:	85 c0                	test   %eax,%eax
c0103a23:	74 3e                	je     c0103a63 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c0103a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a28:	8b 00                	mov    (%eax),%eax
c0103a2a:	89 04 24             	mov    %eax,(%esp)
c0103a2d:	e8 4c f4 ff ff       	call   c0102e7e <pte2page>
c0103a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a38:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a3b:	75 0d                	jne    c0103a4a <page_insert+0x73>
            page_ref_dec(page);
c0103a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a40:	89 04 24             	mov    %eax,(%esp)
c0103a43:	e8 bb f4 ff ff       	call   c0102f03 <page_ref_dec>
c0103a48:	eb 19                	jmp    c0103a63 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103a51:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5b:	89 04 24             	mov    %eax,(%esp)
c0103a5e:	e8 c9 fe ff ff       	call   c010392c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103a63:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a66:	89 04 24             	mov    %eax,(%esp)
c0103a69:	e8 57 f3 ff ff       	call   c0102dc5 <page2pa>
c0103a6e:	0b 45 14             	or     0x14(%ebp),%eax
c0103a71:	83 c8 01             	or     $0x1,%eax
c0103a74:	89 c2                	mov    %eax,%edx
c0103a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a79:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103a7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a85:	89 04 24             	mov    %eax,(%esp)
c0103a88:	e8 07 00 00 00       	call   c0103a94 <tlb_invalidate>
    return 0;
c0103a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a92:	c9                   	leave  
c0103a93:	c3                   	ret    

c0103a94 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103a94:	f3 0f 1e fb          	endbr32 
c0103a98:	55                   	push   %ebp
c0103a99:	89 e5                	mov    %esp,%ebp
c0103a9b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103a9e:	0f 20 d8             	mov    %cr3,%eax
c0103aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aad:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103ab4:	77 23                	ja     c0103ad9 <tlb_invalidate+0x45>
c0103ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103abd:	c7 44 24 08 e4 6d 10 	movl   $0xc0106de4,0x8(%esp)
c0103ac4:	c0 
c0103ac5:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c0103acc:	00 
c0103acd:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103ad4:	e8 58 c9 ff ff       	call   c0100431 <__panic>
c0103ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103adc:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ae1:	39 d0                	cmp    %edx,%eax
c0103ae3:	75 0d                	jne    c0103af2 <tlb_invalidate+0x5e>
        invlpg((void *)la);
c0103ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aee:	0f 01 38             	invlpg (%eax)
}
c0103af1:	90                   	nop
    }
}
c0103af2:	90                   	nop
c0103af3:	c9                   	leave  
c0103af4:	c3                   	ret    

c0103af5 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103af5:	f3 0f 1e fb          	endbr32 
c0103af9:	55                   	push   %ebp
c0103afa:	89 e5                	mov    %esp,%ebp
c0103afc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103aff:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103b04:	8b 40 18             	mov    0x18(%eax),%eax
c0103b07:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103b09:	c7 04 24 68 6e 10 c0 	movl   $0xc0106e68,(%esp)
c0103b10:	e8 b0 c7 ff ff       	call   c01002c5 <cprintf>
}
c0103b15:	90                   	nop
c0103b16:	c9                   	leave  
c0103b17:	c3                   	ret    

c0103b18 <check_pgdir>:

static void
check_pgdir(void) {
c0103b18:	f3 0f 1e fb          	endbr32 
c0103b1c:	55                   	push   %ebp
c0103b1d:	89 e5                	mov    %esp,%ebp
c0103b1f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103b22:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103b27:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103b2c:	76 24                	jbe    c0103b52 <check_pgdir+0x3a>
c0103b2e:	c7 44 24 0c 87 6e 10 	movl   $0xc0106e87,0xc(%esp)
c0103b35:	c0 
c0103b36:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103b3d:	c0 
c0103b3e:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0103b45:	00 
c0103b46:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103b4d:	e8 df c8 ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103b52:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b57:	85 c0                	test   %eax,%eax
c0103b59:	74 0e                	je     c0103b69 <check_pgdir+0x51>
c0103b5b:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b60:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103b65:	85 c0                	test   %eax,%eax
c0103b67:	74 24                	je     c0103b8d <check_pgdir+0x75>
c0103b69:	c7 44 24 0c a4 6e 10 	movl   $0xc0106ea4,0xc(%esp)
c0103b70:	c0 
c0103b71:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103b78:	c0 
c0103b79:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0103b80:	00 
c0103b81:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103b88:	e8 a4 c8 ff ff       	call   c0100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103b8d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b99:	00 
c0103b9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103ba1:	00 
c0103ba2:	89 04 24             	mov    %eax,(%esp)
c0103ba5:	e8 25 fd ff ff       	call   c01038cf <get_page>
c0103baa:	85 c0                	test   %eax,%eax
c0103bac:	74 24                	je     c0103bd2 <check_pgdir+0xba>
c0103bae:	c7 44 24 0c dc 6e 10 	movl   $0xc0106edc,0xc(%esp)
c0103bb5:	c0 
c0103bb6:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103bbd:	c0 
c0103bbe:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103bc5:	00 
c0103bc6:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103bcd:	e8 5f c8 ff ff       	call   c0100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103bd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bd9:	e8 0c f5 ff ff       	call   c01030ea <alloc_pages>
c0103bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103be1:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103be6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103bed:	00 
c0103bee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103bf5:	00 
c0103bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103bf9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bfd:	89 04 24             	mov    %eax,(%esp)
c0103c00:	e8 d2 fd ff ff       	call   c01039d7 <page_insert>
c0103c05:	85 c0                	test   %eax,%eax
c0103c07:	74 24                	je     c0103c2d <check_pgdir+0x115>
c0103c09:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0103c10:	c0 
c0103c11:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103c18:	c0 
c0103c19:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103c20:	00 
c0103c21:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103c28:	e8 04 c8 ff ff       	call   c0100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103c2d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103c32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c39:	00 
c0103c3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103c41:	00 
c0103c42:	89 04 24             	mov    %eax,(%esp)
c0103c45:	e8 48 fb ff ff       	call   c0103792 <get_pte>
c0103c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c51:	75 24                	jne    c0103c77 <check_pgdir+0x15f>
c0103c53:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0103c5a:	c0 
c0103c5b:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103c62:	c0 
c0103c63:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103c6a:	00 
c0103c6b:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103c72:	e8 ba c7 ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c0103c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c7a:	8b 00                	mov    (%eax),%eax
c0103c7c:	89 04 24             	mov    %eax,(%esp)
c0103c7f:	e8 fa f1 ff ff       	call   c0102e7e <pte2page>
c0103c84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103c87:	74 24                	je     c0103cad <check_pgdir+0x195>
c0103c89:	c7 44 24 0c 5d 6f 10 	movl   $0xc0106f5d,0xc(%esp)
c0103c90:	c0 
c0103c91:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103c98:	c0 
c0103c99:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103ca0:	00 
c0103ca1:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103ca8:	e8 84 c7 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 1);
c0103cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb0:	89 04 24             	mov    %eax,(%esp)
c0103cb3:	e8 1c f2 ff ff       	call   c0102ed4 <page_ref>
c0103cb8:	83 f8 01             	cmp    $0x1,%eax
c0103cbb:	74 24                	je     c0103ce1 <check_pgdir+0x1c9>
c0103cbd:	c7 44 24 0c 73 6f 10 	movl   $0xc0106f73,0xc(%esp)
c0103cc4:	c0 
c0103cc5:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103ccc:	c0 
c0103ccd:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103cd4:	00 
c0103cd5:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103cdc:	e8 50 c7 ff ff       	call   c0100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103ce1:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103ce6:	8b 00                	mov    (%eax),%eax
c0103ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cf3:	c1 e8 0c             	shr    $0xc,%eax
c0103cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103cf9:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103cfe:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103d01:	72 23                	jb     c0103d26 <check_pgdir+0x20e>
c0103d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d06:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d0a:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c0103d11:	c0 
c0103d12:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103d19:	00 
c0103d1a:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103d21:	e8 0b c7 ff ff       	call   c0100431 <__panic>
c0103d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d29:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103d2e:	83 c0 04             	add    $0x4,%eax
c0103d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103d34:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d40:	00 
c0103d41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d48:	00 
c0103d49:	89 04 24             	mov    %eax,(%esp)
c0103d4c:	e8 41 fa ff ff       	call   c0103792 <get_pte>
c0103d51:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103d54:	74 24                	je     c0103d7a <check_pgdir+0x262>
c0103d56:	c7 44 24 0c 88 6f 10 	movl   $0xc0106f88,0xc(%esp)
c0103d5d:	c0 
c0103d5e:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103d65:	c0 
c0103d66:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103d6d:	00 
c0103d6e:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103d75:	e8 b7 c6 ff ff       	call   c0100431 <__panic>

    p2 = alloc_page();
c0103d7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d81:	e8 64 f3 ff ff       	call   c01030ea <alloc_pages>
c0103d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103d89:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d8e:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103d95:	00 
c0103d96:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103d9d:	00 
c0103d9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103da1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103da5:	89 04 24             	mov    %eax,(%esp)
c0103da8:	e8 2a fc ff ff       	call   c01039d7 <page_insert>
c0103dad:	85 c0                	test   %eax,%eax
c0103daf:	74 24                	je     c0103dd5 <check_pgdir+0x2bd>
c0103db1:	c7 44 24 0c b0 6f 10 	movl   $0xc0106fb0,0xc(%esp)
c0103db8:	c0 
c0103db9:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103dc0:	c0 
c0103dc1:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103dc8:	00 
c0103dc9:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103dd0:	e8 5c c6 ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103dd5:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103dda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103de1:	00 
c0103de2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103de9:	00 
c0103dea:	89 04 24             	mov    %eax,(%esp)
c0103ded:	e8 a0 f9 ff ff       	call   c0103792 <get_pte>
c0103df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103df9:	75 24                	jne    c0103e1f <check_pgdir+0x307>
c0103dfb:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0103e02:	c0 
c0103e03:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103e0a:	c0 
c0103e0b:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103e12:	00 
c0103e13:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103e1a:	e8 12 c6 ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_U);
c0103e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e22:	8b 00                	mov    (%eax),%eax
c0103e24:	83 e0 04             	and    $0x4,%eax
c0103e27:	85 c0                	test   %eax,%eax
c0103e29:	75 24                	jne    c0103e4f <check_pgdir+0x337>
c0103e2b:	c7 44 24 0c 18 70 10 	movl   $0xc0107018,0xc(%esp)
c0103e32:	c0 
c0103e33:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103e3a:	c0 
c0103e3b:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103e42:	00 
c0103e43:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103e4a:	e8 e2 c5 ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_W);
c0103e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e52:	8b 00                	mov    (%eax),%eax
c0103e54:	83 e0 02             	and    $0x2,%eax
c0103e57:	85 c0                	test   %eax,%eax
c0103e59:	75 24                	jne    c0103e7f <check_pgdir+0x367>
c0103e5b:	c7 44 24 0c 26 70 10 	movl   $0xc0107026,0xc(%esp)
c0103e62:	c0 
c0103e63:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103e6a:	c0 
c0103e6b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103e72:	00 
c0103e73:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103e7a:	e8 b2 c5 ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103e7f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e84:	8b 00                	mov    (%eax),%eax
c0103e86:	83 e0 04             	and    $0x4,%eax
c0103e89:	85 c0                	test   %eax,%eax
c0103e8b:	75 24                	jne    c0103eb1 <check_pgdir+0x399>
c0103e8d:	c7 44 24 0c 34 70 10 	movl   $0xc0107034,0xc(%esp)
c0103e94:	c0 
c0103e95:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103e9c:	c0 
c0103e9d:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103ea4:	00 
c0103ea5:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103eac:	e8 80 c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 1);
c0103eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103eb4:	89 04 24             	mov    %eax,(%esp)
c0103eb7:	e8 18 f0 ff ff       	call   c0102ed4 <page_ref>
c0103ebc:	83 f8 01             	cmp    $0x1,%eax
c0103ebf:	74 24                	je     c0103ee5 <check_pgdir+0x3cd>
c0103ec1:	c7 44 24 0c 4a 70 10 	movl   $0xc010704a,0xc(%esp)
c0103ec8:	c0 
c0103ec9:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103ed0:	c0 
c0103ed1:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103ed8:	00 
c0103ed9:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103ee0:	e8 4c c5 ff ff       	call   c0100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103ee5:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103eea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103ef1:	00 
c0103ef2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103ef9:	00 
c0103efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103efd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f01:	89 04 24             	mov    %eax,(%esp)
c0103f04:	e8 ce fa ff ff       	call   c01039d7 <page_insert>
c0103f09:	85 c0                	test   %eax,%eax
c0103f0b:	74 24                	je     c0103f31 <check_pgdir+0x419>
c0103f0d:	c7 44 24 0c 5c 70 10 	movl   $0xc010705c,0xc(%esp)
c0103f14:	c0 
c0103f15:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103f1c:	c0 
c0103f1d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103f24:	00 
c0103f25:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103f2c:	e8 00 c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 2);
c0103f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f34:	89 04 24             	mov    %eax,(%esp)
c0103f37:	e8 98 ef ff ff       	call   c0102ed4 <page_ref>
c0103f3c:	83 f8 02             	cmp    $0x2,%eax
c0103f3f:	74 24                	je     c0103f65 <check_pgdir+0x44d>
c0103f41:	c7 44 24 0c 88 70 10 	movl   $0xc0107088,0xc(%esp)
c0103f48:	c0 
c0103f49:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103f50:	c0 
c0103f51:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103f58:	00 
c0103f59:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103f60:	e8 cc c4 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0103f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f68:	89 04 24             	mov    %eax,(%esp)
c0103f6b:	e8 64 ef ff ff       	call   c0102ed4 <page_ref>
c0103f70:	85 c0                	test   %eax,%eax
c0103f72:	74 24                	je     c0103f98 <check_pgdir+0x480>
c0103f74:	c7 44 24 0c 9a 70 10 	movl   $0xc010709a,0xc(%esp)
c0103f7b:	c0 
c0103f7c:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103f83:	c0 
c0103f84:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103f8b:	00 
c0103f8c:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103f93:	e8 99 c4 ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103f98:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103f9d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103fa4:	00 
c0103fa5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103fac:	00 
c0103fad:	89 04 24             	mov    %eax,(%esp)
c0103fb0:	e8 dd f7 ff ff       	call   c0103792 <get_pte>
c0103fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103fbc:	75 24                	jne    c0103fe2 <check_pgdir+0x4ca>
c0103fbe:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0103fc5:	c0 
c0103fc6:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0103fcd:	c0 
c0103fce:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103fd5:	00 
c0103fd6:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0103fdd:	e8 4f c4 ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c0103fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fe5:	8b 00                	mov    (%eax),%eax
c0103fe7:	89 04 24             	mov    %eax,(%esp)
c0103fea:	e8 8f ee ff ff       	call   c0102e7e <pte2page>
c0103fef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103ff2:	74 24                	je     c0104018 <check_pgdir+0x500>
c0103ff4:	c7 44 24 0c 5d 6f 10 	movl   $0xc0106f5d,0xc(%esp)
c0103ffb:	c0 
c0103ffc:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104003:	c0 
c0104004:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c010400b:	00 
c010400c:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104013:	e8 19 c4 ff ff       	call   c0100431 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104018:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010401b:	8b 00                	mov    (%eax),%eax
c010401d:	83 e0 04             	and    $0x4,%eax
c0104020:	85 c0                	test   %eax,%eax
c0104022:	74 24                	je     c0104048 <check_pgdir+0x530>
c0104024:	c7 44 24 0c ac 70 10 	movl   $0xc01070ac,0xc(%esp)
c010402b:	c0 
c010402c:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104033:	c0 
c0104034:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010403b:	00 
c010403c:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104043:	e8 e9 c3 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104048:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010404d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104054:	00 
c0104055:	89 04 24             	mov    %eax,(%esp)
c0104058:	e8 31 f9 ff ff       	call   c010398e <page_remove>
    assert(page_ref(p1) == 1);
c010405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104060:	89 04 24             	mov    %eax,(%esp)
c0104063:	e8 6c ee ff ff       	call   c0102ed4 <page_ref>
c0104068:	83 f8 01             	cmp    $0x1,%eax
c010406b:	74 24                	je     c0104091 <check_pgdir+0x579>
c010406d:	c7 44 24 0c 73 6f 10 	movl   $0xc0106f73,0xc(%esp)
c0104074:	c0 
c0104075:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010407c:	c0 
c010407d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104084:	00 
c0104085:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010408c:	e8 a0 c3 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0104091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104094:	89 04 24             	mov    %eax,(%esp)
c0104097:	e8 38 ee ff ff       	call   c0102ed4 <page_ref>
c010409c:	85 c0                	test   %eax,%eax
c010409e:	74 24                	je     c01040c4 <check_pgdir+0x5ac>
c01040a0:	c7 44 24 0c 9a 70 10 	movl   $0xc010709a,0xc(%esp)
c01040a7:	c0 
c01040a8:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c01040af:	c0 
c01040b0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01040b7:	00 
c01040b8:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01040bf:	e8 6d c3 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01040c4:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01040c9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01040d0:	00 
c01040d1:	89 04 24             	mov    %eax,(%esp)
c01040d4:	e8 b5 f8 ff ff       	call   c010398e <page_remove>
    assert(page_ref(p1) == 0);
c01040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040dc:	89 04 24             	mov    %eax,(%esp)
c01040df:	e8 f0 ed ff ff       	call   c0102ed4 <page_ref>
c01040e4:	85 c0                	test   %eax,%eax
c01040e6:	74 24                	je     c010410c <check_pgdir+0x5f4>
c01040e8:	c7 44 24 0c c1 70 10 	movl   $0xc01070c1,0xc(%esp)
c01040ef:	c0 
c01040f0:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c01040f7:	c0 
c01040f8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01040ff:	00 
c0104100:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104107:	e8 25 c3 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c010410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010410f:	89 04 24             	mov    %eax,(%esp)
c0104112:	e8 bd ed ff ff       	call   c0102ed4 <page_ref>
c0104117:	85 c0                	test   %eax,%eax
c0104119:	74 24                	je     c010413f <check_pgdir+0x627>
c010411b:	c7 44 24 0c 9a 70 10 	movl   $0xc010709a,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010413a:	e8 f2 c2 ff ff       	call   c0100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010413f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104144:	8b 00                	mov    (%eax),%eax
c0104146:	89 04 24             	mov    %eax,(%esp)
c0104149:	e8 6e ed ff ff       	call   c0102ebc <pde2page>
c010414e:	89 04 24             	mov    %eax,(%esp)
c0104151:	e8 7e ed ff ff       	call   c0102ed4 <page_ref>
c0104156:	83 f8 01             	cmp    $0x1,%eax
c0104159:	74 24                	je     c010417f <check_pgdir+0x667>
c010415b:	c7 44 24 0c d4 70 10 	movl   $0xc01070d4,0xc(%esp)
c0104162:	c0 
c0104163:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010416a:	c0 
c010416b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104172:	00 
c0104173:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010417a:	e8 b2 c2 ff ff       	call   c0100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010417f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104184:	8b 00                	mov    (%eax),%eax
c0104186:	89 04 24             	mov    %eax,(%esp)
c0104189:	e8 2e ed ff ff       	call   c0102ebc <pde2page>
c010418e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104195:	00 
c0104196:	89 04 24             	mov    %eax,(%esp)
c0104199:	e8 88 ef ff ff       	call   c0103126 <free_pages>
    boot_pgdir[0] = 0;
c010419e:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01041a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01041a9:	c7 04 24 fb 70 10 c0 	movl   $0xc01070fb,(%esp)
c01041b0:	e8 10 c1 ff ff       	call   c01002c5 <cprintf>
}
c01041b5:	90                   	nop
c01041b6:	c9                   	leave  
c01041b7:	c3                   	ret    

c01041b8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01041b8:	f3 0f 1e fb          	endbr32 
c01041bc:	55                   	push   %ebp
c01041bd:	89 e5                	mov    %esp,%ebp
c01041bf:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01041c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01041c9:	e9 ca 00 00 00       	jmp    c0104298 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041d7:	c1 e8 0c             	shr    $0xc,%eax
c01041da:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01041dd:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01041e2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01041e5:	72 23                	jb     c010420a <check_boot_pgdir+0x52>
c01041e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041ee:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c01041f5:	c0 
c01041f6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01041fd:	00 
c01041fe:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104205:	e8 27 c2 ff ff       	call   c0100431 <__panic>
c010420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010420d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104212:	89 c2                	mov    %eax,%edx
c0104214:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104219:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104220:	00 
c0104221:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104225:	89 04 24             	mov    %eax,(%esp)
c0104228:	e8 65 f5 ff ff       	call   c0103792 <get_pte>
c010422d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104230:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104234:	75 24                	jne    c010425a <check_boot_pgdir+0xa2>
c0104236:	c7 44 24 0c 18 71 10 	movl   $0xc0107118,0xc(%esp)
c010423d:	c0 
c010423e:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104245:	c0 
c0104246:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c010424d:	00 
c010424e:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104255:	e8 d7 c1 ff ff       	call   c0100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010425a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010425d:	8b 00                	mov    (%eax),%eax
c010425f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104264:	89 c2                	mov    %eax,%edx
c0104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104269:	39 c2                	cmp    %eax,%edx
c010426b:	74 24                	je     c0104291 <check_boot_pgdir+0xd9>
c010426d:	c7 44 24 0c 55 71 10 	movl   $0xc0107155,0xc(%esp)
c0104274:	c0 
c0104275:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010427c:	c0 
c010427d:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104284:	00 
c0104285:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010428c:	e8 a0 c1 ff ff       	call   c0100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104291:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104298:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010429b:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01042a0:	39 c2                	cmp    %eax,%edx
c01042a2:	0f 82 26 ff ff ff    	jb     c01041ce <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01042a8:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042ad:	05 ac 0f 00 00       	add    $0xfac,%eax
c01042b2:	8b 00                	mov    (%eax),%eax
c01042b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042b9:	89 c2                	mov    %eax,%edx
c01042bb:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042c3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01042ca:	77 23                	ja     c01042ef <check_boot_pgdir+0x137>
c01042cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042d3:	c7 44 24 08 e4 6d 10 	movl   $0xc0106de4,0x8(%esp)
c01042da:	c0 
c01042db:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c01042e2:	00 
c01042e3:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01042ea:	e8 42 c1 ff ff       	call   c0100431 <__panic>
c01042ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f2:	05 00 00 00 40       	add    $0x40000000,%eax
c01042f7:	39 d0                	cmp    %edx,%eax
c01042f9:	74 24                	je     c010431f <check_boot_pgdir+0x167>
c01042fb:	c7 44 24 0c 6c 71 10 	movl   $0xc010716c,0xc(%esp)
c0104302:	c0 
c0104303:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010430a:	c0 
c010430b:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104312:	00 
c0104313:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010431a:	e8 12 c1 ff ff       	call   c0100431 <__panic>

    assert(boot_pgdir[0] == 0);
c010431f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104324:	8b 00                	mov    (%eax),%eax
c0104326:	85 c0                	test   %eax,%eax
c0104328:	74 24                	je     c010434e <check_boot_pgdir+0x196>
c010432a:	c7 44 24 0c a0 71 10 	movl   $0xc01071a0,0xc(%esp)
c0104331:	c0 
c0104332:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104339:	c0 
c010433a:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104341:	00 
c0104342:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104349:	e8 e3 c0 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    p = alloc_page();
c010434e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104355:	e8 90 ed ff ff       	call   c01030ea <alloc_pages>
c010435a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010435d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104362:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104369:	00 
c010436a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104371:	00 
c0104372:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104375:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104379:	89 04 24             	mov    %eax,(%esp)
c010437c:	e8 56 f6 ff ff       	call   c01039d7 <page_insert>
c0104381:	85 c0                	test   %eax,%eax
c0104383:	74 24                	je     c01043a9 <check_boot_pgdir+0x1f1>
c0104385:	c7 44 24 0c b4 71 10 	movl   $0xc01071b4,0xc(%esp)
c010438c:	c0 
c010438d:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104394:	c0 
c0104395:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c010439c:	00 
c010439d:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01043a4:	e8 88 c0 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 1);
c01043a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043ac:	89 04 24             	mov    %eax,(%esp)
c01043af:	e8 20 eb ff ff       	call   c0102ed4 <page_ref>
c01043b4:	83 f8 01             	cmp    $0x1,%eax
c01043b7:	74 24                	je     c01043dd <check_boot_pgdir+0x225>
c01043b9:	c7 44 24 0c e2 71 10 	movl   $0xc01071e2,0xc(%esp)
c01043c0:	c0 
c01043c1:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c01043c8:	c0 
c01043c9:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c01043d0:	00 
c01043d1:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01043d8:	e8 54 c0 ff ff       	call   c0100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01043dd:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01043e2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01043e9:	00 
c01043ea:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01043f1:	00 
c01043f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01043f9:	89 04 24             	mov    %eax,(%esp)
c01043fc:	e8 d6 f5 ff ff       	call   c01039d7 <page_insert>
c0104401:	85 c0                	test   %eax,%eax
c0104403:	74 24                	je     c0104429 <check_boot_pgdir+0x271>
c0104405:	c7 44 24 0c f4 71 10 	movl   $0xc01071f4,0xc(%esp)
c010440c:	c0 
c010440d:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104414:	c0 
c0104415:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010441c:	00 
c010441d:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104424:	e8 08 c0 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 2);
c0104429:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010442c:	89 04 24             	mov    %eax,(%esp)
c010442f:	e8 a0 ea ff ff       	call   c0102ed4 <page_ref>
c0104434:	83 f8 02             	cmp    $0x2,%eax
c0104437:	74 24                	je     c010445d <check_boot_pgdir+0x2a5>
c0104439:	c7 44 24 0c 2b 72 10 	movl   $0xc010722b,0xc(%esp)
c0104440:	c0 
c0104441:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c0104448:	c0 
c0104449:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104450:	00 
c0104451:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c0104458:	e8 d4 bf ff ff       	call   c0100431 <__panic>

    const char *str = "ucore: Hello world!!";
c010445d:	c7 45 e8 3c 72 10 c0 	movl   $0xc010723c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104464:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104467:	89 44 24 04          	mov    %eax,0x4(%esp)
c010446b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104472:	e8 32 16 00 00       	call   c0105aa9 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104477:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010447e:	00 
c010447f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104486:	e8 9c 16 00 00       	call   c0105b27 <strcmp>
c010448b:	85 c0                	test   %eax,%eax
c010448d:	74 24                	je     c01044b3 <check_boot_pgdir+0x2fb>
c010448f:	c7 44 24 0c 54 72 10 	movl   $0xc0107254,0xc(%esp)
c0104496:	c0 
c0104497:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c010449e:	c0 
c010449f:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01044a6:	00 
c01044a7:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01044ae:	e8 7e bf ff ff       	call   c0100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01044b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044b6:	89 04 24             	mov    %eax,(%esp)
c01044b9:	e8 6c e9 ff ff       	call   c0102e2a <page2kva>
c01044be:	05 00 01 00 00       	add    $0x100,%eax
c01044c3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01044c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01044cd:	e8 79 15 00 00       	call   c0105a4b <strlen>
c01044d2:	85 c0                	test   %eax,%eax
c01044d4:	74 24                	je     c01044fa <check_boot_pgdir+0x342>
c01044d6:	c7 44 24 0c 8c 72 10 	movl   $0xc010728c,0xc(%esp)
c01044dd:	c0 
c01044de:	c7 44 24 08 2d 6e 10 	movl   $0xc0106e2d,0x8(%esp)
c01044e5:	c0 
c01044e6:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01044ed:	00 
c01044ee:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c01044f5:	e8 37 bf ff ff       	call   c0100431 <__panic>

    free_page(p);
c01044fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104501:	00 
c0104502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104505:	89 04 24             	mov    %eax,(%esp)
c0104508:	e8 19 ec ff ff       	call   c0103126 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010450d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104512:	8b 00                	mov    (%eax),%eax
c0104514:	89 04 24             	mov    %eax,(%esp)
c0104517:	e8 a0 e9 ff ff       	call   c0102ebc <pde2page>
c010451c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104523:	00 
c0104524:	89 04 24             	mov    %eax,(%esp)
c0104527:	e8 fa eb ff ff       	call   c0103126 <free_pages>
    boot_pgdir[0] = 0;
c010452c:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104537:	c7 04 24 b0 72 10 c0 	movl   $0xc01072b0,(%esp)
c010453e:	e8 82 bd ff ff       	call   c01002c5 <cprintf>
}
c0104543:	90                   	nop
c0104544:	c9                   	leave  
c0104545:	c3                   	ret    

c0104546 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104546:	f3 0f 1e fb          	endbr32 
c010454a:	55                   	push   %ebp
c010454b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	83 e0 04             	and    $0x4,%eax
c0104553:	85 c0                	test   %eax,%eax
c0104555:	74 04                	je     c010455b <perm2str+0x15>
c0104557:	b0 75                	mov    $0x75,%al
c0104559:	eb 02                	jmp    c010455d <perm2str+0x17>
c010455b:	b0 2d                	mov    $0x2d,%al
c010455d:	a2 08 df 11 c0       	mov    %al,0xc011df08
    str[1] = 'r';
c0104562:	c6 05 09 df 11 c0 72 	movb   $0x72,0xc011df09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104569:	8b 45 08             	mov    0x8(%ebp),%eax
c010456c:	83 e0 02             	and    $0x2,%eax
c010456f:	85 c0                	test   %eax,%eax
c0104571:	74 04                	je     c0104577 <perm2str+0x31>
c0104573:	b0 77                	mov    $0x77,%al
c0104575:	eb 02                	jmp    c0104579 <perm2str+0x33>
c0104577:	b0 2d                	mov    $0x2d,%al
c0104579:	a2 0a df 11 c0       	mov    %al,0xc011df0a
    str[3] = '\0';
c010457e:	c6 05 0b df 11 c0 00 	movb   $0x0,0xc011df0b
    return str;
c0104585:	b8 08 df 11 c0       	mov    $0xc011df08,%eax
}
c010458a:	5d                   	pop    %ebp
c010458b:	c3                   	ret    

c010458c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010458c:	f3 0f 1e fb          	endbr32 
c0104590:	55                   	push   %ebp
c0104591:	89 e5                	mov    %esp,%ebp
c0104593:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104596:	8b 45 10             	mov    0x10(%ebp),%eax
c0104599:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010459c:	72 0d                	jb     c01045ab <get_pgtable_items+0x1f>
        return 0;
c010459e:	b8 00 00 00 00       	mov    $0x0,%eax
c01045a3:	e9 98 00 00 00       	jmp    c0104640 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01045a8:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01045ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01045ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01045b1:	73 18                	jae    c01045cb <get_pgtable_items+0x3f>
c01045b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01045b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045bd:	8b 45 14             	mov    0x14(%ebp),%eax
c01045c0:	01 d0                	add    %edx,%eax
c01045c2:	8b 00                	mov    (%eax),%eax
c01045c4:	83 e0 01             	and    $0x1,%eax
c01045c7:	85 c0                	test   %eax,%eax
c01045c9:	74 dd                	je     c01045a8 <get_pgtable_items+0x1c>
    }
    if (start < right) {
c01045cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01045ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01045d1:	73 68                	jae    c010463b <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01045d3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01045d7:	74 08                	je     c01045e1 <get_pgtable_items+0x55>
            *left_store = start;
c01045d9:	8b 45 18             	mov    0x18(%ebp),%eax
c01045dc:	8b 55 10             	mov    0x10(%ebp),%edx
c01045df:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01045e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01045e4:	8d 50 01             	lea    0x1(%eax),%edx
c01045e7:	89 55 10             	mov    %edx,0x10(%ebp)
c01045ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045f1:	8b 45 14             	mov    0x14(%ebp),%eax
c01045f4:	01 d0                	add    %edx,%eax
c01045f6:	8b 00                	mov    (%eax),%eax
c01045f8:	83 e0 07             	and    $0x7,%eax
c01045fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01045fe:	eb 03                	jmp    c0104603 <get_pgtable_items+0x77>
            start ++;
c0104600:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104603:	8b 45 10             	mov    0x10(%ebp),%eax
c0104606:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104609:	73 1d                	jae    c0104628 <get_pgtable_items+0x9c>
c010460b:	8b 45 10             	mov    0x10(%ebp),%eax
c010460e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104615:	8b 45 14             	mov    0x14(%ebp),%eax
c0104618:	01 d0                	add    %edx,%eax
c010461a:	8b 00                	mov    (%eax),%eax
c010461c:	83 e0 07             	and    $0x7,%eax
c010461f:	89 c2                	mov    %eax,%edx
c0104621:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104624:	39 c2                	cmp    %eax,%edx
c0104626:	74 d8                	je     c0104600 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c0104628:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010462c:	74 08                	je     c0104636 <get_pgtable_items+0xaa>
            *right_store = start;
c010462e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104631:	8b 55 10             	mov    0x10(%ebp),%edx
c0104634:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104636:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104639:	eb 05                	jmp    c0104640 <get_pgtable_items+0xb4>
    }
    return 0;
c010463b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104640:	c9                   	leave  
c0104641:	c3                   	ret    

c0104642 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104642:	f3 0f 1e fb          	endbr32 
c0104646:	55                   	push   %ebp
c0104647:	89 e5                	mov    %esp,%ebp
c0104649:	57                   	push   %edi
c010464a:	56                   	push   %esi
c010464b:	53                   	push   %ebx
c010464c:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010464f:	c7 04 24 d0 72 10 c0 	movl   $0xc01072d0,(%esp)
c0104656:	e8 6a bc ff ff       	call   c01002c5 <cprintf>
    size_t left, right = 0, perm;
c010465b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104662:	e9 fa 00 00 00       	jmp    c0104761 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010466a:	89 04 24             	mov    %eax,(%esp)
c010466d:	e8 d4 fe ff ff       	call   c0104546 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104675:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104678:	29 d1                	sub    %edx,%ecx
c010467a:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010467c:	89 d6                	mov    %edx,%esi
c010467e:	c1 e6 16             	shl    $0x16,%esi
c0104681:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104684:	89 d3                	mov    %edx,%ebx
c0104686:	c1 e3 16             	shl    $0x16,%ebx
c0104689:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010468c:	89 d1                	mov    %edx,%ecx
c010468e:	c1 e1 16             	shl    $0x16,%ecx
c0104691:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104694:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104697:	29 d7                	sub    %edx,%edi
c0104699:	89 fa                	mov    %edi,%edx
c010469b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010469f:	89 74 24 10          	mov    %esi,0x10(%esp)
c01046a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01046a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01046ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046af:	c7 04 24 01 73 10 c0 	movl   $0xc0107301,(%esp)
c01046b6:	e8 0a bc ff ff       	call   c01002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01046bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046be:	c1 e0 0a             	shl    $0xa,%eax
c01046c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01046c4:	eb 54                	jmp    c010471a <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01046c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046c9:	89 04 24             	mov    %eax,(%esp)
c01046cc:	e8 75 fe ff ff       	call   c0104546 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01046d1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01046d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046d7:	29 d1                	sub    %edx,%ecx
c01046d9:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01046db:	89 d6                	mov    %edx,%esi
c01046dd:	c1 e6 0c             	shl    $0xc,%esi
c01046e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01046e3:	89 d3                	mov    %edx,%ebx
c01046e5:	c1 e3 0c             	shl    $0xc,%ebx
c01046e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046eb:	89 d1                	mov    %edx,%ecx
c01046ed:	c1 e1 0c             	shl    $0xc,%ecx
c01046f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01046f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01046f6:	29 d7                	sub    %edx,%edi
c01046f8:	89 fa                	mov    %edi,%edx
c01046fa:	89 44 24 14          	mov    %eax,0x14(%esp)
c01046fe:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104702:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104706:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010470a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010470e:	c7 04 24 20 73 10 c0 	movl   $0xc0107320,(%esp)
c0104715:	e8 ab bb ff ff       	call   c01002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010471a:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010471f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104722:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104725:	89 d3                	mov    %edx,%ebx
c0104727:	c1 e3 0a             	shl    $0xa,%ebx
c010472a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010472d:	89 d1                	mov    %edx,%ecx
c010472f:	c1 e1 0a             	shl    $0xa,%ecx
c0104732:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104735:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104739:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010473c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104740:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104744:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104748:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010474c:	89 0c 24             	mov    %ecx,(%esp)
c010474f:	e8 38 fe ff ff       	call   c010458c <get_pgtable_items>
c0104754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010475b:	0f 85 65 ff ff ff    	jne    c01046c6 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104761:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104766:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104769:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010476c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104770:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104773:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104777:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010477b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010477f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104786:	00 
c0104787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010478e:	e8 f9 fd ff ff       	call   c010458c <get_pgtable_items>
c0104793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010479a:	0f 85 c7 fe ff ff    	jne    c0104667 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01047a0:	c7 04 24 44 73 10 c0 	movl   $0xc0107344,(%esp)
c01047a7:	e8 19 bb ff ff       	call   c01002c5 <cprintf>
}
c01047ac:	90                   	nop
c01047ad:	83 c4 4c             	add    $0x4c,%esp
c01047b0:	5b                   	pop    %ebx
c01047b1:	5e                   	pop    %esi
c01047b2:	5f                   	pop    %edi
c01047b3:	5d                   	pop    %ebp
c01047b4:	c3                   	ret    

c01047b5 <page2ppn>:
page2ppn(struct Page *page) {
c01047b5:	55                   	push   %ebp
c01047b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01047b8:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c01047bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01047c0:	29 c2                	sub    %eax,%edx
c01047c2:	89 d0                	mov    %edx,%eax
c01047c4:	c1 f8 02             	sar    $0x2,%eax
c01047c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01047cd:	5d                   	pop    %ebp
c01047ce:	c3                   	ret    

c01047cf <page2pa>:
page2pa(struct Page *page) {
c01047cf:	55                   	push   %ebp
c01047d0:	89 e5                	mov    %esp,%ebp
c01047d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01047d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d8:	89 04 24             	mov    %eax,(%esp)
c01047db:	e8 d5 ff ff ff       	call   c01047b5 <page2ppn>
c01047e0:	c1 e0 0c             	shl    $0xc,%eax
}
c01047e3:	c9                   	leave  
c01047e4:	c3                   	ret    

c01047e5 <page_ref>:
page_ref(struct Page *page) {
c01047e5:	55                   	push   %ebp
c01047e6:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01047e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047eb:	8b 00                	mov    (%eax),%eax
}
c01047ed:	5d                   	pop    %ebp
c01047ee:	c3                   	ret    

c01047ef <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01047ef:	55                   	push   %ebp
c01047f0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01047f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047f8:	89 10                	mov    %edx,(%eax)
}
c01047fa:	90                   	nop
c01047fb:	5d                   	pop    %ebp
c01047fc:	c3                   	ret    

c01047fd <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01047fd:	f3 0f 1e fb          	endbr32 
c0104801:	55                   	push   %ebp
c0104802:	89 e5                	mov    %esp,%ebp
c0104804:	83 ec 10             	sub    $0x10,%esp
c0104807:	c7 45 fc 7c df 11 c0 	movl   $0xc011df7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010480e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104811:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104814:	89 50 04             	mov    %edx,0x4(%eax)
c0104817:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010481a:	8b 50 04             	mov    0x4(%eax),%edx
c010481d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104820:	89 10                	mov    %edx,(%eax)
}
c0104822:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0104823:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c010482a:	00 00 00 
}
c010482d:	90                   	nop
c010482e:	c9                   	leave  
c010482f:	c3                   	ret    

c0104830 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104830:	f3 0f 1e fb          	endbr32 
c0104834:	55                   	push   %ebp
c0104835:	89 e5                	mov    %esp,%ebp
c0104837:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010483a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010483e:	75 24                	jne    c0104864 <default_init_memmap+0x34>
c0104840:	c7 44 24 0c 78 73 10 	movl   $0xc0107378,0xc(%esp)
c0104847:	c0 
c0104848:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010484f:	c0 
c0104850:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104857:	00 
c0104858:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010485f:	e8 cd bb ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c0104864:	8b 45 08             	mov    0x8(%ebp),%eax
c0104867:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010486a:	eb 7d                	jmp    c01048e9 <default_init_memmap+0xb9>
        assert(PageReserved(p));
c010486c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486f:	83 c0 04             	add    $0x4,%eax
c0104872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104879:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010487c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010487f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104882:	0f a3 10             	bt     %edx,(%eax)
c0104885:	19 c0                	sbb    %eax,%eax
c0104887:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010488a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010488e:	0f 95 c0             	setne  %al
c0104891:	0f b6 c0             	movzbl %al,%eax
c0104894:	85 c0                	test   %eax,%eax
c0104896:	75 24                	jne    c01048bc <default_init_memmap+0x8c>
c0104898:	c7 44 24 0c a9 73 10 	movl   $0xc01073a9,0xc(%esp)
c010489f:	c0 
c01048a0:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01048a7:	c0 
c01048a8:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01048af:	00 
c01048b0:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01048b7:	e8 75 bb ff ff       	call   c0100431 <__panic>
        p->flags = p->property = 0;
c01048bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c9:	8b 50 08             	mov    0x8(%eax),%edx
c01048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cf:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01048d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048d9:	00 
c01048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048dd:	89 04 24             	mov    %eax,(%esp)
c01048e0:	e8 0a ff ff ff       	call   c01047ef <set_page_ref>
    for (; p != base + n; p ++) {
c01048e5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01048e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048ec:	89 d0                	mov    %edx,%eax
c01048ee:	c1 e0 02             	shl    $0x2,%eax
c01048f1:	01 d0                	add    %edx,%eax
c01048f3:	c1 e0 02             	shl    $0x2,%eax
c01048f6:	89 c2                	mov    %eax,%edx
c01048f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048fb:	01 d0                	add    %edx,%eax
c01048fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104900:	0f 85 66 ff ff ff    	jne    c010486c <default_init_memmap+0x3c>
    }
    base->property = n;
c0104906:	8b 45 08             	mov    0x8(%ebp),%eax
c0104909:	8b 55 0c             	mov    0xc(%ebp),%edx
c010490c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010490f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104912:	83 c0 04             	add    $0x4,%eax
c0104915:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c010491c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010491f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104922:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104925:	0f ab 10             	bts    %edx,(%eax)
}
c0104928:	90                   	nop
    nr_free += n;
c0104929:	8b 15 84 df 11 c0    	mov    0xc011df84,%edx
c010492f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104932:	01 d0                	add    %edx,%eax
c0104934:	a3 84 df 11 c0       	mov    %eax,0xc011df84
    list_add(&free_list, &(base->page_link));
c0104939:	8b 45 08             	mov    0x8(%ebp),%eax
c010493c:	83 c0 0c             	add    $0xc,%eax
c010493f:	c7 45 e4 7c df 11 c0 	movl   $0xc011df7c,-0x1c(%ebp)
c0104946:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010494c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010494f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104952:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104955:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104958:	8b 40 04             	mov    0x4(%eax),%eax
c010495b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010495e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104961:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104964:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104967:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010496a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010496d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104970:	89 10                	mov    %edx,(%eax)
c0104972:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104975:	8b 10                	mov    (%eax),%edx
c0104977:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010497a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010497d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104980:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104983:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104986:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104989:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010498c:	89 10                	mov    %edx,(%eax)
}
c010498e:	90                   	nop
}
c010498f:	90                   	nop
}
c0104990:	90                   	nop
}
c0104991:	90                   	nop
c0104992:	c9                   	leave  
c0104993:	c3                   	ret    

c0104994 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104994:	f3 0f 1e fb          	endbr32 
c0104998:	55                   	push   %ebp
c0104999:	89 e5                	mov    %esp,%ebp
c010499b:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010499e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049a2:	75 24                	jne    c01049c8 <default_alloc_pages+0x34>
c01049a4:	c7 44 24 0c 78 73 10 	movl   $0xc0107378,0xc(%esp)
c01049ab:	c0 
c01049ac:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01049b3:	c0 
c01049b4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01049bb:	00 
c01049bc:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01049c3:	e8 69 ba ff ff       	call   c0100431 <__panic>
    if (n > nr_free) {
c01049c8:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c01049cd:	39 45 08             	cmp    %eax,0x8(%ebp)
c01049d0:	76 0a                	jbe    c01049dc <default_alloc_pages+0x48>
        return NULL;
c01049d2:	b8 00 00 00 00       	mov    $0x0,%eax
c01049d7:	e9 4e 01 00 00       	jmp    c0104b2a <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c01049dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01049e3:	c7 45 f0 7c df 11 c0 	movl   $0xc011df7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01049ea:	eb 1c                	jmp    c0104a08 <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c01049ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ef:	83 e8 0c             	sub    $0xc,%eax
c01049f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01049f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049f8:	8b 40 08             	mov    0x8(%eax),%eax
c01049fb:	39 45 08             	cmp    %eax,0x8(%ebp)
c01049fe:	77 08                	ja     c0104a08 <default_alloc_pages+0x74>
            page = p;
c0104a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
            //SetPageReserved(page);
            break;
c0104a06:	eb 18                	jmp    c0104a20 <default_alloc_pages+0x8c>
c0104a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a11:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a17:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c0104a1e:	75 cc                	jne    c01049ec <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c0104a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a24:	0f 84 fd 00 00 00    	je     c0104b27 <default_alloc_pages+0x193>
        //list_del(&(page->page_link));
        if (page->property > n) {
c0104a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a2d:	8b 40 08             	mov    0x8(%eax),%eax
c0104a30:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104a33:	0f 83 9a 00 00 00    	jae    c0104ad3 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
c0104a39:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a3c:	89 d0                	mov    %edx,%eax
c0104a3e:	c1 e0 02             	shl    $0x2,%eax
c0104a41:	01 d0                	add    %edx,%eax
c0104a43:	c1 e0 02             	shl    $0x2,%eax
c0104a46:	89 c2                	mov    %eax,%edx
c0104a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a4b:	01 d0                	add    %edx,%eax
c0104a4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a53:	8b 40 08             	mov    0x8(%eax),%eax
c0104a56:	2b 45 08             	sub    0x8(%ebp),%eax
c0104a59:	89 c2                	mov    %eax,%edx
c0104a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a5e:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a64:	83 c0 04             	add    $0x4,%eax
c0104a67:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104a6e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a71:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a74:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104a77:	0f ab 10             	bts    %edx,(%eax)
}
c0104a7a:	90                   	nop
            //ClearPageReserved(p);
            list_add(&free_list, &(p->page_link));
c0104a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a7e:	83 c0 0c             	add    $0xc,%eax
c0104a81:	c7 45 e0 7c df 11 c0 	movl   $0xc011df7c,-0x20(%ebp)
c0104a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104a97:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a9a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104aa0:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104aa3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104aa6:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104aa9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0104aac:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104aaf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104ab2:	89 10                	mov    %edx,(%eax)
c0104ab4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104ab7:	8b 10                	mov    (%eax),%edx
c0104ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104abc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104abf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ac2:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104ac5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ac8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104acb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104ace:	89 10                	mov    %edx,(%eax)
}
c0104ad0:	90                   	nop
}
c0104ad1:	90                   	nop
}
c0104ad2:	90                   	nop
    }
        list_del(&(page->page_link));
c0104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad6:	83 c0 0c             	add    $0xc,%eax
c0104ad9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104adc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104adf:	8b 40 04             	mov    0x4(%eax),%eax
c0104ae2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ae5:	8b 12                	mov    (%edx),%edx
c0104ae7:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0104aea:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104aed:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104af0:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104af3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104af6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104af9:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104afc:	89 10                	mov    %edx,(%eax)
}
c0104afe:	90                   	nop
}
c0104aff:	90                   	nop
        nr_free -= n;
c0104b00:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0104b05:	2b 45 08             	sub    0x8(%ebp),%eax
c0104b08:	a3 84 df 11 c0       	mov    %eax,0xc011df84
        ClearPageProperty(page);
c0104b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b10:	83 c0 04             	add    $0x4,%eax
c0104b13:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104b1a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104b20:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104b23:	0f b3 10             	btr    %edx,(%eax)
}
c0104b26:	90                   	nop
    }
    return page;
c0104b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104b2a:	c9                   	leave  
c0104b2b:	c3                   	ret    

c0104b2c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104b2c:	f3 0f 1e fb          	endbr32 
c0104b30:	55                   	push   %ebp
c0104b31:	89 e5                	mov    %esp,%ebp
c0104b33:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104b3d:	75 24                	jne    c0104b63 <default_free_pages+0x37>
c0104b3f:	c7 44 24 0c 78 73 10 	movl   $0xc0107378,0xc(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0104b56:	00 
c0104b57:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104b5e:	e8 ce b8 ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c0104b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104b69:	e9 9d 00 00 00       	jmp    c0104c0b <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c0104b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b71:	83 c0 04             	add    $0x4,%eax
c0104b74:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b81:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b84:	0f a3 10             	bt     %edx,(%eax)
c0104b87:	19 c0                	sbb    %eax,%eax
c0104b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104b8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104b90:	0f 95 c0             	setne  %al
c0104b93:	0f b6 c0             	movzbl %al,%eax
c0104b96:	85 c0                	test   %eax,%eax
c0104b98:	75 2c                	jne    c0104bc6 <default_free_pages+0x9a>
c0104b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b9d:	83 c0 04             	add    $0x4,%eax
c0104ba0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bad:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104bb0:	0f a3 10             	bt     %edx,(%eax)
c0104bb3:	19 c0                	sbb    %eax,%eax
c0104bb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104bb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104bbc:	0f 95 c0             	setne  %al
c0104bbf:	0f b6 c0             	movzbl %al,%eax
c0104bc2:	85 c0                	test   %eax,%eax
c0104bc4:	74 24                	je     c0104bea <default_free_pages+0xbe>
c0104bc6:	c7 44 24 0c bc 73 10 	movl   $0xc01073bc,0xc(%esp)
c0104bcd:	c0 
c0104bce:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104bd5:	c0 
c0104bd6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0104bdd:	00 
c0104bde:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104be5:	e8 47 b8 ff ff       	call   c0100431 <__panic>
        p->flags = 0;
c0104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104bf4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104bfb:	00 
c0104bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bff:	89 04 24             	mov    %eax,(%esp)
c0104c02:	e8 e8 fb ff ff       	call   c01047ef <set_page_ref>
    for (; p != base + n; p ++) {
c0104c07:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c0e:	89 d0                	mov    %edx,%eax
c0104c10:	c1 e0 02             	shl    $0x2,%eax
c0104c13:	01 d0                	add    %edx,%eax
c0104c15:	c1 e0 02             	shl    $0x2,%eax
c0104c18:	89 c2                	mov    %eax,%edx
c0104c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c1d:	01 d0                	add    %edx,%eax
c0104c1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104c22:	0f 85 46 ff ff ff    	jne    c0104b6e <default_free_pages+0x42>
    }
    base->property = n;
c0104c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c2e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c34:	83 c0 04             	add    $0x4,%eax
c0104c37:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104c3e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c41:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c44:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c47:	0f ab 10             	bts    %edx,(%eax)
}
c0104c4a:	90                   	nop
c0104c4b:	c7 45 d4 7c df 11 c0 	movl   $0xc011df7c,-0x2c(%ebp)
    return listelm->next;
c0104c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c55:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104c5b:	e9 0e 01 00 00       	jmp    c0104d6e <default_free_pages+0x242>
        p = le2page(le, page_link);
c0104c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c63:	83 e8 0c             	sub    $0xc,%eax
c0104c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c6c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104c6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c72:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c7b:	8b 50 08             	mov    0x8(%eax),%edx
c0104c7e:	89 d0                	mov    %edx,%eax
c0104c80:	c1 e0 02             	shl    $0x2,%eax
c0104c83:	01 d0                	add    %edx,%eax
c0104c85:	c1 e0 02             	shl    $0x2,%eax
c0104c88:	89 c2                	mov    %eax,%edx
c0104c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c8d:	01 d0                	add    %edx,%eax
c0104c8f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104c92:	75 5d                	jne    c0104cf1 <default_free_pages+0x1c5>
            base->property += p->property;
c0104c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c97:	8b 50 08             	mov    0x8(%eax),%edx
c0104c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c9d:	8b 40 08             	mov    0x8(%eax),%eax
c0104ca0:	01 c2                	add    %eax,%edx
c0104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cab:	83 c0 04             	add    $0x4,%eax
c0104cae:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104cb5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104cb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104cbb:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104cbe:	0f b3 10             	btr    %edx,(%eax)
}
c0104cc1:	90                   	nop
            list_del(&(p->page_link));
c0104cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc5:	83 c0 0c             	add    $0xc,%eax
c0104cc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104ccb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104cce:	8b 40 04             	mov    0x4(%eax),%eax
c0104cd1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104cd4:	8b 12                	mov    (%edx),%edx
c0104cd6:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104cd9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104cdc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104cdf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ce2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ce5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ce8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104ceb:	89 10                	mov    %edx,(%eax)
}
c0104ced:	90                   	nop
}
c0104cee:	90                   	nop
c0104cef:	eb 7d                	jmp    c0104d6e <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
c0104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf4:	8b 50 08             	mov    0x8(%eax),%edx
c0104cf7:	89 d0                	mov    %edx,%eax
c0104cf9:	c1 e0 02             	shl    $0x2,%eax
c0104cfc:	01 d0                	add    %edx,%eax
c0104cfe:	c1 e0 02             	shl    $0x2,%eax
c0104d01:	89 c2                	mov    %eax,%edx
c0104d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d06:	01 d0                	add    %edx,%eax
c0104d08:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104d0b:	75 61                	jne    c0104d6e <default_free_pages+0x242>
            p->property += base->property;
c0104d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d10:	8b 50 08             	mov    0x8(%eax),%edx
c0104d13:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d16:	8b 40 08             	mov    0x8(%eax),%eax
c0104d19:	01 c2                	add    %eax,%edx
c0104d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d24:	83 c0 04             	add    $0x4,%eax
c0104d27:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104d2e:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104d31:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104d34:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104d37:	0f b3 10             	btr    %edx,(%eax)
}
c0104d3a:	90                   	nop
            base = p;
c0104d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d3e:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d44:	83 c0 0c             	add    $0xc,%eax
c0104d47:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104d4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d4d:	8b 40 04             	mov    0x4(%eax),%eax
c0104d50:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104d53:	8b 12                	mov    (%edx),%edx
c0104d55:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104d58:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104d5b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104d5e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104d61:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104d64:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104d67:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104d6a:	89 10                	mov    %edx,(%eax)
}
c0104d6c:	90                   	nop
}
c0104d6d:	90                   	nop
    while (le != &free_list) {
c0104d6e:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c0104d75:	0f 85 e5 fe ff ff    	jne    c0104c60 <default_free_pages+0x134>
        }
    }
    nr_free += n;
c0104d7b:	8b 15 84 df 11 c0    	mov    0xc011df84,%edx
c0104d81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d84:	01 d0                	add    %edx,%eax
c0104d86:	a3 84 df 11 c0       	mov    %eax,0xc011df84
c0104d8b:	c7 45 9c 7c df 11 c0 	movl   $0xc011df7c,-0x64(%ebp)
    return listelm->next;
c0104d92:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104d95:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104d9b:	eb 74                	jmp    c0104e11 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
c0104d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da0:	83 e8 0c             	sub    $0xc,%eax
c0104da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da9:	8b 50 08             	mov    0x8(%eax),%edx
c0104dac:	89 d0                	mov    %edx,%eax
c0104dae:	c1 e0 02             	shl    $0x2,%eax
c0104db1:	01 d0                	add    %edx,%eax
c0104db3:	c1 e0 02             	shl    $0x2,%eax
c0104db6:	89 c2                	mov    %eax,%edx
c0104db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dbb:	01 d0                	add    %edx,%eax
c0104dbd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104dc0:	72 40                	jb     c0104e02 <default_free_pages+0x2d6>
            assert(base + base->property != p);
c0104dc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dc5:	8b 50 08             	mov    0x8(%eax),%edx
c0104dc8:	89 d0                	mov    %edx,%eax
c0104dca:	c1 e0 02             	shl    $0x2,%eax
c0104dcd:	01 d0                	add    %edx,%eax
c0104dcf:	c1 e0 02             	shl    $0x2,%eax
c0104dd2:	89 c2                	mov    %eax,%edx
c0104dd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dd7:	01 d0                	add    %edx,%eax
c0104dd9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ddc:	75 3e                	jne    c0104e1c <default_free_pages+0x2f0>
c0104dde:	c7 44 24 0c e1 73 10 	movl   $0xc01073e1,0xc(%esp)
c0104de5:	c0 
c0104de6:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104ded:	c0 
c0104dee:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0104df5:	00 
c0104df6:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104dfd:	e8 2f b6 ff ff       	call   c0100431 <__panic>
c0104e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e05:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104e08:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104e0b:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104e11:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c0104e18:	75 83                	jne    c0104d9d <default_free_pages+0x271>
c0104e1a:	eb 01                	jmp    c0104e1d <default_free_pages+0x2f1>
            break;
c0104e1c:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0104e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e20:	8d 50 0c             	lea    0xc(%eax),%edx
c0104e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e26:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104e29:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104e2c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e2f:	8b 00                	mov    (%eax),%eax
c0104e31:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104e34:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104e37:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104e3a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e3d:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104e40:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104e43:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104e46:	89 10                	mov    %edx,(%eax)
c0104e48:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104e4b:	8b 10                	mov    (%eax),%edx
c0104e4d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104e50:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104e53:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104e56:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104e59:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104e5c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104e5f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104e62:	89 10                	mov    %edx,(%eax)
}
c0104e64:	90                   	nop
}
c0104e65:	90                   	nop
}
c0104e66:	90                   	nop
c0104e67:	c9                   	leave  
c0104e68:	c3                   	ret    

c0104e69 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104e69:	f3 0f 1e fb          	endbr32 
c0104e6d:	55                   	push   %ebp
c0104e6e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104e70:	a1 84 df 11 c0       	mov    0xc011df84,%eax
}
c0104e75:	5d                   	pop    %ebp
c0104e76:	c3                   	ret    

c0104e77 <basic_check>:

static void
basic_check(void) {
c0104e77:	f3 0f 1e fb          	endbr32 
c0104e7b:	55                   	push   %ebp
c0104e7c:	89 e5                	mov    %esp,%ebp
c0104e7e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104e94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e9b:	e8 4a e2 ff ff       	call   c01030ea <alloc_pages>
c0104ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ea3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104ea7:	75 24                	jne    c0104ecd <basic_check+0x56>
c0104ea9:	c7 44 24 0c fc 73 10 	movl   $0xc01073fc,0xc(%esp)
c0104eb0:	c0 
c0104eb1:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104eb8:	c0 
c0104eb9:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104ec0:	00 
c0104ec1:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104ec8:	e8 64 b5 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104ecd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ed4:	e8 11 e2 ff ff       	call   c01030ea <alloc_pages>
c0104ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104edc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ee0:	75 24                	jne    c0104f06 <basic_check+0x8f>
c0104ee2:	c7 44 24 0c 18 74 10 	movl   $0xc0107418,0xc(%esp)
c0104ee9:	c0 
c0104eea:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104ef1:	c0 
c0104ef2:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104ef9:	00 
c0104efa:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104f01:	e8 2b b5 ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104f06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f0d:	e8 d8 e1 ff ff       	call   c01030ea <alloc_pages>
c0104f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f19:	75 24                	jne    c0104f3f <basic_check+0xc8>
c0104f1b:	c7 44 24 0c 34 74 10 	movl   $0xc0107434,0xc(%esp)
c0104f22:	c0 
c0104f23:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104f2a:	c0 
c0104f2b:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0104f32:	00 
c0104f33:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104f3a:	e8 f2 b4 ff ff       	call   c0100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104f45:	74 10                	je     c0104f57 <basic_check+0xe0>
c0104f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f4d:	74 08                	je     c0104f57 <basic_check+0xe0>
c0104f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f55:	75 24                	jne    c0104f7b <basic_check+0x104>
c0104f57:	c7 44 24 0c 50 74 10 	movl   $0xc0107450,0xc(%esp)
c0104f5e:	c0 
c0104f5f:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104f66:	c0 
c0104f67:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104f6e:	00 
c0104f6f:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104f76:	e8 b6 b4 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f7e:	89 04 24             	mov    %eax,(%esp)
c0104f81:	e8 5f f8 ff ff       	call   c01047e5 <page_ref>
c0104f86:	85 c0                	test   %eax,%eax
c0104f88:	75 1e                	jne    c0104fa8 <basic_check+0x131>
c0104f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f8d:	89 04 24             	mov    %eax,(%esp)
c0104f90:	e8 50 f8 ff ff       	call   c01047e5 <page_ref>
c0104f95:	85 c0                	test   %eax,%eax
c0104f97:	75 0f                	jne    c0104fa8 <basic_check+0x131>
c0104f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f9c:	89 04 24             	mov    %eax,(%esp)
c0104f9f:	e8 41 f8 ff ff       	call   c01047e5 <page_ref>
c0104fa4:	85 c0                	test   %eax,%eax
c0104fa6:	74 24                	je     c0104fcc <basic_check+0x155>
c0104fa8:	c7 44 24 0c 74 74 10 	movl   $0xc0107474,0xc(%esp)
c0104faf:	c0 
c0104fb0:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104fb7:	c0 
c0104fb8:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104fbf:	00 
c0104fc0:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0104fc7:	e8 65 b4 ff ff       	call   c0100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fcf:	89 04 24             	mov    %eax,(%esp)
c0104fd2:	e8 f8 f7 ff ff       	call   c01047cf <page2pa>
c0104fd7:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0104fdd:	c1 e2 0c             	shl    $0xc,%edx
c0104fe0:	39 d0                	cmp    %edx,%eax
c0104fe2:	72 24                	jb     c0105008 <basic_check+0x191>
c0104fe4:	c7 44 24 0c b0 74 10 	movl   $0xc01074b0,0xc(%esp)
c0104feb:	c0 
c0104fec:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0104ff3:	c0 
c0104ff4:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0104ffb:	00 
c0104ffc:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105003:	e8 29 b4 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105008:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500b:	89 04 24             	mov    %eax,(%esp)
c010500e:	e8 bc f7 ff ff       	call   c01047cf <page2pa>
c0105013:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0105019:	c1 e2 0c             	shl    $0xc,%edx
c010501c:	39 d0                	cmp    %edx,%eax
c010501e:	72 24                	jb     c0105044 <basic_check+0x1cd>
c0105020:	c7 44 24 0c cd 74 10 	movl   $0xc01074cd,0xc(%esp)
c0105027:	c0 
c0105028:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010502f:	c0 
c0105030:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105037:	00 
c0105038:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010503f:	e8 ed b3 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105044:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105047:	89 04 24             	mov    %eax,(%esp)
c010504a:	e8 80 f7 ff ff       	call   c01047cf <page2pa>
c010504f:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0105055:	c1 e2 0c             	shl    $0xc,%edx
c0105058:	39 d0                	cmp    %edx,%eax
c010505a:	72 24                	jb     c0105080 <basic_check+0x209>
c010505c:	c7 44 24 0c ea 74 10 	movl   $0xc01074ea,0xc(%esp)
c0105063:	c0 
c0105064:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010506b:	c0 
c010506c:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0105073:	00 
c0105074:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010507b:	e8 b1 b3 ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c0105080:	a1 7c df 11 c0       	mov    0xc011df7c,%eax
c0105085:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c010508b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010508e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105091:	c7 45 dc 7c df 11 c0 	movl   $0xc011df7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105098:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010509b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010509e:	89 50 04             	mov    %edx,0x4(%eax)
c01050a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050a4:	8b 50 04             	mov    0x4(%eax),%edx
c01050a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050aa:	89 10                	mov    %edx,(%eax)
}
c01050ac:	90                   	nop
c01050ad:	c7 45 e0 7c df 11 c0 	movl   $0xc011df7c,-0x20(%ebp)
    return list->next == list;
c01050b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050b7:	8b 40 04             	mov    0x4(%eax),%eax
c01050ba:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01050bd:	0f 94 c0             	sete   %al
c01050c0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01050c3:	85 c0                	test   %eax,%eax
c01050c5:	75 24                	jne    c01050eb <basic_check+0x274>
c01050c7:	c7 44 24 0c 07 75 10 	movl   $0xc0107507,0xc(%esp)
c01050ce:	c0 
c01050cf:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01050d6:	c0 
c01050d7:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01050de:	00 
c01050df:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01050e6:	e8 46 b3 ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c01050eb:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c01050f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01050f3:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c01050fa:	00 00 00 

    assert(alloc_page() == NULL);
c01050fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105104:	e8 e1 df ff ff       	call   c01030ea <alloc_pages>
c0105109:	85 c0                	test   %eax,%eax
c010510b:	74 24                	je     c0105131 <basic_check+0x2ba>
c010510d:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c0105114:	c0 
c0105115:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010511c:	c0 
c010511d:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0105124:	00 
c0105125:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010512c:	e8 00 b3 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c0105131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105138:	00 
c0105139:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010513c:	89 04 24             	mov    %eax,(%esp)
c010513f:	e8 e2 df ff ff       	call   c0103126 <free_pages>
    free_page(p1);
c0105144:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010514b:	00 
c010514c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010514f:	89 04 24             	mov    %eax,(%esp)
c0105152:	e8 cf df ff ff       	call   c0103126 <free_pages>
    free_page(p2);
c0105157:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010515e:	00 
c010515f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105162:	89 04 24             	mov    %eax,(%esp)
c0105165:	e8 bc df ff ff       	call   c0103126 <free_pages>
    assert(nr_free == 3);
c010516a:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c010516f:	83 f8 03             	cmp    $0x3,%eax
c0105172:	74 24                	je     c0105198 <basic_check+0x321>
c0105174:	c7 44 24 0c 33 75 10 	movl   $0xc0107533,0xc(%esp)
c010517b:	c0 
c010517c:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105183:	c0 
c0105184:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010518b:	00 
c010518c:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105193:	e8 99 b2 ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010519f:	e8 46 df ff ff       	call   c01030ea <alloc_pages>
c01051a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01051a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01051ab:	75 24                	jne    c01051d1 <basic_check+0x35a>
c01051ad:	c7 44 24 0c fc 73 10 	movl   $0xc01073fc,0xc(%esp)
c01051b4:	c0 
c01051b5:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01051bc:	c0 
c01051bd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01051c4:	00 
c01051c5:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01051cc:	e8 60 b2 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01051d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051d8:	e8 0d df ff ff       	call   c01030ea <alloc_pages>
c01051dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01051e4:	75 24                	jne    c010520a <basic_check+0x393>
c01051e6:	c7 44 24 0c 18 74 10 	movl   $0xc0107418,0xc(%esp)
c01051ed:	c0 
c01051ee:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01051f5:	c0 
c01051f6:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01051fd:	00 
c01051fe:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105205:	e8 27 b2 ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010520a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105211:	e8 d4 de ff ff       	call   c01030ea <alloc_pages>
c0105216:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010521d:	75 24                	jne    c0105243 <basic_check+0x3cc>
c010521f:	c7 44 24 0c 34 74 10 	movl   $0xc0107434,0xc(%esp)
c0105226:	c0 
c0105227:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010522e:	c0 
c010522f:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0105236:	00 
c0105237:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010523e:	e8 ee b1 ff ff       	call   c0100431 <__panic>

    assert(alloc_page() == NULL);
c0105243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010524a:	e8 9b de ff ff       	call   c01030ea <alloc_pages>
c010524f:	85 c0                	test   %eax,%eax
c0105251:	74 24                	je     c0105277 <basic_check+0x400>
c0105253:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c010525a:	c0 
c010525b:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105262:	c0 
c0105263:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010526a:	00 
c010526b:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105272:	e8 ba b1 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c0105277:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010527e:	00 
c010527f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105282:	89 04 24             	mov    %eax,(%esp)
c0105285:	e8 9c de ff ff       	call   c0103126 <free_pages>
c010528a:	c7 45 d8 7c df 11 c0 	movl   $0xc011df7c,-0x28(%ebp)
c0105291:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105294:	8b 40 04             	mov    0x4(%eax),%eax
c0105297:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010529a:	0f 94 c0             	sete   %al
c010529d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01052a0:	85 c0                	test   %eax,%eax
c01052a2:	74 24                	je     c01052c8 <basic_check+0x451>
c01052a4:	c7 44 24 0c 40 75 10 	movl   $0xc0107540,0xc(%esp)
c01052ab:	c0 
c01052ac:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01052b3:	c0 
c01052b4:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01052bb:	00 
c01052bc:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01052c3:	e8 69 b1 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01052c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052cf:	e8 16 de ff ff       	call   c01030ea <alloc_pages>
c01052d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01052dd:	74 24                	je     c0105303 <basic_check+0x48c>
c01052df:	c7 44 24 0c 58 75 10 	movl   $0xc0107558,0xc(%esp)
c01052e6:	c0 
c01052e7:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01052ee:	c0 
c01052ef:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01052f6:	00 
c01052f7:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01052fe:	e8 2e b1 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c0105303:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010530a:	e8 db dd ff ff       	call   c01030ea <alloc_pages>
c010530f:	85 c0                	test   %eax,%eax
c0105311:	74 24                	je     c0105337 <basic_check+0x4c0>
c0105313:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c010531a:	c0 
c010531b:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105322:	c0 
c0105323:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c010532a:	00 
c010532b:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105332:	e8 fa b0 ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c0105337:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c010533c:	85 c0                	test   %eax,%eax
c010533e:	74 24                	je     c0105364 <basic_check+0x4ed>
c0105340:	c7 44 24 0c 71 75 10 	movl   $0xc0107571,0xc(%esp)
c0105347:	c0 
c0105348:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010534f:	c0 
c0105350:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0105357:	00 
c0105358:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010535f:	e8 cd b0 ff ff       	call   c0100431 <__panic>
    free_list = free_list_store;
c0105364:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105367:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010536a:	a3 7c df 11 c0       	mov    %eax,0xc011df7c
c010536f:	89 15 80 df 11 c0    	mov    %edx,0xc011df80
    nr_free = nr_free_store;
c0105375:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105378:	a3 84 df 11 c0       	mov    %eax,0xc011df84

    free_page(p);
c010537d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105384:	00 
c0105385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105388:	89 04 24             	mov    %eax,(%esp)
c010538b:	e8 96 dd ff ff       	call   c0103126 <free_pages>
    free_page(p1);
c0105390:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105397:	00 
c0105398:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010539b:	89 04 24             	mov    %eax,(%esp)
c010539e:	e8 83 dd ff ff       	call   c0103126 <free_pages>
    free_page(p2);
c01053a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053aa:	00 
c01053ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053ae:	89 04 24             	mov    %eax,(%esp)
c01053b1:	e8 70 dd ff ff       	call   c0103126 <free_pages>
}
c01053b6:	90                   	nop
c01053b7:	c9                   	leave  
c01053b8:	c3                   	ret    

c01053b9 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01053b9:	f3 0f 1e fb          	endbr32 
c01053bd:	55                   	push   %ebp
c01053be:	89 e5                	mov    %esp,%ebp
c01053c0:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01053c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01053cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01053d4:	c7 45 ec 7c df 11 c0 	movl   $0xc011df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01053db:	eb 6a                	jmp    c0105447 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c01053dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053e0:	83 e8 0c             	sub    $0xc,%eax
c01053e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01053e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053e9:	83 c0 04             	add    $0x4,%eax
c01053ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01053f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01053f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01053fc:	0f a3 10             	bt     %edx,(%eax)
c01053ff:	19 c0                	sbb    %eax,%eax
c0105401:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105404:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105408:	0f 95 c0             	setne  %al
c010540b:	0f b6 c0             	movzbl %al,%eax
c010540e:	85 c0                	test   %eax,%eax
c0105410:	75 24                	jne    c0105436 <default_check+0x7d>
c0105412:	c7 44 24 0c 7e 75 10 	movl   $0xc010757e,0xc(%esp)
c0105419:	c0 
c010541a:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105421:	c0 
c0105422:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0105429:	00 
c010542a:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105431:	e8 fb af ff ff       	call   c0100431 <__panic>
        count ++, total += p->property;
c0105436:	ff 45 f4             	incl   -0xc(%ebp)
c0105439:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010543c:	8b 50 08             	mov    0x8(%eax),%edx
c010543f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105442:	01 d0                	add    %edx,%eax
c0105444:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010544a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010544d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105450:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105453:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105456:	81 7d ec 7c df 11 c0 	cmpl   $0xc011df7c,-0x14(%ebp)
c010545d:	0f 85 7a ff ff ff    	jne    c01053dd <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0105463:	e8 f5 dc ff ff       	call   c010315d <nr_free_pages>
c0105468:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010546b:	39 d0                	cmp    %edx,%eax
c010546d:	74 24                	je     c0105493 <default_check+0xda>
c010546f:	c7 44 24 0c 8e 75 10 	movl   $0xc010758e,0xc(%esp)
c0105476:	c0 
c0105477:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010547e:	c0 
c010547f:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0105486:	00 
c0105487:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010548e:	e8 9e af ff ff       	call   c0100431 <__panic>

    basic_check();
c0105493:	e8 df f9 ff ff       	call   c0104e77 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105498:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010549f:	e8 46 dc ff ff       	call   c01030ea <alloc_pages>
c01054a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01054a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01054ab:	75 24                	jne    c01054d1 <default_check+0x118>
c01054ad:	c7 44 24 0c a7 75 10 	movl   $0xc01075a7,0xc(%esp)
c01054b4:	c0 
c01054b5:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01054bc:	c0 
c01054bd:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01054c4:	00 
c01054c5:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01054cc:	e8 60 af ff ff       	call   c0100431 <__panic>
    assert(!PageProperty(p0));
c01054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054d4:	83 c0 04             	add    $0x4,%eax
c01054d7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01054de:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01054e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01054e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01054e7:	0f a3 10             	bt     %edx,(%eax)
c01054ea:	19 c0                	sbb    %eax,%eax
c01054ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01054ef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01054f3:	0f 95 c0             	setne  %al
c01054f6:	0f b6 c0             	movzbl %al,%eax
c01054f9:	85 c0                	test   %eax,%eax
c01054fb:	74 24                	je     c0105521 <default_check+0x168>
c01054fd:	c7 44 24 0c b2 75 10 	movl   $0xc01075b2,0xc(%esp)
c0105504:	c0 
c0105505:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010550c:	c0 
c010550d:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0105514:	00 
c0105515:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010551c:	e8 10 af ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c0105521:	a1 7c df 11 c0       	mov    0xc011df7c,%eax
c0105526:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c010552c:	89 45 80             	mov    %eax,-0x80(%ebp)
c010552f:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105532:	c7 45 b0 7c df 11 c0 	movl   $0xc011df7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105539:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010553c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010553f:	89 50 04             	mov    %edx,0x4(%eax)
c0105542:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105545:	8b 50 04             	mov    0x4(%eax),%edx
c0105548:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010554b:	89 10                	mov    %edx,(%eax)
}
c010554d:	90                   	nop
c010554e:	c7 45 b4 7c df 11 c0 	movl   $0xc011df7c,-0x4c(%ebp)
    return list->next == list;
c0105555:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105558:	8b 40 04             	mov    0x4(%eax),%eax
c010555b:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c010555e:	0f 94 c0             	sete   %al
c0105561:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105564:	85 c0                	test   %eax,%eax
c0105566:	75 24                	jne    c010558c <default_check+0x1d3>
c0105568:	c7 44 24 0c 07 75 10 	movl   $0xc0107507,0xc(%esp)
c010556f:	c0 
c0105570:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105577:	c0 
c0105578:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c010557f:	00 
c0105580:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105587:	e8 a5 ae ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c010558c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105593:	e8 52 db ff ff       	call   c01030ea <alloc_pages>
c0105598:	85 c0                	test   %eax,%eax
c010559a:	74 24                	je     c01055c0 <default_check+0x207>
c010559c:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c01055a3:	c0 
c01055a4:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01055ab:	c0 
c01055ac:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01055b3:	00 
c01055b4:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01055bb:	e8 71 ae ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c01055c0:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c01055c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01055c8:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c01055cf:	00 00 00 

    free_pages(p0 + 2, 3);
c01055d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d5:	83 c0 28             	add    $0x28,%eax
c01055d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01055df:	00 
c01055e0:	89 04 24             	mov    %eax,(%esp)
c01055e3:	e8 3e db ff ff       	call   c0103126 <free_pages>
    assert(alloc_pages(4) == NULL);
c01055e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01055ef:	e8 f6 da ff ff       	call   c01030ea <alloc_pages>
c01055f4:	85 c0                	test   %eax,%eax
c01055f6:	74 24                	je     c010561c <default_check+0x263>
c01055f8:	c7 44 24 0c c4 75 10 	movl   $0xc01075c4,0xc(%esp)
c01055ff:	c0 
c0105600:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105607:	c0 
c0105608:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010560f:	00 
c0105610:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105617:	e8 15 ae ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010561c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010561f:	83 c0 28             	add    $0x28,%eax
c0105622:	83 c0 04             	add    $0x4,%eax
c0105625:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010562c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010562f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105632:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105635:	0f a3 10             	bt     %edx,(%eax)
c0105638:	19 c0                	sbb    %eax,%eax
c010563a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010563d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105641:	0f 95 c0             	setne  %al
c0105644:	0f b6 c0             	movzbl %al,%eax
c0105647:	85 c0                	test   %eax,%eax
c0105649:	74 0e                	je     c0105659 <default_check+0x2a0>
c010564b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010564e:	83 c0 28             	add    $0x28,%eax
c0105651:	8b 40 08             	mov    0x8(%eax),%eax
c0105654:	83 f8 03             	cmp    $0x3,%eax
c0105657:	74 24                	je     c010567d <default_check+0x2c4>
c0105659:	c7 44 24 0c dc 75 10 	movl   $0xc01075dc,0xc(%esp)
c0105660:	c0 
c0105661:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105668:	c0 
c0105669:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105670:	00 
c0105671:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105678:	e8 b4 ad ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010567d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105684:	e8 61 da ff ff       	call   c01030ea <alloc_pages>
c0105689:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010568c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105690:	75 24                	jne    c01056b6 <default_check+0x2fd>
c0105692:	c7 44 24 0c 08 76 10 	movl   $0xc0107608,0xc(%esp)
c0105699:	c0 
c010569a:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01056a1:	c0 
c01056a2:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01056a9:	00 
c01056aa:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01056b1:	e8 7b ad ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c01056b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056bd:	e8 28 da ff ff       	call   c01030ea <alloc_pages>
c01056c2:	85 c0                	test   %eax,%eax
c01056c4:	74 24                	je     c01056ea <default_check+0x331>
c01056c6:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c01056cd:	c0 
c01056ce:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01056d5:	c0 
c01056d6:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01056dd:	00 
c01056de:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01056e5:	e8 47 ad ff ff       	call   c0100431 <__panic>
    assert(p0 + 2 == p1);
c01056ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ed:	83 c0 28             	add    $0x28,%eax
c01056f0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01056f3:	74 24                	je     c0105719 <default_check+0x360>
c01056f5:	c7 44 24 0c 26 76 10 	movl   $0xc0107626,0xc(%esp)
c01056fc:	c0 
c01056fd:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105704:	c0 
c0105705:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010570c:	00 
c010570d:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105714:	e8 18 ad ff ff       	call   c0100431 <__panic>

    p2 = p0 + 1;
c0105719:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010571c:	83 c0 14             	add    $0x14,%eax
c010571f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0105722:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105729:	00 
c010572a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010572d:	89 04 24             	mov    %eax,(%esp)
c0105730:	e8 f1 d9 ff ff       	call   c0103126 <free_pages>
    free_pages(p1, 3);
c0105735:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010573c:	00 
c010573d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105740:	89 04 24             	mov    %eax,(%esp)
c0105743:	e8 de d9 ff ff       	call   c0103126 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105748:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010574b:	83 c0 04             	add    $0x4,%eax
c010574e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105755:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105758:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010575b:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010575e:	0f a3 10             	bt     %edx,(%eax)
c0105761:	19 c0                	sbb    %eax,%eax
c0105763:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105766:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010576a:	0f 95 c0             	setne  %al
c010576d:	0f b6 c0             	movzbl %al,%eax
c0105770:	85 c0                	test   %eax,%eax
c0105772:	74 0b                	je     c010577f <default_check+0x3c6>
c0105774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105777:	8b 40 08             	mov    0x8(%eax),%eax
c010577a:	83 f8 01             	cmp    $0x1,%eax
c010577d:	74 24                	je     c01057a3 <default_check+0x3ea>
c010577f:	c7 44 24 0c 34 76 10 	movl   $0xc0107634,0xc(%esp)
c0105786:	c0 
c0105787:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010578e:	c0 
c010578f:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0105796:	00 
c0105797:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010579e:	e8 8e ac ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01057a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057a6:	83 c0 04             	add    $0x4,%eax
c01057a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01057b0:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01057b3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01057b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01057b9:	0f a3 10             	bt     %edx,(%eax)
c01057bc:	19 c0                	sbb    %eax,%eax
c01057be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01057c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01057c5:	0f 95 c0             	setne  %al
c01057c8:	0f b6 c0             	movzbl %al,%eax
c01057cb:	85 c0                	test   %eax,%eax
c01057cd:	74 0b                	je     c01057da <default_check+0x421>
c01057cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057d2:	8b 40 08             	mov    0x8(%eax),%eax
c01057d5:	83 f8 03             	cmp    $0x3,%eax
c01057d8:	74 24                	je     c01057fe <default_check+0x445>
c01057da:	c7 44 24 0c 5c 76 10 	movl   $0xc010765c,0xc(%esp)
c01057e1:	c0 
c01057e2:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01057e9:	c0 
c01057ea:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01057f1:	00 
c01057f2:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01057f9:	e8 33 ac ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01057fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105805:	e8 e0 d8 ff ff       	call   c01030ea <alloc_pages>
c010580a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010580d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105810:	83 e8 14             	sub    $0x14,%eax
c0105813:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105816:	74 24                	je     c010583c <default_check+0x483>
c0105818:	c7 44 24 0c 82 76 10 	movl   $0xc0107682,0xc(%esp)
c010581f:	c0 
c0105820:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105827:	c0 
c0105828:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c010582f:	00 
c0105830:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105837:	e8 f5 ab ff ff       	call   c0100431 <__panic>
    free_page(p0);
c010583c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105843:	00 
c0105844:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105847:	89 04 24             	mov    %eax,(%esp)
c010584a:	e8 d7 d8 ff ff       	call   c0103126 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010584f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105856:	e8 8f d8 ff ff       	call   c01030ea <alloc_pages>
c010585b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010585e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105861:	83 c0 14             	add    $0x14,%eax
c0105864:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105867:	74 24                	je     c010588d <default_check+0x4d4>
c0105869:	c7 44 24 0c a0 76 10 	movl   $0xc01076a0,0xc(%esp)
c0105870:	c0 
c0105871:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105878:	c0 
c0105879:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105880:	00 
c0105881:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105888:	e8 a4 ab ff ff       	call   c0100431 <__panic>

    free_pages(p0, 2);
c010588d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105894:	00 
c0105895:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105898:	89 04 24             	mov    %eax,(%esp)
c010589b:	e8 86 d8 ff ff       	call   c0103126 <free_pages>
    free_page(p2);
c01058a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058a7:	00 
c01058a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058ab:	89 04 24             	mov    %eax,(%esp)
c01058ae:	e8 73 d8 ff ff       	call   c0103126 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01058b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01058ba:	e8 2b d8 ff ff       	call   c01030ea <alloc_pages>
c01058bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058c6:	75 24                	jne    c01058ec <default_check+0x533>
c01058c8:	c7 44 24 0c c0 76 10 	movl   $0xc01076c0,0xc(%esp)
c01058cf:	c0 
c01058d0:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01058d7:	c0 
c01058d8:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01058df:	00 
c01058e0:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01058e7:	e8 45 ab ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c01058ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058f3:	e8 f2 d7 ff ff       	call   c01030ea <alloc_pages>
c01058f8:	85 c0                	test   %eax,%eax
c01058fa:	74 24                	je     c0105920 <default_check+0x567>
c01058fc:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c0105903:	c0 
c0105904:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c010590b:	c0 
c010590c:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0105913:	00 
c0105914:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c010591b:	e8 11 ab ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c0105920:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0105925:	85 c0                	test   %eax,%eax
c0105927:	74 24                	je     c010594d <default_check+0x594>
c0105929:	c7 44 24 0c 71 75 10 	movl   $0xc0107571,0xc(%esp)
c0105930:	c0 
c0105931:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105938:	c0 
c0105939:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0105940:	00 
c0105941:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105948:	e8 e4 aa ff ff       	call   c0100431 <__panic>
    nr_free = nr_free_store;
c010594d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105950:	a3 84 df 11 c0       	mov    %eax,0xc011df84

    free_list = free_list_store;
c0105955:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105958:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010595b:	a3 7c df 11 c0       	mov    %eax,0xc011df7c
c0105960:	89 15 80 df 11 c0    	mov    %edx,0xc011df80
    free_pages(p0, 5);
c0105966:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010596d:	00 
c010596e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105971:	89 04 24             	mov    %eax,(%esp)
c0105974:	e8 ad d7 ff ff       	call   c0103126 <free_pages>

    le = &free_list;
c0105979:	c7 45 ec 7c df 11 c0 	movl   $0xc011df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105980:	eb 5a                	jmp    c01059dc <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
c0105982:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105985:	8b 40 04             	mov    0x4(%eax),%eax
c0105988:	8b 00                	mov    (%eax),%eax
c010598a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010598d:	75 0d                	jne    c010599c <default_check+0x5e3>
c010598f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105992:	8b 00                	mov    (%eax),%eax
c0105994:	8b 40 04             	mov    0x4(%eax),%eax
c0105997:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010599a:	74 24                	je     c01059c0 <default_check+0x607>
c010599c:	c7 44 24 0c e0 76 10 	movl   $0xc01076e0,0xc(%esp)
c01059a3:	c0 
c01059a4:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c01059ab:	c0 
c01059ac:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01059b3:	00 
c01059b4:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c01059bb:	e8 71 aa ff ff       	call   c0100431 <__panic>
        struct Page *p = le2page(le, page_link);
c01059c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059c3:	83 e8 0c             	sub    $0xc,%eax
c01059c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01059c9:	ff 4d f4             	decl   -0xc(%ebp)
c01059cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059d2:	8b 40 08             	mov    0x8(%eax),%eax
c01059d5:	29 c2                	sub    %eax,%edx
c01059d7:	89 d0                	mov    %edx,%eax
c01059d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059df:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01059e2:	8b 45 88             	mov    -0x78(%ebp),%eax
c01059e5:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01059e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059eb:	81 7d ec 7c df 11 c0 	cmpl   $0xc011df7c,-0x14(%ebp)
c01059f2:	75 8e                	jne    c0105982 <default_check+0x5c9>
    }
    assert(count == 0);
c01059f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059f8:	74 24                	je     c0105a1e <default_check+0x665>
c01059fa:	c7 44 24 0c 0d 77 10 	movl   $0xc010770d,0xc(%esp)
c0105a01:	c0 
c0105a02:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105a09:	c0 
c0105a0a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0105a11:	00 
c0105a12:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105a19:	e8 13 aa ff ff       	call   c0100431 <__panic>
    assert(total == 0);
c0105a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a22:	74 24                	je     c0105a48 <default_check+0x68f>
c0105a24:	c7 44 24 0c 18 77 10 	movl   $0xc0107718,0xc(%esp)
c0105a2b:	c0 
c0105a2c:	c7 44 24 08 7e 73 10 	movl   $0xc010737e,0x8(%esp)
c0105a33:	c0 
c0105a34:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0105a3b:	00 
c0105a3c:	c7 04 24 93 73 10 c0 	movl   $0xc0107393,(%esp)
c0105a43:	e8 e9 a9 ff ff       	call   c0100431 <__panic>
}
c0105a48:	90                   	nop
c0105a49:	c9                   	leave  
c0105a4a:	c3                   	ret    

c0105a4b <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a4b:	f3 0f 1e fb          	endbr32 
c0105a4f:	55                   	push   %ebp
c0105a50:	89 e5                	mov    %esp,%ebp
c0105a52:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a5c:	eb 03                	jmp    c0105a61 <strlen+0x16>
        cnt ++;
c0105a5e:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a64:	8d 50 01             	lea    0x1(%eax),%edx
c0105a67:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a6a:	0f b6 00             	movzbl (%eax),%eax
c0105a6d:	84 c0                	test   %al,%al
c0105a6f:	75 ed                	jne    c0105a5e <strlen+0x13>
    }
    return cnt;
c0105a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a74:	c9                   	leave  
c0105a75:	c3                   	ret    

c0105a76 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a76:	f3 0f 1e fb          	endbr32 
c0105a7a:	55                   	push   %ebp
c0105a7b:	89 e5                	mov    %esp,%ebp
c0105a7d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a87:	eb 03                	jmp    c0105a8c <strnlen+0x16>
        cnt ++;
c0105a89:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a92:	73 10                	jae    c0105aa4 <strnlen+0x2e>
c0105a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a97:	8d 50 01             	lea    0x1(%eax),%edx
c0105a9a:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a9d:	0f b6 00             	movzbl (%eax),%eax
c0105aa0:	84 c0                	test   %al,%al
c0105aa2:	75 e5                	jne    c0105a89 <strnlen+0x13>
    }
    return cnt;
c0105aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105aa7:	c9                   	leave  
c0105aa8:	c3                   	ret    

c0105aa9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105aa9:	f3 0f 1e fb          	endbr32 
c0105aad:	55                   	push   %ebp
c0105aae:	89 e5                	mov    %esp,%ebp
c0105ab0:	57                   	push   %edi
c0105ab1:	56                   	push   %esi
c0105ab2:	83 ec 20             	sub    $0x20,%esp
c0105ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105ac1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ac7:	89 d1                	mov    %edx,%ecx
c0105ac9:	89 c2                	mov    %eax,%edx
c0105acb:	89 ce                	mov    %ecx,%esi
c0105acd:	89 d7                	mov    %edx,%edi
c0105acf:	ac                   	lods   %ds:(%esi),%al
c0105ad0:	aa                   	stos   %al,%es:(%edi)
c0105ad1:	84 c0                	test   %al,%al
c0105ad3:	75 fa                	jne    c0105acf <strcpy+0x26>
c0105ad5:	89 fa                	mov    %edi,%edx
c0105ad7:	89 f1                	mov    %esi,%ecx
c0105ad9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105adc:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105ae5:	83 c4 20             	add    $0x20,%esp
c0105ae8:	5e                   	pop    %esi
c0105ae9:	5f                   	pop    %edi
c0105aea:	5d                   	pop    %ebp
c0105aeb:	c3                   	ret    

c0105aec <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105aec:	f3 0f 1e fb          	endbr32 
c0105af0:	55                   	push   %ebp
c0105af1:	89 e5                	mov    %esp,%ebp
c0105af3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105afc:	eb 1e                	jmp    c0105b1c <strncpy+0x30>
        if ((*p = *src) != '\0') {
c0105afe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b01:	0f b6 10             	movzbl (%eax),%edx
c0105b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b07:	88 10                	mov    %dl,(%eax)
c0105b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b0c:	0f b6 00             	movzbl (%eax),%eax
c0105b0f:	84 c0                	test   %al,%al
c0105b11:	74 03                	je     c0105b16 <strncpy+0x2a>
            src ++;
c0105b13:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105b16:	ff 45 fc             	incl   -0x4(%ebp)
c0105b19:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b20:	75 dc                	jne    c0105afe <strncpy+0x12>
    }
    return dst;
c0105b22:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b25:	c9                   	leave  
c0105b26:	c3                   	ret    

c0105b27 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b27:	f3 0f 1e fb          	endbr32 
c0105b2b:	55                   	push   %ebp
c0105b2c:	89 e5                	mov    %esp,%ebp
c0105b2e:	57                   	push   %edi
c0105b2f:	56                   	push   %esi
c0105b30:	83 ec 20             	sub    $0x20,%esp
c0105b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b45:	89 d1                	mov    %edx,%ecx
c0105b47:	89 c2                	mov    %eax,%edx
c0105b49:	89 ce                	mov    %ecx,%esi
c0105b4b:	89 d7                	mov    %edx,%edi
c0105b4d:	ac                   	lods   %ds:(%esi),%al
c0105b4e:	ae                   	scas   %es:(%edi),%al
c0105b4f:	75 08                	jne    c0105b59 <strcmp+0x32>
c0105b51:	84 c0                	test   %al,%al
c0105b53:	75 f8                	jne    c0105b4d <strcmp+0x26>
c0105b55:	31 c0                	xor    %eax,%eax
c0105b57:	eb 04                	jmp    c0105b5d <strcmp+0x36>
c0105b59:	19 c0                	sbb    %eax,%eax
c0105b5b:	0c 01                	or     $0x1,%al
c0105b5d:	89 fa                	mov    %edi,%edx
c0105b5f:	89 f1                	mov    %esi,%ecx
c0105b61:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b64:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b67:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b6d:	83 c4 20             	add    $0x20,%esp
c0105b70:	5e                   	pop    %esi
c0105b71:	5f                   	pop    %edi
c0105b72:	5d                   	pop    %ebp
c0105b73:	c3                   	ret    

c0105b74 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b74:	f3 0f 1e fb          	endbr32 
c0105b78:	55                   	push   %ebp
c0105b79:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b7b:	eb 09                	jmp    c0105b86 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0105b7d:	ff 4d 10             	decl   0x10(%ebp)
c0105b80:	ff 45 08             	incl   0x8(%ebp)
c0105b83:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b8a:	74 1a                	je     c0105ba6 <strncmp+0x32>
c0105b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8f:	0f b6 00             	movzbl (%eax),%eax
c0105b92:	84 c0                	test   %al,%al
c0105b94:	74 10                	je     c0105ba6 <strncmp+0x32>
c0105b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b99:	0f b6 10             	movzbl (%eax),%edx
c0105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9f:	0f b6 00             	movzbl (%eax),%eax
c0105ba2:	38 c2                	cmp    %al,%dl
c0105ba4:	74 d7                	je     c0105b7d <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105baa:	74 18                	je     c0105bc4 <strncmp+0x50>
c0105bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baf:	0f b6 00             	movzbl (%eax),%eax
c0105bb2:	0f b6 d0             	movzbl %al,%edx
c0105bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb8:	0f b6 00             	movzbl (%eax),%eax
c0105bbb:	0f b6 c0             	movzbl %al,%eax
c0105bbe:	29 c2                	sub    %eax,%edx
c0105bc0:	89 d0                	mov    %edx,%eax
c0105bc2:	eb 05                	jmp    c0105bc9 <strncmp+0x55>
c0105bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bc9:	5d                   	pop    %ebp
c0105bca:	c3                   	ret    

c0105bcb <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105bcb:	f3 0f 1e fb          	endbr32 
c0105bcf:	55                   	push   %ebp
c0105bd0:	89 e5                	mov    %esp,%ebp
c0105bd2:	83 ec 04             	sub    $0x4,%esp
c0105bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bdb:	eb 13                	jmp    c0105bf0 <strchr+0x25>
        if (*s == c) {
c0105bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be0:	0f b6 00             	movzbl (%eax),%eax
c0105be3:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105be6:	75 05                	jne    c0105bed <strchr+0x22>
            return (char *)s;
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105beb:	eb 12                	jmp    c0105bff <strchr+0x34>
        }
        s ++;
c0105bed:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf3:	0f b6 00             	movzbl (%eax),%eax
c0105bf6:	84 c0                	test   %al,%al
c0105bf8:	75 e3                	jne    c0105bdd <strchr+0x12>
    }
    return NULL;
c0105bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bff:	c9                   	leave  
c0105c00:	c3                   	ret    

c0105c01 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c01:	f3 0f 1e fb          	endbr32 
c0105c05:	55                   	push   %ebp
c0105c06:	89 e5                	mov    %esp,%ebp
c0105c08:	83 ec 04             	sub    $0x4,%esp
c0105c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c11:	eb 0e                	jmp    c0105c21 <strfind+0x20>
        if (*s == c) {
c0105c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c16:	0f b6 00             	movzbl (%eax),%eax
c0105c19:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c1c:	74 0f                	je     c0105c2d <strfind+0x2c>
            break;
        }
        s ++;
c0105c1e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c24:	0f b6 00             	movzbl (%eax),%eax
c0105c27:	84 c0                	test   %al,%al
c0105c29:	75 e8                	jne    c0105c13 <strfind+0x12>
c0105c2b:	eb 01                	jmp    c0105c2e <strfind+0x2d>
            break;
c0105c2d:	90                   	nop
    }
    return (char *)s;
c0105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c31:	c9                   	leave  
c0105c32:	c3                   	ret    

c0105c33 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c33:	f3 0f 1e fb          	endbr32 
c0105c37:	55                   	push   %ebp
c0105c38:	89 e5                	mov    %esp,%ebp
c0105c3a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c4b:	eb 03                	jmp    c0105c50 <strtol+0x1d>
        s ++;
c0105c4d:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c53:	0f b6 00             	movzbl (%eax),%eax
c0105c56:	3c 20                	cmp    $0x20,%al
c0105c58:	74 f3                	je     c0105c4d <strtol+0x1a>
c0105c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5d:	0f b6 00             	movzbl (%eax),%eax
c0105c60:	3c 09                	cmp    $0x9,%al
c0105c62:	74 e9                	je     c0105c4d <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c0105c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c67:	0f b6 00             	movzbl (%eax),%eax
c0105c6a:	3c 2b                	cmp    $0x2b,%al
c0105c6c:	75 05                	jne    c0105c73 <strtol+0x40>
        s ++;
c0105c6e:	ff 45 08             	incl   0x8(%ebp)
c0105c71:	eb 14                	jmp    c0105c87 <strtol+0x54>
    }
    else if (*s == '-') {
c0105c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c76:	0f b6 00             	movzbl (%eax),%eax
c0105c79:	3c 2d                	cmp    $0x2d,%al
c0105c7b:	75 0a                	jne    c0105c87 <strtol+0x54>
        s ++, neg = 1;
c0105c7d:	ff 45 08             	incl   0x8(%ebp)
c0105c80:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c8b:	74 06                	je     c0105c93 <strtol+0x60>
c0105c8d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c91:	75 22                	jne    c0105cb5 <strtol+0x82>
c0105c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c96:	0f b6 00             	movzbl (%eax),%eax
c0105c99:	3c 30                	cmp    $0x30,%al
c0105c9b:	75 18                	jne    c0105cb5 <strtol+0x82>
c0105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca0:	40                   	inc    %eax
c0105ca1:	0f b6 00             	movzbl (%eax),%eax
c0105ca4:	3c 78                	cmp    $0x78,%al
c0105ca6:	75 0d                	jne    c0105cb5 <strtol+0x82>
        s += 2, base = 16;
c0105ca8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105cac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cb3:	eb 29                	jmp    c0105cde <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0105cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cb9:	75 16                	jne    c0105cd1 <strtol+0x9e>
c0105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbe:	0f b6 00             	movzbl (%eax),%eax
c0105cc1:	3c 30                	cmp    $0x30,%al
c0105cc3:	75 0c                	jne    c0105cd1 <strtol+0x9e>
        s ++, base = 8;
c0105cc5:	ff 45 08             	incl   0x8(%ebp)
c0105cc8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105ccf:	eb 0d                	jmp    c0105cde <strtol+0xab>
    }
    else if (base == 0) {
c0105cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cd5:	75 07                	jne    c0105cde <strtol+0xab>
        base = 10;
c0105cd7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce1:	0f b6 00             	movzbl (%eax),%eax
c0105ce4:	3c 2f                	cmp    $0x2f,%al
c0105ce6:	7e 1b                	jle    c0105d03 <strtol+0xd0>
c0105ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ceb:	0f b6 00             	movzbl (%eax),%eax
c0105cee:	3c 39                	cmp    $0x39,%al
c0105cf0:	7f 11                	jg     c0105d03 <strtol+0xd0>
            dig = *s - '0';
c0105cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf5:	0f b6 00             	movzbl (%eax),%eax
c0105cf8:	0f be c0             	movsbl %al,%eax
c0105cfb:	83 e8 30             	sub    $0x30,%eax
c0105cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d01:	eb 48                	jmp    c0105d4b <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d06:	0f b6 00             	movzbl (%eax),%eax
c0105d09:	3c 60                	cmp    $0x60,%al
c0105d0b:	7e 1b                	jle    c0105d28 <strtol+0xf5>
c0105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d10:	0f b6 00             	movzbl (%eax),%eax
c0105d13:	3c 7a                	cmp    $0x7a,%al
c0105d15:	7f 11                	jg     c0105d28 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0105d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1a:	0f b6 00             	movzbl (%eax),%eax
c0105d1d:	0f be c0             	movsbl %al,%eax
c0105d20:	83 e8 57             	sub    $0x57,%eax
c0105d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d26:	eb 23                	jmp    c0105d4b <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2b:	0f b6 00             	movzbl (%eax),%eax
c0105d2e:	3c 40                	cmp    $0x40,%al
c0105d30:	7e 3b                	jle    c0105d6d <strtol+0x13a>
c0105d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d35:	0f b6 00             	movzbl (%eax),%eax
c0105d38:	3c 5a                	cmp    $0x5a,%al
c0105d3a:	7f 31                	jg     c0105d6d <strtol+0x13a>
            dig = *s - 'A' + 10;
c0105d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3f:	0f b6 00             	movzbl (%eax),%eax
c0105d42:	0f be c0             	movsbl %al,%eax
c0105d45:	83 e8 37             	sub    $0x37,%eax
c0105d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d4e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d51:	7d 19                	jge    c0105d6c <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c0105d53:	ff 45 08             	incl   0x8(%ebp)
c0105d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d59:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d5d:	89 c2                	mov    %eax,%edx
c0105d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d62:	01 d0                	add    %edx,%eax
c0105d64:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105d67:	e9 72 ff ff ff       	jmp    c0105cde <strtol+0xab>
            break;
c0105d6c:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d71:	74 08                	je     c0105d7b <strtol+0x148>
        *endptr = (char *) s;
c0105d73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d76:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d79:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d7f:	74 07                	je     c0105d88 <strtol+0x155>
c0105d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d84:	f7 d8                	neg    %eax
c0105d86:	eb 03                	jmp    c0105d8b <strtol+0x158>
c0105d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d8b:	c9                   	leave  
c0105d8c:	c3                   	ret    

c0105d8d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d8d:	f3 0f 1e fb          	endbr32 
c0105d91:	55                   	push   %ebp
c0105d92:	89 e5                	mov    %esp,%ebp
c0105d94:	57                   	push   %edi
c0105d95:	83 ec 24             	sub    $0x24,%esp
c0105d98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d9b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d9e:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105da8:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105dab:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105db1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105db4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105db8:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105dbb:	89 d7                	mov    %edx,%edi
c0105dbd:	f3 aa                	rep stos %al,%es:(%edi)
c0105dbf:	89 fa                	mov    %edi,%edx
c0105dc1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105dc4:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105dca:	83 c4 24             	add    $0x24,%esp
c0105dcd:	5f                   	pop    %edi
c0105dce:	5d                   	pop    %ebp
c0105dcf:	c3                   	ret    

c0105dd0 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105dd0:	f3 0f 1e fb          	endbr32 
c0105dd4:	55                   	push   %ebp
c0105dd5:	89 e5                	mov    %esp,%ebp
c0105dd7:	57                   	push   %edi
c0105dd8:	56                   	push   %esi
c0105dd9:	53                   	push   %ebx
c0105dda:	83 ec 30             	sub    $0x30,%esp
c0105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105de3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105de9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dec:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105df2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105df5:	73 42                	jae    c0105e39 <memmove+0x69>
c0105df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e06:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e0c:	c1 e8 02             	shr    $0x2,%eax
c0105e0f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e17:	89 d7                	mov    %edx,%edi
c0105e19:	89 c6                	mov    %eax,%esi
c0105e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e1d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e20:	83 e1 03             	and    $0x3,%ecx
c0105e23:	74 02                	je     c0105e27 <memmove+0x57>
c0105e25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e27:	89 f0                	mov    %esi,%eax
c0105e29:	89 fa                	mov    %edi,%edx
c0105e2b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e31:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105e37:	eb 36                	jmp    c0105e6f <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e3c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e42:	01 c2                	add    %eax,%edx
c0105e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e47:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e4d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e53:	89 c1                	mov    %eax,%ecx
c0105e55:	89 d8                	mov    %ebx,%eax
c0105e57:	89 d6                	mov    %edx,%esi
c0105e59:	89 c7                	mov    %eax,%edi
c0105e5b:	fd                   	std    
c0105e5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e5e:	fc                   	cld    
c0105e5f:	89 f8                	mov    %edi,%eax
c0105e61:	89 f2                	mov    %esi,%edx
c0105e63:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e66:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e6f:	83 c4 30             	add    $0x30,%esp
c0105e72:	5b                   	pop    %ebx
c0105e73:	5e                   	pop    %esi
c0105e74:	5f                   	pop    %edi
c0105e75:	5d                   	pop    %ebp
c0105e76:	c3                   	ret    

c0105e77 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e77:	f3 0f 1e fb          	endbr32 
c0105e7b:	55                   	push   %ebp
c0105e7c:	89 e5                	mov    %esp,%ebp
c0105e7e:	57                   	push   %edi
c0105e7f:	56                   	push   %esi
c0105e80:	83 ec 20             	sub    $0x20,%esp
c0105e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e8f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e92:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e98:	c1 e8 02             	shr    $0x2,%eax
c0105e9b:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ea3:	89 d7                	mov    %edx,%edi
c0105ea5:	89 c6                	mov    %eax,%esi
c0105ea7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ea9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105eac:	83 e1 03             	and    $0x3,%ecx
c0105eaf:	74 02                	je     c0105eb3 <memcpy+0x3c>
c0105eb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105eb3:	89 f0                	mov    %esi,%eax
c0105eb5:	89 fa                	mov    %edi,%edx
c0105eb7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105eba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105ec3:	83 c4 20             	add    $0x20,%esp
c0105ec6:	5e                   	pop    %esi
c0105ec7:	5f                   	pop    %edi
c0105ec8:	5d                   	pop    %ebp
c0105ec9:	c3                   	ret    

c0105eca <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105eca:	f3 0f 1e fb          	endbr32 
c0105ece:	55                   	push   %ebp
c0105ecf:	89 e5                	mov    %esp,%ebp
c0105ed1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105eda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105edd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105ee0:	eb 2e                	jmp    c0105f10 <memcmp+0x46>
        if (*s1 != *s2) {
c0105ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ee5:	0f b6 10             	movzbl (%eax),%edx
c0105ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105eeb:	0f b6 00             	movzbl (%eax),%eax
c0105eee:	38 c2                	cmp    %al,%dl
c0105ef0:	74 18                	je     c0105f0a <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ef5:	0f b6 00             	movzbl (%eax),%eax
c0105ef8:	0f b6 d0             	movzbl %al,%edx
c0105efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105efe:	0f b6 00             	movzbl (%eax),%eax
c0105f01:	0f b6 c0             	movzbl %al,%eax
c0105f04:	29 c2                	sub    %eax,%edx
c0105f06:	89 d0                	mov    %edx,%eax
c0105f08:	eb 18                	jmp    c0105f22 <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0105f0a:	ff 45 fc             	incl   -0x4(%ebp)
c0105f0d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105f10:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f13:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f16:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f19:	85 c0                	test   %eax,%eax
c0105f1b:	75 c5                	jne    c0105ee2 <memcmp+0x18>
    }
    return 0;
c0105f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f22:	c9                   	leave  
c0105f23:	c3                   	ret    

c0105f24 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105f24:	f3 0f 1e fb          	endbr32 
c0105f28:	55                   	push   %ebp
c0105f29:	89 e5                	mov    %esp,%ebp
c0105f2b:	83 ec 58             	sub    $0x58,%esp
c0105f2e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f31:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105f34:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105f3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f43:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105f46:	8b 45 18             	mov    0x18(%ebp),%eax
c0105f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f55:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f62:	74 1c                	je     c0105f80 <printnum+0x5c>
c0105f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f67:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f6c:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f75:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f7a:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f86:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f92:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105f95:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f98:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f9e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105fa1:	8b 45 18             	mov    0x18(%ebp),%eax
c0105fa4:	ba 00 00 00 00       	mov    $0x0,%edx
c0105fa9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105fac:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105faf:	19 d1                	sbb    %edx,%ecx
c0105fb1:	72 4c                	jb     c0105fff <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105fb3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105fb9:	8b 45 20             	mov    0x20(%ebp),%eax
c0105fbc:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105fc0:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105fc4:	8b 45 18             	mov    0x18(%ebp),%eax
c0105fc7:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105fd1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105fd5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fe0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe3:	89 04 24             	mov    %eax,(%esp)
c0105fe6:	e8 39 ff ff ff       	call   c0105f24 <printnum>
c0105feb:	eb 1b                	jmp    c0106008 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105fed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ff4:	8b 45 20             	mov    0x20(%ebp),%eax
c0105ff7:	89 04 24             	mov    %eax,(%esp)
c0105ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffd:	ff d0                	call   *%eax
        while (-- width > 0)
c0105fff:	ff 4d 1c             	decl   0x1c(%ebp)
c0106002:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106006:	7f e5                	jg     c0105fed <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106008:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010600b:	05 d4 77 10 c0       	add    $0xc01077d4,%eax
c0106010:	0f b6 00             	movzbl (%eax),%eax
c0106013:	0f be c0             	movsbl %al,%eax
c0106016:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106019:	89 54 24 04          	mov    %edx,0x4(%esp)
c010601d:	89 04 24             	mov    %eax,(%esp)
c0106020:	8b 45 08             	mov    0x8(%ebp),%eax
c0106023:	ff d0                	call   *%eax
}
c0106025:	90                   	nop
c0106026:	c9                   	leave  
c0106027:	c3                   	ret    

c0106028 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0106028:	f3 0f 1e fb          	endbr32 
c010602c:	55                   	push   %ebp
c010602d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010602f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106033:	7e 14                	jle    c0106049 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0106035:	8b 45 08             	mov    0x8(%ebp),%eax
c0106038:	8b 00                	mov    (%eax),%eax
c010603a:	8d 48 08             	lea    0x8(%eax),%ecx
c010603d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106040:	89 0a                	mov    %ecx,(%edx)
c0106042:	8b 50 04             	mov    0x4(%eax),%edx
c0106045:	8b 00                	mov    (%eax),%eax
c0106047:	eb 30                	jmp    c0106079 <getuint+0x51>
    }
    else if (lflag) {
c0106049:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010604d:	74 16                	je     c0106065 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c010604f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106052:	8b 00                	mov    (%eax),%eax
c0106054:	8d 48 04             	lea    0x4(%eax),%ecx
c0106057:	8b 55 08             	mov    0x8(%ebp),%edx
c010605a:	89 0a                	mov    %ecx,(%edx)
c010605c:	8b 00                	mov    (%eax),%eax
c010605e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106063:	eb 14                	jmp    c0106079 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0106065:	8b 45 08             	mov    0x8(%ebp),%eax
c0106068:	8b 00                	mov    (%eax),%eax
c010606a:	8d 48 04             	lea    0x4(%eax),%ecx
c010606d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106070:	89 0a                	mov    %ecx,(%edx)
c0106072:	8b 00                	mov    (%eax),%eax
c0106074:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106079:	5d                   	pop    %ebp
c010607a:	c3                   	ret    

c010607b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010607b:	f3 0f 1e fb          	endbr32 
c010607f:	55                   	push   %ebp
c0106080:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106082:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106086:	7e 14                	jle    c010609c <getint+0x21>
        return va_arg(*ap, long long);
c0106088:	8b 45 08             	mov    0x8(%ebp),%eax
c010608b:	8b 00                	mov    (%eax),%eax
c010608d:	8d 48 08             	lea    0x8(%eax),%ecx
c0106090:	8b 55 08             	mov    0x8(%ebp),%edx
c0106093:	89 0a                	mov    %ecx,(%edx)
c0106095:	8b 50 04             	mov    0x4(%eax),%edx
c0106098:	8b 00                	mov    (%eax),%eax
c010609a:	eb 28                	jmp    c01060c4 <getint+0x49>
    }
    else if (lflag) {
c010609c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01060a0:	74 12                	je     c01060b4 <getint+0x39>
        return va_arg(*ap, long);
c01060a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060a5:	8b 00                	mov    (%eax),%eax
c01060a7:	8d 48 04             	lea    0x4(%eax),%ecx
c01060aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01060ad:	89 0a                	mov    %ecx,(%edx)
c01060af:	8b 00                	mov    (%eax),%eax
c01060b1:	99                   	cltd   
c01060b2:	eb 10                	jmp    c01060c4 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c01060b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01060b7:	8b 00                	mov    (%eax),%eax
c01060b9:	8d 48 04             	lea    0x4(%eax),%ecx
c01060bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01060bf:	89 0a                	mov    %ecx,(%edx)
c01060c1:	8b 00                	mov    (%eax),%eax
c01060c3:	99                   	cltd   
    }
}
c01060c4:	5d                   	pop    %ebp
c01060c5:	c3                   	ret    

c01060c6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01060c6:	f3 0f 1e fb          	endbr32 
c01060ca:	55                   	push   %ebp
c01060cb:	89 e5                	mov    %esp,%ebp
c01060cd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01060d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01060d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01060e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01060e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ee:	89 04 24             	mov    %eax,(%esp)
c01060f1:	e8 03 00 00 00       	call   c01060f9 <vprintfmt>
    va_end(ap);
}
c01060f6:	90                   	nop
c01060f7:	c9                   	leave  
c01060f8:	c3                   	ret    

c01060f9 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01060f9:	f3 0f 1e fb          	endbr32 
c01060fd:	55                   	push   %ebp
c01060fe:	89 e5                	mov    %esp,%ebp
c0106100:	56                   	push   %esi
c0106101:	53                   	push   %ebx
c0106102:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106105:	eb 17                	jmp    c010611e <vprintfmt+0x25>
            if (ch == '\0') {
c0106107:	85 db                	test   %ebx,%ebx
c0106109:	0f 84 c0 03 00 00    	je     c01064cf <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c010610f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106112:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106116:	89 1c 24             	mov    %ebx,(%esp)
c0106119:	8b 45 08             	mov    0x8(%ebp),%eax
c010611c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010611e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106121:	8d 50 01             	lea    0x1(%eax),%edx
c0106124:	89 55 10             	mov    %edx,0x10(%ebp)
c0106127:	0f b6 00             	movzbl (%eax),%eax
c010612a:	0f b6 d8             	movzbl %al,%ebx
c010612d:	83 fb 25             	cmp    $0x25,%ebx
c0106130:	75 d5                	jne    c0106107 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106132:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106136:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010613d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106140:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106143:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010614a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010614d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0106150:	8b 45 10             	mov    0x10(%ebp),%eax
c0106153:	8d 50 01             	lea    0x1(%eax),%edx
c0106156:	89 55 10             	mov    %edx,0x10(%ebp)
c0106159:	0f b6 00             	movzbl (%eax),%eax
c010615c:	0f b6 d8             	movzbl %al,%ebx
c010615f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106162:	83 f8 55             	cmp    $0x55,%eax
c0106165:	0f 87 38 03 00 00    	ja     c01064a3 <vprintfmt+0x3aa>
c010616b:	8b 04 85 f8 77 10 c0 	mov    -0x3fef8808(,%eax,4),%eax
c0106172:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106175:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106179:	eb d5                	jmp    c0106150 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010617b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010617f:	eb cf                	jmp    c0106150 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106181:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010618b:	89 d0                	mov    %edx,%eax
c010618d:	c1 e0 02             	shl    $0x2,%eax
c0106190:	01 d0                	add    %edx,%eax
c0106192:	01 c0                	add    %eax,%eax
c0106194:	01 d8                	add    %ebx,%eax
c0106196:	83 e8 30             	sub    $0x30,%eax
c0106199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010619c:	8b 45 10             	mov    0x10(%ebp),%eax
c010619f:	0f b6 00             	movzbl (%eax),%eax
c01061a2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01061a5:	83 fb 2f             	cmp    $0x2f,%ebx
c01061a8:	7e 38                	jle    c01061e2 <vprintfmt+0xe9>
c01061aa:	83 fb 39             	cmp    $0x39,%ebx
c01061ad:	7f 33                	jg     c01061e2 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c01061af:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01061b2:	eb d4                	jmp    c0106188 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01061b4:	8b 45 14             	mov    0x14(%ebp),%eax
c01061b7:	8d 50 04             	lea    0x4(%eax),%edx
c01061ba:	89 55 14             	mov    %edx,0x14(%ebp)
c01061bd:	8b 00                	mov    (%eax),%eax
c01061bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01061c2:	eb 1f                	jmp    c01061e3 <vprintfmt+0xea>

        case '.':
            if (width < 0)
c01061c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01061c8:	79 86                	jns    c0106150 <vprintfmt+0x57>
                width = 0;
c01061ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01061d1:	e9 7a ff ff ff       	jmp    c0106150 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c01061d6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01061dd:	e9 6e ff ff ff       	jmp    c0106150 <vprintfmt+0x57>
            goto process_precision;
c01061e2:	90                   	nop

        process_precision:
            if (width < 0)
c01061e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01061e7:	0f 89 63 ff ff ff    	jns    c0106150 <vprintfmt+0x57>
                width = precision, precision = -1;
c01061ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061f3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01061fa:	e9 51 ff ff ff       	jmp    c0106150 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01061ff:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0106202:	e9 49 ff ff ff       	jmp    c0106150 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106207:	8b 45 14             	mov    0x14(%ebp),%eax
c010620a:	8d 50 04             	lea    0x4(%eax),%edx
c010620d:	89 55 14             	mov    %edx,0x14(%ebp)
c0106210:	8b 00                	mov    (%eax),%eax
c0106212:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106215:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106219:	89 04 24             	mov    %eax,(%esp)
c010621c:	8b 45 08             	mov    0x8(%ebp),%eax
c010621f:	ff d0                	call   *%eax
            break;
c0106221:	e9 a4 02 00 00       	jmp    c01064ca <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106226:	8b 45 14             	mov    0x14(%ebp),%eax
c0106229:	8d 50 04             	lea    0x4(%eax),%edx
c010622c:	89 55 14             	mov    %edx,0x14(%ebp)
c010622f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106231:	85 db                	test   %ebx,%ebx
c0106233:	79 02                	jns    c0106237 <vprintfmt+0x13e>
                err = -err;
c0106235:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106237:	83 fb 06             	cmp    $0x6,%ebx
c010623a:	7f 0b                	jg     c0106247 <vprintfmt+0x14e>
c010623c:	8b 34 9d b8 77 10 c0 	mov    -0x3fef8848(,%ebx,4),%esi
c0106243:	85 f6                	test   %esi,%esi
c0106245:	75 23                	jne    c010626a <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0106247:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010624b:	c7 44 24 08 e5 77 10 	movl   $0xc01077e5,0x8(%esp)
c0106252:	c0 
c0106253:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106256:	89 44 24 04          	mov    %eax,0x4(%esp)
c010625a:	8b 45 08             	mov    0x8(%ebp),%eax
c010625d:	89 04 24             	mov    %eax,(%esp)
c0106260:	e8 61 fe ff ff       	call   c01060c6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106265:	e9 60 02 00 00       	jmp    c01064ca <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c010626a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010626e:	c7 44 24 08 ee 77 10 	movl   $0xc01077ee,0x8(%esp)
c0106275:	c0 
c0106276:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106279:	89 44 24 04          	mov    %eax,0x4(%esp)
c010627d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106280:	89 04 24             	mov    %eax,(%esp)
c0106283:	e8 3e fe ff ff       	call   c01060c6 <printfmt>
            break;
c0106288:	e9 3d 02 00 00       	jmp    c01064ca <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010628d:	8b 45 14             	mov    0x14(%ebp),%eax
c0106290:	8d 50 04             	lea    0x4(%eax),%edx
c0106293:	89 55 14             	mov    %edx,0x14(%ebp)
c0106296:	8b 30                	mov    (%eax),%esi
c0106298:	85 f6                	test   %esi,%esi
c010629a:	75 05                	jne    c01062a1 <vprintfmt+0x1a8>
                p = "(null)";
c010629c:	be f1 77 10 c0       	mov    $0xc01077f1,%esi
            }
            if (width > 0 && padc != '-') {
c01062a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01062a5:	7e 76                	jle    c010631d <vprintfmt+0x224>
c01062a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01062ab:	74 70                	je     c010631d <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01062ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062b4:	89 34 24             	mov    %esi,(%esp)
c01062b7:	e8 ba f7 ff ff       	call   c0105a76 <strnlen>
c01062bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01062bf:	29 c2                	sub    %eax,%edx
c01062c1:	89 d0                	mov    %edx,%eax
c01062c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062c6:	eb 16                	jmp    c01062de <vprintfmt+0x1e5>
                    putch(padc, putdat);
c01062c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01062cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01062cf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062d3:	89 04 24             	mov    %eax,(%esp)
c01062d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01062d9:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01062db:	ff 4d e8             	decl   -0x18(%ebp)
c01062de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01062e2:	7f e4                	jg     c01062c8 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01062e4:	eb 37                	jmp    c010631d <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c01062e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01062ea:	74 1f                	je     c010630b <vprintfmt+0x212>
c01062ec:	83 fb 1f             	cmp    $0x1f,%ebx
c01062ef:	7e 05                	jle    c01062f6 <vprintfmt+0x1fd>
c01062f1:	83 fb 7e             	cmp    $0x7e,%ebx
c01062f4:	7e 15                	jle    c010630b <vprintfmt+0x212>
                    putch('?', putdat);
c01062f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062fd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106304:	8b 45 08             	mov    0x8(%ebp),%eax
c0106307:	ff d0                	call   *%eax
c0106309:	eb 0f                	jmp    c010631a <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c010630b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010630e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106312:	89 1c 24             	mov    %ebx,(%esp)
c0106315:	8b 45 08             	mov    0x8(%ebp),%eax
c0106318:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010631a:	ff 4d e8             	decl   -0x18(%ebp)
c010631d:	89 f0                	mov    %esi,%eax
c010631f:	8d 70 01             	lea    0x1(%eax),%esi
c0106322:	0f b6 00             	movzbl (%eax),%eax
c0106325:	0f be d8             	movsbl %al,%ebx
c0106328:	85 db                	test   %ebx,%ebx
c010632a:	74 27                	je     c0106353 <vprintfmt+0x25a>
c010632c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106330:	78 b4                	js     c01062e6 <vprintfmt+0x1ed>
c0106332:	ff 4d e4             	decl   -0x1c(%ebp)
c0106335:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106339:	79 ab                	jns    c01062e6 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c010633b:	eb 16                	jmp    c0106353 <vprintfmt+0x25a>
                putch(' ', putdat);
c010633d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106340:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010634b:	8b 45 08             	mov    0x8(%ebp),%eax
c010634e:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0106350:	ff 4d e8             	decl   -0x18(%ebp)
c0106353:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106357:	7f e4                	jg     c010633d <vprintfmt+0x244>
            }
            break;
c0106359:	e9 6c 01 00 00       	jmp    c01064ca <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010635e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106361:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106365:	8d 45 14             	lea    0x14(%ebp),%eax
c0106368:	89 04 24             	mov    %eax,(%esp)
c010636b:	e8 0b fd ff ff       	call   c010607b <getint>
c0106370:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106373:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106376:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106379:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010637c:	85 d2                	test   %edx,%edx
c010637e:	79 26                	jns    c01063a6 <vprintfmt+0x2ad>
                putch('-', putdat);
c0106380:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106383:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106387:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010638e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106391:	ff d0                	call   *%eax
                num = -(long long)num;
c0106393:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106396:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106399:	f7 d8                	neg    %eax
c010639b:	83 d2 00             	adc    $0x0,%edx
c010639e:	f7 da                	neg    %edx
c01063a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01063a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01063ad:	e9 a8 00 00 00       	jmp    c010645a <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01063b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063b9:	8d 45 14             	lea    0x14(%ebp),%eax
c01063bc:	89 04 24             	mov    %eax,(%esp)
c01063bf:	e8 64 fc ff ff       	call   c0106028 <getuint>
c01063c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01063ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01063d1:	e9 84 00 00 00       	jmp    c010645a <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01063d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063dd:	8d 45 14             	lea    0x14(%ebp),%eax
c01063e0:	89 04 24             	mov    %eax,(%esp)
c01063e3:	e8 40 fc ff ff       	call   c0106028 <getuint>
c01063e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01063ee:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01063f5:	eb 63                	jmp    c010645a <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c01063f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063fe:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106405:	8b 45 08             	mov    0x8(%ebp),%eax
c0106408:	ff d0                	call   *%eax
            putch('x', putdat);
c010640a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010640d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106411:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106418:	8b 45 08             	mov    0x8(%ebp),%eax
c010641b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010641d:	8b 45 14             	mov    0x14(%ebp),%eax
c0106420:	8d 50 04             	lea    0x4(%eax),%edx
c0106423:	89 55 14             	mov    %edx,0x14(%ebp)
c0106426:	8b 00                	mov    (%eax),%eax
c0106428:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010642b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106432:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106439:	eb 1f                	jmp    c010645a <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010643b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010643e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106442:	8d 45 14             	lea    0x14(%ebp),%eax
c0106445:	89 04 24             	mov    %eax,(%esp)
c0106448:	e8 db fb ff ff       	call   c0106028 <getuint>
c010644d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106450:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106453:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010645a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010645e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106461:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106465:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106468:	89 54 24 14          	mov    %edx,0x14(%esp)
c010646c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106470:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106473:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106476:	89 44 24 08          	mov    %eax,0x8(%esp)
c010647a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010647e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106481:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106485:	8b 45 08             	mov    0x8(%ebp),%eax
c0106488:	89 04 24             	mov    %eax,(%esp)
c010648b:	e8 94 fa ff ff       	call   c0105f24 <printnum>
            break;
c0106490:	eb 38                	jmp    c01064ca <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106495:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106499:	89 1c 24             	mov    %ebx,(%esp)
c010649c:	8b 45 08             	mov    0x8(%ebp),%eax
c010649f:	ff d0                	call   *%eax
            break;
c01064a1:	eb 27                	jmp    c01064ca <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01064a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01064aa:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01064b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01064b4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01064b6:	ff 4d 10             	decl   0x10(%ebp)
c01064b9:	eb 03                	jmp    c01064be <vprintfmt+0x3c5>
c01064bb:	ff 4d 10             	decl   0x10(%ebp)
c01064be:	8b 45 10             	mov    0x10(%ebp),%eax
c01064c1:	48                   	dec    %eax
c01064c2:	0f b6 00             	movzbl (%eax),%eax
c01064c5:	3c 25                	cmp    $0x25,%al
c01064c7:	75 f2                	jne    c01064bb <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c01064c9:	90                   	nop
    while (1) {
c01064ca:	e9 36 fc ff ff       	jmp    c0106105 <vprintfmt+0xc>
                return;
c01064cf:	90                   	nop
        }
    }
}
c01064d0:	83 c4 40             	add    $0x40,%esp
c01064d3:	5b                   	pop    %ebx
c01064d4:	5e                   	pop    %esi
c01064d5:	5d                   	pop    %ebp
c01064d6:	c3                   	ret    

c01064d7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01064d7:	f3 0f 1e fb          	endbr32 
c01064db:	55                   	push   %ebp
c01064dc:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01064de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064e1:	8b 40 08             	mov    0x8(%eax),%eax
c01064e4:	8d 50 01             	lea    0x1(%eax),%edx
c01064e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064ea:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01064ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064f0:	8b 10                	mov    (%eax),%edx
c01064f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064f5:	8b 40 04             	mov    0x4(%eax),%eax
c01064f8:	39 c2                	cmp    %eax,%edx
c01064fa:	73 12                	jae    c010650e <sprintputch+0x37>
        *b->buf ++ = ch;
c01064fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064ff:	8b 00                	mov    (%eax),%eax
c0106501:	8d 48 01             	lea    0x1(%eax),%ecx
c0106504:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106507:	89 0a                	mov    %ecx,(%edx)
c0106509:	8b 55 08             	mov    0x8(%ebp),%edx
c010650c:	88 10                	mov    %dl,(%eax)
    }
}
c010650e:	90                   	nop
c010650f:	5d                   	pop    %ebp
c0106510:	c3                   	ret    

c0106511 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106511:	f3 0f 1e fb          	endbr32 
c0106515:	55                   	push   %ebp
c0106516:	89 e5                	mov    %esp,%ebp
c0106518:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010651b:	8d 45 14             	lea    0x14(%ebp),%eax
c010651e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106521:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106524:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106528:	8b 45 10             	mov    0x10(%ebp),%eax
c010652b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010652f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106536:	8b 45 08             	mov    0x8(%ebp),%eax
c0106539:	89 04 24             	mov    %eax,(%esp)
c010653c:	e8 08 00 00 00       	call   c0106549 <vsnprintf>
c0106541:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106547:	c9                   	leave  
c0106548:	c3                   	ret    

c0106549 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106549:	f3 0f 1e fb          	endbr32 
c010654d:	55                   	push   %ebp
c010654e:	89 e5                	mov    %esp,%ebp
c0106550:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106553:	8b 45 08             	mov    0x8(%ebp),%eax
c0106556:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010655c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010655f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106562:	01 d0                	add    %edx,%eax
c0106564:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010656e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106572:	74 0a                	je     c010657e <vsnprintf+0x35>
c0106574:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106577:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010657a:	39 c2                	cmp    %eax,%edx
c010657c:	76 07                	jbe    c0106585 <vsnprintf+0x3c>
        return -E_INVAL;
c010657e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106583:	eb 2a                	jmp    c01065af <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106585:	8b 45 14             	mov    0x14(%ebp),%eax
c0106588:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010658c:	8b 45 10             	mov    0x10(%ebp),%eax
c010658f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106593:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106596:	89 44 24 04          	mov    %eax,0x4(%esp)
c010659a:	c7 04 24 d7 64 10 c0 	movl   $0xc01064d7,(%esp)
c01065a1:	e8 53 fb ff ff       	call   c01060f9 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01065a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065a9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01065ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01065af:	c9                   	leave  
c01065b0:	c3                   	ret    

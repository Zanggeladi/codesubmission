
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 e1 2c 00 00       	call   102d0d <memset>

    cons_init();                // init the console
  10002c:	e8 32 15 00 00       	call   101563 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 20 35 10 00 	movl   $0x103520,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 3c 35 10 00 	movl   $0x10353c,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 c2 08 00 00       	call   100912 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8e 00 00 00       	call   1000e3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 88 29 00 00       	call   1029e2 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 43 16 00 00       	call   1016a2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 c8 17 00 00       	call   10182c <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 db 0c 00 00       	call   100d44 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 6e 17 00 00       	call   1017dc <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6b 01 00 00       	call   1001de <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 9b 0c 00 00       	call   100d32 <mon_backtrace>
}
  100097:	90                   	nop
  100098:	c9                   	leave  
  100099:	c3                   	ret    

0010009a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	53                   	push   %ebx
  10009e:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b4 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 ba ff ff ff       	call   10009a <grade_backtrace1>
}
  1000e0:	90                   	nop
  1000e1:	c9                   	leave  
  1000e2:	c3                   	ret    

001000e3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e3:	55                   	push   %ebp
  1000e4:	89 e5                	mov    %esp,%ebp
  1000e6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ee:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f5:	ff 
  1000f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100101:	e8 c2 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 41 35 10 00 	movl   $0x103541,(%esp)
  100138:	e8 2f 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 5d 35 10 00 	movl   $0x10355d,(%esp)
  100176:	e8 f1 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 6b 35 10 00 	movl   $0x10356b,(%esp)
  100195:	e8 d2 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 79 35 10 00 	movl   $0x103579,(%esp)
  1001b4:	e8 b3 00 00 00       	call   10026c <cprintf>
    round ++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	90                   	nop
  1001c5:	c9                   	leave  
  1001c6:	c3                   	ret    

001001c7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c7:	55                   	push   %ebp
  1001c8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001ca:	83 ec 08             	sub    $0x8,%esp
  1001cd:	cd 78                	int    $0x78
  1001cf:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001d7:	cd 79                	int    $0x79
  1001d9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e4:	e8 20 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	c7 04 24 88 35 10 00 	movl   $0x103588,(%esp)
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f5:	e8 cd ff ff ff       	call   1001c7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fa:	e8 0a ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ff:	c7 04 24 a8 35 10 00 	movl   $0x1035a8,(%esp)
  100206:	e8 61 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020b:	e8 c4 ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100210:	e8 f4 fe ff ff       	call   100109 <lab1_print_cur_status>
}
  100215:	90                   	nop
  100216:	c9                   	leave  
  100217:	c3                   	ret    

00100218 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100218:	55                   	push   %ebp
  100219:	89 e5                	mov    %esp,%ebp
  10021b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021e:	8b 45 08             	mov    0x8(%ebp),%eax
  100221:	89 04 24             	mov    %eax,(%esp)
  100224:	e8 67 13 00 00       	call   101590 <cons_putc>
    (*cnt) ++;
  100229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022c:	8b 00                	mov    (%eax),%eax
  10022e:	8d 50 01             	lea    0x1(%eax),%edx
  100231:	8b 45 0c             	mov    0xc(%ebp),%eax
  100234:	89 10                	mov    %edx,(%eax)
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 18 02 10 00 	movl   $0x100218,(%esp)
  100262:	e8 f9 2d 00 00       	call   103060 <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 ed 12 00 00       	call   101590 <cons_putc>
}
  1002a3:	90                   	nop
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b3:	eb 13                	jmp    1002c8 <cputs+0x22>
        cputch(c, &cnt);
  1002b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 50 ff ff ff       	call   100218 <cputch>
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d8                	jne    1002b5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002eb:	e8 28 ff ff ff       	call   100218 <cputch>
    return cnt;
  1002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fb:	e8 ba 12 00 00       	call   1015ba <cons_getc>
  100300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100307:	74 f2                	je     1002fb <getchar+0x6>
        /* do nothing */;
    return c;
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

0010030e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030e:	55                   	push   %ebp
  10030f:	89 e5                	mov    %esp,%ebp
  100311:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100318:	74 13                	je     10032d <readline+0x1f>
        cprintf("%s", prompt);
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100321:	c7 04 24 c7 35 10 00 	movl   $0x1035c7,(%esp)
  100328:	e8 3f ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100334:	e8 bc ff ff ff       	call   1002f5 <getchar>
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100340:	79 07                	jns    100349 <readline+0x3b>
            return NULL;
  100342:	b8 00 00 00 00       	mov    $0x0,%eax
  100347:	eb 78                	jmp    1003c1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 28                	jle    100377 <readline+0x69>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 1f                	jg     100377 <readline+0x69>
            cputchar(c);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 04 24             	mov    %eax,(%esp)
  10035e:	e8 2f ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100366:	8d 50 01             	lea    0x1(%eax),%edx
  100369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100375:	eb 45                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100377:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037b:	75 16                	jne    100393 <readline+0x85>
  10037d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100381:	7e 10                	jle    100393 <readline+0x85>
            cputchar(c);
  100383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 04 ff ff ff       	call   100292 <cputchar>
            i --;
  10038e:	ff 4d f4             	decl   -0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x91>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 95                	jne    100334 <readline+0x26>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb3>
        c = getchar();
  1003bc:	e9 73 ff ff ff       	jmp    100334 <readline+0x26>
        }
    }
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	75 5b                	jne    10042d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003d2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003d9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f0:	c7 04 24 ca 35 10 00 	movl   $0x1035ca,(%esp)
  1003f7:	e8 70 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100403:	8b 45 10             	mov    0x10(%ebp),%eax
  100406:	89 04 24             	mov    %eax,(%esp)
  100409:	e8 2b fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  10040e:	c7 04 24 e6 35 10 00 	movl   $0x1035e6,(%esp)
  100415:	e8 52 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041a:	c7 04 24 e8 35 10 00 	movl   $0x1035e8,(%esp)
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100426:	e8 32 06 00 00       	call   100a5d <print_stackframe>
  10042b:	eb 01                	jmp    10042e <__panic+0x6b>
        goto panic_dead;
  10042d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042e:	e8 b0 13 00 00       	call   1017e3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100433:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10043a:	e8 26 08 00 00       	call   100c65 <kmonitor>
  10043f:	eb f2                	jmp    100433 <__panic+0x70>

00100441 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
  100444:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100447:	8d 45 14             	lea    0x14(%ebp),%eax
  10044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	89 44 24 08          	mov    %eax,0x8(%esp)
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045b:	c7 04 24 fa 35 10 00 	movl   $0x1035fa,(%esp)
  100462:	e8 05 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	8b 45 10             	mov    0x10(%ebp),%eax
  100471:	89 04 24             	mov    %eax,(%esp)
  100474:	e8 c0 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100479:	c7 04 24 e6 35 10 00 	movl   $0x1035e6,(%esp)
  100480:	e8 e7 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100485:	90                   	nop
  100486:	c9                   	leave  
  100487:	c3                   	ret    

00100488 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100488:	55                   	push   %ebp
  100489:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100490:	5d                   	pop    %ebp
  100491:	c3                   	ret    

00100492 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
  100495:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100498:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049b:	8b 00                	mov    (%eax),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004af:	e9 ca 00 00 00       	jmp    10057e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	01 d0                	add    %edx,%eax
  1004bc:	89 c2                	mov    %eax,%edx
  1004be:	c1 ea 1f             	shr    $0x1f,%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	d1 f8                	sar    %eax
  1004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	eb 03                	jmp    1004d3 <stab_binsearch+0x41>
            m --;
  1004d0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x68>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004f8:	75 d6                	jne    1004d0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 09                	jge    10050b <stab_binsearch+0x79>
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	40                   	inc    %eax
  100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100509:	eb 73                	jmp    10057e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10050b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100515:	89 d0                	mov    %edx,%eax
  100517:	01 c0                	add    %eax,%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	c1 e0 02             	shl    $0x2,%eax
  10051e:	89 c2                	mov    %eax,%edx
  100520:	8b 45 08             	mov    0x8(%ebp),%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	8b 40 08             	mov    0x8(%eax),%eax
  100528:	39 45 18             	cmp    %eax,0x18(%ebp)
  10052b:	76 11                	jbe    10053e <stab_binsearch+0xac>
            *region_left = m;
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100533:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100538:	40                   	inc    %eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 40                	jmp    10057e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	39 45 18             	cmp    %eax,0x18(%ebp)
  100557:	73 14                	jae    10056d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	48                   	dec    %eax
  100568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056b:	eb 11                	jmp    10057e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100573:	89 10                	mov    %edx,(%eax)
            l = m;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10057e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100581:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100584:	0f 8e 2a ff ff ff    	jle    1004b4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10058a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058e:	75 0f                	jne    10059f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	8b 45 10             	mov    0x10(%ebp),%eax
  10059b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059d:	eb 3e                	jmp    1005dd <stab_binsearch+0x14b>
        l = *region_right;
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a7:	eb 03                	jmp    1005ac <stab_binsearch+0x11a>
  1005a9:	ff 4d fc             	decl   -0x4(%ebp)
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b4:	7e 1f                	jle    1005d5 <stab_binsearch+0x143>
  1005b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b9:	89 d0                	mov    %edx,%eax
  1005bb:	01 c0                	add    %eax,%eax
  1005bd:	01 d0                	add    %edx,%eax
  1005bf:	c1 e0 02             	shl    $0x2,%eax
  1005c2:	89 c2                	mov    %eax,%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cd:	0f b6 c0             	movzbl %al,%eax
  1005d0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005d3:	75 d4                	jne    1005a9 <stab_binsearch+0x117>
        *region_left = l;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005db:	89 10                	mov    %edx,(%eax)
}
  1005dd:	90                   	nop
  1005de:	c9                   	leave  
  1005df:	c3                   	ret    

001005e0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e0:	55                   	push   %ebp
  1005e1:	89 e5                	mov    %esp,%ebp
  1005e3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 00 18 36 10 00    	movl   $0x103618,(%eax)
    info->eip_line = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 08 18 36 10 00 	movl   $0x103618,0x8(%eax)
    info->eip_fn_namelen = 9;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 08             	mov    0x8(%ebp),%edx
  100613:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100620:	c7 45 f4 6c 3e 10 00 	movl   $0x103e6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100627:	c7 45 f0 d0 bb 10 00 	movl   $0x10bbd0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062e:	c7 45 ec d1 bb 10 00 	movl   $0x10bbd1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100635:	c7 45 e8 9f dc 10 00 	movl   $0x10dc9f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100642:	76 0b                	jbe    10064f <debuginfo_eip+0x6f>
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	48                   	dec    %eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x79>
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 b7 02 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	48                   	dec    %eax
  100674:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100677:	8b 45 08             	mov    0x8(%ebp),%eax
  10067a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10067e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100685:	00 
  100686:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10068d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100690:	89 44 24 04          	mov    %eax,0x4(%esp)
  100694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100697:	89 04 24             	mov    %eax,(%esp)
  10069a:	e8 f3 fd ff ff       	call   100492 <stab_binsearch>
    if (lfile == 0)
  10069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a2:	85 c0                	test   %eax,%eax
  1006a4:	75 0a                	jne    1006b0 <debuginfo_eip+0xd0>
        return -1;
  1006a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ab:	e9 60 02 00 00       	jmp    100910 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ca:	00 
  1006cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dc:	89 04 24             	mov    %eax,(%esp)
  1006df:	e8 ae fd ff ff       	call   100492 <stab_binsearch>

    if (lfun <= rfun) {
  1006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ea:	39 c2                	cmp    %eax,%edx
  1006ec:	7f 7c                	jg     10076a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f1:	89 c2                	mov    %eax,%edx
  1006f3:	89 d0                	mov    %edx,%eax
  1006f5:	01 c0                	add    %eax,%eax
  1006f7:	01 d0                	add    %edx,%eax
  1006f9:	c1 e0 02             	shl    $0x2,%eax
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	8b 00                	mov    (%eax),%eax
  100705:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10070b:	29 d1                	sub    %edx,%ecx
  10070d:	89 ca                	mov    %ecx,%edx
  10070f:	39 d0                	cmp    %edx,%eax
  100711:	73 22                	jae    100735 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8b 10                	mov    (%eax),%edx
  10072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10072d:	01 c2                	add    %eax,%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	8b 50 08             	mov    0x8(%eax),%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100753:	8b 45 0c             	mov    0xc(%ebp),%eax
  100756:	8b 40 10             	mov    0x10(%eax),%eax
  100759:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100768:	eb 15                	jmp    10077f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 55 08             	mov    0x8(%ebp),%edx
  100770:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	8b 40 08             	mov    0x8(%eax),%eax
  100785:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10078c:	00 
  10078d:	89 04 24             	mov    %eax,(%esp)
  100790:	e8 f4 23 00 00       	call   102b89 <strfind>
  100795:	89 c2                	mov    %eax,%edx
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	29 c2                	sub    %eax,%edx
  10079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ac:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007b3:	00 
  1007b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c5:	89 04 24             	mov    %eax,(%esp)
  1007c8:	e8 c5 fc ff ff       	call   100492 <stab_binsearch>
    if (lline <= rline) {
  1007cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d3:	39 c2                	cmp    %eax,%edx
  1007d5:	7f 23                	jg     1007fa <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007da:	89 c2                	mov    %eax,%edx
  1007dc:	89 d0                	mov    %edx,%eax
  1007de:	01 c0                	add    %eax,%eax
  1007e0:	01 d0                	add    %edx,%eax
  1007e2:	c1 e0 02             	shl    $0x2,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f8:	eb 11                	jmp    10080b <debuginfo_eip+0x22b>
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0c 01 00 00       	jmp    100910 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	48                   	dec    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100811:	39 c2                	cmp    %eax,%edx
  100813:	7c 56                	jl     10086b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 84                	cmp    $0x84,%al
  100830:	74 39                	je     10086b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c 64                	cmp    $0x64,%al
  10084d:	75 b5                	jne    100804 <debuginfo_eip+0x224>
  10084f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	89 d0                	mov    %edx,%eax
  100856:	01 c0                	add    %eax,%eax
  100858:	01 d0                	add    %edx,%eax
  10085a:	c1 e0 02             	shl    $0x2,%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	8b 40 08             	mov    0x8(%eax),%eax
  100867:	85 c0                	test   %eax,%eax
  100869:	74 99                	je     100804 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10086b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100871:	39 c2                	cmp    %eax,%edx
  100873:	7c 46                	jl     1008bb <debuginfo_eip+0x2db>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 00                	mov    (%eax),%eax
  10088c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100892:	29 d1                	sub    %edx,%ecx
  100894:	89 ca                	mov    %ecx,%edx
  100896:	39 d0                	cmp    %edx,%eax
  100898:	73 21                	jae    1008bb <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	89 d0                	mov    %edx,%eax
  1008a1:	01 c0                	add    %eax,%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	c1 e0 02             	shl    $0x2,%eax
  1008a8:	89 c2                	mov    %eax,%edx
  1008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ad:	01 d0                	add    %edx,%eax
  1008af:	8b 10                	mov    (%eax),%edx
  1008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b4:	01 c2                	add    %eax,%edx
  1008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c1:	39 c2                	cmp    %eax,%edx
  1008c3:	7d 46                	jge    10090b <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c8:	40                   	inc    %eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 16                	jmp    1008e4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	40                   	inc    %eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	7d 1d                	jge    10090b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100907:	3c a0                	cmp    $0xa0,%al
  100909:	74 c3                	je     1008ce <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  10090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100918:	c7 04 24 22 36 10 00 	movl   $0x103622,(%esp)
  10091f:	e8 48 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100924:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092b:	00 
  10092c:	c7 04 24 3b 36 10 00 	movl   $0x10363b,(%esp)
  100933:	e8 34 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100938:	c7 44 24 04 07 35 10 	movl   $0x103507,0x4(%esp)
  10093f:	00 
  100940:	c7 04 24 53 36 10 00 	movl   $0x103653,(%esp)
  100947:	e8 20 f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100953:	00 
  100954:	c7 04 24 6b 36 10 00 	movl   $0x10366b,(%esp)
  10095b:	e8 0c f9 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100960:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  100967:	00 
  100968:	c7 04 24 83 36 10 00 	movl   $0x103683,(%esp)
  10096f:	e8 f8 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100974:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100979:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100984:	29 c2                	sub    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098e:	85 c0                	test   %eax,%eax
  100990:	0f 48 c2             	cmovs  %edx,%eax
  100993:	c1 f8 0a             	sar    $0xa,%eax
  100996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099a:	c7 04 24 9c 36 10 00 	movl   $0x10369c,(%esp)
  1009a1:	e8 c6 f8 ff ff       	call   10026c <cprintf>
}
  1009a6:	90                   	nop
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 1c fc ff ff       	call   1005e0 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 c6 36 10 00 	movl   $0x1036c6,(%esp)
  1009d6:	e8 91 f8 ff ff       	call   10026c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009db:	eb 6c                	jmp    100a49 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1b                	jmp    100a01 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	ff 45 f4             	incl   -0xc(%ebp)
  100a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a07:	7c dd                	jl     1009e6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a09:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1d:	89 d1                	mov    %edx,%ecx
  100a1f:	29 c1                	sub    %eax,%ecx
  100a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a35:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  100a44:	e8 23 f8 ff ff       	call   10026c <cprintf>
}
  100a49:	90                   	nop
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	53                   	push   %ebx
  100a61:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a64:	89 e8                	mov    %ebp,%eax
  100a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t *ebp = (uint32_t *)read_ebp();
  100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t esp = read_eip();
  100a6f:	e8 d8 ff ff ff       	call   100a4c <read_eip>
  100a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(ebp){
  100a77:	eb 73                	jmp    100aec <print_stackframe+0x8f>
        cprintf("ebp:0x%08x eip:0x%08x args:",(uint32_t)ebp,esp);
  100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100a7f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a87:	c7 04 24 f4 36 10 00 	movl   $0x1036f4,(%esp)
  100a8e:	e8 d9 f7 ff ff       	call   10026c <cprintf>
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n",ebp[2],ebp[3],ebp[4],ebp[5]);
  100a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a96:	83 c0 14             	add    $0x14,%eax
  100a99:	8b 18                	mov    (%eax),%ebx
  100a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9e:	83 c0 10             	add    $0x10,%eax
  100aa1:	8b 08                	mov    (%eax),%ecx
  100aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aa6:	83 c0 0c             	add    $0xc,%eax
  100aa9:	8b 10                	mov    (%eax),%edx
  100aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aae:	83 c0 08             	add    $0x8,%eax
  100ab1:	8b 00                	mov    (%eax),%eax
  100ab3:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100ab7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100abb:	89 54 24 08          	mov    %edx,0x8(%esp)
  100abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac3:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  100aca:	e8 9d f7 ff ff       	call   10026c <cprintf>
        print_debuginfo(esp - 1);
  100acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad2:	48                   	dec    %eax
  100ad3:	89 04 24             	mov    %eax,(%esp)
  100ad6:	e8 ce fe ff ff       	call   1009a9 <print_debuginfo>
        esp = ebp[1];
  100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ade:	8b 40 04             	mov    0x4(%eax),%eax
  100ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = (uint32_t *)*ebp;
  100ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae7:	8b 00                	mov    (%eax),%eax
  100ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(ebp){
  100aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af0:	75 87                	jne    100a79 <print_stackframe+0x1c>
    }
}
  100af2:	90                   	nop
  100af3:	83 c4 34             	add    $0x34,%esp
  100af6:	5b                   	pop    %ebx
  100af7:	5d                   	pop    %ebp
  100af8:	c3                   	ret    

00100af9 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100af9:	55                   	push   %ebp
  100afa:	89 e5                	mov    %esp,%ebp
  100afc:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b06:	eb 0c                	jmp    100b14 <parse+0x1b>
            *buf ++ = '\0';
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	8d 50 01             	lea    0x1(%eax),%edx
  100b0e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b11:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	84 c0                	test   %al,%al
  100b1c:	74 1d                	je     100b3b <parse+0x42>
  100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b21:	0f b6 00             	movzbl (%eax),%eax
  100b24:	0f be c0             	movsbl %al,%eax
  100b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2b:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100b32:	e8 20 20 00 00       	call   102b57 <strchr>
  100b37:	85 c0                	test   %eax,%eax
  100b39:	75 cd                	jne    100b08 <parse+0xf>
        }
        if (*buf == '\0') {
  100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3e:	0f b6 00             	movzbl (%eax),%eax
  100b41:	84 c0                	test   %al,%al
  100b43:	74 65                	je     100baa <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b45:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b49:	75 14                	jne    100b5f <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b52:	00 
  100b53:	c7 04 24 b5 37 10 00 	movl   $0x1037b5,(%esp)
  100b5a:	e8 0d f7 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b62:	8d 50 01             	lea    0x1(%eax),%edx
  100b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b72:	01 c2                	add    %eax,%edx
  100b74:	8b 45 08             	mov    0x8(%ebp),%eax
  100b77:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b79:	eb 03                	jmp    100b7e <parse+0x85>
            buf ++;
  100b7b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b81:	0f b6 00             	movzbl (%eax),%eax
  100b84:	84 c0                	test   %al,%al
  100b86:	74 8c                	je     100b14 <parse+0x1b>
  100b88:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8b:	0f b6 00             	movzbl (%eax),%eax
  100b8e:	0f be c0             	movsbl %al,%eax
  100b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b95:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100b9c:	e8 b6 1f 00 00       	call   102b57 <strchr>
  100ba1:	85 c0                	test   %eax,%eax
  100ba3:	74 d6                	je     100b7b <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba5:	e9 6a ff ff ff       	jmp    100b14 <parse+0x1b>
            break;
  100baa:	90                   	nop
        }
    }
    return argc;
  100bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bae:	c9                   	leave  
  100baf:	c3                   	ret    

00100bb0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb0:	55                   	push   %ebp
  100bb1:	89 e5                	mov    %esp,%ebp
  100bb3:	53                   	push   %ebx
  100bb4:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bb7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc1:	89 04 24             	mov    %eax,(%esp)
  100bc4:	e8 30 ff ff ff       	call   100af9 <parse>
  100bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd0:	75 0a                	jne    100bdc <runcmd+0x2c>
        return 0;
  100bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  100bd7:	e9 83 00 00 00       	jmp    100c5f <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be3:	eb 5a                	jmp    100c3f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100be5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100beb:	89 d0                	mov    %edx,%eax
  100bed:	01 c0                	add    %eax,%eax
  100bef:	01 d0                	add    %edx,%eax
  100bf1:	c1 e0 02             	shl    $0x2,%eax
  100bf4:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bf9:	8b 00                	mov    (%eax),%eax
  100bfb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bff:	89 04 24             	mov    %eax,(%esp)
  100c02:	e8 b3 1e 00 00       	call   102aba <strcmp>
  100c07:	85 c0                	test   %eax,%eax
  100c09:	75 31                	jne    100c3c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c0e:	89 d0                	mov    %edx,%eax
  100c10:	01 c0                	add    %eax,%eax
  100c12:	01 d0                	add    %edx,%eax
  100c14:	c1 e0 02             	shl    $0x2,%eax
  100c17:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c1c:	8b 10                	mov    (%eax),%edx
  100c1e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c21:	83 c0 04             	add    $0x4,%eax
  100c24:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c27:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c35:	89 1c 24             	mov    %ebx,(%esp)
  100c38:	ff d2                	call   *%edx
  100c3a:	eb 23                	jmp    100c5f <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3c:	ff 45 f4             	incl   -0xc(%ebp)
  100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c42:	83 f8 02             	cmp    $0x2,%eax
  100c45:	76 9e                	jbe    100be5 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c47:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4e:	c7 04 24 d3 37 10 00 	movl   $0x1037d3,(%esp)
  100c55:	e8 12 f6 ff ff       	call   10026c <cprintf>
    return 0;
  100c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c5f:	83 c4 64             	add    $0x64,%esp
  100c62:	5b                   	pop    %ebx
  100c63:	5d                   	pop    %ebp
  100c64:	c3                   	ret    

00100c65 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c65:	55                   	push   %ebp
  100c66:	89 e5                	mov    %esp,%ebp
  100c68:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c6b:	c7 04 24 ec 37 10 00 	movl   $0x1037ec,(%esp)
  100c72:	e8 f5 f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c77:	c7 04 24 14 38 10 00 	movl   $0x103814,(%esp)
  100c7e:	e8 e9 f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c87:	74 0b                	je     100c94 <kmonitor+0x2f>
        print_trapframe(tf);
  100c89:	8b 45 08             	mov    0x8(%ebp),%eax
  100c8c:	89 04 24             	mov    %eax,(%esp)
  100c8f:	e8 d2 0c 00 00       	call   101966 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c94:	c7 04 24 39 38 10 00 	movl   $0x103839,(%esp)
  100c9b:	e8 6e f6 ff ff       	call   10030e <readline>
  100ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca7:	74 eb                	je     100c94 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb3:	89 04 24             	mov    %eax,(%esp)
  100cb6:	e8 f5 fe ff ff       	call   100bb0 <runcmd>
  100cbb:	85 c0                	test   %eax,%eax
  100cbd:	78 02                	js     100cc1 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100cbf:	eb d3                	jmp    100c94 <kmonitor+0x2f>
                break;
  100cc1:	90                   	nop
            }
        }
    }
}
  100cc2:	90                   	nop
  100cc3:	c9                   	leave  
  100cc4:	c3                   	ret    

00100cc5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc5:	55                   	push   %ebp
  100cc6:	89 e5                	mov    %esp,%ebp
  100cc8:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cd2:	eb 3d                	jmp    100d11 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd7:	89 d0                	mov    %edx,%eax
  100cd9:	01 c0                	add    %eax,%eax
  100cdb:	01 d0                	add    %edx,%eax
  100cdd:	c1 e0 02             	shl    $0x2,%eax
  100ce0:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce5:	8b 08                	mov    (%eax),%ecx
  100ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cea:	89 d0                	mov    %edx,%eax
  100cec:	01 c0                	add    %eax,%eax
  100cee:	01 d0                	add    %edx,%eax
  100cf0:	c1 e0 02             	shl    $0x2,%eax
  100cf3:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf8:	8b 00                	mov    (%eax),%eax
  100cfa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d02:	c7 04 24 3d 38 10 00 	movl   $0x10383d,(%esp)
  100d09:	e8 5e f5 ff ff       	call   10026c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0e:	ff 45 f4             	incl   -0xc(%ebp)
  100d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d14:	83 f8 02             	cmp    $0x2,%eax
  100d17:	76 bb                	jbe    100cd4 <mon_help+0xf>
    }
    return 0;
  100d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1e:	c9                   	leave  
  100d1f:	c3                   	ret    

00100d20 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d20:	55                   	push   %ebp
  100d21:	89 e5                	mov    %esp,%ebp
  100d23:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d26:	e8 e7 fb ff ff       	call   100912 <print_kerninfo>
    return 0;
  100d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d30:	c9                   	leave  
  100d31:	c3                   	ret    

00100d32 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d38:	e8 20 fd ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d42:	c9                   	leave  
  100d43:	c3                   	ret    

00100d44 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d44:	55                   	push   %ebp
  100d45:	89 e5                	mov    %esp,%ebp
  100d47:	83 ec 28             	sub    $0x28,%esp
  100d4a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d50:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d54:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d58:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d5c:	ee                   	out    %al,(%dx)
  100d5d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d63:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d6b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d6f:	ee                   	out    %al,(%dx)
  100d70:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d76:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d7a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d82:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d83:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d8a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8d:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100d94:	e8 d3 f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100d99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100da0:	e8 ca 08 00 00       	call   10166f <pic_enable>
}
  100da5:	90                   	nop
  100da6:	c9                   	leave  
  100da7:	c3                   	ret    

00100da8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da8:	55                   	push   %ebp
  100da9:	89 e5                	mov    %esp,%ebp
  100dab:	83 ec 10             	sub    $0x10,%esp
  100dae:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100db8:	89 c2                	mov    %eax,%edx
  100dba:	ec                   	in     (%dx),%al
  100dbb:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dbe:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dce:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dde:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100de4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de8:	89 c2                	mov    %eax,%edx
  100dea:	ec                   	in     (%dx),%al
  100deb:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dee:	90                   	nop
  100def:	c9                   	leave  
  100df0:	c3                   	ret    

00100df1 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100df1:	55                   	push   %ebp
  100df2:	89 e5                	mov    %esp,%ebp
  100df4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100df7:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e01:	0f b7 00             	movzwl (%eax),%eax
  100e04:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e13:	0f b7 00             	movzwl (%eax),%eax
  100e16:	0f b7 c0             	movzwl %ax,%eax
  100e19:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e1e:	74 12                	je     100e32 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e20:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e27:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e2e:	b4 03 
  100e30:	eb 13                	jmp    100e45 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e39:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e3c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e43:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e45:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e50:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e54:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e58:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e5c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e5d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e64:	40                   	inc    %eax
  100e65:	0f b7 c0             	movzwl %ax,%eax
  100e68:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e6c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e70:	89 c2                	mov    %eax,%edx
  100e72:	ec                   	in     (%dx),%al
  100e73:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e76:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e7a:	0f b6 c0             	movzbl %al,%eax
  100e7d:	c1 e0 08             	shl    $0x8,%eax
  100e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e83:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e8e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e92:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e96:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e9a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e9b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea2:	40                   	inc    %eax
  100ea3:	0f b7 c0             	movzwl %ax,%eax
  100ea6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eaa:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eae:	89 c2                	mov    %eax,%edx
  100eb0:	ec                   	in     (%dx),%al
  100eb1:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eb4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eb8:	0f b6 c0             	movzbl %al,%eax
  100ebb:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec1:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ec9:	0f b7 c0             	movzwl %ax,%eax
  100ecc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed2:	90                   	nop
  100ed3:	c9                   	leave  
  100ed4:	c3                   	ret    

00100ed5 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed5:	55                   	push   %ebp
  100ed6:	89 e5                	mov    %esp,%ebp
  100ed8:	83 ec 48             	sub    $0x48,%esp
  100edb:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ee1:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ee9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100eed:	ee                   	out    %al,(%dx)
  100eee:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ef4:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100ef8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100efc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f00:	ee                   	out    %al,(%dx)
  100f01:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f07:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f0b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f0f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f13:	ee                   	out    %al,(%dx)
  100f14:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f1a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f26:	ee                   	out    %al,(%dx)
  100f27:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f2d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f31:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f35:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f39:	ee                   	out    %al,(%dx)
  100f3a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f40:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f44:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f48:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
  100f4d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f53:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f57:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f5b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
  100f60:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f66:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f6a:	89 c2                	mov    %eax,%edx
  100f6c:	ec                   	in     (%dx),%al
  100f6d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f70:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f74:	3c ff                	cmp    $0xff,%al
  100f76:	0f 95 c0             	setne  %al
  100f79:	0f b6 c0             	movzbl %al,%eax
  100f7c:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f81:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f87:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f8b:	89 c2                	mov    %eax,%edx
  100f8d:	ec                   	in     (%dx),%al
  100f8e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f91:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f97:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f9b:	89 c2                	mov    %eax,%edx
  100f9d:	ec                   	in     (%dx),%al
  100f9e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa1:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fa6:	85 c0                	test   %eax,%eax
  100fa8:	74 0c                	je     100fb6 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100faa:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fb1:	e8 b9 06 00 00       	call   10166f <pic_enable>
    }
}
  100fb6:	90                   	nop
  100fb7:	c9                   	leave  
  100fb8:	c3                   	ret    

00100fb9 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fb9:	55                   	push   %ebp
  100fba:	89 e5                	mov    %esp,%ebp
  100fbc:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc6:	eb 08                	jmp    100fd0 <lpt_putc_sub+0x17>
        delay();
  100fc8:	e8 db fd ff ff       	call   100da8 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcd:	ff 45 fc             	incl   -0x4(%ebp)
  100fd0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fd6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fda:	89 c2                	mov    %eax,%edx
  100fdc:	ec                   	in     (%dx),%al
  100fdd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fe4:	84 c0                	test   %al,%al
  100fe6:	78 09                	js     100ff1 <lpt_putc_sub+0x38>
  100fe8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fef:	7e d7                	jle    100fc8 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100ffd:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101000:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101004:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101008:	ee                   	out    %al,(%dx)
  101009:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10100f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101013:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101017:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10101b:	ee                   	out    %al,(%dx)
  10101c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101022:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101026:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10102f:	90                   	nop
  101030:	c9                   	leave  
  101031:	c3                   	ret    

00101032 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101032:	55                   	push   %ebp
  101033:	89 e5                	mov    %esp,%ebp
  101035:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101038:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103c:	74 0d                	je     10104b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10103e:	8b 45 08             	mov    0x8(%ebp),%eax
  101041:	89 04 24             	mov    %eax,(%esp)
  101044:	e8 70 ff ff ff       	call   100fb9 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101049:	eb 24                	jmp    10106f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10104b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101052:	e8 62 ff ff ff       	call   100fb9 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101057:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10105e:	e8 56 ff ff ff       	call   100fb9 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101063:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10106a:	e8 4a ff ff ff       	call   100fb9 <lpt_putc_sub>
}
  10106f:	90                   	nop
  101070:	c9                   	leave  
  101071:	c3                   	ret    

00101072 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101072:	55                   	push   %ebp
  101073:	89 e5                	mov    %esp,%ebp
  101075:	53                   	push   %ebx
  101076:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101079:	8b 45 08             	mov    0x8(%ebp),%eax
  10107c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101081:	85 c0                	test   %eax,%eax
  101083:	75 07                	jne    10108c <cga_putc+0x1a>
        c |= 0x0700;
  101085:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10108c:	8b 45 08             	mov    0x8(%ebp),%eax
  10108f:	0f b6 c0             	movzbl %al,%eax
  101092:	83 f8 0a             	cmp    $0xa,%eax
  101095:	74 55                	je     1010ec <cga_putc+0x7a>
  101097:	83 f8 0d             	cmp    $0xd,%eax
  10109a:	74 63                	je     1010ff <cga_putc+0x8d>
  10109c:	83 f8 08             	cmp    $0x8,%eax
  10109f:	0f 85 94 00 00 00    	jne    101139 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010a5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ac:	85 c0                	test   %eax,%eax
  1010ae:	0f 84 af 00 00 00    	je     101163 <cga_putc+0xf1>
            crt_pos --;
  1010b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bb:	48                   	dec    %eax
  1010bc:	0f b7 c0             	movzwl %ax,%eax
  1010bf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c8:	98                   	cwtl   
  1010c9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ce:	98                   	cwtl   
  1010cf:	83 c8 20             	or     $0x20,%eax
  1010d2:	98                   	cwtl   
  1010d3:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1010d9:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010e0:	01 c9                	add    %ecx,%ecx
  1010e2:	01 ca                	add    %ecx,%edx
  1010e4:	0f b7 c0             	movzwl %ax,%eax
  1010e7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ea:	eb 77                	jmp    101163 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  1010ec:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f3:	83 c0 50             	add    $0x50,%eax
  1010f6:	0f b7 c0             	movzwl %ax,%eax
  1010f9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010ff:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101106:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10110d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101112:	89 c8                	mov    %ecx,%eax
  101114:	f7 e2                	mul    %edx
  101116:	c1 ea 06             	shr    $0x6,%edx
  101119:	89 d0                	mov    %edx,%eax
  10111b:	c1 e0 02             	shl    $0x2,%eax
  10111e:	01 d0                	add    %edx,%eax
  101120:	c1 e0 04             	shl    $0x4,%eax
  101123:	29 c1                	sub    %eax,%ecx
  101125:	89 c8                	mov    %ecx,%eax
  101127:	0f b7 c0             	movzwl %ax,%eax
  10112a:	29 c3                	sub    %eax,%ebx
  10112c:	89 d8                	mov    %ebx,%eax
  10112e:	0f b7 c0             	movzwl %ax,%eax
  101131:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101137:	eb 2b                	jmp    101164 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101139:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10113f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101146:	8d 50 01             	lea    0x1(%eax),%edx
  101149:	0f b7 d2             	movzwl %dx,%edx
  10114c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101153:	01 c0                	add    %eax,%eax
  101155:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101158:	8b 45 08             	mov    0x8(%ebp),%eax
  10115b:	0f b7 c0             	movzwl %ax,%eax
  10115e:	66 89 02             	mov    %ax,(%edx)
        break;
  101161:	eb 01                	jmp    101164 <cga_putc+0xf2>
        break;
  101163:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101164:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101170:	76 5d                	jbe    1011cf <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101172:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101177:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101182:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101189:	00 
  10118a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10118e:	89 04 24             	mov    %eax,(%esp)
  101191:	e8 b7 1b 00 00       	call   102d4d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101196:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10119d:	eb 14                	jmp    1011b3 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  10119f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a7:	01 d2                	add    %edx,%edx
  1011a9:	01 d0                	add    %edx,%eax
  1011ab:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b0:	ff 45 f4             	incl   -0xc(%ebp)
  1011b3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ba:	7e e3                	jle    10119f <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011bc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c3:	83 e8 50             	sub    $0x50,%eax
  1011c6:	0f b7 c0             	movzwl %ax,%eax
  1011c9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011cf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011da:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011de:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011e2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011e6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ee:	c1 e8 08             	shr    $0x8,%eax
  1011f1:	0f b7 c0             	movzwl %ax,%eax
  1011f4:	0f b6 c0             	movzbl %al,%eax
  1011f7:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011fe:	42                   	inc    %edx
  1011ff:	0f b7 d2             	movzwl %dx,%edx
  101202:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101206:	88 45 e9             	mov    %al,-0x17(%ebp)
  101209:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10120d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101211:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101212:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101219:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10121d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101221:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101225:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101229:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10122a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101231:	0f b6 c0             	movzbl %al,%eax
  101234:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123b:	42                   	inc    %edx
  10123c:	0f b7 d2             	movzwl %dx,%edx
  10123f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101243:	88 45 f1             	mov    %al,-0xf(%ebp)
  101246:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124e:	ee                   	out    %al,(%dx)
}
  10124f:	90                   	nop
  101250:	83 c4 34             	add    $0x34,%esp
  101253:	5b                   	pop    %ebx
  101254:	5d                   	pop    %ebp
  101255:	c3                   	ret    

00101256 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101256:	55                   	push   %ebp
  101257:	89 e5                	mov    %esp,%ebp
  101259:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101263:	eb 08                	jmp    10126d <serial_putc_sub+0x17>
        delay();
  101265:	e8 3e fb ff ff       	call   100da8 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126a:	ff 45 fc             	incl   -0x4(%ebp)
  10126d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101273:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101277:	89 c2                	mov    %eax,%edx
  101279:	ec                   	in     (%dx),%al
  10127a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101281:	0f b6 c0             	movzbl %al,%eax
  101284:	83 e0 20             	and    $0x20,%eax
  101287:	85 c0                	test   %eax,%eax
  101289:	75 09                	jne    101294 <serial_putc_sub+0x3e>
  10128b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101292:	7e d1                	jle    101265 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101294:	8b 45 08             	mov    0x8(%ebp),%eax
  101297:	0f b6 c0             	movzbl %al,%eax
  10129a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ab:	ee                   	out    %al,(%dx)
}
  1012ac:	90                   	nop
  1012ad:	c9                   	leave  
  1012ae:	c3                   	ret    

001012af <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012af:	55                   	push   %ebp
  1012b0:	89 e5                	mov    %esp,%ebp
  1012b2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b9:	74 0d                	je     1012c8 <serial_putc+0x19>
        serial_putc_sub(c);
  1012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012be:	89 04 24             	mov    %eax,(%esp)
  1012c1:	e8 90 ff ff ff       	call   101256 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012c6:	eb 24                	jmp    1012ec <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012cf:	e8 82 ff ff ff       	call   101256 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012db:	e8 76 ff ff ff       	call   101256 <serial_putc_sub>
        serial_putc_sub('\b');
  1012e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e7:	e8 6a ff ff ff       	call   101256 <serial_putc_sub>
}
  1012ec:	90                   	nop
  1012ed:	c9                   	leave  
  1012ee:	c3                   	ret    

001012ef <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ef:	55                   	push   %ebp
  1012f0:	89 e5                	mov    %esp,%ebp
  1012f2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f5:	eb 33                	jmp    10132a <cons_intr+0x3b>
        if (c != 0) {
  1012f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012fb:	74 2d                	je     10132a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012fd:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101302:	8d 50 01             	lea    0x1(%eax),%edx
  101305:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10130b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10130e:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101314:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101319:	3d 00 02 00 00       	cmp    $0x200,%eax
  10131e:	75 0a                	jne    10132a <cons_intr+0x3b>
                cons.wpos = 0;
  101320:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101327:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10132a:	8b 45 08             	mov    0x8(%ebp),%eax
  10132d:	ff d0                	call   *%eax
  10132f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101332:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101336:	75 bf                	jne    1012f7 <cons_intr+0x8>
            }
        }
    }
}
  101338:	90                   	nop
  101339:	c9                   	leave  
  10133a:	c3                   	ret    

0010133b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10133b:	55                   	push   %ebp
  10133c:	89 e5                	mov    %esp,%ebp
  10133e:	83 ec 10             	sub    $0x10,%esp
  101341:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101347:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134b:	89 c2                	mov    %eax,%edx
  10134d:	ec                   	in     (%dx),%al
  10134e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101351:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	83 e0 01             	and    $0x1,%eax
  10135b:	85 c0                	test   %eax,%eax
  10135d:	75 07                	jne    101366 <serial_proc_data+0x2b>
        return -1;
  10135f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101364:	eb 2a                	jmp    101390 <serial_proc_data+0x55>
  101366:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10136c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101370:	89 c2                	mov    %eax,%edx
  101372:	ec                   	in     (%dx),%al
  101373:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101376:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10137a:	0f b6 c0             	movzbl %al,%eax
  10137d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101380:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101384:	75 07                	jne    10138d <serial_proc_data+0x52>
        c = '\b';
  101386:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101390:	c9                   	leave  
  101391:	c3                   	ret    

00101392 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101392:	55                   	push   %ebp
  101393:	89 e5                	mov    %esp,%ebp
  101395:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101398:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10139d:	85 c0                	test   %eax,%eax
  10139f:	74 0c                	je     1013ad <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013a1:	c7 04 24 3b 13 10 00 	movl   $0x10133b,(%esp)
  1013a8:	e8 42 ff ff ff       	call   1012ef <cons_intr>
    }
}
  1013ad:	90                   	nop
  1013ae:	c9                   	leave  
  1013af:	c3                   	ret    

001013b0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013b0:	55                   	push   %ebp
  1013b1:	89 e5                	mov    %esp,%ebp
  1013b3:	83 ec 38             	sub    $0x38,%esp
  1013b6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013bf:	89 c2                	mov    %eax,%edx
  1013c1:	ec                   	in     (%dx),%al
  1013c2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c9:	0f b6 c0             	movzbl %al,%eax
  1013cc:	83 e0 01             	and    $0x1,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	75 0a                	jne    1013dd <kbd_proc_data+0x2d>
        return -1;
  1013d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d8:	e9 55 01 00 00       	jmp    101532 <kbd_proc_data+0x182>
  1013dd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013e6:	89 c2                	mov    %eax,%edx
  1013e8:	ec                   	in     (%dx),%al
  1013e9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013ec:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013f0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f7:	75 17                	jne    101410 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1013f9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fe:	83 c8 40             	or     $0x40,%eax
  101401:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101406:	b8 00 00 00 00       	mov    $0x0,%eax
  10140b:	e9 22 01 00 00       	jmp    101532 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101410:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101414:	84 c0                	test   %al,%al
  101416:	79 45                	jns    10145d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101418:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141d:	83 e0 40             	and    $0x40,%eax
  101420:	85 c0                	test   %eax,%eax
  101422:	75 08                	jne    10142c <kbd_proc_data+0x7c>
  101424:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101428:	24 7f                	and    $0x7f,%al
  10142a:	eb 04                	jmp    101430 <kbd_proc_data+0x80>
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143e:	0c 40                	or     $0x40,%al
  101440:	0f b6 c0             	movzbl %al,%eax
  101443:	f7 d0                	not    %eax
  101445:	89 c2                	mov    %eax,%edx
  101447:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144c:	21 d0                	and    %edx,%eax
  10144e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101453:	b8 00 00 00 00       	mov    $0x0,%eax
  101458:	e9 d5 00 00 00       	jmp    101532 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  10145d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101462:	83 e0 40             	and    $0x40,%eax
  101465:	85 c0                	test   %eax,%eax
  101467:	74 11                	je     10147a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101469:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101472:	83 e0 bf             	and    $0xffffffbf,%eax
  101475:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101485:	0f b6 d0             	movzbl %al,%edx
  101488:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148d:	09 d0                	or     %edx,%eax
  10148f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101498:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10149f:	0f b6 d0             	movzbl %al,%edx
  1014a2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a7:	31 d0                	xor    %edx,%eax
  1014a9:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ae:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b3:	83 e0 03             	and    $0x3,%eax
  1014b6:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c1:	01 d0                	add    %edx,%eax
  1014c3:	0f b6 00             	movzbl (%eax),%eax
  1014c6:	0f b6 c0             	movzbl %al,%eax
  1014c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d1:	83 e0 08             	and    $0x8,%eax
  1014d4:	85 c0                	test   %eax,%eax
  1014d6:	74 22                	je     1014fa <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1014d8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014dc:	7e 0c                	jle    1014ea <kbd_proc_data+0x13a>
  1014de:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e2:	7f 06                	jg     1014ea <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1014e4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e8:	eb 10                	jmp    1014fa <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1014ea:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ee:	7e 0a                	jle    1014fa <kbd_proc_data+0x14a>
  1014f0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f4:	7f 04                	jg     1014fa <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1014f6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ff:	f7 d0                	not    %eax
  101501:	83 e0 06             	and    $0x6,%eax
  101504:	85 c0                	test   %eax,%eax
  101506:	75 27                	jne    10152f <kbd_proc_data+0x17f>
  101508:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10150f:	75 1e                	jne    10152f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101511:	c7 04 24 61 38 10 00 	movl   $0x103861,(%esp)
  101518:	e8 4f ed ff ff       	call   10026c <cprintf>
  10151d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101523:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101527:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10152b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10152e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10152f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101532:	c9                   	leave  
  101533:	c3                   	ret    

00101534 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101534:	55                   	push   %ebp
  101535:	89 e5                	mov    %esp,%ebp
  101537:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10153a:	c7 04 24 b0 13 10 00 	movl   $0x1013b0,(%esp)
  101541:	e8 a9 fd ff ff       	call   1012ef <cons_intr>
}
  101546:	90                   	nop
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <kbd_init>:

static void
kbd_init(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10154f:	e8 e0 ff ff ff       	call   101534 <kbd_intr>
    pic_enable(IRQ_KBD);
  101554:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10155b:	e8 0f 01 00 00       	call   10166f <pic_enable>
}
  101560:	90                   	nop
  101561:	c9                   	leave  
  101562:	c3                   	ret    

00101563 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101563:	55                   	push   %ebp
  101564:	89 e5                	mov    %esp,%ebp
  101566:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101569:	e8 83 f8 ff ff       	call   100df1 <cga_init>
    serial_init();
  10156e:	e8 62 f9 ff ff       	call   100ed5 <serial_init>
    kbd_init();
  101573:	e8 d1 ff ff ff       	call   101549 <kbd_init>
    if (!serial_exists) {
  101578:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10157d:	85 c0                	test   %eax,%eax
  10157f:	75 0c                	jne    10158d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101581:	c7 04 24 6d 38 10 00 	movl   $0x10386d,(%esp)
  101588:	e8 df ec ff ff       	call   10026c <cprintf>
    }
}
  10158d:	90                   	nop
  10158e:	c9                   	leave  
  10158f:	c3                   	ret    

00101590 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101590:	55                   	push   %ebp
  101591:	89 e5                	mov    %esp,%ebp
  101593:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101596:	8b 45 08             	mov    0x8(%ebp),%eax
  101599:	89 04 24             	mov    %eax,(%esp)
  10159c:	e8 91 fa ff ff       	call   101032 <lpt_putc>
    cga_putc(c);
  1015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a4:	89 04 24             	mov    %eax,(%esp)
  1015a7:	e8 c6 fa ff ff       	call   101072 <cga_putc>
    serial_putc(c);
  1015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1015af:	89 04 24             	mov    %eax,(%esp)
  1015b2:	e8 f8 fc ff ff       	call   1012af <serial_putc>
}
  1015b7:	90                   	nop
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c0:	e8 cd fd ff ff       	call   101392 <serial_intr>
    kbd_intr();
  1015c5:	e8 6a ff ff ff       	call   101534 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ca:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d5:	39 c2                	cmp    %eax,%edx
  1015d7:	74 36                	je     10160f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015de:	8d 50 01             	lea    0x1(%eax),%edx
  1015e1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ee:	0f b6 c0             	movzbl %al,%eax
  1015f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015fe:	75 0a                	jne    10160a <cons_getc+0x50>
            cons.rpos = 0;
  101600:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101607:	00 00 00 
        }
        return c;
  10160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160d:	eb 05                	jmp    101614 <cons_getc+0x5a>
    }
    return 0;
  10160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101614:	c9                   	leave  
  101615:	c3                   	ret    

00101616 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
  101619:	83 ec 14             	sub    $0x14,%esp
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101626:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10162c:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101631:	85 c0                	test   %eax,%eax
  101633:	74 37                	je     10166c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101638:	0f b6 c0             	movzbl %al,%eax
  10163b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101641:	88 45 f9             	mov    %al,-0x7(%ebp)
  101644:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101648:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10164c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10164d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101651:	c1 e8 08             	shr    $0x8,%eax
  101654:	0f b7 c0             	movzwl %ax,%eax
  101657:	0f b6 c0             	movzbl %al,%eax
  10165a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101660:	88 45 fd             	mov    %al,-0x3(%ebp)
  101663:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101667:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166b:	ee                   	out    %al,(%dx)
    }
}
  10166c:	90                   	nop
  10166d:	c9                   	leave  
  10166e:	c3                   	ret    

0010166f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10166f:	55                   	push   %ebp
  101670:	89 e5                	mov    %esp,%ebp
  101672:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101675:	8b 45 08             	mov    0x8(%ebp),%eax
  101678:	ba 01 00 00 00       	mov    $0x1,%edx
  10167d:	88 c1                	mov    %al,%cl
  10167f:	d3 e2                	shl    %cl,%edx
  101681:	89 d0                	mov    %edx,%eax
  101683:	98                   	cwtl   
  101684:	f7 d0                	not    %eax
  101686:	0f bf d0             	movswl %ax,%edx
  101689:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101690:	98                   	cwtl   
  101691:	21 d0                	and    %edx,%eax
  101693:	98                   	cwtl   
  101694:	0f b7 c0             	movzwl %ax,%eax
  101697:	89 04 24             	mov    %eax,(%esp)
  10169a:	e8 77 ff ff ff       	call   101616 <pic_setmask>
}
  10169f:	90                   	nop
  1016a0:	c9                   	leave  
  1016a1:	c3                   	ret    

001016a2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
  1016a5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016a8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016af:	00 00 00 
  1016b2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016b8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016bc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016c0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016c4:	ee                   	out    %al,(%dx)
  1016c5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016cb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016cf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016d3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016d7:	ee                   	out    %al,(%dx)
  1016d8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016de:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016e2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016e6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
  1016eb:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016f1:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1016f5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016f9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016fd:	ee                   	out    %al,(%dx)
  1016fe:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101704:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101708:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10170c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101710:	ee                   	out    %al,(%dx)
  101711:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101717:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  10171b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10171f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101723:	ee                   	out    %al,(%dx)
  101724:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10172a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10172e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101732:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101736:	ee                   	out    %al,(%dx)
  101737:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10173d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101741:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101745:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101749:	ee                   	out    %al,(%dx)
  10174a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101750:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101754:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101758:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10175c:	ee                   	out    %al,(%dx)
  10175d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101763:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101767:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10176b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
  101770:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101776:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10177a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10177e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101789:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10178d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101791:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10179c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017a0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017a4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017af:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017b3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017b7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017bc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c3:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017c8:	74 0f                	je     1017d9 <pic_init+0x137>
        pic_setmask(irq_mask);
  1017ca:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d1:	89 04 24             	mov    %eax,(%esp)
  1017d4:	e8 3d fe ff ff       	call   101616 <pic_setmask>
    }
}
  1017d9:	90                   	nop
  1017da:	c9                   	leave  
  1017db:	c3                   	ret    

001017dc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017dc:	55                   	push   %ebp
  1017dd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017df:	fb                   	sti    
    sti();
}
  1017e0:	90                   	nop
  1017e1:	5d                   	pop    %ebp
  1017e2:	c3                   	ret    

001017e3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e3:	55                   	push   %ebp
  1017e4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e6:	fa                   	cli    
    cli();
}
  1017e7:	90                   	nop
  1017e8:	5d                   	pop    %ebp
  1017e9:	c3                   	ret    

001017ea <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ea:	55                   	push   %ebp
  1017eb:	89 e5                	mov    %esp,%ebp
  1017ed:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017f7:	00 
  1017f8:	c7 04 24 a0 38 10 00 	movl   $0x1038a0,(%esp)
  1017ff:	e8 68 ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101804:	c7 04 24 aa 38 10 00 	movl   $0x1038aa,(%esp)
  10180b:	e8 5c ea ff ff       	call   10026c <cprintf>
    panic("EOT: kernel seems ok.");
  101810:	c7 44 24 08 b8 38 10 	movl   $0x1038b8,0x8(%esp)
  101817:	00 
  101818:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10181f:	00 
  101820:	c7 04 24 ce 38 10 00 	movl   $0x1038ce,(%esp)
  101827:	e8 97 eb ff ff       	call   1003c3 <__panic>

0010182c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10182c:	55                   	push   %ebp
  10182d:	89 e5                	mov    %esp,%ebp
  10182f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];

    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  101832:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101839:	e9 c4 00 00 00       	jmp    101902 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10183e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101841:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101848:	0f b7 d0             	movzwl %ax,%edx
  10184b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101855:	00 
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101860:	00 08 00 
  101863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101866:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186d:	00 
  10186e:	80 e2 e0             	and    $0xe0,%dl
  101871:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101882:	00 
  101883:	80 e2 1f             	and    $0x1f,%dl
  101886:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101890:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101897:	00 
  101898:	80 e2 f0             	and    $0xf0,%dl
  10189b:	80 ca 0e             	or     $0xe,%dl
  10189e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018af:	00 
  1018b0:	80 e2 ef             	and    $0xef,%dl
  1018b3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c4:	00 
  1018c5:	80 e2 9f             	and    $0x9f,%dl
  1018c8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d9:	00 
  1018da:	80 ca 80             	or     $0x80,%dl
  1018dd:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ee:	c1 e8 10             	shr    $0x10,%eax
  1018f1:	0f b7 d0             	movzwl %ax,%edx
  1018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f7:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018fe:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  1018ff:	ff 45 fc             	incl   -0x4(%ebp)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	3d ff 00 00 00       	cmp    $0xff,%eax
  10190a:	0f 86 2e ff ff ff    	jbe    10183e <idt_init+0x12>
  101910:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10191a:	0f 01 18             	lidtl  (%eax)
    }

    //SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);

    lidt(&idt_pd);
}
  10191d:	90                   	nop
  10191e:	c9                   	leave  
  10191f:	c3                   	ret    

00101920 <trapname>:

static const char *
trapname(int trapno) {
  101920:	55                   	push   %ebp
  101921:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101923:	8b 45 08             	mov    0x8(%ebp),%eax
  101926:	83 f8 13             	cmp    $0x13,%eax
  101929:	77 0c                	ja     101937 <trapname+0x17>
        return excnames[trapno];
  10192b:	8b 45 08             	mov    0x8(%ebp),%eax
  10192e:	8b 04 85 20 3c 10 00 	mov    0x103c20(,%eax,4),%eax
  101935:	eb 18                	jmp    10194f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101937:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10193b:	7e 0d                	jle    10194a <trapname+0x2a>
  10193d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101941:	7f 07                	jg     10194a <trapname+0x2a>
        return "Hardware Interrupt";
  101943:	b8 df 38 10 00       	mov    $0x1038df,%eax
  101948:	eb 05                	jmp    10194f <trapname+0x2f>
    }
    return "(unknown trap)";
  10194a:	b8 f2 38 10 00       	mov    $0x1038f2,%eax
}
  10194f:	5d                   	pop    %ebp
  101950:	c3                   	ret    

00101951 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101951:	55                   	push   %ebp
  101952:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101954:	8b 45 08             	mov    0x8(%ebp),%eax
  101957:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10195b:	83 f8 08             	cmp    $0x8,%eax
  10195e:	0f 94 c0             	sete   %al
  101961:	0f b6 c0             	movzbl %al,%eax
}
  101964:	5d                   	pop    %ebp
  101965:	c3                   	ret    

00101966 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101966:	55                   	push   %ebp
  101967:	89 e5                	mov    %esp,%ebp
  101969:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  10196c:	8b 45 08             	mov    0x8(%ebp),%eax
  10196f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101973:	c7 04 24 33 39 10 00 	movl   $0x103933,(%esp)
  10197a:	e8 ed e8 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  10197f:	8b 45 08             	mov    0x8(%ebp),%eax
  101982:	89 04 24             	mov    %eax,(%esp)
  101985:	e8 8f 01 00 00       	call   101b19 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10198a:	8b 45 08             	mov    0x8(%ebp),%eax
  10198d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101991:	89 44 24 04          	mov    %eax,0x4(%esp)
  101995:	c7 04 24 44 39 10 00 	movl   $0x103944,(%esp)
  10199c:	e8 cb e8 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a4:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ac:	c7 04 24 57 39 10 00 	movl   $0x103957,(%esp)
  1019b3:	e8 b4 e8 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c3:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  1019ca:	e8 9d e8 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d2:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019da:	c7 04 24 7d 39 10 00 	movl   $0x10397d,(%esp)
  1019e1:	e8 86 e8 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e9:	8b 40 30             	mov    0x30(%eax),%eax
  1019ec:	89 04 24             	mov    %eax,(%esp)
  1019ef:	e8 2c ff ff ff       	call   101920 <trapname>
  1019f4:	89 c2                	mov    %eax,%edx
  1019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f9:	8b 40 30             	mov    0x30(%eax),%eax
  1019fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a04:	c7 04 24 90 39 10 00 	movl   $0x103990,(%esp)
  101a0b:	e8 5c e8 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a10:	8b 45 08             	mov    0x8(%ebp),%eax
  101a13:	8b 40 34             	mov    0x34(%eax),%eax
  101a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1a:	c7 04 24 a2 39 10 00 	movl   $0x1039a2,(%esp)
  101a21:	e8 46 e8 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	8b 40 38             	mov    0x38(%eax),%eax
  101a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a30:	c7 04 24 b1 39 10 00 	movl   $0x1039b1,(%esp)
  101a37:	e8 30 e8 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a47:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  101a4e:	e8 19 e8 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a53:	8b 45 08             	mov    0x8(%ebp),%eax
  101a56:	8b 40 40             	mov    0x40(%eax),%eax
  101a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5d:	c7 04 24 d3 39 10 00 	movl   $0x1039d3,(%esp)
  101a64:	e8 03 e8 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a70:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a77:	eb 3d                	jmp    101ab6 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a79:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7c:	8b 50 40             	mov    0x40(%eax),%edx
  101a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a82:	21 d0                	and    %edx,%eax
  101a84:	85 c0                	test   %eax,%eax
  101a86:	74 28                	je     101ab0 <print_trapframe+0x14a>
  101a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a8b:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a92:	85 c0                	test   %eax,%eax
  101a94:	74 1a                	je     101ab0 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a99:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa4:	c7 04 24 e2 39 10 00 	movl   $0x1039e2,(%esp)
  101aab:	e8 bc e7 ff ff       	call   10026c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ab0:	ff 45 f4             	incl   -0xc(%ebp)
  101ab3:	d1 65 f0             	shll   -0x10(%ebp)
  101ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ab9:	83 f8 17             	cmp    $0x17,%eax
  101abc:	76 bb                	jbe    101a79 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	8b 40 40             	mov    0x40(%eax),%eax
  101ac4:	c1 e8 0c             	shr    $0xc,%eax
  101ac7:	83 e0 03             	and    $0x3,%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 e6 39 10 00 	movl   $0x1039e6,(%esp)
  101ad5:	e8 92 e7 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf)) {
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	89 04 24             	mov    %eax,(%esp)
  101ae0:	e8 6c fe ff ff       	call   101951 <trap_in_kernel>
  101ae5:	85 c0                	test   %eax,%eax
  101ae7:	75 2d                	jne    101b16 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	8b 40 44             	mov    0x44(%eax),%eax
  101aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af3:	c7 04 24 ef 39 10 00 	movl   $0x1039ef,(%esp)
  101afa:	e8 6d e7 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0a:	c7 04 24 fe 39 10 00 	movl   $0x1039fe,(%esp)
  101b11:	e8 56 e7 ff ff       	call   10026c <cprintf>
    }
}
  101b16:	90                   	nop
  101b17:	c9                   	leave  
  101b18:	c3                   	ret    

00101b19 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b19:	55                   	push   %ebp
  101b1a:	89 e5                	mov    %esp,%ebp
  101b1c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	8b 00                	mov    (%eax),%eax
  101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b28:	c7 04 24 11 3a 10 00 	movl   $0x103a11,(%esp)
  101b2f:	e8 38 e7 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	8b 40 04             	mov    0x4(%eax),%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 20 3a 10 00 	movl   $0x103a20,(%esp)
  101b45:	e8 22 e7 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	8b 40 08             	mov    0x8(%eax),%eax
  101b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b54:	c7 04 24 2f 3a 10 00 	movl   $0x103a2f,(%esp)
  101b5b:	e8 0c e7 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	8b 40 0c             	mov    0xc(%eax),%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 3e 3a 10 00 	movl   $0x103a3e,(%esp)
  101b71:	e8 f6 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	8b 40 10             	mov    0x10(%eax),%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 4d 3a 10 00 	movl   $0x103a4d,(%esp)
  101b87:	e8 e0 e6 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	8b 40 14             	mov    0x14(%eax),%eax
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 5c 3a 10 00 	movl   $0x103a5c,(%esp)
  101b9d:	e8 ca e6 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba5:	8b 40 18             	mov    0x18(%eax),%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 6b 3a 10 00 	movl   $0x103a6b,(%esp)
  101bb3:	e8 b4 e6 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc2:	c7 04 24 7a 3a 10 00 	movl   $0x103a7a,(%esp)
  101bc9:	e8 9e e6 ff ff       	call   10026c <cprintf>
}
  101bce:	90                   	nop
  101bcf:	c9                   	leave  
  101bd0:	c3                   	ret    

00101bd1 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bd1:	55                   	push   %ebp
  101bd2:	89 e5                	mov    %esp,%ebp
  101bd4:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 30             	mov    0x30(%eax),%eax
  101bdd:	83 f8 2f             	cmp    $0x2f,%eax
  101be0:	77 21                	ja     101c03 <trap_dispatch+0x32>
  101be2:	83 f8 2e             	cmp    $0x2e,%eax
  101be5:	0f 83 16 02 00 00    	jae    101e01 <trap_dispatch+0x230>
  101beb:	83 f8 21             	cmp    $0x21,%eax
  101bee:	0f 84 95 00 00 00    	je     101c89 <trap_dispatch+0xb8>
  101bf4:	83 f8 24             	cmp    $0x24,%eax
  101bf7:	74 67                	je     101c60 <trap_dispatch+0x8f>
  101bf9:	83 f8 20             	cmp    $0x20,%eax
  101bfc:	74 1c                	je     101c1a <trap_dispatch+0x49>
  101bfe:	e9 c9 01 00 00       	jmp    101dcc <trap_dispatch+0x1fb>
  101c03:	83 f8 78             	cmp    $0x78,%eax
  101c06:	0f 84 44 01 00 00    	je     101d50 <trap_dispatch+0x17f>
  101c0c:	83 f8 79             	cmp    $0x79,%eax
  101c0f:	0f 84 7e 01 00 00    	je     101d93 <trap_dispatch+0x1c2>
  101c15:	e9 b2 01 00 00       	jmp    101dcc <trap_dispatch+0x1fb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101c1a:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c1f:	40                   	inc    %eax
  101c20:	a3 08 f9 10 00       	mov    %eax,0x10f908
        
        if (ticks % TICK_NUM == 0) {
  101c25:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c2b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c30:	89 c8                	mov    %ecx,%eax
  101c32:	f7 e2                	mul    %edx
  101c34:	c1 ea 05             	shr    $0x5,%edx
  101c37:	89 d0                	mov    %edx,%eax
  101c39:	c1 e0 02             	shl    $0x2,%eax
  101c3c:	01 d0                	add    %edx,%eax
  101c3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101c45:	01 d0                	add    %edx,%eax
  101c47:	c1 e0 02             	shl    $0x2,%eax
  101c4a:	29 c1                	sub    %eax,%ecx
  101c4c:	89 ca                	mov    %ecx,%edx
  101c4e:	85 d2                	test   %edx,%edx
  101c50:	0f 85 ae 01 00 00    	jne    101e04 <trap_dispatch+0x233>
            print_ticks();
  101c56:	e8 8f fb ff ff       	call   1017ea <print_ticks>
        }

        break;
  101c5b:	e9 a4 01 00 00       	jmp    101e04 <trap_dispatch+0x233>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c60:	e8 55 f9 ff ff       	call   1015ba <cons_getc>
  101c65:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c68:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c6c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c70:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c78:	c7 04 24 89 3a 10 00 	movl   $0x103a89,(%esp)
  101c7f:	e8 e8 e5 ff ff       	call   10026c <cprintf>
        break;
  101c84:	e9 7f 01 00 00       	jmp    101e08 <trap_dispatch+0x237>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c89:	e8 2c f9 ff ff       	call   1015ba <cons_getc>
  101c8e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c91:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c95:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c99:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca1:	c7 04 24 9b 3a 10 00 	movl   $0x103a9b,(%esp)
  101ca8:	e8 bf e5 ff ff       	call   10026c <cprintf>
        if ( c =='3'){
  101cad:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101cb1:	75 4c                	jne    101cff <trap_dispatch+0x12e>
			tf->tf_cs = USER_CS;
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbf:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccf:	66 89 50 28          	mov    %dx,0x28(%eax)
  101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101cda:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce4:	8b 40 40             	mov    0x40(%eax),%eax
  101ce7:	0d 00 30 00 00       	or     $0x3000,%eax
  101cec:	89 c2                	mov    %eax,%edx
  101cee:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf1:	89 50 40             	mov    %edx,0x40(%eax)
			print_trapframe(tf);
  101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf7:	89 04 24             	mov    %eax,(%esp)
  101cfa:	e8 67 fc ff ff       	call   101966 <print_trapframe>
		}
		if ( c =='0'){
  101cff:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101d03:	0f 85 fe 00 00 00    	jne    101e07 <trap_dispatch+0x236>
			tf->tf_cs = KERNEL_CS;
  101d09:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0c:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = KERNEL_DS;
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
            tf->tf_es = KERNEL_DS;
  101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
            tf->tf_ss = KERNEL_DS;
  101d24:	8b 45 08             	mov    0x8(%ebp),%eax
  101d27:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	8b 40 40             	mov    0x40(%eax),%eax
  101d33:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101d38:	89 c2                	mov    %eax,%edx
  101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3d:	89 50 40             	mov    %edx,0x40(%eax)
			print_trapframe(tf);
  101d40:	8b 45 08             	mov    0x8(%ebp),%eax
  101d43:	89 04 24             	mov    %eax,(%esp)
  101d46:	e8 1b fc ff ff       	call   101966 <print_trapframe>
		}
        break;
  101d4b:	e9 b7 00 00 00       	jmp    101e07 <trap_dispatch+0x236>
        // if (tf->tf_cs != USER_CS) {
        //     tf->tf_cs = USER_CS;
        //     tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
        //     tf->tf_eflags |= FL_IOPL_MASK;
        // }
        tf->tf_cs = USER_CS;
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101d62:	8b 45 08             	mov    0x8(%ebp),%eax
  101d65:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101d69:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6c:	66 89 50 28          	mov    %dx,0x28(%eax)
  101d70:	8b 45 08             	mov    0x8(%ebp),%eax
  101d73:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d77:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags |= FL_IOPL_MASK;
  101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d81:	8b 40 40             	mov    0x40(%eax),%eax
  101d84:	0d 00 30 00 00       	or     $0x3000,%eax
  101d89:	89 c2                	mov    %eax,%edx
  101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8e:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101d91:	eb 75                	jmp    101e08 <trap_dispatch+0x237>
        // if (tf->tf_cs != KERNEL_CS) {
        //     tf->tf_cs = KERNEL_CS;
        //     tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
        //     tf->tf_eflags &= ~FL_IOPL_MASK;
        // }
        tf->tf_cs = KERNEL_CS;
  101d93:	8b 45 08             	mov    0x8(%ebp),%eax
  101d96:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9f:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101da5:	8b 45 08             	mov    0x8(%ebp),%eax
  101da8:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ss = KERNEL_DS;
  101dae:	8b 45 08             	mov    0x8(%ebp),%eax
  101db1:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	8b 40 40             	mov    0x40(%eax),%eax
  101dbd:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101dc2:	89 c2                	mov    %eax,%edx
  101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc7:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101dca:	eb 3c                	jmp    101e08 <trap_dispatch+0x237>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd3:	83 e0 03             	and    $0x3,%eax
  101dd6:	85 c0                	test   %eax,%eax
  101dd8:	75 2e                	jne    101e08 <trap_dispatch+0x237>
            print_trapframe(tf);
  101dda:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddd:	89 04 24             	mov    %eax,(%esp)
  101de0:	e8 81 fb ff ff       	call   101966 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101de5:	c7 44 24 08 aa 3a 10 	movl   $0x103aaa,0x8(%esp)
  101dec:	00 
  101ded:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  101df4:	00 
  101df5:	c7 04 24 ce 38 10 00 	movl   $0x1038ce,(%esp)
  101dfc:	e8 c2 e5 ff ff       	call   1003c3 <__panic>
        break;
  101e01:	90                   	nop
  101e02:	eb 04                	jmp    101e08 <trap_dispatch+0x237>
        break;
  101e04:	90                   	nop
  101e05:	eb 01                	jmp    101e08 <trap_dispatch+0x237>
        break;
  101e07:	90                   	nop
        }
    }
}
  101e08:	90                   	nop
  101e09:	c9                   	leave  
  101e0a:	c3                   	ret    

00101e0b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e0b:	55                   	push   %ebp
  101e0c:	89 e5                	mov    %esp,%ebp
  101e0e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e11:	8b 45 08             	mov    0x8(%ebp),%eax
  101e14:	89 04 24             	mov    %eax,(%esp)
  101e17:	e8 b5 fd ff ff       	call   101bd1 <trap_dispatch>
}
  101e1c:	90                   	nop
  101e1d:	c9                   	leave  
  101e1e:	c3                   	ret    

00101e1f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $0
  101e21:	6a 00                	push   $0x0
  jmp __alltraps
  101e23:	e9 69 0a 00 00       	jmp    102891 <__alltraps>

00101e28 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e28:	6a 00                	push   $0x0
  pushl $1
  101e2a:	6a 01                	push   $0x1
  jmp __alltraps
  101e2c:	e9 60 0a 00 00       	jmp    102891 <__alltraps>

00101e31 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $2
  101e33:	6a 02                	push   $0x2
  jmp __alltraps
  101e35:	e9 57 0a 00 00       	jmp    102891 <__alltraps>

00101e3a <vector3>:
.globl vector3
vector3:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $3
  101e3c:	6a 03                	push   $0x3
  jmp __alltraps
  101e3e:	e9 4e 0a 00 00       	jmp    102891 <__alltraps>

00101e43 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $4
  101e45:	6a 04                	push   $0x4
  jmp __alltraps
  101e47:	e9 45 0a 00 00       	jmp    102891 <__alltraps>

00101e4c <vector5>:
.globl vector5
vector5:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $5
  101e4e:	6a 05                	push   $0x5
  jmp __alltraps
  101e50:	e9 3c 0a 00 00       	jmp    102891 <__alltraps>

00101e55 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $6
  101e57:	6a 06                	push   $0x6
  jmp __alltraps
  101e59:	e9 33 0a 00 00       	jmp    102891 <__alltraps>

00101e5e <vector7>:
.globl vector7
vector7:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $7
  101e60:	6a 07                	push   $0x7
  jmp __alltraps
  101e62:	e9 2a 0a 00 00       	jmp    102891 <__alltraps>

00101e67 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e67:	6a 08                	push   $0x8
  jmp __alltraps
  101e69:	e9 23 0a 00 00       	jmp    102891 <__alltraps>

00101e6e <vector9>:
.globl vector9
vector9:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $9
  101e70:	6a 09                	push   $0x9
  jmp __alltraps
  101e72:	e9 1a 0a 00 00       	jmp    102891 <__alltraps>

00101e77 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e77:	6a 0a                	push   $0xa
  jmp __alltraps
  101e79:	e9 13 0a 00 00       	jmp    102891 <__alltraps>

00101e7e <vector11>:
.globl vector11
vector11:
  pushl $11
  101e7e:	6a 0b                	push   $0xb
  jmp __alltraps
  101e80:	e9 0c 0a 00 00       	jmp    102891 <__alltraps>

00101e85 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e85:	6a 0c                	push   $0xc
  jmp __alltraps
  101e87:	e9 05 0a 00 00       	jmp    102891 <__alltraps>

00101e8c <vector13>:
.globl vector13
vector13:
  pushl $13
  101e8c:	6a 0d                	push   $0xd
  jmp __alltraps
  101e8e:	e9 fe 09 00 00       	jmp    102891 <__alltraps>

00101e93 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e93:	6a 0e                	push   $0xe
  jmp __alltraps
  101e95:	e9 f7 09 00 00       	jmp    102891 <__alltraps>

00101e9a <vector15>:
.globl vector15
vector15:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $15
  101e9c:	6a 0f                	push   $0xf
  jmp __alltraps
  101e9e:	e9 ee 09 00 00       	jmp    102891 <__alltraps>

00101ea3 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $16
  101ea5:	6a 10                	push   $0x10
  jmp __alltraps
  101ea7:	e9 e5 09 00 00       	jmp    102891 <__alltraps>

00101eac <vector17>:
.globl vector17
vector17:
  pushl $17
  101eac:	6a 11                	push   $0x11
  jmp __alltraps
  101eae:	e9 de 09 00 00       	jmp    102891 <__alltraps>

00101eb3 <vector18>:
.globl vector18
vector18:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $18
  101eb5:	6a 12                	push   $0x12
  jmp __alltraps
  101eb7:	e9 d5 09 00 00       	jmp    102891 <__alltraps>

00101ebc <vector19>:
.globl vector19
vector19:
  pushl $0
  101ebc:	6a 00                	push   $0x0
  pushl $19
  101ebe:	6a 13                	push   $0x13
  jmp __alltraps
  101ec0:	e9 cc 09 00 00       	jmp    102891 <__alltraps>

00101ec5 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $20
  101ec7:	6a 14                	push   $0x14
  jmp __alltraps
  101ec9:	e9 c3 09 00 00       	jmp    102891 <__alltraps>

00101ece <vector21>:
.globl vector21
vector21:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $21
  101ed0:	6a 15                	push   $0x15
  jmp __alltraps
  101ed2:	e9 ba 09 00 00       	jmp    102891 <__alltraps>

00101ed7 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $22
  101ed9:	6a 16                	push   $0x16
  jmp __alltraps
  101edb:	e9 b1 09 00 00       	jmp    102891 <__alltraps>

00101ee0 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $23
  101ee2:	6a 17                	push   $0x17
  jmp __alltraps
  101ee4:	e9 a8 09 00 00       	jmp    102891 <__alltraps>

00101ee9 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $24
  101eeb:	6a 18                	push   $0x18
  jmp __alltraps
  101eed:	e9 9f 09 00 00       	jmp    102891 <__alltraps>

00101ef2 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $25
  101ef4:	6a 19                	push   $0x19
  jmp __alltraps
  101ef6:	e9 96 09 00 00       	jmp    102891 <__alltraps>

00101efb <vector26>:
.globl vector26
vector26:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $26
  101efd:	6a 1a                	push   $0x1a
  jmp __alltraps
  101eff:	e9 8d 09 00 00       	jmp    102891 <__alltraps>

00101f04 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $27
  101f06:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f08:	e9 84 09 00 00       	jmp    102891 <__alltraps>

00101f0d <vector28>:
.globl vector28
vector28:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $28
  101f0f:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f11:	e9 7b 09 00 00       	jmp    102891 <__alltraps>

00101f16 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $29
  101f18:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f1a:	e9 72 09 00 00       	jmp    102891 <__alltraps>

00101f1f <vector30>:
.globl vector30
vector30:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $30
  101f21:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f23:	e9 69 09 00 00       	jmp    102891 <__alltraps>

00101f28 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $31
  101f2a:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f2c:	e9 60 09 00 00       	jmp    102891 <__alltraps>

00101f31 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $32
  101f33:	6a 20                	push   $0x20
  jmp __alltraps
  101f35:	e9 57 09 00 00       	jmp    102891 <__alltraps>

00101f3a <vector33>:
.globl vector33
vector33:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $33
  101f3c:	6a 21                	push   $0x21
  jmp __alltraps
  101f3e:	e9 4e 09 00 00       	jmp    102891 <__alltraps>

00101f43 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $34
  101f45:	6a 22                	push   $0x22
  jmp __alltraps
  101f47:	e9 45 09 00 00       	jmp    102891 <__alltraps>

00101f4c <vector35>:
.globl vector35
vector35:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $35
  101f4e:	6a 23                	push   $0x23
  jmp __alltraps
  101f50:	e9 3c 09 00 00       	jmp    102891 <__alltraps>

00101f55 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $36
  101f57:	6a 24                	push   $0x24
  jmp __alltraps
  101f59:	e9 33 09 00 00       	jmp    102891 <__alltraps>

00101f5e <vector37>:
.globl vector37
vector37:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $37
  101f60:	6a 25                	push   $0x25
  jmp __alltraps
  101f62:	e9 2a 09 00 00       	jmp    102891 <__alltraps>

00101f67 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $38
  101f69:	6a 26                	push   $0x26
  jmp __alltraps
  101f6b:	e9 21 09 00 00       	jmp    102891 <__alltraps>

00101f70 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $39
  101f72:	6a 27                	push   $0x27
  jmp __alltraps
  101f74:	e9 18 09 00 00       	jmp    102891 <__alltraps>

00101f79 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $40
  101f7b:	6a 28                	push   $0x28
  jmp __alltraps
  101f7d:	e9 0f 09 00 00       	jmp    102891 <__alltraps>

00101f82 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $41
  101f84:	6a 29                	push   $0x29
  jmp __alltraps
  101f86:	e9 06 09 00 00       	jmp    102891 <__alltraps>

00101f8b <vector42>:
.globl vector42
vector42:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $42
  101f8d:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f8f:	e9 fd 08 00 00       	jmp    102891 <__alltraps>

00101f94 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $43
  101f96:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f98:	e9 f4 08 00 00       	jmp    102891 <__alltraps>

00101f9d <vector44>:
.globl vector44
vector44:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $44
  101f9f:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fa1:	e9 eb 08 00 00       	jmp    102891 <__alltraps>

00101fa6 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $45
  101fa8:	6a 2d                	push   $0x2d
  jmp __alltraps
  101faa:	e9 e2 08 00 00       	jmp    102891 <__alltraps>

00101faf <vector46>:
.globl vector46
vector46:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $46
  101fb1:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fb3:	e9 d9 08 00 00       	jmp    102891 <__alltraps>

00101fb8 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $47
  101fba:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fbc:	e9 d0 08 00 00       	jmp    102891 <__alltraps>

00101fc1 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $48
  101fc3:	6a 30                	push   $0x30
  jmp __alltraps
  101fc5:	e9 c7 08 00 00       	jmp    102891 <__alltraps>

00101fca <vector49>:
.globl vector49
vector49:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $49
  101fcc:	6a 31                	push   $0x31
  jmp __alltraps
  101fce:	e9 be 08 00 00       	jmp    102891 <__alltraps>

00101fd3 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $50
  101fd5:	6a 32                	push   $0x32
  jmp __alltraps
  101fd7:	e9 b5 08 00 00       	jmp    102891 <__alltraps>

00101fdc <vector51>:
.globl vector51
vector51:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $51
  101fde:	6a 33                	push   $0x33
  jmp __alltraps
  101fe0:	e9 ac 08 00 00       	jmp    102891 <__alltraps>

00101fe5 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $52
  101fe7:	6a 34                	push   $0x34
  jmp __alltraps
  101fe9:	e9 a3 08 00 00       	jmp    102891 <__alltraps>

00101fee <vector53>:
.globl vector53
vector53:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $53
  101ff0:	6a 35                	push   $0x35
  jmp __alltraps
  101ff2:	e9 9a 08 00 00       	jmp    102891 <__alltraps>

00101ff7 <vector54>:
.globl vector54
vector54:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $54
  101ff9:	6a 36                	push   $0x36
  jmp __alltraps
  101ffb:	e9 91 08 00 00       	jmp    102891 <__alltraps>

00102000 <vector55>:
.globl vector55
vector55:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $55
  102002:	6a 37                	push   $0x37
  jmp __alltraps
  102004:	e9 88 08 00 00       	jmp    102891 <__alltraps>

00102009 <vector56>:
.globl vector56
vector56:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $56
  10200b:	6a 38                	push   $0x38
  jmp __alltraps
  10200d:	e9 7f 08 00 00       	jmp    102891 <__alltraps>

00102012 <vector57>:
.globl vector57
vector57:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $57
  102014:	6a 39                	push   $0x39
  jmp __alltraps
  102016:	e9 76 08 00 00       	jmp    102891 <__alltraps>

0010201b <vector58>:
.globl vector58
vector58:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $58
  10201d:	6a 3a                	push   $0x3a
  jmp __alltraps
  10201f:	e9 6d 08 00 00       	jmp    102891 <__alltraps>

00102024 <vector59>:
.globl vector59
vector59:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $59
  102026:	6a 3b                	push   $0x3b
  jmp __alltraps
  102028:	e9 64 08 00 00       	jmp    102891 <__alltraps>

0010202d <vector60>:
.globl vector60
vector60:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $60
  10202f:	6a 3c                	push   $0x3c
  jmp __alltraps
  102031:	e9 5b 08 00 00       	jmp    102891 <__alltraps>

00102036 <vector61>:
.globl vector61
vector61:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $61
  102038:	6a 3d                	push   $0x3d
  jmp __alltraps
  10203a:	e9 52 08 00 00       	jmp    102891 <__alltraps>

0010203f <vector62>:
.globl vector62
vector62:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $62
  102041:	6a 3e                	push   $0x3e
  jmp __alltraps
  102043:	e9 49 08 00 00       	jmp    102891 <__alltraps>

00102048 <vector63>:
.globl vector63
vector63:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $63
  10204a:	6a 3f                	push   $0x3f
  jmp __alltraps
  10204c:	e9 40 08 00 00       	jmp    102891 <__alltraps>

00102051 <vector64>:
.globl vector64
vector64:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $64
  102053:	6a 40                	push   $0x40
  jmp __alltraps
  102055:	e9 37 08 00 00       	jmp    102891 <__alltraps>

0010205a <vector65>:
.globl vector65
vector65:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $65
  10205c:	6a 41                	push   $0x41
  jmp __alltraps
  10205e:	e9 2e 08 00 00       	jmp    102891 <__alltraps>

00102063 <vector66>:
.globl vector66
vector66:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $66
  102065:	6a 42                	push   $0x42
  jmp __alltraps
  102067:	e9 25 08 00 00       	jmp    102891 <__alltraps>

0010206c <vector67>:
.globl vector67
vector67:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $67
  10206e:	6a 43                	push   $0x43
  jmp __alltraps
  102070:	e9 1c 08 00 00       	jmp    102891 <__alltraps>

00102075 <vector68>:
.globl vector68
vector68:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $68
  102077:	6a 44                	push   $0x44
  jmp __alltraps
  102079:	e9 13 08 00 00       	jmp    102891 <__alltraps>

0010207e <vector69>:
.globl vector69
vector69:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $69
  102080:	6a 45                	push   $0x45
  jmp __alltraps
  102082:	e9 0a 08 00 00       	jmp    102891 <__alltraps>

00102087 <vector70>:
.globl vector70
vector70:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $70
  102089:	6a 46                	push   $0x46
  jmp __alltraps
  10208b:	e9 01 08 00 00       	jmp    102891 <__alltraps>

00102090 <vector71>:
.globl vector71
vector71:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $71
  102092:	6a 47                	push   $0x47
  jmp __alltraps
  102094:	e9 f8 07 00 00       	jmp    102891 <__alltraps>

00102099 <vector72>:
.globl vector72
vector72:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $72
  10209b:	6a 48                	push   $0x48
  jmp __alltraps
  10209d:	e9 ef 07 00 00       	jmp    102891 <__alltraps>

001020a2 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $73
  1020a4:	6a 49                	push   $0x49
  jmp __alltraps
  1020a6:	e9 e6 07 00 00       	jmp    102891 <__alltraps>

001020ab <vector74>:
.globl vector74
vector74:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $74
  1020ad:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020af:	e9 dd 07 00 00       	jmp    102891 <__alltraps>

001020b4 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $75
  1020b6:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020b8:	e9 d4 07 00 00       	jmp    102891 <__alltraps>

001020bd <vector76>:
.globl vector76
vector76:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $76
  1020bf:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020c1:	e9 cb 07 00 00       	jmp    102891 <__alltraps>

001020c6 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $77
  1020c8:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020ca:	e9 c2 07 00 00       	jmp    102891 <__alltraps>

001020cf <vector78>:
.globl vector78
vector78:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $78
  1020d1:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020d3:	e9 b9 07 00 00       	jmp    102891 <__alltraps>

001020d8 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $79
  1020da:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020dc:	e9 b0 07 00 00       	jmp    102891 <__alltraps>

001020e1 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $80
  1020e3:	6a 50                	push   $0x50
  jmp __alltraps
  1020e5:	e9 a7 07 00 00       	jmp    102891 <__alltraps>

001020ea <vector81>:
.globl vector81
vector81:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $81
  1020ec:	6a 51                	push   $0x51
  jmp __alltraps
  1020ee:	e9 9e 07 00 00       	jmp    102891 <__alltraps>

001020f3 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $82
  1020f5:	6a 52                	push   $0x52
  jmp __alltraps
  1020f7:	e9 95 07 00 00       	jmp    102891 <__alltraps>

001020fc <vector83>:
.globl vector83
vector83:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $83
  1020fe:	6a 53                	push   $0x53
  jmp __alltraps
  102100:	e9 8c 07 00 00       	jmp    102891 <__alltraps>

00102105 <vector84>:
.globl vector84
vector84:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $84
  102107:	6a 54                	push   $0x54
  jmp __alltraps
  102109:	e9 83 07 00 00       	jmp    102891 <__alltraps>

0010210e <vector85>:
.globl vector85
vector85:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $85
  102110:	6a 55                	push   $0x55
  jmp __alltraps
  102112:	e9 7a 07 00 00       	jmp    102891 <__alltraps>

00102117 <vector86>:
.globl vector86
vector86:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $86
  102119:	6a 56                	push   $0x56
  jmp __alltraps
  10211b:	e9 71 07 00 00       	jmp    102891 <__alltraps>

00102120 <vector87>:
.globl vector87
vector87:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $87
  102122:	6a 57                	push   $0x57
  jmp __alltraps
  102124:	e9 68 07 00 00       	jmp    102891 <__alltraps>

00102129 <vector88>:
.globl vector88
vector88:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $88
  10212b:	6a 58                	push   $0x58
  jmp __alltraps
  10212d:	e9 5f 07 00 00       	jmp    102891 <__alltraps>

00102132 <vector89>:
.globl vector89
vector89:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $89
  102134:	6a 59                	push   $0x59
  jmp __alltraps
  102136:	e9 56 07 00 00       	jmp    102891 <__alltraps>

0010213b <vector90>:
.globl vector90
vector90:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $90
  10213d:	6a 5a                	push   $0x5a
  jmp __alltraps
  10213f:	e9 4d 07 00 00       	jmp    102891 <__alltraps>

00102144 <vector91>:
.globl vector91
vector91:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $91
  102146:	6a 5b                	push   $0x5b
  jmp __alltraps
  102148:	e9 44 07 00 00       	jmp    102891 <__alltraps>

0010214d <vector92>:
.globl vector92
vector92:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $92
  10214f:	6a 5c                	push   $0x5c
  jmp __alltraps
  102151:	e9 3b 07 00 00       	jmp    102891 <__alltraps>

00102156 <vector93>:
.globl vector93
vector93:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $93
  102158:	6a 5d                	push   $0x5d
  jmp __alltraps
  10215a:	e9 32 07 00 00       	jmp    102891 <__alltraps>

0010215f <vector94>:
.globl vector94
vector94:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $94
  102161:	6a 5e                	push   $0x5e
  jmp __alltraps
  102163:	e9 29 07 00 00       	jmp    102891 <__alltraps>

00102168 <vector95>:
.globl vector95
vector95:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $95
  10216a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10216c:	e9 20 07 00 00       	jmp    102891 <__alltraps>

00102171 <vector96>:
.globl vector96
vector96:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $96
  102173:	6a 60                	push   $0x60
  jmp __alltraps
  102175:	e9 17 07 00 00       	jmp    102891 <__alltraps>

0010217a <vector97>:
.globl vector97
vector97:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $97
  10217c:	6a 61                	push   $0x61
  jmp __alltraps
  10217e:	e9 0e 07 00 00       	jmp    102891 <__alltraps>

00102183 <vector98>:
.globl vector98
vector98:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $98
  102185:	6a 62                	push   $0x62
  jmp __alltraps
  102187:	e9 05 07 00 00       	jmp    102891 <__alltraps>

0010218c <vector99>:
.globl vector99
vector99:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $99
  10218e:	6a 63                	push   $0x63
  jmp __alltraps
  102190:	e9 fc 06 00 00       	jmp    102891 <__alltraps>

00102195 <vector100>:
.globl vector100
vector100:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $100
  102197:	6a 64                	push   $0x64
  jmp __alltraps
  102199:	e9 f3 06 00 00       	jmp    102891 <__alltraps>

0010219e <vector101>:
.globl vector101
vector101:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $101
  1021a0:	6a 65                	push   $0x65
  jmp __alltraps
  1021a2:	e9 ea 06 00 00       	jmp    102891 <__alltraps>

001021a7 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $102
  1021a9:	6a 66                	push   $0x66
  jmp __alltraps
  1021ab:	e9 e1 06 00 00       	jmp    102891 <__alltraps>

001021b0 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $103
  1021b2:	6a 67                	push   $0x67
  jmp __alltraps
  1021b4:	e9 d8 06 00 00       	jmp    102891 <__alltraps>

001021b9 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $104
  1021bb:	6a 68                	push   $0x68
  jmp __alltraps
  1021bd:	e9 cf 06 00 00       	jmp    102891 <__alltraps>

001021c2 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $105
  1021c4:	6a 69                	push   $0x69
  jmp __alltraps
  1021c6:	e9 c6 06 00 00       	jmp    102891 <__alltraps>

001021cb <vector106>:
.globl vector106
vector106:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $106
  1021cd:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021cf:	e9 bd 06 00 00       	jmp    102891 <__alltraps>

001021d4 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $107
  1021d6:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021d8:	e9 b4 06 00 00       	jmp    102891 <__alltraps>

001021dd <vector108>:
.globl vector108
vector108:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $108
  1021df:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021e1:	e9 ab 06 00 00       	jmp    102891 <__alltraps>

001021e6 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $109
  1021e8:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021ea:	e9 a2 06 00 00       	jmp    102891 <__alltraps>

001021ef <vector110>:
.globl vector110
vector110:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $110
  1021f1:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021f3:	e9 99 06 00 00       	jmp    102891 <__alltraps>

001021f8 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $111
  1021fa:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021fc:	e9 90 06 00 00       	jmp    102891 <__alltraps>

00102201 <vector112>:
.globl vector112
vector112:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $112
  102203:	6a 70                	push   $0x70
  jmp __alltraps
  102205:	e9 87 06 00 00       	jmp    102891 <__alltraps>

0010220a <vector113>:
.globl vector113
vector113:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $113
  10220c:	6a 71                	push   $0x71
  jmp __alltraps
  10220e:	e9 7e 06 00 00       	jmp    102891 <__alltraps>

00102213 <vector114>:
.globl vector114
vector114:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $114
  102215:	6a 72                	push   $0x72
  jmp __alltraps
  102217:	e9 75 06 00 00       	jmp    102891 <__alltraps>

0010221c <vector115>:
.globl vector115
vector115:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $115
  10221e:	6a 73                	push   $0x73
  jmp __alltraps
  102220:	e9 6c 06 00 00       	jmp    102891 <__alltraps>

00102225 <vector116>:
.globl vector116
vector116:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $116
  102227:	6a 74                	push   $0x74
  jmp __alltraps
  102229:	e9 63 06 00 00       	jmp    102891 <__alltraps>

0010222e <vector117>:
.globl vector117
vector117:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $117
  102230:	6a 75                	push   $0x75
  jmp __alltraps
  102232:	e9 5a 06 00 00       	jmp    102891 <__alltraps>

00102237 <vector118>:
.globl vector118
vector118:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $118
  102239:	6a 76                	push   $0x76
  jmp __alltraps
  10223b:	e9 51 06 00 00       	jmp    102891 <__alltraps>

00102240 <vector119>:
.globl vector119
vector119:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $119
  102242:	6a 77                	push   $0x77
  jmp __alltraps
  102244:	e9 48 06 00 00       	jmp    102891 <__alltraps>

00102249 <vector120>:
.globl vector120
vector120:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $120
  10224b:	6a 78                	push   $0x78
  jmp __alltraps
  10224d:	e9 3f 06 00 00       	jmp    102891 <__alltraps>

00102252 <vector121>:
.globl vector121
vector121:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $121
  102254:	6a 79                	push   $0x79
  jmp __alltraps
  102256:	e9 36 06 00 00       	jmp    102891 <__alltraps>

0010225b <vector122>:
.globl vector122
vector122:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $122
  10225d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10225f:	e9 2d 06 00 00       	jmp    102891 <__alltraps>

00102264 <vector123>:
.globl vector123
vector123:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $123
  102266:	6a 7b                	push   $0x7b
  jmp __alltraps
  102268:	e9 24 06 00 00       	jmp    102891 <__alltraps>

0010226d <vector124>:
.globl vector124
vector124:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $124
  10226f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102271:	e9 1b 06 00 00       	jmp    102891 <__alltraps>

00102276 <vector125>:
.globl vector125
vector125:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $125
  102278:	6a 7d                	push   $0x7d
  jmp __alltraps
  10227a:	e9 12 06 00 00       	jmp    102891 <__alltraps>

0010227f <vector126>:
.globl vector126
vector126:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $126
  102281:	6a 7e                	push   $0x7e
  jmp __alltraps
  102283:	e9 09 06 00 00       	jmp    102891 <__alltraps>

00102288 <vector127>:
.globl vector127
vector127:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $127
  10228a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10228c:	e9 00 06 00 00       	jmp    102891 <__alltraps>

00102291 <vector128>:
.globl vector128
vector128:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $128
  102293:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102298:	e9 f4 05 00 00       	jmp    102891 <__alltraps>

0010229d <vector129>:
.globl vector129
vector129:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $129
  10229f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022a4:	e9 e8 05 00 00       	jmp    102891 <__alltraps>

001022a9 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $130
  1022ab:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022b0:	e9 dc 05 00 00       	jmp    102891 <__alltraps>

001022b5 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $131
  1022b7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022bc:	e9 d0 05 00 00       	jmp    102891 <__alltraps>

001022c1 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $132
  1022c3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022c8:	e9 c4 05 00 00       	jmp    102891 <__alltraps>

001022cd <vector133>:
.globl vector133
vector133:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $133
  1022cf:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022d4:	e9 b8 05 00 00       	jmp    102891 <__alltraps>

001022d9 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $134
  1022db:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022e0:	e9 ac 05 00 00       	jmp    102891 <__alltraps>

001022e5 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $135
  1022e7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022ec:	e9 a0 05 00 00       	jmp    102891 <__alltraps>

001022f1 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $136
  1022f3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022f8:	e9 94 05 00 00       	jmp    102891 <__alltraps>

001022fd <vector137>:
.globl vector137
vector137:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $137
  1022ff:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102304:	e9 88 05 00 00       	jmp    102891 <__alltraps>

00102309 <vector138>:
.globl vector138
vector138:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $138
  10230b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102310:	e9 7c 05 00 00       	jmp    102891 <__alltraps>

00102315 <vector139>:
.globl vector139
vector139:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $139
  102317:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10231c:	e9 70 05 00 00       	jmp    102891 <__alltraps>

00102321 <vector140>:
.globl vector140
vector140:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $140
  102323:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102328:	e9 64 05 00 00       	jmp    102891 <__alltraps>

0010232d <vector141>:
.globl vector141
vector141:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $141
  10232f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102334:	e9 58 05 00 00       	jmp    102891 <__alltraps>

00102339 <vector142>:
.globl vector142
vector142:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $142
  10233b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102340:	e9 4c 05 00 00       	jmp    102891 <__alltraps>

00102345 <vector143>:
.globl vector143
vector143:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $143
  102347:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10234c:	e9 40 05 00 00       	jmp    102891 <__alltraps>

00102351 <vector144>:
.globl vector144
vector144:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $144
  102353:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102358:	e9 34 05 00 00       	jmp    102891 <__alltraps>

0010235d <vector145>:
.globl vector145
vector145:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $145
  10235f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102364:	e9 28 05 00 00       	jmp    102891 <__alltraps>

00102369 <vector146>:
.globl vector146
vector146:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $146
  10236b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102370:	e9 1c 05 00 00       	jmp    102891 <__alltraps>

00102375 <vector147>:
.globl vector147
vector147:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $147
  102377:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10237c:	e9 10 05 00 00       	jmp    102891 <__alltraps>

00102381 <vector148>:
.globl vector148
vector148:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $148
  102383:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102388:	e9 04 05 00 00       	jmp    102891 <__alltraps>

0010238d <vector149>:
.globl vector149
vector149:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $149
  10238f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102394:	e9 f8 04 00 00       	jmp    102891 <__alltraps>

00102399 <vector150>:
.globl vector150
vector150:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $150
  10239b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023a0:	e9 ec 04 00 00       	jmp    102891 <__alltraps>

001023a5 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $151
  1023a7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023ac:	e9 e0 04 00 00       	jmp    102891 <__alltraps>

001023b1 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $152
  1023b3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023b8:	e9 d4 04 00 00       	jmp    102891 <__alltraps>

001023bd <vector153>:
.globl vector153
vector153:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $153
  1023bf:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023c4:	e9 c8 04 00 00       	jmp    102891 <__alltraps>

001023c9 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $154
  1023cb:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023d0:	e9 bc 04 00 00       	jmp    102891 <__alltraps>

001023d5 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $155
  1023d7:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023dc:	e9 b0 04 00 00       	jmp    102891 <__alltraps>

001023e1 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $156
  1023e3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023e8:	e9 a4 04 00 00       	jmp    102891 <__alltraps>

001023ed <vector157>:
.globl vector157
vector157:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $157
  1023ef:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023f4:	e9 98 04 00 00       	jmp    102891 <__alltraps>

001023f9 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $158
  1023fb:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102400:	e9 8c 04 00 00       	jmp    102891 <__alltraps>

00102405 <vector159>:
.globl vector159
vector159:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $159
  102407:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10240c:	e9 80 04 00 00       	jmp    102891 <__alltraps>

00102411 <vector160>:
.globl vector160
vector160:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $160
  102413:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102418:	e9 74 04 00 00       	jmp    102891 <__alltraps>

0010241d <vector161>:
.globl vector161
vector161:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $161
  10241f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102424:	e9 68 04 00 00       	jmp    102891 <__alltraps>

00102429 <vector162>:
.globl vector162
vector162:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $162
  10242b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102430:	e9 5c 04 00 00       	jmp    102891 <__alltraps>

00102435 <vector163>:
.globl vector163
vector163:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $163
  102437:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10243c:	e9 50 04 00 00       	jmp    102891 <__alltraps>

00102441 <vector164>:
.globl vector164
vector164:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $164
  102443:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102448:	e9 44 04 00 00       	jmp    102891 <__alltraps>

0010244d <vector165>:
.globl vector165
vector165:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $165
  10244f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102454:	e9 38 04 00 00       	jmp    102891 <__alltraps>

00102459 <vector166>:
.globl vector166
vector166:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $166
  10245b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102460:	e9 2c 04 00 00       	jmp    102891 <__alltraps>

00102465 <vector167>:
.globl vector167
vector167:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $167
  102467:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10246c:	e9 20 04 00 00       	jmp    102891 <__alltraps>

00102471 <vector168>:
.globl vector168
vector168:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $168
  102473:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102478:	e9 14 04 00 00       	jmp    102891 <__alltraps>

0010247d <vector169>:
.globl vector169
vector169:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $169
  10247f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102484:	e9 08 04 00 00       	jmp    102891 <__alltraps>

00102489 <vector170>:
.globl vector170
vector170:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $170
  10248b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102490:	e9 fc 03 00 00       	jmp    102891 <__alltraps>

00102495 <vector171>:
.globl vector171
vector171:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $171
  102497:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10249c:	e9 f0 03 00 00       	jmp    102891 <__alltraps>

001024a1 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $172
  1024a3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024a8:	e9 e4 03 00 00       	jmp    102891 <__alltraps>

001024ad <vector173>:
.globl vector173
vector173:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $173
  1024af:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024b4:	e9 d8 03 00 00       	jmp    102891 <__alltraps>

001024b9 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $174
  1024bb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024c0:	e9 cc 03 00 00       	jmp    102891 <__alltraps>

001024c5 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $175
  1024c7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024cc:	e9 c0 03 00 00       	jmp    102891 <__alltraps>

001024d1 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $176
  1024d3:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024d8:	e9 b4 03 00 00       	jmp    102891 <__alltraps>

001024dd <vector177>:
.globl vector177
vector177:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $177
  1024df:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024e4:	e9 a8 03 00 00       	jmp    102891 <__alltraps>

001024e9 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $178
  1024eb:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024f0:	e9 9c 03 00 00       	jmp    102891 <__alltraps>

001024f5 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $179
  1024f7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024fc:	e9 90 03 00 00       	jmp    102891 <__alltraps>

00102501 <vector180>:
.globl vector180
vector180:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $180
  102503:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102508:	e9 84 03 00 00       	jmp    102891 <__alltraps>

0010250d <vector181>:
.globl vector181
vector181:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $181
  10250f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102514:	e9 78 03 00 00       	jmp    102891 <__alltraps>

00102519 <vector182>:
.globl vector182
vector182:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $182
  10251b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102520:	e9 6c 03 00 00       	jmp    102891 <__alltraps>

00102525 <vector183>:
.globl vector183
vector183:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $183
  102527:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10252c:	e9 60 03 00 00       	jmp    102891 <__alltraps>

00102531 <vector184>:
.globl vector184
vector184:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $184
  102533:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102538:	e9 54 03 00 00       	jmp    102891 <__alltraps>

0010253d <vector185>:
.globl vector185
vector185:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $185
  10253f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102544:	e9 48 03 00 00       	jmp    102891 <__alltraps>

00102549 <vector186>:
.globl vector186
vector186:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $186
  10254b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102550:	e9 3c 03 00 00       	jmp    102891 <__alltraps>

00102555 <vector187>:
.globl vector187
vector187:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $187
  102557:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10255c:	e9 30 03 00 00       	jmp    102891 <__alltraps>

00102561 <vector188>:
.globl vector188
vector188:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $188
  102563:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102568:	e9 24 03 00 00       	jmp    102891 <__alltraps>

0010256d <vector189>:
.globl vector189
vector189:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $189
  10256f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102574:	e9 18 03 00 00       	jmp    102891 <__alltraps>

00102579 <vector190>:
.globl vector190
vector190:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $190
  10257b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102580:	e9 0c 03 00 00       	jmp    102891 <__alltraps>

00102585 <vector191>:
.globl vector191
vector191:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $191
  102587:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10258c:	e9 00 03 00 00       	jmp    102891 <__alltraps>

00102591 <vector192>:
.globl vector192
vector192:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $192
  102593:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102598:	e9 f4 02 00 00       	jmp    102891 <__alltraps>

0010259d <vector193>:
.globl vector193
vector193:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $193
  10259f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025a4:	e9 e8 02 00 00       	jmp    102891 <__alltraps>

001025a9 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $194
  1025ab:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025b0:	e9 dc 02 00 00       	jmp    102891 <__alltraps>

001025b5 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $195
  1025b7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025bc:	e9 d0 02 00 00       	jmp    102891 <__alltraps>

001025c1 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $196
  1025c3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025c8:	e9 c4 02 00 00       	jmp    102891 <__alltraps>

001025cd <vector197>:
.globl vector197
vector197:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $197
  1025cf:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025d4:	e9 b8 02 00 00       	jmp    102891 <__alltraps>

001025d9 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $198
  1025db:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025e0:	e9 ac 02 00 00       	jmp    102891 <__alltraps>

001025e5 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $199
  1025e7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025ec:	e9 a0 02 00 00       	jmp    102891 <__alltraps>

001025f1 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $200
  1025f3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025f8:	e9 94 02 00 00       	jmp    102891 <__alltraps>

001025fd <vector201>:
.globl vector201
vector201:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $201
  1025ff:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102604:	e9 88 02 00 00       	jmp    102891 <__alltraps>

00102609 <vector202>:
.globl vector202
vector202:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $202
  10260b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102610:	e9 7c 02 00 00       	jmp    102891 <__alltraps>

00102615 <vector203>:
.globl vector203
vector203:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $203
  102617:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10261c:	e9 70 02 00 00       	jmp    102891 <__alltraps>

00102621 <vector204>:
.globl vector204
vector204:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $204
  102623:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102628:	e9 64 02 00 00       	jmp    102891 <__alltraps>

0010262d <vector205>:
.globl vector205
vector205:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $205
  10262f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102634:	e9 58 02 00 00       	jmp    102891 <__alltraps>

00102639 <vector206>:
.globl vector206
vector206:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $206
  10263b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102640:	e9 4c 02 00 00       	jmp    102891 <__alltraps>

00102645 <vector207>:
.globl vector207
vector207:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $207
  102647:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10264c:	e9 40 02 00 00       	jmp    102891 <__alltraps>

00102651 <vector208>:
.globl vector208
vector208:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $208
  102653:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102658:	e9 34 02 00 00       	jmp    102891 <__alltraps>

0010265d <vector209>:
.globl vector209
vector209:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $209
  10265f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102664:	e9 28 02 00 00       	jmp    102891 <__alltraps>

00102669 <vector210>:
.globl vector210
vector210:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $210
  10266b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102670:	e9 1c 02 00 00       	jmp    102891 <__alltraps>

00102675 <vector211>:
.globl vector211
vector211:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $211
  102677:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10267c:	e9 10 02 00 00       	jmp    102891 <__alltraps>

00102681 <vector212>:
.globl vector212
vector212:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $212
  102683:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102688:	e9 04 02 00 00       	jmp    102891 <__alltraps>

0010268d <vector213>:
.globl vector213
vector213:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $213
  10268f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102694:	e9 f8 01 00 00       	jmp    102891 <__alltraps>

00102699 <vector214>:
.globl vector214
vector214:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $214
  10269b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026a0:	e9 ec 01 00 00       	jmp    102891 <__alltraps>

001026a5 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $215
  1026a7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026ac:	e9 e0 01 00 00       	jmp    102891 <__alltraps>

001026b1 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $216
  1026b3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026b8:	e9 d4 01 00 00       	jmp    102891 <__alltraps>

001026bd <vector217>:
.globl vector217
vector217:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $217
  1026bf:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026c4:	e9 c8 01 00 00       	jmp    102891 <__alltraps>

001026c9 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $218
  1026cb:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026d0:	e9 bc 01 00 00       	jmp    102891 <__alltraps>

001026d5 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $219
  1026d7:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026dc:	e9 b0 01 00 00       	jmp    102891 <__alltraps>

001026e1 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $220
  1026e3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026e8:	e9 a4 01 00 00       	jmp    102891 <__alltraps>

001026ed <vector221>:
.globl vector221
vector221:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $221
  1026ef:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026f4:	e9 98 01 00 00       	jmp    102891 <__alltraps>

001026f9 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $222
  1026fb:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102700:	e9 8c 01 00 00       	jmp    102891 <__alltraps>

00102705 <vector223>:
.globl vector223
vector223:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $223
  102707:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10270c:	e9 80 01 00 00       	jmp    102891 <__alltraps>

00102711 <vector224>:
.globl vector224
vector224:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $224
  102713:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102718:	e9 74 01 00 00       	jmp    102891 <__alltraps>

0010271d <vector225>:
.globl vector225
vector225:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $225
  10271f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102724:	e9 68 01 00 00       	jmp    102891 <__alltraps>

00102729 <vector226>:
.globl vector226
vector226:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $226
  10272b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102730:	e9 5c 01 00 00       	jmp    102891 <__alltraps>

00102735 <vector227>:
.globl vector227
vector227:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $227
  102737:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10273c:	e9 50 01 00 00       	jmp    102891 <__alltraps>

00102741 <vector228>:
.globl vector228
vector228:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $228
  102743:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102748:	e9 44 01 00 00       	jmp    102891 <__alltraps>

0010274d <vector229>:
.globl vector229
vector229:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $229
  10274f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102754:	e9 38 01 00 00       	jmp    102891 <__alltraps>

00102759 <vector230>:
.globl vector230
vector230:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $230
  10275b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102760:	e9 2c 01 00 00       	jmp    102891 <__alltraps>

00102765 <vector231>:
.globl vector231
vector231:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $231
  102767:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10276c:	e9 20 01 00 00       	jmp    102891 <__alltraps>

00102771 <vector232>:
.globl vector232
vector232:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $232
  102773:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102778:	e9 14 01 00 00       	jmp    102891 <__alltraps>

0010277d <vector233>:
.globl vector233
vector233:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $233
  10277f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102784:	e9 08 01 00 00       	jmp    102891 <__alltraps>

00102789 <vector234>:
.globl vector234
vector234:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $234
  10278b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102790:	e9 fc 00 00 00       	jmp    102891 <__alltraps>

00102795 <vector235>:
.globl vector235
vector235:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $235
  102797:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10279c:	e9 f0 00 00 00       	jmp    102891 <__alltraps>

001027a1 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $236
  1027a3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027a8:	e9 e4 00 00 00       	jmp    102891 <__alltraps>

001027ad <vector237>:
.globl vector237
vector237:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $237
  1027af:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027b4:	e9 d8 00 00 00       	jmp    102891 <__alltraps>

001027b9 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $238
  1027bb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027c0:	e9 cc 00 00 00       	jmp    102891 <__alltraps>

001027c5 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $239
  1027c7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027cc:	e9 c0 00 00 00       	jmp    102891 <__alltraps>

001027d1 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $240
  1027d3:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027d8:	e9 b4 00 00 00       	jmp    102891 <__alltraps>

001027dd <vector241>:
.globl vector241
vector241:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $241
  1027df:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027e4:	e9 a8 00 00 00       	jmp    102891 <__alltraps>

001027e9 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $242
  1027eb:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027f0:	e9 9c 00 00 00       	jmp    102891 <__alltraps>

001027f5 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $243
  1027f7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027fc:	e9 90 00 00 00       	jmp    102891 <__alltraps>

00102801 <vector244>:
.globl vector244
vector244:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $244
  102803:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102808:	e9 84 00 00 00       	jmp    102891 <__alltraps>

0010280d <vector245>:
.globl vector245
vector245:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $245
  10280f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102814:	e9 78 00 00 00       	jmp    102891 <__alltraps>

00102819 <vector246>:
.globl vector246
vector246:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $246
  10281b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102820:	e9 6c 00 00 00       	jmp    102891 <__alltraps>

00102825 <vector247>:
.globl vector247
vector247:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $247
  102827:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10282c:	e9 60 00 00 00       	jmp    102891 <__alltraps>

00102831 <vector248>:
.globl vector248
vector248:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $248
  102833:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102838:	e9 54 00 00 00       	jmp    102891 <__alltraps>

0010283d <vector249>:
.globl vector249
vector249:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $249
  10283f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102844:	e9 48 00 00 00       	jmp    102891 <__alltraps>

00102849 <vector250>:
.globl vector250
vector250:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $250
  10284b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102850:	e9 3c 00 00 00       	jmp    102891 <__alltraps>

00102855 <vector251>:
.globl vector251
vector251:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $251
  102857:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10285c:	e9 30 00 00 00       	jmp    102891 <__alltraps>

00102861 <vector252>:
.globl vector252
vector252:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $252
  102863:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102868:	e9 24 00 00 00       	jmp    102891 <__alltraps>

0010286d <vector253>:
.globl vector253
vector253:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $253
  10286f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102874:	e9 18 00 00 00       	jmp    102891 <__alltraps>

00102879 <vector254>:
.globl vector254
vector254:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $254
  10287b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102880:	e9 0c 00 00 00       	jmp    102891 <__alltraps>

00102885 <vector255>:
.globl vector255
vector255:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $255
  102887:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10288c:	e9 00 00 00 00       	jmp    102891 <__alltraps>

00102891 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102891:	1e                   	push   %ds
    pushl %es
  102892:	06                   	push   %es
    pushl %fs
  102893:	0f a0                	push   %fs
    pushl %gs
  102895:	0f a8                	push   %gs
    pushal
  102897:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102898:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10289d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10289f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1028a1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1028a2:	e8 64 f5 ff ff       	call   101e0b <trap>

    # pop the pushed stack pointer
    popl %esp
  1028a7:	5c                   	pop    %esp

001028a8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1028a8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1028a9:	0f a9                	pop    %gs
    popl %fs
  1028ab:	0f a1                	pop    %fs
    popl %es
  1028ad:	07                   	pop    %es
    popl %ds
  1028ae:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1028af:	83 c4 08             	add    $0x8,%esp
    iret
  1028b2:	cf                   	iret   

001028b3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028b3:	55                   	push   %ebp
  1028b4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028bc:	b8 23 00 00 00       	mov    $0x23,%eax
  1028c1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028c3:	b8 23 00 00 00       	mov    $0x23,%eax
  1028c8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028ca:	b8 10 00 00 00       	mov    $0x10,%eax
  1028cf:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028d1:	b8 10 00 00 00       	mov    $0x10,%eax
  1028d6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028d8:	b8 10 00 00 00       	mov    $0x10,%eax
  1028dd:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028df:	ea e6 28 10 00 08 00 	ljmp   $0x8,$0x1028e6
}
  1028e6:	90                   	nop
  1028e7:	5d                   	pop    %ebp
  1028e8:	c3                   	ret    

001028e9 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028e9:	55                   	push   %ebp
  1028ea:	89 e5                	mov    %esp,%ebp
  1028ec:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1028ef:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1028f4:	05 00 04 00 00       	add    $0x400,%eax
  1028f9:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1028fe:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102905:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102907:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10290e:	68 00 
  102910:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102915:	0f b7 c0             	movzwl %ax,%eax
  102918:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10291e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102923:	c1 e8 10             	shr    $0x10,%eax
  102926:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10292b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102932:	24 f0                	and    $0xf0,%al
  102934:	0c 09                	or     $0x9,%al
  102936:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10293b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102942:	0c 10                	or     $0x10,%al
  102944:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102949:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102950:	24 9f                	and    $0x9f,%al
  102952:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102957:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10295e:	0c 80                	or     $0x80,%al
  102960:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102965:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10296c:	24 f0                	and    $0xf0,%al
  10296e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102973:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10297a:	24 ef                	and    $0xef,%al
  10297c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102981:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102988:	24 df                	and    $0xdf,%al
  10298a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10298f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102996:	0c 40                	or     $0x40,%al
  102998:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10299d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029a4:	24 7f                	and    $0x7f,%al
  1029a6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029ab:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b0:	c1 e8 18             	shr    $0x18,%eax
  1029b3:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1029b8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029bf:	24 ef                	and    $0xef,%al
  1029c1:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1029c6:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1029cd:	e8 e1 fe ff ff       	call   1028b3 <lgdt>
  1029d2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029d8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029dc:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029df:	90                   	nop
  1029e0:	c9                   	leave  
  1029e1:	c3                   	ret    

001029e2 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029e2:	55                   	push   %ebp
  1029e3:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1029e5:	e8 ff fe ff ff       	call   1028e9 <gdt_init>
}
  1029ea:	90                   	nop
  1029eb:	5d                   	pop    %ebp
  1029ec:	c3                   	ret    

001029ed <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1029ed:	55                   	push   %ebp
  1029ee:	89 e5                	mov    %esp,%ebp
  1029f0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1029f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1029fa:	eb 03                	jmp    1029ff <strlen+0x12>
        cnt ++;
  1029fc:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  102a02:	8d 50 01             	lea    0x1(%eax),%edx
  102a05:	89 55 08             	mov    %edx,0x8(%ebp)
  102a08:	0f b6 00             	movzbl (%eax),%eax
  102a0b:	84 c0                	test   %al,%al
  102a0d:	75 ed                	jne    1029fc <strlen+0xf>
    }
    return cnt;
  102a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a12:	c9                   	leave  
  102a13:	c3                   	ret    

00102a14 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a14:	55                   	push   %ebp
  102a15:	89 e5                	mov    %esp,%ebp
  102a17:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a21:	eb 03                	jmp    102a26 <strnlen+0x12>
        cnt ++;
  102a23:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a29:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102a2c:	73 10                	jae    102a3e <strnlen+0x2a>
  102a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a31:	8d 50 01             	lea    0x1(%eax),%edx
  102a34:	89 55 08             	mov    %edx,0x8(%ebp)
  102a37:	0f b6 00             	movzbl (%eax),%eax
  102a3a:	84 c0                	test   %al,%al
  102a3c:	75 e5                	jne    102a23 <strnlen+0xf>
    }
    return cnt;
  102a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a41:	c9                   	leave  
  102a42:	c3                   	ret    

00102a43 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102a43:	55                   	push   %ebp
  102a44:	89 e5                	mov    %esp,%ebp
  102a46:	57                   	push   %edi
  102a47:	56                   	push   %esi
  102a48:	83 ec 20             	sub    $0x20,%esp
  102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5d:	89 d1                	mov    %edx,%ecx
  102a5f:	89 c2                	mov    %eax,%edx
  102a61:	89 ce                	mov    %ecx,%esi
  102a63:	89 d7                	mov    %edx,%edi
  102a65:	ac                   	lods   %ds:(%esi),%al
  102a66:	aa                   	stos   %al,%es:(%edi)
  102a67:	84 c0                	test   %al,%al
  102a69:	75 fa                	jne    102a65 <strcpy+0x22>
  102a6b:	89 fa                	mov    %edi,%edx
  102a6d:	89 f1                	mov    %esi,%ecx
  102a6f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102a72:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102a7b:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102a7c:	83 c4 20             	add    $0x20,%esp
  102a7f:	5e                   	pop    %esi
  102a80:	5f                   	pop    %edi
  102a81:	5d                   	pop    %ebp
  102a82:	c3                   	ret    

00102a83 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102a83:	55                   	push   %ebp
  102a84:	89 e5                	mov    %esp,%ebp
  102a86:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102a89:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102a8f:	eb 1e                	jmp    102aaf <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a94:	0f b6 10             	movzbl (%eax),%edx
  102a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a9a:	88 10                	mov    %dl,(%eax)
  102a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a9f:	0f b6 00             	movzbl (%eax),%eax
  102aa2:	84 c0                	test   %al,%al
  102aa4:	74 03                	je     102aa9 <strncpy+0x26>
            src ++;
  102aa6:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102aa9:	ff 45 fc             	incl   -0x4(%ebp)
  102aac:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102aaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ab3:	75 dc                	jne    102a91 <strncpy+0xe>
    }
    return dst;
  102ab5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ab8:	c9                   	leave  
  102ab9:	c3                   	ret    

00102aba <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102aba:	55                   	push   %ebp
  102abb:	89 e5                	mov    %esp,%ebp
  102abd:	57                   	push   %edi
  102abe:	56                   	push   %esi
  102abf:	83 ec 20             	sub    $0x20,%esp
  102ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ad4:	89 d1                	mov    %edx,%ecx
  102ad6:	89 c2                	mov    %eax,%edx
  102ad8:	89 ce                	mov    %ecx,%esi
  102ada:	89 d7                	mov    %edx,%edi
  102adc:	ac                   	lods   %ds:(%esi),%al
  102add:	ae                   	scas   %es:(%edi),%al
  102ade:	75 08                	jne    102ae8 <strcmp+0x2e>
  102ae0:	84 c0                	test   %al,%al
  102ae2:	75 f8                	jne    102adc <strcmp+0x22>
  102ae4:	31 c0                	xor    %eax,%eax
  102ae6:	eb 04                	jmp    102aec <strcmp+0x32>
  102ae8:	19 c0                	sbb    %eax,%eax
  102aea:	0c 01                	or     $0x1,%al
  102aec:	89 fa                	mov    %edi,%edx
  102aee:	89 f1                	mov    %esi,%ecx
  102af0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102af3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102af6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102afc:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102afd:	83 c4 20             	add    $0x20,%esp
  102b00:	5e                   	pop    %esi
  102b01:	5f                   	pop    %edi
  102b02:	5d                   	pop    %ebp
  102b03:	c3                   	ret    

00102b04 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b04:	55                   	push   %ebp
  102b05:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b07:	eb 09                	jmp    102b12 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102b09:	ff 4d 10             	decl   0x10(%ebp)
  102b0c:	ff 45 08             	incl   0x8(%ebp)
  102b0f:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b16:	74 1a                	je     102b32 <strncmp+0x2e>
  102b18:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1b:	0f b6 00             	movzbl (%eax),%eax
  102b1e:	84 c0                	test   %al,%al
  102b20:	74 10                	je     102b32 <strncmp+0x2e>
  102b22:	8b 45 08             	mov    0x8(%ebp),%eax
  102b25:	0f b6 10             	movzbl (%eax),%edx
  102b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b2b:	0f b6 00             	movzbl (%eax),%eax
  102b2e:	38 c2                	cmp    %al,%dl
  102b30:	74 d7                	je     102b09 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b36:	74 18                	je     102b50 <strncmp+0x4c>
  102b38:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3b:	0f b6 00             	movzbl (%eax),%eax
  102b3e:	0f b6 d0             	movzbl %al,%edx
  102b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b44:	0f b6 00             	movzbl (%eax),%eax
  102b47:	0f b6 c0             	movzbl %al,%eax
  102b4a:	29 c2                	sub    %eax,%edx
  102b4c:	89 d0                	mov    %edx,%eax
  102b4e:	eb 05                	jmp    102b55 <strncmp+0x51>
  102b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b55:	5d                   	pop    %ebp
  102b56:	c3                   	ret    

00102b57 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102b57:	55                   	push   %ebp
  102b58:	89 e5                	mov    %esp,%ebp
  102b5a:	83 ec 04             	sub    $0x4,%esp
  102b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b60:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b63:	eb 13                	jmp    102b78 <strchr+0x21>
        if (*s == c) {
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	0f b6 00             	movzbl (%eax),%eax
  102b6b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102b6e:	75 05                	jne    102b75 <strchr+0x1e>
            return (char *)s;
  102b70:	8b 45 08             	mov    0x8(%ebp),%eax
  102b73:	eb 12                	jmp    102b87 <strchr+0x30>
        }
        s ++;
  102b75:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102b78:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7b:	0f b6 00             	movzbl (%eax),%eax
  102b7e:	84 c0                	test   %al,%al
  102b80:	75 e3                	jne    102b65 <strchr+0xe>
    }
    return NULL;
  102b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b87:	c9                   	leave  
  102b88:	c3                   	ret    

00102b89 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102b89:	55                   	push   %ebp
  102b8a:	89 e5                	mov    %esp,%ebp
  102b8c:	83 ec 04             	sub    $0x4,%esp
  102b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b92:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b95:	eb 0e                	jmp    102ba5 <strfind+0x1c>
        if (*s == c) {
  102b97:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9a:	0f b6 00             	movzbl (%eax),%eax
  102b9d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102ba0:	74 0f                	je     102bb1 <strfind+0x28>
            break;
        }
        s ++;
  102ba2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba8:	0f b6 00             	movzbl (%eax),%eax
  102bab:	84 c0                	test   %al,%al
  102bad:	75 e8                	jne    102b97 <strfind+0xe>
  102baf:	eb 01                	jmp    102bb2 <strfind+0x29>
            break;
  102bb1:	90                   	nop
    }
    return (char *)s;
  102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102bb5:	c9                   	leave  
  102bb6:	c3                   	ret    

00102bb7 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102bb7:	55                   	push   %ebp
  102bb8:	89 e5                	mov    %esp,%ebp
  102bba:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102bbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102bc4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102bcb:	eb 03                	jmp    102bd0 <strtol+0x19>
        s ++;
  102bcd:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd3:	0f b6 00             	movzbl (%eax),%eax
  102bd6:	3c 20                	cmp    $0x20,%al
  102bd8:	74 f3                	je     102bcd <strtol+0x16>
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	0f b6 00             	movzbl (%eax),%eax
  102be0:	3c 09                	cmp    $0x9,%al
  102be2:	74 e9                	je     102bcd <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	0f b6 00             	movzbl (%eax),%eax
  102bea:	3c 2b                	cmp    $0x2b,%al
  102bec:	75 05                	jne    102bf3 <strtol+0x3c>
        s ++;
  102bee:	ff 45 08             	incl   0x8(%ebp)
  102bf1:	eb 14                	jmp    102c07 <strtol+0x50>
    }
    else if (*s == '-') {
  102bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf6:	0f b6 00             	movzbl (%eax),%eax
  102bf9:	3c 2d                	cmp    $0x2d,%al
  102bfb:	75 0a                	jne    102c07 <strtol+0x50>
        s ++, neg = 1;
  102bfd:	ff 45 08             	incl   0x8(%ebp)
  102c00:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c0b:	74 06                	je     102c13 <strtol+0x5c>
  102c0d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102c11:	75 22                	jne    102c35 <strtol+0x7e>
  102c13:	8b 45 08             	mov    0x8(%ebp),%eax
  102c16:	0f b6 00             	movzbl (%eax),%eax
  102c19:	3c 30                	cmp    $0x30,%al
  102c1b:	75 18                	jne    102c35 <strtol+0x7e>
  102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c20:	40                   	inc    %eax
  102c21:	0f b6 00             	movzbl (%eax),%eax
  102c24:	3c 78                	cmp    $0x78,%al
  102c26:	75 0d                	jne    102c35 <strtol+0x7e>
        s += 2, base = 16;
  102c28:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102c2c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102c33:	eb 29                	jmp    102c5e <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c39:	75 16                	jne    102c51 <strtol+0x9a>
  102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3e:	0f b6 00             	movzbl (%eax),%eax
  102c41:	3c 30                	cmp    $0x30,%al
  102c43:	75 0c                	jne    102c51 <strtol+0x9a>
        s ++, base = 8;
  102c45:	ff 45 08             	incl   0x8(%ebp)
  102c48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102c4f:	eb 0d                	jmp    102c5e <strtol+0xa7>
    }
    else if (base == 0) {
  102c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c55:	75 07                	jne    102c5e <strtol+0xa7>
        base = 10;
  102c57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c61:	0f b6 00             	movzbl (%eax),%eax
  102c64:	3c 2f                	cmp    $0x2f,%al
  102c66:	7e 1b                	jle    102c83 <strtol+0xcc>
  102c68:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6b:	0f b6 00             	movzbl (%eax),%eax
  102c6e:	3c 39                	cmp    $0x39,%al
  102c70:	7f 11                	jg     102c83 <strtol+0xcc>
            dig = *s - '0';
  102c72:	8b 45 08             	mov    0x8(%ebp),%eax
  102c75:	0f b6 00             	movzbl (%eax),%eax
  102c78:	0f be c0             	movsbl %al,%eax
  102c7b:	83 e8 30             	sub    $0x30,%eax
  102c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c81:	eb 48                	jmp    102ccb <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102c83:	8b 45 08             	mov    0x8(%ebp),%eax
  102c86:	0f b6 00             	movzbl (%eax),%eax
  102c89:	3c 60                	cmp    $0x60,%al
  102c8b:	7e 1b                	jle    102ca8 <strtol+0xf1>
  102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c90:	0f b6 00             	movzbl (%eax),%eax
  102c93:	3c 7a                	cmp    $0x7a,%al
  102c95:	7f 11                	jg     102ca8 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	0f b6 00             	movzbl (%eax),%eax
  102c9d:	0f be c0             	movsbl %al,%eax
  102ca0:	83 e8 57             	sub    $0x57,%eax
  102ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca6:	eb 23                	jmp    102ccb <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cab:	0f b6 00             	movzbl (%eax),%eax
  102cae:	3c 40                	cmp    $0x40,%al
  102cb0:	7e 3b                	jle    102ced <strtol+0x136>
  102cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb5:	0f b6 00             	movzbl (%eax),%eax
  102cb8:	3c 5a                	cmp    $0x5a,%al
  102cba:	7f 31                	jg     102ced <strtol+0x136>
            dig = *s - 'A' + 10;
  102cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbf:	0f b6 00             	movzbl (%eax),%eax
  102cc2:	0f be c0             	movsbl %al,%eax
  102cc5:	83 e8 37             	sub    $0x37,%eax
  102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cce:	3b 45 10             	cmp    0x10(%ebp),%eax
  102cd1:	7d 19                	jge    102cec <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102cd3:	ff 45 08             	incl   0x8(%ebp)
  102cd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  102cdd:	89 c2                	mov    %eax,%edx
  102cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce2:	01 d0                	add    %edx,%eax
  102ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102ce7:	e9 72 ff ff ff       	jmp    102c5e <strtol+0xa7>
            break;
  102cec:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cf1:	74 08                	je     102cfb <strtol+0x144>
        *endptr = (char *) s;
  102cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  102cf9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102cfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102cff:	74 07                	je     102d08 <strtol+0x151>
  102d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d04:	f7 d8                	neg    %eax
  102d06:	eb 03                	jmp    102d0b <strtol+0x154>
  102d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102d0b:	c9                   	leave  
  102d0c:	c3                   	ret    

00102d0d <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102d0d:	55                   	push   %ebp
  102d0e:	89 e5                	mov    %esp,%ebp
  102d10:	57                   	push   %edi
  102d11:	83 ec 24             	sub    $0x24,%esp
  102d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d17:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102d1a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  102d21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102d24:	88 45 f7             	mov    %al,-0x9(%ebp)
  102d27:	8b 45 10             	mov    0x10(%ebp),%eax
  102d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102d2d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102d30:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102d34:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102d37:	89 d7                	mov    %edx,%edi
  102d39:	f3 aa                	rep stos %al,%es:(%edi)
  102d3b:	89 fa                	mov    %edi,%edx
  102d3d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d40:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102d43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d46:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102d47:	83 c4 24             	add    $0x24,%esp
  102d4a:	5f                   	pop    %edi
  102d4b:	5d                   	pop    %ebp
  102d4c:	c3                   	ret    

00102d4d <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102d4d:	55                   	push   %ebp
  102d4e:	89 e5                	mov    %esp,%ebp
  102d50:	57                   	push   %edi
  102d51:	56                   	push   %esi
  102d52:	53                   	push   %ebx
  102d53:	83 ec 30             	sub    $0x30,%esp
  102d56:	8b 45 08             	mov    0x8(%ebp),%eax
  102d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d62:	8b 45 10             	mov    0x10(%ebp),%eax
  102d65:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102d6e:	73 42                	jae    102db2 <memmove+0x65>
  102d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d79:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d85:	c1 e8 02             	shr    $0x2,%eax
  102d88:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102d8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d90:	89 d7                	mov    %edx,%edi
  102d92:	89 c6                	mov    %eax,%esi
  102d94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d96:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102d99:	83 e1 03             	and    $0x3,%ecx
  102d9c:	74 02                	je     102da0 <memmove+0x53>
  102d9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102da0:	89 f0                	mov    %esi,%eax
  102da2:	89 fa                	mov    %edi,%edx
  102da4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102da7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102daa:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102db0:	eb 36                	jmp    102de8 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dbb:	01 c2                	add    %eax,%edx
  102dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dc0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dcc:	89 c1                	mov    %eax,%ecx
  102dce:	89 d8                	mov    %ebx,%eax
  102dd0:	89 d6                	mov    %edx,%esi
  102dd2:	89 c7                	mov    %eax,%edi
  102dd4:	fd                   	std    
  102dd5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102dd7:	fc                   	cld    
  102dd8:	89 f8                	mov    %edi,%eax
  102dda:	89 f2                	mov    %esi,%edx
  102ddc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102ddf:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102de2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102de8:	83 c4 30             	add    $0x30,%esp
  102deb:	5b                   	pop    %ebx
  102dec:	5e                   	pop    %esi
  102ded:	5f                   	pop    %edi
  102dee:	5d                   	pop    %ebp
  102def:	c3                   	ret    

00102df0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102df0:	55                   	push   %ebp
  102df1:	89 e5                	mov    %esp,%ebp
  102df3:	57                   	push   %edi
  102df4:	56                   	push   %esi
  102df5:	83 ec 20             	sub    $0x20,%esp
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e04:	8b 45 10             	mov    0x10(%ebp),%eax
  102e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e0d:	c1 e8 02             	shr    $0x2,%eax
  102e10:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e18:	89 d7                	mov    %edx,%edi
  102e1a:	89 c6                	mov    %eax,%esi
  102e1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e1e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102e21:	83 e1 03             	and    $0x3,%ecx
  102e24:	74 02                	je     102e28 <memcpy+0x38>
  102e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e28:	89 f0                	mov    %esi,%eax
  102e2a:	89 fa                	mov    %edi,%edx
  102e2c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e2f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102e32:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102e38:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102e39:	83 c4 20             	add    $0x20,%esp
  102e3c:	5e                   	pop    %esi
  102e3d:	5f                   	pop    %edi
  102e3e:	5d                   	pop    %ebp
  102e3f:	c3                   	ret    

00102e40 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102e40:	55                   	push   %ebp
  102e41:	89 e5                	mov    %esp,%ebp
  102e43:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102e52:	eb 2e                	jmp    102e82 <memcmp+0x42>
        if (*s1 != *s2) {
  102e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e57:	0f b6 10             	movzbl (%eax),%edx
  102e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e5d:	0f b6 00             	movzbl (%eax),%eax
  102e60:	38 c2                	cmp    %al,%dl
  102e62:	74 18                	je     102e7c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e67:	0f b6 00             	movzbl (%eax),%eax
  102e6a:	0f b6 d0             	movzbl %al,%edx
  102e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e70:	0f b6 00             	movzbl (%eax),%eax
  102e73:	0f b6 c0             	movzbl %al,%eax
  102e76:	29 c2                	sub    %eax,%edx
  102e78:	89 d0                	mov    %edx,%eax
  102e7a:	eb 18                	jmp    102e94 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102e7c:	ff 45 fc             	incl   -0x4(%ebp)
  102e7f:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102e82:	8b 45 10             	mov    0x10(%ebp),%eax
  102e85:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e88:	89 55 10             	mov    %edx,0x10(%ebp)
  102e8b:	85 c0                	test   %eax,%eax
  102e8d:	75 c5                	jne    102e54 <memcmp+0x14>
    }
    return 0;
  102e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e94:	c9                   	leave  
  102e95:	c3                   	ret    

00102e96 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102e96:	55                   	push   %ebp
  102e97:	89 e5                	mov    %esp,%ebp
  102e99:	83 ec 58             	sub    $0x58,%esp
  102e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  102e9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ea2:	8b 45 14             	mov    0x14(%ebp),%eax
  102ea5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102ea8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102eab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102eae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102eb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102eb4:	8b 45 18             	mov    0x18(%ebp),%eax
  102eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ebd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ec0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ec3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ecc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ed0:	74 1c                	je     102eee <printnum+0x58>
  102ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  102eda:	f7 75 e4             	divl   -0x1c(%ebp)
  102edd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ee8:	f7 75 e4             	divl   -0x1c(%ebp)
  102eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ef4:	f7 75 e4             	divl   -0x1c(%ebp)
  102ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102efa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f03:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f06:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f0c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102f0f:	8b 45 18             	mov    0x18(%ebp),%eax
  102f12:	ba 00 00 00 00       	mov    $0x0,%edx
  102f17:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102f1a:	72 56                	jb     102f72 <printnum+0xdc>
  102f1c:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102f1f:	77 05                	ja     102f26 <printnum+0x90>
  102f21:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102f24:	72 4c                	jb     102f72 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102f26:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102f29:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f2c:	8b 45 20             	mov    0x20(%ebp),%eax
  102f2f:	89 44 24 18          	mov    %eax,0x18(%esp)
  102f33:	89 54 24 14          	mov    %edx,0x14(%esp)
  102f37:	8b 45 18             	mov    0x18(%ebp),%eax
  102f3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  102f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f44:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f48:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f53:	8b 45 08             	mov    0x8(%ebp),%eax
  102f56:	89 04 24             	mov    %eax,(%esp)
  102f59:	e8 38 ff ff ff       	call   102e96 <printnum>
  102f5e:	eb 1b                	jmp    102f7b <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f67:	8b 45 20             	mov    0x20(%ebp),%eax
  102f6a:	89 04 24             	mov    %eax,(%esp)
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	ff d0                	call   *%eax
        while (-- width > 0)
  102f72:	ff 4d 1c             	decl   0x1c(%ebp)
  102f75:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102f79:	7f e5                	jg     102f60 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102f7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f7e:	05 f0 3c 10 00       	add    $0x103cf0,%eax
  102f83:	0f b6 00             	movzbl (%eax),%eax
  102f86:	0f be c0             	movsbl %al,%eax
  102f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f90:	89 04 24             	mov    %eax,(%esp)
  102f93:	8b 45 08             	mov    0x8(%ebp),%eax
  102f96:	ff d0                	call   *%eax
}
  102f98:	90                   	nop
  102f99:	c9                   	leave  
  102f9a:	c3                   	ret    

00102f9b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102f9b:	55                   	push   %ebp
  102f9c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f9e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102fa2:	7e 14                	jle    102fb8 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa7:	8b 00                	mov    (%eax),%eax
  102fa9:	8d 48 08             	lea    0x8(%eax),%ecx
  102fac:	8b 55 08             	mov    0x8(%ebp),%edx
  102faf:	89 0a                	mov    %ecx,(%edx)
  102fb1:	8b 50 04             	mov    0x4(%eax),%edx
  102fb4:	8b 00                	mov    (%eax),%eax
  102fb6:	eb 30                	jmp    102fe8 <getuint+0x4d>
    }
    else if (lflag) {
  102fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102fbc:	74 16                	je     102fd4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc1:	8b 00                	mov    (%eax),%eax
  102fc3:	8d 48 04             	lea    0x4(%eax),%ecx
  102fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  102fc9:	89 0a                	mov    %ecx,(%edx)
  102fcb:	8b 00                	mov    (%eax),%eax
  102fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  102fd2:	eb 14                	jmp    102fe8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd7:	8b 00                	mov    (%eax),%eax
  102fd9:	8d 48 04             	lea    0x4(%eax),%ecx
  102fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  102fdf:	89 0a                	mov    %ecx,(%edx)
  102fe1:	8b 00                	mov    (%eax),%eax
  102fe3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102fe8:	5d                   	pop    %ebp
  102fe9:	c3                   	ret    

00102fea <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102fea:	55                   	push   %ebp
  102feb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102fed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ff1:	7e 14                	jle    103007 <getint+0x1d>
        return va_arg(*ap, long long);
  102ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff6:	8b 00                	mov    (%eax),%eax
  102ff8:	8d 48 08             	lea    0x8(%eax),%ecx
  102ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  102ffe:	89 0a                	mov    %ecx,(%edx)
  103000:	8b 50 04             	mov    0x4(%eax),%edx
  103003:	8b 00                	mov    (%eax),%eax
  103005:	eb 28                	jmp    10302f <getint+0x45>
    }
    else if (lflag) {
  103007:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10300b:	74 12                	je     10301f <getint+0x35>
        return va_arg(*ap, long);
  10300d:	8b 45 08             	mov    0x8(%ebp),%eax
  103010:	8b 00                	mov    (%eax),%eax
  103012:	8d 48 04             	lea    0x4(%eax),%ecx
  103015:	8b 55 08             	mov    0x8(%ebp),%edx
  103018:	89 0a                	mov    %ecx,(%edx)
  10301a:	8b 00                	mov    (%eax),%eax
  10301c:	99                   	cltd   
  10301d:	eb 10                	jmp    10302f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10301f:	8b 45 08             	mov    0x8(%ebp),%eax
  103022:	8b 00                	mov    (%eax),%eax
  103024:	8d 48 04             	lea    0x4(%eax),%ecx
  103027:	8b 55 08             	mov    0x8(%ebp),%edx
  10302a:	89 0a                	mov    %ecx,(%edx)
  10302c:	8b 00                	mov    (%eax),%eax
  10302e:	99                   	cltd   
    }
}
  10302f:	5d                   	pop    %ebp
  103030:	c3                   	ret    

00103031 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103031:	55                   	push   %ebp
  103032:	89 e5                	mov    %esp,%ebp
  103034:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103037:	8d 45 14             	lea    0x14(%ebp),%eax
  10303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103040:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103044:	8b 45 10             	mov    0x10(%ebp),%eax
  103047:	89 44 24 08          	mov    %eax,0x8(%esp)
  10304b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103052:	8b 45 08             	mov    0x8(%ebp),%eax
  103055:	89 04 24             	mov    %eax,(%esp)
  103058:	e8 03 00 00 00       	call   103060 <vprintfmt>
    va_end(ap);
}
  10305d:	90                   	nop
  10305e:	c9                   	leave  
  10305f:	c3                   	ret    

00103060 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103060:	55                   	push   %ebp
  103061:	89 e5                	mov    %esp,%ebp
  103063:	56                   	push   %esi
  103064:	53                   	push   %ebx
  103065:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103068:	eb 17                	jmp    103081 <vprintfmt+0x21>
            if (ch == '\0') {
  10306a:	85 db                	test   %ebx,%ebx
  10306c:	0f 84 bf 03 00 00    	je     103431 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  103072:	8b 45 0c             	mov    0xc(%ebp),%eax
  103075:	89 44 24 04          	mov    %eax,0x4(%esp)
  103079:	89 1c 24             	mov    %ebx,(%esp)
  10307c:	8b 45 08             	mov    0x8(%ebp),%eax
  10307f:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103081:	8b 45 10             	mov    0x10(%ebp),%eax
  103084:	8d 50 01             	lea    0x1(%eax),%edx
  103087:	89 55 10             	mov    %edx,0x10(%ebp)
  10308a:	0f b6 00             	movzbl (%eax),%eax
  10308d:	0f b6 d8             	movzbl %al,%ebx
  103090:	83 fb 25             	cmp    $0x25,%ebx
  103093:	75 d5                	jne    10306a <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103095:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103099:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1030a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1030b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b6:	8d 50 01             	lea    0x1(%eax),%edx
  1030b9:	89 55 10             	mov    %edx,0x10(%ebp)
  1030bc:	0f b6 00             	movzbl (%eax),%eax
  1030bf:	0f b6 d8             	movzbl %al,%ebx
  1030c2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1030c5:	83 f8 55             	cmp    $0x55,%eax
  1030c8:	0f 87 37 03 00 00    	ja     103405 <vprintfmt+0x3a5>
  1030ce:	8b 04 85 14 3d 10 00 	mov    0x103d14(,%eax,4),%eax
  1030d5:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1030d7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1030db:	eb d6                	jmp    1030b3 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1030dd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1030e1:	eb d0                	jmp    1030b3 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1030ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030ed:	89 d0                	mov    %edx,%eax
  1030ef:	c1 e0 02             	shl    $0x2,%eax
  1030f2:	01 d0                	add    %edx,%eax
  1030f4:	01 c0                	add    %eax,%eax
  1030f6:	01 d8                	add    %ebx,%eax
  1030f8:	83 e8 30             	sub    $0x30,%eax
  1030fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1030fe:	8b 45 10             	mov    0x10(%ebp),%eax
  103101:	0f b6 00             	movzbl (%eax),%eax
  103104:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103107:	83 fb 2f             	cmp    $0x2f,%ebx
  10310a:	7e 38                	jle    103144 <vprintfmt+0xe4>
  10310c:	83 fb 39             	cmp    $0x39,%ebx
  10310f:	7f 33                	jg     103144 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  103111:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103114:	eb d4                	jmp    1030ea <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103116:	8b 45 14             	mov    0x14(%ebp),%eax
  103119:	8d 50 04             	lea    0x4(%eax),%edx
  10311c:	89 55 14             	mov    %edx,0x14(%ebp)
  10311f:	8b 00                	mov    (%eax),%eax
  103121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103124:	eb 1f                	jmp    103145 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  103126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10312a:	79 87                	jns    1030b3 <vprintfmt+0x53>
                width = 0;
  10312c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103133:	e9 7b ff ff ff       	jmp    1030b3 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103138:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10313f:	e9 6f ff ff ff       	jmp    1030b3 <vprintfmt+0x53>
            goto process_precision;
  103144:	90                   	nop

        process_precision:
            if (width < 0)
  103145:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103149:	0f 89 64 ff ff ff    	jns    1030b3 <vprintfmt+0x53>
                width = precision, precision = -1;
  10314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103152:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103155:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10315c:	e9 52 ff ff ff       	jmp    1030b3 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103161:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103164:	e9 4a ff ff ff       	jmp    1030b3 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103169:	8b 45 14             	mov    0x14(%ebp),%eax
  10316c:	8d 50 04             	lea    0x4(%eax),%edx
  10316f:	89 55 14             	mov    %edx,0x14(%ebp)
  103172:	8b 00                	mov    (%eax),%eax
  103174:	8b 55 0c             	mov    0xc(%ebp),%edx
  103177:	89 54 24 04          	mov    %edx,0x4(%esp)
  10317b:	89 04 24             	mov    %eax,(%esp)
  10317e:	8b 45 08             	mov    0x8(%ebp),%eax
  103181:	ff d0                	call   *%eax
            break;
  103183:	e9 a4 02 00 00       	jmp    10342c <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103188:	8b 45 14             	mov    0x14(%ebp),%eax
  10318b:	8d 50 04             	lea    0x4(%eax),%edx
  10318e:	89 55 14             	mov    %edx,0x14(%ebp)
  103191:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103193:	85 db                	test   %ebx,%ebx
  103195:	79 02                	jns    103199 <vprintfmt+0x139>
                err = -err;
  103197:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103199:	83 fb 06             	cmp    $0x6,%ebx
  10319c:	7f 0b                	jg     1031a9 <vprintfmt+0x149>
  10319e:	8b 34 9d d4 3c 10 00 	mov    0x103cd4(,%ebx,4),%esi
  1031a5:	85 f6                	test   %esi,%esi
  1031a7:	75 23                	jne    1031cc <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1031a9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1031ad:	c7 44 24 08 01 3d 10 	movl   $0x103d01,0x8(%esp)
  1031b4:	00 
  1031b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bf:	89 04 24             	mov    %eax,(%esp)
  1031c2:	e8 6a fe ff ff       	call   103031 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1031c7:	e9 60 02 00 00       	jmp    10342c <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1031cc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1031d0:	c7 44 24 08 0a 3d 10 	movl   $0x103d0a,0x8(%esp)
  1031d7:	00 
  1031d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031df:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e2:	89 04 24             	mov    %eax,(%esp)
  1031e5:	e8 47 fe ff ff       	call   103031 <printfmt>
            break;
  1031ea:	e9 3d 02 00 00       	jmp    10342c <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1031ef:	8b 45 14             	mov    0x14(%ebp),%eax
  1031f2:	8d 50 04             	lea    0x4(%eax),%edx
  1031f5:	89 55 14             	mov    %edx,0x14(%ebp)
  1031f8:	8b 30                	mov    (%eax),%esi
  1031fa:	85 f6                	test   %esi,%esi
  1031fc:	75 05                	jne    103203 <vprintfmt+0x1a3>
                p = "(null)";
  1031fe:	be 0d 3d 10 00       	mov    $0x103d0d,%esi
            }
            if (width > 0 && padc != '-') {
  103203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103207:	7e 76                	jle    10327f <vprintfmt+0x21f>
  103209:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10320d:	74 70                	je     10327f <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103212:	89 44 24 04          	mov    %eax,0x4(%esp)
  103216:	89 34 24             	mov    %esi,(%esp)
  103219:	e8 f6 f7 ff ff       	call   102a14 <strnlen>
  10321e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103221:	29 c2                	sub    %eax,%edx
  103223:	89 d0                	mov    %edx,%eax
  103225:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103228:	eb 16                	jmp    103240 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10322a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10322e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103231:	89 54 24 04          	mov    %edx,0x4(%esp)
  103235:	89 04 24             	mov    %eax,(%esp)
  103238:	8b 45 08             	mov    0x8(%ebp),%eax
  10323b:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10323d:	ff 4d e8             	decl   -0x18(%ebp)
  103240:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103244:	7f e4                	jg     10322a <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103246:	eb 37                	jmp    10327f <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  103248:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10324c:	74 1f                	je     10326d <vprintfmt+0x20d>
  10324e:	83 fb 1f             	cmp    $0x1f,%ebx
  103251:	7e 05                	jle    103258 <vprintfmt+0x1f8>
  103253:	83 fb 7e             	cmp    $0x7e,%ebx
  103256:	7e 15                	jle    10326d <vprintfmt+0x20d>
                    putch('?', putdat);
  103258:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10325f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103266:	8b 45 08             	mov    0x8(%ebp),%eax
  103269:	ff d0                	call   *%eax
  10326b:	eb 0f                	jmp    10327c <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103270:	89 44 24 04          	mov    %eax,0x4(%esp)
  103274:	89 1c 24             	mov    %ebx,(%esp)
  103277:	8b 45 08             	mov    0x8(%ebp),%eax
  10327a:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10327c:	ff 4d e8             	decl   -0x18(%ebp)
  10327f:	89 f0                	mov    %esi,%eax
  103281:	8d 70 01             	lea    0x1(%eax),%esi
  103284:	0f b6 00             	movzbl (%eax),%eax
  103287:	0f be d8             	movsbl %al,%ebx
  10328a:	85 db                	test   %ebx,%ebx
  10328c:	74 27                	je     1032b5 <vprintfmt+0x255>
  10328e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103292:	78 b4                	js     103248 <vprintfmt+0x1e8>
  103294:	ff 4d e4             	decl   -0x1c(%ebp)
  103297:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10329b:	79 ab                	jns    103248 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  10329d:	eb 16                	jmp    1032b5 <vprintfmt+0x255>
                putch(' ', putdat);
  10329f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032a6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b0:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1032b2:	ff 4d e8             	decl   -0x18(%ebp)
  1032b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032b9:	7f e4                	jg     10329f <vprintfmt+0x23f>
            }
            break;
  1032bb:	e9 6c 01 00 00       	jmp    10342c <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1032c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032c7:	8d 45 14             	lea    0x14(%ebp),%eax
  1032ca:	89 04 24             	mov    %eax,(%esp)
  1032cd:	e8 18 fd ff ff       	call   102fea <getint>
  1032d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032de:	85 d2                	test   %edx,%edx
  1032e0:	79 26                	jns    103308 <vprintfmt+0x2a8>
                putch('-', putdat);
  1032e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032e9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f3:	ff d0                	call   *%eax
                num = -(long long)num;
  1032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032fb:	f7 d8                	neg    %eax
  1032fd:	83 d2 00             	adc    $0x0,%edx
  103300:	f7 da                	neg    %edx
  103302:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103305:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103308:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10330f:	e9 a8 00 00 00       	jmp    1033bc <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103317:	89 44 24 04          	mov    %eax,0x4(%esp)
  10331b:	8d 45 14             	lea    0x14(%ebp),%eax
  10331e:	89 04 24             	mov    %eax,(%esp)
  103321:	e8 75 fc ff ff       	call   102f9b <getuint>
  103326:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103329:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10332c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103333:	e9 84 00 00 00       	jmp    1033bc <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10333b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10333f:	8d 45 14             	lea    0x14(%ebp),%eax
  103342:	89 04 24             	mov    %eax,(%esp)
  103345:	e8 51 fc ff ff       	call   102f9b <getuint>
  10334a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10334d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103350:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103357:	eb 63                	jmp    1033bc <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103359:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103360:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103367:	8b 45 08             	mov    0x8(%ebp),%eax
  10336a:	ff d0                	call   *%eax
            putch('x', putdat);
  10336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103373:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10337a:	8b 45 08             	mov    0x8(%ebp),%eax
  10337d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10337f:	8b 45 14             	mov    0x14(%ebp),%eax
  103382:	8d 50 04             	lea    0x4(%eax),%edx
  103385:	89 55 14             	mov    %edx,0x14(%ebp)
  103388:	8b 00                	mov    (%eax),%eax
  10338a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103394:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10339b:	eb 1f                	jmp    1033bc <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10339d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033a4:	8d 45 14             	lea    0x14(%ebp),%eax
  1033a7:	89 04 24             	mov    %eax,(%esp)
  1033aa:	e8 ec fb ff ff       	call   102f9b <getuint>
  1033af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1033b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1033bc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033c3:	89 54 24 18          	mov    %edx,0x18(%esp)
  1033c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1033ca:	89 54 24 14          	mov    %edx,0x14(%esp)
  1033ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  1033d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1033e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ea:	89 04 24             	mov    %eax,(%esp)
  1033ed:	e8 a4 fa ff ff       	call   102e96 <printnum>
            break;
  1033f2:	eb 38                	jmp    10342c <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033fb:	89 1c 24             	mov    %ebx,(%esp)
  1033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103401:	ff d0                	call   *%eax
            break;
  103403:	eb 27                	jmp    10342c <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103405:	8b 45 0c             	mov    0xc(%ebp),%eax
  103408:	89 44 24 04          	mov    %eax,0x4(%esp)
  10340c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103413:	8b 45 08             	mov    0x8(%ebp),%eax
  103416:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103418:	ff 4d 10             	decl   0x10(%ebp)
  10341b:	eb 03                	jmp    103420 <vprintfmt+0x3c0>
  10341d:	ff 4d 10             	decl   0x10(%ebp)
  103420:	8b 45 10             	mov    0x10(%ebp),%eax
  103423:	48                   	dec    %eax
  103424:	0f b6 00             	movzbl (%eax),%eax
  103427:	3c 25                	cmp    $0x25,%al
  103429:	75 f2                	jne    10341d <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  10342b:	90                   	nop
    while (1) {
  10342c:	e9 37 fc ff ff       	jmp    103068 <vprintfmt+0x8>
                return;
  103431:	90                   	nop
        }
    }
}
  103432:	83 c4 40             	add    $0x40,%esp
  103435:	5b                   	pop    %ebx
  103436:	5e                   	pop    %esi
  103437:	5d                   	pop    %ebp
  103438:	c3                   	ret    

00103439 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103439:	55                   	push   %ebp
  10343a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10343c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343f:	8b 40 08             	mov    0x8(%eax),%eax
  103442:	8d 50 01             	lea    0x1(%eax),%edx
  103445:	8b 45 0c             	mov    0xc(%ebp),%eax
  103448:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10344b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10344e:	8b 10                	mov    (%eax),%edx
  103450:	8b 45 0c             	mov    0xc(%ebp),%eax
  103453:	8b 40 04             	mov    0x4(%eax),%eax
  103456:	39 c2                	cmp    %eax,%edx
  103458:	73 12                	jae    10346c <sprintputch+0x33>
        *b->buf ++ = ch;
  10345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345d:	8b 00                	mov    (%eax),%eax
  10345f:	8d 48 01             	lea    0x1(%eax),%ecx
  103462:	8b 55 0c             	mov    0xc(%ebp),%edx
  103465:	89 0a                	mov    %ecx,(%edx)
  103467:	8b 55 08             	mov    0x8(%ebp),%edx
  10346a:	88 10                	mov    %dl,(%eax)
    }
}
  10346c:	90                   	nop
  10346d:	5d                   	pop    %ebp
  10346e:	c3                   	ret    

0010346f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10346f:	55                   	push   %ebp
  103470:	89 e5                	mov    %esp,%ebp
  103472:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103475:	8d 45 14             	lea    0x14(%ebp),%eax
  103478:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10347b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10347e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103482:	8b 45 10             	mov    0x10(%ebp),%eax
  103485:	89 44 24 08          	mov    %eax,0x8(%esp)
  103489:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103490:	8b 45 08             	mov    0x8(%ebp),%eax
  103493:	89 04 24             	mov    %eax,(%esp)
  103496:	e8 08 00 00 00       	call   1034a3 <vsnprintf>
  10349b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034a1:	c9                   	leave  
  1034a2:	c3                   	ret    

001034a3 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1034a3:	55                   	push   %ebp
  1034a4:	89 e5                	mov    %esp,%ebp
  1034a6:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b8:	01 d0                	add    %edx,%eax
  1034ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1034c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1034c8:	74 0a                	je     1034d4 <vsnprintf+0x31>
  1034ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1034cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034d0:	39 c2                	cmp    %eax,%edx
  1034d2:	76 07                	jbe    1034db <vsnprintf+0x38>
        return -E_INVAL;
  1034d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1034d9:	eb 2a                	jmp    103505 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1034db:	8b 45 14             	mov    0x14(%ebp),%eax
  1034de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1034e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1034ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f0:	c7 04 24 39 34 10 00 	movl   $0x103439,(%esp)
  1034f7:	e8 64 fb ff ff       	call   103060 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1034fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ff:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103502:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103505:	c9                   	leave  
  103506:	c3                   	ret    

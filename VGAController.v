`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data, 
	input up, input down, input left, input right);
	
//start mayari's code
wire mywritedata;
wire [7:0] mytx;
assign mywritedata = 1'b0;
assign mytx = 8'b0;
wire myreaddata;
wire [7:0] myrx;
wire [7:0] asciidat;
//reg [7:0] extramyrx;
wire spritedat ;
wire [17:0] spritesadd; 
reg [6:0] asciiadd;
wire [12:0] rel_off;

Ps2Interface my_interface (.ps2_clk(ps2_clk), .ps2_data(ps2_data), .clk(clk), .rst(reset), .tx_data(mytx), .write_data(mywritedata),
                            .read_data(myreaddata), .rx_data(myrx) );
                         
                   
    reg [7:0] asciidat0, asciidat1, asciidat2, asciidat3, asciidat4, asciidat5, asciidat6, asciidat7, asciidat8, asciidat9,
    asciidat10, asciidat11, asciidat12, asciidat13, asciidat14, asciidat15, asciidat16, asciidat17, asciidat18, asciidat19,
    asciidat20, asciidat21, asciidat22, asciidat23, asciidat24, asciidat25, asciidat26, asciidat27, asciidat28, asciidat29;
    
    wire [12:0] cur_rel_off, rel_off0, rel_off1, rel_off2, rel_off3, rel_off4, rel_off5, rel_off6, rel_off7, rel_off8, rel_off9, rel_off10, rel_off11, rel_off12, rel_off13, rel_off14, rel_off15, rel_off16,
                rel_off17, rel_off18, rel_off19, rel_off20, rel_off21, rel_off22, rel_off23, rel_off24, rel_off25, rel_off26, rel_off27, rel_off28, rel_off29;
//    assign spritesadd = (asciidat - 33)*2500 + cur_rel_off;
    reg [4:0] counter;
   
    reg [29:0] hasbeenwritten;
    
    integer j;
    
    wire [31:0] randomnumber;
    wire [39:0] word, wo;
    register40 guessword(.out(word), .clk(clk), .ie(counter==0), .indata(wo), .clr(1'b0));
    
    counterz count(.out(randomnumber), .clock(clk), .reset(1'b0));
    
//    lfsr randomnum(.clock(clk), .reset(counter==30), .rnd(randomnumber));
    
    RAM #(		
		.DEPTH(16), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(40),      // Set data width according to the color palette
		.ADDRESS_WIDTH(4),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "words.mem"})) 	 // Memory initialization
	Words(
		.clk(clk), 						 		 // Falling edge of the 100 MHz clk
		.addr(randomnumber[3:0]),					 	 // Image data address
		.dataOut(wo),				 	 // Color palette address
		.wEn(1'b0));
    
    Wrapper wrap(.clock(clk), .reset(counter==30), .corr0(word[39:32]), .corr1(word[31:24]), .corr2(word[23:16]), .corr3(word[15:8]), .corr4(word[7:0]), 
					.guess0(g0), .guess1(g1), .guess2(g2), .guess3(g3), .guess4(g4), 
					.color0(clr0), .color1(clr1), .color2(clr2), .color3(clr3), .color4(clr4), .rdy(dataready), .counter(counter));
    
    wire dataready;
    wire [11:0] clr0, clr1, clr2, clr3, clr4;
    wire [11:0] c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22,
    c23, c24, c25, c26, c27, c28, c29;
    wire [7:0] g0, g1, g2, g3, g4;
    assign g0 = (counter < 5) ? asciidat0 : (counter>=5 && counter<10) ? asciidat5 : (counter>=10 && counter<15) ? 
        asciidat10 : (counter>=15 && counter<20) ? asciidat15 : (counter>=20 && counter < 25) ? asciidat20 : asciidat25;
    assign g1 = (counter < 5) ? asciidat1 : (counter>=5 && counter<10) ? asciidat6 : (counter>=10 && counter<15) ? 
        asciidat11 : (counter>=15 && counter<20) ? asciidat16 : (counter>=20 && counter < 25) ? asciidat21 : asciidat26;
    assign g2 = (counter < 5) ? asciidat2 : (counter>=5 && counter<10) ? asciidat7 : (counter>=10 && counter<15) ? 
        asciidat12 : (counter>=15 && counter<20) ? asciidat17 : (counter>=20 && counter < 25) ? asciidat22 : asciidat27;
    assign g3 = (counter < 5) ? asciidat3 : (counter>=5 && counter<10) ? asciidat8 : (counter>=10 && counter<15) ? 
        asciidat13 : (counter>=15 && counter<20) ? asciidat18 : (counter>=20 && counter < 25) ? asciidat23 : asciidat28;
    assign g4 = (counter < 5) ? asciidat4 : (counter>=5 && counter<10) ? asciidat9 : (counter>=10 && counter<15) ? 
        asciidat14 : (counter>=15 && counter<20) ? asciidat19 : (counter>=20 && counter < 25) ? asciidat24 : asciidat29;
                        
    register r0(.out(c0), .clk(clk), .ie(counter==4), .indata(clr0), .clr(1'b0));
    register r1(.out(c1), .clk(clk), .ie(counter==4), .indata(clr1), .clr(1'b0));
    register r2(.out(c2), .clk(clk), .ie(counter==4), .indata(clr2), .clr(1'b0));
    register r3(.out(c3), .clk(clk), .ie(counter==4), .indata(clr3), .clr(1'b0));
    register r4(.out(c4), .clk(clk), .ie(counter==4), .indata(clr4), .clr(1'b0));
    register r5(.out(c5), .clk(clk), .ie(counter==9), .indata(clr0), .clr(1'b0));
    register r6(.out(c6), .clk(clk), .ie(counter==9), .indata(clr1), .clr(1'b0));
    register r7(.out(c7), .clk(clk), .ie(counter==9), .indata(clr2), .clr(1'b0));
    register r8(.out(c8), .clk(clk), .ie(counter==9), .indata(clr3), .clr(1'b0));
    register r9(.out(c9), .clk(clk), .ie(counter==9), .indata(clr4), .clr(1'b0));
    register r10(.out(c10), .clk(clk), .ie(counter==14), .indata(clr0), .clr(1'b0));
    register r11(.out(c11), .clk(clk), .ie(counter==14), .indata(clr1), .clr(1'b0));
    register r12(.out(c12), .clk(clk), .ie(counter==14), .indata(clr2), .clr(1'b0));
    register r13(.out(c13), .clk(clk), .ie(counter==14), .indata(clr3), .clr(1'b0));
    register r14(.out(c14), .clk(clk), .ie(counter==14), .indata(clr4), .clr(1'b0));
    register r15(.out(c15), .clk(clk), .ie(counter==19), .indata(clr0), .clr(1'b0));
    register r16(.out(c16), .clk(clk), .ie(counter==19), .indata(clr1), .clr(1'b0));
    register r17(.out(c17), .clk(clk), .ie(counter==19), .indata(clr2), .clr(1'b0));
    register r18(.out(c18), .clk(clk), .ie(counter==19), .indata(clr3), .clr(1'b0));
    register r19(.out(c19), .clk(clk), .ie(counter==19), .indata(clr4), .clr(1'b0));
    register r20(.out(c20), .clk(clk), .ie(counter==24), .indata(clr0), .clr(1'b0));
    register r21(.out(c21), .clk(clk), .ie(counter==24), .indata(clr1), .clr(1'b0));
    register r22(.out(c22), .clk(clk), .ie(counter==24), .indata(clr2), .clr(1'b0));
    register r23(.out(c23), .clk(clk), .ie(counter==24), .indata(clr3), .clr(1'b0));
    register r24(.out(c24), .clk(clk), .ie(counter==24), .indata(clr4), .clr(1'b0));
    register r25(.out(c25), .clk(clk), .ie(counter==29), .indata(clr0), .clr(1'b0));
    register r26(.out(c26), .clk(clk), .ie(counter==29), .indata(clr1), .clr(1'b0));
    register r27(.out(c27), .clk(clk), .ie(counter==29), .indata(clr2), .clr(1'b0));
    register r28(.out(c28), .clk(clk), .ie(counter==29), .indata(clr3), .clr(1'b0));
    register r29(.out(c29), .clk(clk), .ie(counter==29), .indata(clr4), .clr(1'b0));
    
           
always@(posedge myreaddata) 
begin

    if (hasbeenwritten[counter] ==0) begin
        j = j + 1; 
        asciiadd <= myrx;
        hasbeenwritten[counter] <=1;
    end 

    if (myrx === 8'hf0) begin 
        counter <= counter + 1;     
    end
    
end
    wire [11:0] clrdat0;
	wire [11:0] sprdat, sprdat0, sprdat1, sprdat2, sprdat3, sprdat4, sprdat5, sprdat6, sprdat7, sprdat8, sprdat9, sprdat10, sprdat11, sprdat12, sprdat13,
	sprdat14, sprdat15, sprdat16, sprdat17, sprdat18, sprdat19, sprdat20, sprdat21, sprdat22, sprdat23, sprdat24, sprdat25, sprdat26, sprdat27, sprdat28, sprdat29;
//	assign sprdat = spritedat ? 12'hfff : 12'b0;
	assign sprdat0 = spritedat ? 12'hfff : c0;
	assign sprdat1 = spritedat ? 12'hfff : c1;
	assign sprdat2 = spritedat ? 12'hfff : c2;
	assign sprdat3 = spritedat ? 12'hfff : c3;
	assign sprdat4 = spritedat ? 12'hfff : c4;
	assign sprdat5 = spritedat ? 12'hfff : c5;
	assign sprdat6 = spritedat ? 12'hfff : c6;
	assign sprdat7 = spritedat ? 12'hfff : c7;
	assign sprdat8 = spritedat ? 12'hfff : c8;
	assign sprdat9 = spritedat ? 12'hfff : c9;
	assign sprdat10 = spritedat ? 12'hfff : c10;
	assign sprdat11 = spritedat ? 12'hfff : c11;
	assign sprdat12 = spritedat ? 12'hfff : c12;
	assign sprdat13 = spritedat ? 12'hfff : c13;
	assign sprdat14 = spritedat ? 12'hfff : c14;
	assign sprdat15 = spritedat ? 12'hfff : c15;
	assign sprdat16 = spritedat ? 12'hfff : c16;
	assign sprdat17 = spritedat ? 12'hfff : c17;
	assign sprdat18 = spritedat ? 12'hfff : c18;
	assign sprdat19 = spritedat ? 12'hfff : c19;
	assign sprdat20 = spritedat ? 12'hfff : c20;
	assign sprdat21 = spritedat ? 12'hfff : c21;
	assign sprdat22 = spritedat ? 12'hfff : c22;
	assign sprdat23 = spritedat ? 12'hfff : c23;
	assign sprdat24 = spritedat ? 12'hfff : c24;
	assign sprdat25 = spritedat ? 12'hfff : c25;
	assign sprdat26 = spritedat ? 12'hfff : c26;
	assign sprdat27 = spritedat ? 12'hfff : c27;
	assign sprdat28 = spritedat ? 12'hfff : c28;
	assign sprdat29 = spritedat ? 12'hfff : c29;
	
    
    integer i;
    
    reg [17:0] spradd;

always@(posedge clk)
begin        

    if(counter ==0) begin asciidat0 <= asciidat; end
    else if(counter ==1) begin asciidat1 <= asciidat; end
    else if(counter ==2) begin asciidat2 <= asciidat; end
    else if(counter ==3) begin asciidat3 <= asciidat; end
    else if(counter ==4) begin asciidat4 <= asciidat; end
    else if(counter ==5) begin asciidat5 <= asciidat; end
    else if(counter ==6) begin asciidat6 <= asciidat; end
    else if(counter ==7) begin asciidat7 <= asciidat; end
    else if(counter ==8) begin asciidat8 <= asciidat; end
    else if(counter ==9) begin asciidat9 <= asciidat; end
    else if(counter ==10) begin asciidat10 <= asciidat; end
    else if(counter ==11) begin asciidat11 <= asciidat; end
    else if(counter ==12) begin asciidat12 <= asciidat; end
    else if(counter ==13) begin asciidat13 <= asciidat; end
    else if(counter ==14) begin asciidat14 <= asciidat; end
    else if(counter ==15) begin asciidat15 <= asciidat; end
    else if(counter ==16) begin asciidat16 <= asciidat; end
    else if(counter ==17) begin asciidat17 <= asciidat; end
    else if(counter ==18) begin asciidat18 <= asciidat; end
    else if(counter ==19) begin asciidat19 <= asciidat; end
    else if(counter ==20) begin asciidat20 <= asciidat; end
    else if(counter ==21) begin asciidat21 <= asciidat; end
    else if(counter ==22) begin asciidat22 <= asciidat; end
    else if(counter ==23) begin asciidat23 <= asciidat; end
    else if(counter ==24) begin asciidat24 <= asciidat; end
    else if(counter ==25) begin asciidat25 <= asciidat; end
    else if(counter ==26) begin asciidat26 <= asciidat; end
    else if(counter ==27) begin asciidat27 <= asciidat; end
    else if(counter ==28) begin asciidat28 <= asciidat; end
    else if(counter ==29) begin asciidat29 <= asciidat; end 
   
    if(inSquare[0]) spradd <= (asciidat0 - 33)*2500 + rel_off0;
    if(inSquare[1]) spradd <= (asciidat1 - 33)*2500 + rel_off1;
    if(inSquare[2]) spradd <= (asciidat2 - 33)*2500 + rel_off2;
    if(inSquare[3]) spradd <= (asciidat3 - 33)*2500 + rel_off3;
    if(inSquare[4]) spradd <= (asciidat4 - 33)*2500 + rel_off4;
    if(inSquare[5]) spradd <= (asciidat5 - 33)*2500 + rel_off5;
    if(inSquare[6]) spradd <= (asciidat6 - 33)*2500 + rel_off6;
    if(inSquare[7]) spradd <= (asciidat7 - 33)*2500 + rel_off7;
    if(inSquare[8]) spradd <= (asciidat8 - 33)*2500 + rel_off8;
    if(inSquare[9]) spradd <= (asciidat9 - 33)*2500 + rel_off9;
    if(inSquare[10]) spradd <= (asciidat10 - 33)*2500 + rel_off10;
    if(inSquare[11]) spradd <= (asciidat11 - 33)*2500 + rel_off11;
    if(inSquare[12]) spradd <= (asciidat12 - 33)*2500 + rel_off12;
    if(inSquare[13]) spradd <= (asciidat13 - 33)*2500 + rel_off13;
    if(inSquare[14]) spradd <= (asciidat14 - 33)*2500 + rel_off14;
    if(inSquare[15]) spradd <= (asciidat15 - 33)*2500 + rel_off15;
    if(inSquare[16]) spradd <= (asciidat16 - 33)*2500 + rel_off16;
    if(inSquare[17]) spradd <= (asciidat17 - 33)*2500 + rel_off17;
    if(inSquare[18]) spradd <= (asciidat18 - 33)*2500 + rel_off18;
    if(inSquare[19]) spradd <= (asciidat19 - 33)*2500 + rel_off19;
    if(inSquare[20]) spradd <= (asciidat20 - 33)*2500 + rel_off20;
    if(inSquare[21]) spradd <= (asciidat21 - 33)*2500 + rel_off21;
    if(inSquare[22]) spradd <= (asciidat22 - 33)*2500 + rel_off22;
    if(inSquare[23]) spradd <= (asciidat23 - 33)*2500 + rel_off23;
    if(inSquare[24]) spradd <= (asciidat24 - 33)*2500 + rel_off24;
    if(inSquare[25]) spradd <= (asciidat25 - 33)*2500 + rel_off25;
    if(inSquare[26]) spradd <= (asciidat26 - 33)*2500 + rel_off26;
    if(inSquare[27]) spradd <= (asciidat27 - 33)*2500 + rel_off27;
    if(inSquare[28]) spradd <= (asciidat28 - 33)*2500 + rel_off28;
    if(inSquare[29]) spradd <= (asciidat29 - 33)*2500 + rel_off29;

end
    
    assign spritesadd = spradd;

//    wire [31:0] drool_in;
//	assign drool_in = {20'b0, sprdat};
	
//    assign drool_en = (myrx != 8'hf0) && myreaddata;
    
//    wire [11:0] r0, r1, r2, r3, r4, r5;
    

	RAM #(		
		.DEPTH(235000), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(18),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "sprites.mem"})) 	 // Memory initialization
	Sprites_Data(
		.clk(clk), 						 		 // Falling edge of the 100 MHz clk
		.addr(spritesadd),					 	 // Image data address
		.dataOut(spritedat),				 	 // Color palette address
		.wEn(1'b0)); 	

	RAM #(		
		.DEPTH(256), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(7),      // Set data width according to the color palette
		.ADDRESS_WIDTH(8),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "ascii.mem"})) 	 // Memory initialization
	ASCII_Data(
		.clk(clk), 						 		 // Falling edge of the 100 MHz clk
		.addr(asciiadd),					 	 // Image data address
		.dataOut(asciidat),				 	 // Color palette address
		.wEn(1'b0)); 
	
	
	
	// Lab Memory Files Location
	localparam FILES_PATH = "D:/lab-5---vga-team-39-main/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      		// Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; 		// Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; 	// Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	
    initial begin 
        hasbeenwritten =0;
        counter = -1;
//        othercolor = 12'h5ff;
        asciidat0 = 45; asciidat1 = 45; asciidat2 = 45; asciidat3 =45; asciidat4=45; asciidat5=45; asciidat6=45; asciidat7=45;
        asciidat8=45; asciidat9=45; asciidat10=45; asciidat11=45; asciidat12=45; asciidat13 =45; asciidat14=45; asciidat15=45;
        asciidat16=45; asciidat17=45; asciidat18=45; asciidat19=45; asciidat20=45; asciidat21=45; asciidat22=45; asciidat23=45;
        asciidat24=45; asciidat25=45; asciidat26=45; asciidat27=45; asciidat28=45; asciidat29=45;
    end
    
    always@(posedge screenEnd) begin

        
    end
	wire [29:0] inSquare;
	//assign inSquare = (x>= xRefr && x <=xRefr + 50 && y>= yRefr && y<= yRefr + 50);
	assign inSquare[0] = (x>=100 && x<=150 && y>=50 && y<=110);   assign   rel_off0 = (x-100) + (y - 50)*50;                            
	assign inSquare[1] = (x>=175 && x<=225 && y>=50 && y<=110);   assign   rel_off1 = (x-175) + (y - 50)*50;
	assign inSquare[2] = (x>=250 && x<=300 && y>=50 && y<=110);   assign   rel_off2 = (x-250) + (y - 50)*50;
	assign inSquare[3] = (x>=325 && x<=375 && y>=50 && y<=110);   assign   rel_off3 = (x-325) + (y - 50)*50;
	assign inSquare[4] = (x>=400 && x<=450 && y>=50 && y<=110);   assign   rel_off4 = (x-400) + (y - 50)*50;

	assign inSquare[5] = (x>=100 && x<=150 && y>=125 && y<=185);   assign   rel_off5 = (x-100) + (y - 125)*50;
	assign inSquare[6] = (x>=175 && x<=225 && y>=125 && y<=185);   assign   rel_off6 = (x-175) + (y - 125)*50;
    assign inSquare[7] = (x>=250 && x<=300 && y>=125 && y<=185);   assign   rel_off7 = (x-250) + (y - 125)*50;
	assign inSquare[8] = (x>=325 && x<=375 && y>=125 && y<=185);   assign   rel_off8 = (x-325) + (y - 125)*50;
	assign inSquare[9] = (x>=400 && x<=450 && y>=125 && y<=185);   assign   rel_off9 = (x-400) + (y - 125)*50;
	
	assign inSquare[10] = (x>=100 && x<=150 && y>=200 && y<=260);    assign   rel_off10 = (x-100) + (y - 200)*50;
	assign inSquare[11] = (x>=175 && x<=225 && y>=200 && y<=260);   assign   rel_off11 = (x-175) + (y - 200)*50;
	assign inSquare[12] = (x>=250 && x<=300 && y>=200 && y<=260);   assign   rel_off12 = (x-250) + (y - 200)*50;
	assign inSquare[13] = (x>=325 && x<=375 && y>=200 && y<=260);   assign   rel_off13 = (x-325) + (y - 200)*50;
	assign inSquare[14] = (x>=400 && x<=450 && y>=200 && y<=260);   assign   rel_off14 = (x-400) + (y - 200)*50;
	
    assign inSquare[15] = (x>=100 && x<=150 && y>=275 && y<=335);   assign   rel_off15 = (x-100) + (y - 275)*50;
	assign inSquare[16] = (x>=175 && x<=225 && y>=275 && y<=335);   assign   rel_off16 = (x-175) + (y - 275)*50;
    assign inSquare[17] = (x>=250 && x<=300 && y>=275 && y<=335);   assign   rel_off17 = (x-250) + (y - 275)*50;
	assign inSquare[18] = (x>=325 && x<=375 && y>=275 && y<=335);   assign   rel_off18 = (x-325) + (y - 275)*50;
	assign inSquare[19] = (x>=400 && x<=450 && y>=275 && y<=335);   assign   rel_off19 = (x-400) + (y - 275)*50;
	
	assign inSquare[20] = (x>=100 && x<=150 && y>=350 && y<=410);    assign   rel_off20 = (x-100) + (y - 350)*50;
	assign inSquare[21] = (x>=175 && x<=225 && y>=350 && y<=410);   assign   rel_off21 = (x-175) + (y - 350)*50;
	assign inSquare[22] = (x>=250 && x<=300 && y>=350 && y<=410);   assign   rel_off22 = (x-250) + (y - 350)*50;
	assign inSquare[23] = (x>=325 && x<=375 && y>=350 && y<=410);   assign   rel_off23 = (x-325) + (y - 350)*50;
	assign inSquare[24] = (x>=400 && x<=450 && y>=350 && y<=410);   assign   rel_off24 = (x-400) + (y - 350)*50;
	
    assign inSquare[25] = (x>=100 && x<=150 && y>=425 && y<=485);   assign   rel_off25 = (x-100) + (y - 425)*50;
	assign inSquare[26] = (x>=175 && x<=225 && y>=425 && y<=485);   assign   rel_off26 = (x-175) + (y - 425)*50;
    assign inSquare[27] = (x>=250 && x<=300 && y>=425 && y<=485);   assign   rel_off27 = (x-250) + (y - 425)*50;
	assign inSquare[28] = (x>=325 && x<=375 && y>=425 && y<=485);   assign   rel_off28 = (x-325) + (y - 425)*50;
	assign inSquare[29] = (x>=400 && x<=450 && y>=425 && y<=485);   assign   rel_off29 = (x-400) + (y - 425)*50;
	
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) 	 // Memory initialization
	ImageData(
		.clk(clk), 						 		 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 	 // Image data address
		.dataOut(colorAddr),				 	 // Color palette address
		.wEn(1'b0)); 						 	 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  	   // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	///////////////////////////////////////////////////////////////
	// Edit this line to add something over the background image //
	///////////////////////////////////////////////////////////////
	
//	reg [BITS_PER_COLOR-1:0] myCTD;
//	assign colorToDisplay = myCTD;
	
	wire[BITS_PER_COLOR-1:0] colorToDisplay;
	
	// create a bus (reg) for each square every time a key gets pressed. 
	// starts at spritesadd and goes to 2500 after spritesadd. this bus will only have 1's and 0's.
	// if it's a 1, colortodisplay becomes white and if it's a 0, colortodisplay becomes black
	
	assign colorToDisplay = inSquare[0] ? sprdat0 : inSquare[1] ? sprdat1 : inSquare[2] ? sprdat2 : inSquare[3] ? sprdat3 : inSquare[4] ? sprdat4
	   : inSquare[5] ? sprdat5 : inSquare[6] ? sprdat6 : inSquare[7] ? sprdat7 : inSquare[8] ? sprdat8 : inSquare[9] ? sprdat9 
	   : inSquare[10] ? sprdat10 : inSquare[11] ? sprdat11 : inSquare[12] ? sprdat12 : inSquare[13] ? sprdat13 : inSquare[14] ? sprdat14 
	   : inSquare[15] ? sprdat15 : inSquare[16] ? sprdat16 : inSquare[17] ? sprdat17 : inSquare[18] ? sprdat18 : inSquare[19] ? sprdat19 
	   : inSquare[20] ? sprdat20 : inSquare[21] ? sprdat21 : inSquare[22] ? sprdat22 : inSquare[23] ? sprdat23 : inSquare[24] ? sprdat24 
	   : inSquare[25] ? sprdat25 : inSquare[26] ? sprdat26 : inSquare[27] ? sprdat27 : inSquare[28] ? sprdat28 : inSquare[29] ? sprdat29 : colorData;  

//    assign colorToDisplay = (~|inSquare) ? colorData : sprdat;

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] signalOut; 			  // Output color 
	assign signalOut = active ? colorToDisplay : 12'd0; // When not active, output black //DO NOT MODIFY!!!

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = signalOut;
	
	
	
	
endmodule

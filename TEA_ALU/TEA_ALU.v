module TEA_ALU (
                input E_D, readyBit,
                input [7:0] Key0, Key1, Key2, Key3, //4 8-Bit Key Values as input
                input [7:0] V0, V1, //2 8-Bit V values as input for
                output reg [7:0] aluResult0, aluResult1
                );

  reg [7:0] delta = 8'hB7; //Delta as shown in project instructions
  reg [7:0] temp_v0, temp_v1, sum;
  integer i;


  always @(posedge readyBit) begin

      if(E_D == 0) begin //Case if Encrypt
        temp_v0 = V0;
    	  temp_v1 = V1;
    	  sum = 0;

        for(i = 0; i < 32; i = i + 1) begin
          sum = sum + delta;
          temp_v0 = temp_v0 + ((temp_v1 << 4) + Key0) ^ (temp_v1 + sum) ^ ((temp_v1 >> 5) + Key1);
          temp_v1 = temp_v1 + ((temp_v0 << 4) + Key2) ^ (temp_v0 + sum) ^ ((temp_v0 >> 5) + Key3);
          end

	      aluResult0 = temp_v0;
   	    aluResult1 = temp_v1;
        end //End Case if Encrypt

      if (E_D == 1) begin //Case if Decrypt
        temp_v0 = V0;
        temp_v1 = V1;
        sum = 8'hE0;

        for(i = 0; i < 32; i = i + 1) begin
          sum = sum + delta;
          temp_v0 = temp_v0 + ((temp_v1 << 4) + Key0) ^ (temp_v1 + sum) ^ ((temp_v1 >> 5) + Key1); //EDIT THIS
          temp_v1 = temp_v1 + ((temp_v0 << 4) + Key2) ^ (temp_v0 + sum) ^ ((temp_v0 >> 5) + Key3); //EDIT THIS
          end
        aluResult0 = temp_v0;
     	  aluResult1 = temp_v1;
        end //End case if Decrypt
   end

endmodule

**********************
*  Output of h5dump  *
**********************

HDF5 "h5ex_t_bitatt_F03.h5" {
GROUP "/" {
   DATASET "DS1" {
      DATATYPE  H5T_STD_I32LE
      DATASPACE  NULL
      DATA {
      }
      ATTRIBUTE "A1" {
         DATATYPE  H5T_STD_B8BE
         DATASPACE  SIMPLE { ( 7, 4 ) / ( 7, 4 ) }
         DATA {
         (0,0): 0x00, 0x44, 0x88, 0xcc,
         (1,0): 0x53, 0x94, 0xd9, 0x1e,
         (2,0): 0xa2, 0xe4, 0x2a, 0x6c,
         (3,0): 0xf1, 0x34, 0x7b, 0xbe,
         (4,0): 0x00, 0x44, 0x88, 0xcc,
         (5,0): 0x53, 0x94, 0xd9, 0x1e,
         (6,0): 0xa2, 0xe4, 0x2a, 0x6c
         }
      }
   }
}
}
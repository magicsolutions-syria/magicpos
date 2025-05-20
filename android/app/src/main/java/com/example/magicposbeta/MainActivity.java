package com.example.magicposbeta;


import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.ImageDecoder;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.util.ArrayMap;

import androidx.annotation.NonNull;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.szsicod.print.escpos.PrinterAPI;
import com.szsicod.print.log.Logger;
import com.szsicod.print.utils.BitmapUtils;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "IcodPrinter";
    private UsbEndpoint endpoint;

    private ArrayList<String> devices;
    private  ArrayMap<String,UsbDevice> printersMap = new ArrayMap<>();
    private  ArrayMap<String, UsbDeviceConnection> connectedPrinters = new ArrayMap<>();
    private static final String ACTION_USB_PERMISSION =
            "com.example.magicposbeta1.USB_PERMISSION";
    private final BroadcastReceiver usbReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (ACTION_USB_PERMISSION.equals(action)) {
                synchronized(this) {
                    UsbDevice device = (UsbDevice)intent.getParcelableExtra("device");
                    if (intent.getBooleanExtra("permission", false)) {
                        System.out.println("success");
                    } else {
                        System.out.println("not success");

                    }
                }
            }

        }
    };
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "print":
                                    ArrayList<String> text = call.arguments();
                                    try {
                                        assert text != null;
                                        String printer = getPrinterPort(text.get(1));
                                        print(text.get(0), printer,false,false);
                                        result.success(null);
                                    } catch (IOException e) {
                                        result.error("",e.toString(),null);
                                    } catch (Exception e) {
                                        result.error("404",e.toString(),null);

                                    }
                                    break;
                                case "printAndCut":
                                    text = call.arguments();
                                    try {
                                        assert text != null;
                                        String printer = getPrinterPort(text.get(1));
                                        System.out.println("00000000000000000000");
                                        System.out.println(printer);
                                        System.out.println("00000000000000000000");
                                        print(text.get(0), printer,true,true);
                                        result.success(null);
                                    } catch (IOException e) {
                                        result.error("",e.toString(),null);

                                    } catch (Exception e) {
                                        result.error("404",e.toString(),null);

                                    }
                                    break;
                                case "getUsbDevices":
                                    devices = getUsbDevices();

                                    result.success(devices);
                                    break;
                                case "linkPrinters":
                                    ArrayList<String> linkDevices = call.arguments();
                                    ArrayList<String> linkedPorts = new ArrayList<String>();
                                    for(int i = 0; i< Objects.requireNonNull(linkDevices).size(); i++){
                                        String s = linkDevices.get(i);
                                        s = getPrinterPort(s);
                                        linkedPorts.add(s);
                                    }
                                    System.out.println(linkedPorts);
                                    linkPrinters(linkedPorts);
                                    result.success(null);
                                    break;
                                case "printHeader":
                                    ArrayList<String> header = call.arguments();
                                    System.out.println(header);
                                    assert header != null;
                                    String headerPrinter = getPrinterPort(header.get(1));
                                    System.out.println(headerPrinter);

                                    try {
                                        printHeader(header.get(0),headerPrinter,false);
                                        result.success(null);
                                    } catch (IOException e) {
                                        result.error("error:",e.toString(),null);
                                    } catch (Exception e) {
                                        result.error("404",e.toString(),null);

                                    }
                                    break;
                                case "printHeaderWithCut":
                                    header = call.arguments();
                                    assert header != null;
                                    headerPrinter = getPrinterPort(header.get(1));
                                    try {
                                        printHeader(header.get(0),headerPrinter,true);
                                        result.success(null);
                                    } catch (Exception e) {
                                        result.error("error:",e.toString(),null);
                                    }
                                    break;
                                case "printLogo":
                                    String printerName = call.arguments();
                                if(printerName!=null){
                                    printerName = getPrinterPort(printerName);
                                }
                                    try {
                                        printLogo(printerName);
                                    } catch (Exception e) {
                                        result.error("404",e.toString(),null);

                                    }
                                    break;
                                case "createCopy":
                                    String path = call.arguments();
                                    try {
                                        createCopy(path);
                                        result.success(null);

                                    } catch (IOException e) {
                                        throw new RuntimeException(e);
                                    }
                                    break;
                                case "connect":
                                    String printer = call.arguments();
                                    if(printer!=null){
                                        printer = getPrinterPort(printer);
                                    }
                                    try{
                                        if(!Objects.equals(printer, null)){
                                            connect(printer);
                                            result.success(null);

                                        }else{
                                            System.out.println("connect");
                                                connect();
                                                result.success(null);

                                        }
                                    }catch (Exception e){
                                        result.error("404",e.toString(),null);
                                    }
                                    break;
                                case "printQrCode":
                                    text = call.arguments();
                                if(text!=null){
                                    printer = getPrinterPort(text.get(1));
                                    try {
                                        printQrCode(text.get(0), printer);
                                    } catch (Exception e) {
                                        result.error("404",e.toString(),null);

                                    }
                                }
                                    break;
                                case "openCash":
                                    openCash();
                                    result.success(null);
                                    break;
                                case "disconnect":
                                    disconnect();
                                    result.success(null);
                                    break;
                                case "isConnect":
                                    boolean isCon = isConnect();
                                    result.success(isCon);
                                default:
                                    result.notImplemented();
                                    break;

                            }
                        }

                );
    }
    private static Runnable runnable;
    private void disconnect(){
        for (Map.Entry<String, UsbDeviceConnection> set :
                connectedPrinters.entrySet()) {
            if(set.getValue()!=null){
                set.getValue().close();
                connectedPrinters.remove(set.getKey());
            }
            else{
                connectedPrinters.remove(set.getKey());
            }
        }
    }

    private boolean isConnect(){
        return false;
    }
    private void connect() throws Exception {
        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
        HashMap<String, UsbDevice> deviceList = manager.getDeviceList();
        int i =0;
        System.out.println(i);

        for (Map.Entry<String, UsbDevice> set :
                printersMap.entrySet()) {

            System.out.println(i);
            i++;
        }
        System.out.println(i);

        for (Map.Entry<String, UsbDevice> set :
                printersMap.entrySet()) {
            System.out.println(set.getKey());
            PendingIntent permissionIntent = PendingIntent.getBroadcast(MainActivity.this, 0, new Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE);
            UsbDevice usbDevice = set.getValue();
            if(!deviceList.containsValue(set.getValue())){
                throw new Exception("printer at the port: "+set.getKey()+" is not found");
            }
            IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
            filter.setPriority(Integer.MAX_VALUE);
            MainActivity.this.registerReceiver(usbReceiver, filter);
            boolean unRegister = false;
            if (!manager.hasPermission(usbDevice)) {

                manager.requestPermission(usbDevice, permissionIntent);
                int num = 0;

                while(!manager.hasPermission(usbDevice)) {
                    try {
                        if (11 == num) {
                            return ;
                        }

                        ++num;
                        if (num % 2 == 0) {
                            MainActivity.this.unregisterReceiver(usbReceiver);
                            unRegister = true;
                            Thread.sleep(1000L);
                            if (manager.hasPermission(usbDevice)) {
                                System.out.println("connected");
                                break;
                            }

                            MainActivity.this.registerReceiver(usbReceiver, filter);
                            manager.requestPermission(usbDevice, permissionIntent);
                            unRegister = false;
                        }


                    } catch (InterruptedException var5) {
                        var5.printStackTrace();
                    }
                }
            }
            connectedPrinters.put(set.getKey(),manager.openDevice(usbDevice));
            if(manager.openDevice(usbDevice)!=null){
                System.out.println("connected successfully");
            }

        }
        System.out.println(connectedPrinters);



    }
    private void connect(String printerName){

        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);

            PendingIntent permissionIntent = PendingIntent.getBroadcast(MainActivity.this, 0, new Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE);
            UsbDevice usbDevice = printersMap.get(printerName);
            IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
            filter.setPriority(Integer.MAX_VALUE);
            MainActivity.this.registerReceiver(usbReceiver, filter);
            boolean unRegister = false;
            if (!manager.hasPermission(usbDevice)) {

                manager.requestPermission(usbDevice, permissionIntent);
                int num = 0;

                while(!manager.hasPermission(usbDevice)) {
                    try {
                        if (11 == num) {
                            return ;
                        }

                        ++num;
                        if (num % 2 == 0) {
                            MainActivity.this.unregisterReceiver(usbReceiver);
                            unRegister = true;
                            Thread.sleep(1000L);
                            if (manager.hasPermission(usbDevice)) {
                                System.out.println("connected");
                                break;
                            }

                            MainActivity.this.registerReceiver(usbReceiver, filter);
                            manager.requestPermission(usbDevice, permissionIntent);
                            unRegister = false;
                        }


                    } catch (InterruptedException var5) {
                        var5.printStackTrace();
                    }
                }
            }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            assert usbDevice != null;
            connectedPrinters.put(usbDevice.getProductName(),manager.openDevice(usbDevice));
        }
        if(manager.openDevice(usbDevice)!=null){
                System.out.println("connected successfully");
            }

        System.out.println(connectedPrinters);



    }
    private void printQrCode(String text, String printerName) throws Exception {
        UsbDeviceConnection usbDeviceConnection = setPrinter(printerName);
        MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
        try {
            BitMatrix bitMatrix = multiFormatWriter.encode(text,BarcodeFormat.QR_CODE,100,100);
            int width = bitMatrix.getWidth();
            int height = bitMatrix.getHeight();
            int [] pixels = new int[width*height];
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    if (bitMatrix.get(x, y)) {
                        pixels[y * width + x] = 0xff000000;
                        System.out.println(1);
                    } else {
                        pixels[y * width + x] = 0xffffffff;
                        System.out.println(2);
                    }
                }
            }
            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            bitmap.setPixels(pixels, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());

            try{

                setAlignMode(1,usbDeviceConnection);
                int length = 0;
                byte[] bytes;
                bytes = BitmapUtils.parseBmpToByte(bitmap);
                length = bytes.length;
                int timeOut = bitmap.getHeight() * bitmap.getWidth();
                int success = usbWrite(bytes, 0, length, timeOut,usbDeviceConnection);
                setAlignMode(0,usbDeviceConnection);
            }catch (Exception e)
            {
                e.printStackTrace();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @SuppressLint("SdCardPath")
    private void printLogo(String printerName) throws Exception {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            System.out.println("started");
            File f= new File("/data/user/0/com.example.magicposbeta1/logo.jpg");

            ImageDecoder.Source source = ImageDecoder.createSource(f);

            ImageDecoder.OnHeaderDecodedListener listener = (decoder, info, source1) -> decoder.setTargetSampleSize(2);
            Bitmap bitmap1 = ImageDecoder.decodeBitmap(source,listener).copy(Bitmap.Config.ARGB_8888, true);

            if(bitmap1.getWidth()>300||bitmap1.getHeight()>300){

                ImageDecoder.OnHeaderDecodedListener listener1 = new ImageDecoder.OnHeaderDecodedListener() {
                    @Override
                    public void onHeaderDecoded(@NonNull ImageDecoder decoder, @NonNull ImageDecoder.ImageInfo info, @NonNull ImageDecoder.Source source) {
                        decoder.setTargetSize(300,300);
                    }
                };

                bitmap1 = ImageDecoder.decodeBitmap(source,listener1).copy(Bitmap.Config.ARGB_8888, true);
            }
            int [] pixels1 = new int[bitmap1.getHeight()*bitmap1.getWidth()];
            bitmap1.getPixels(pixels1,0,bitmap1.getWidth(),0,0,bitmap1.getWidth(),bitmap1.getHeight());
            for (int i =0;i<pixels1.length;i++) {
                if(pixels1[i] <= Color.CYAN){
                    pixels1[i] = Color.BLACK;
                }
            }
            bitmap1.setPixels(pixels1,0,bitmap1.getWidth(),0,0,bitmap1.getWidth(),bitmap1.getHeight());
            System.out.println("------------------------------");
            Bitmap finalBitmap = bitmap1;
            runnable=new Runnable() {
                final UsbDeviceConnection usbDeviceConnection = setPrinter(printerName);

                @Override
                public void run() {
                    setAlignMode(1,usbDeviceConnection);
                    int length = 0;
                    byte[] bytes;
                    bytes = BitmapUtils.parseBmpToByte(finalBitmap);
                    length = bytes.length;
                    int timeOut = finalBitmap.getHeight() * finalBitmap.getWidth();
                    int success = usbWrite(bytes, 0, length, timeOut,usbDeviceConnection);
                    setAlignMode(0,usbDeviceConnection);

                }
        };
        new Thread(runnable).start();
            System.out.println("finish");
        }
        return;
    }

    private void print(String text) throws Exception {
        print(text,"Icod_Thermal_Printer",true,true);
    }
    private void printHeader(String text,String printerName,boolean withCut) throws Exception {
        UsbDeviceConnection connection = setPrinter(printerName);

        System.out.println("alignmode1");

        setAlignMode(1,connection);
        System.out.println("alignmode1");

        print(text,printerName,true,withCut);
        setAlignMode(0,connection);
    }
    private void print(String text,String printerName,boolean feed,boolean cut) throws Exception {

        int TIMEOUT = 10;
        System.out.println();
        runnable=new Runnable() {
            final UsbDeviceConnection connection = setPrinter(printerName);



            @Override
            public void run() {
                System.out.println("printing");
                System.out.println(printerName);
                System.out.println(connection);

                byte[] newBytes3 = new byte[]{27 ,64} ;
                usbWrite(newBytes3,0,newBytes3.length,TIMEOUT,connection);

                byte[] newBytes2 ;
                newBytes2 = new byte[]{27, 't', 63};
                usbWrite(newBytes2,0,newBytes2.length,TIMEOUT,connection);
                byte[] b = encode(text);
                usbWrite(b,0,b.length,TIMEOUT,connection);
                if(feed){
                    byte[] mCmd = new byte[3];
                    mCmd[0] = 27;
                    mCmd[1] = 100;
                    mCmd[2] = (byte)4;
                    usbWrite(mCmd,0,3,TIMEOUT,connection);
                }

                System.out.println("cutting");
                System.out.println(printerName);
                System.out.println(connection);
                if(cut){
                    byte[] mCmd = new byte[2];

                    mCmd[0] = 27;
                    mCmd[1] = 109;
                    usbWrite(mCmd, 0, 2, 2000,connection);
                }
            }
        };
        new Thread(runnable).start();


    }
    private void setAlignMode(int type,UsbDeviceConnection connection){
        byte[] mCmd = new byte[3];
        mCmd[0] = 27;
        mCmd[1] = 97;
        mCmd[2] = (byte)type;
        usbWrite(mCmd,0,mCmd.length,10,connection);
    }
    private byte[] encode(String text){
        byte[] bb=new byte[text.length()];
        int ll=text.length();
        for (int i=0;i<ll;i++){
            switch (text.charAt(i) ){
                case 'ا':{
                    if(text.charAt(i+1)=='ل'){
                        {bb[i]=(byte)0x9E;i++;break;}
                    }
                    else {
                        if (charCaseS(text, i, ll)) {
                            bb[i] = (byte) 0xC7;
                        } else {
                            bb[i] = (byte) 0xA8;
                        }  }                    break;}
                case 'ب':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xA9; }else{ bb[i]=(byte)0xC8;  } break;}
                case 'ت':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xAA; }else{ bb[i]=(byte)0xCA;  } break;}
                case 'ث':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xAB; }else{ bb[i]=(byte)0xCB;  } break;}
                case 'ج':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xAD; }else{ bb[i]=(byte)0xCC;  }  break;}
                case 'ح':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xAE; }else{ bb[i]=(byte)0xCD;  } break;}
                case 'خ':{ if(charCase2(text,i,ll)){bb[i]=(byte)0xAF; }else{ bb[i]=(byte)0xCE;  }break;}
                case 'د':{  bb[i]=(byte)0xCF; break;}
                case 'ذ':{bb[i]=(byte)0xD0; break;}
                case 'ر':{ bb[i]=(byte)0xD1; break;}
                case 'ز':{ bb[i]=(byte)0xD2; break;}
                case 'س':{if(charCase2(text,i,ll)){bb[i]=(byte)0xBC; }else{ bb[i]=(byte)0xD3;  }break;}
                case 'ش':{if(charCase2(text,i,ll)){bb[i]=(byte)0xBD; }else{ bb[i]=(byte)0xD4;  } break;}
                case 'ص':{if(charCase2(text,i,ll)){bb[i]=(byte)0xBE; }else{ bb[i]=(byte)0xD5;  }break;}
                case 'ض':{if(charCase2(text,i,ll)){bb[i]=(byte)0xEB; }else{ bb[i]=(byte)0xD6;  }break;}
                case 'ط':{bb[i]=(byte)0xD7;break;}
                case 'ظ':{bb[i]=(byte)0xD8;break;}
                case 'ع':{int n=charCase4(text,i,ll);switch (n){
                    case 1:{bb[i]=(byte)0xD9;break;} case 2:{bb[i]=(byte)0xEC;break;} case 3:{bb[i]=(byte)0xC5;break;} default:{bb[i]=(byte)0xDF;break;}}  break;}
                case 'غ':{int n=charCase4(text,i,ll);switch (n){
                    case 1:{bb[i]=(byte)0xDA;break;} case 2:{bb[i]=(byte)0xF7;break;} case 3:{bb[i]=(byte)0xED;break;} default:{bb[i]=(byte)0xEE;break;}}  break;}
                case 'ف':{if(charCase2(text,i,ll)){bb[i]=(byte)0xBA; }else{ bb[i]=(byte)0xE1;  } break;}
                case 'ق':{if(charCase2(text,i,ll)){bb[i]=(byte)0xF8; }else{ bb[i]=(byte)0xE2;  } break;}
                case 'ك':{if(charCase2(text,i,ll)){bb[i]=(byte)0xFC; }else{ bb[i]=(byte)0xE3;  }break;}
                case 'ل':{if(charCase2(text,i,ll)){bb[i]=(byte)0xFB; }else{ bb[i]=(byte)0xE4;}break;}
                case 'م':{if(charCase2(text,i,ll)){bb[i]=(byte)0xEF; }else{ bb[i]=(byte)0xE5;  }break;}
                case 'ن':{if(charCase2(text,i,ll)){bb[i]=(byte)0xF2; }else{ bb[i]=(byte)0xE6;  }break;}
                case 'ه':{int n=charCase4(text,i,ll);switch (n){
                    case 1:{bb[i]=(byte)0xE7;break;} case 2:{bb[i]=(byte)0xF4;break;}  default:{bb[i]=(byte)0xF3;break;}}  break;}
                case 'و':{bb[i]=(byte)0xE8;break;}
                case 'ي':{int n=charCase4(text,i,ll);switch (n){
                    case 0:{bb[i]=(byte)0xFD;break;} case 3:{bb[i]=(byte)0xF6;break;}  default:{bb[i]=(byte)0xEA;break;}}  break;}
                case 'ء':{bb[i]=(byte)0xC1;break;}
                case 'أ':
                case 'إ': {
                    if(text.charAt(i+1)=='ل'){
                        {bb[i]=(byte)0x9A;i++;break;}
                    }
                    else {
                        if (charCaseS(text, i, ll)) {
                            bb[i] = (byte) 0xC3;
                        } else {
                            bb[i] = (byte) 0xA5;
                        }  }                    break;}
                case 'آ':{
                    if(text.charAt(i+1)=='ل'){
                        {bb[i]=(byte)0xFA;i++;break;}
                    }
                    else {
                        if (charCaseS(text, i, ll)) {
                            bb[i] = (byte) 0xC2;
                        } else {
                            bb[i] = (byte) 0xA2;
                        }  }                    break;}
                case 'ة':{bb[i]=(byte)0xC9;break;}
                case 'ئ':{bb[i]=(byte)0xC6;break;}
                case 'ؤ':{bb[i]=(byte)0xC4;break;}
                case 'ى':{if(charCase2(text,i,ll)){bb[i]=(byte)0xE9; }else{ bb[i]=(byte)0xF5;  }break;}
                case '١':{bb[i]=(byte)0xB1; break;}
                case '٢':{bb[i]=(byte)0xB2; break;}
                case '٣':{bb[i]=(byte)0xB3; break;}
                case '٤':{bb[i]=(byte)0xB4; break;}
                case '٥':{bb[i]=(byte)0xB5; break;}
                case '٦':{bb[i]=(byte)0xB6; break;}
                case '٧':{bb[i]=(byte)0xB7; break;}
                case '٨':{bb[i]=(byte)0xB8; break;}
                case '٩':{bb[i]=(byte)0xB9; break;}
                case '٠':{bb[i]=(byte)0xB0; break;}
                default:{bb[i]=(byte)text.charAt(i);break;}
            }

        }

        return bb;
    }

    boolean charCaseS(String s,int i,int length){
        int n=charCase4(s,i,length);
        return n==0||n==1;
    }

    char[] chars = {'ا','ة','د','ذ','ر','ز','و','ء','ؤ','ى','آ','أ','\n'};
    private  boolean charCase2(String s,int i,int length){
        if(length==1)return true;
        if(i!=length-1&&(s.charAt(i-1)==' '||s.charAt(i-1)=='\n'))return  true;
        return i == 0;
    }
    private  int charCase4(String s,int i,int length) {
        if (charCase2(s, i, length)) {
            if(!(s.charAt(i+1)==' '|| Arrays.toString(chars).indexOf(s.charAt(i+1))!=-1)&&i!=0){
                return 3;
            }
            return 0;



        }
        else{
            if(i!=length-1&&i!=0&&(s.charAt(i+1)==' '|| Arrays.toString(chars).indexOf(s.charAt(i+1))!=-1))return  1;
            if(i==0)return 1;

            return 2;
        }


    }

    //////////////////////////////////////////////////////////////////////////

    private ArrayList<String> getUsbDevices(){
        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
        HashMap<String, UsbDevice> deviceList = manager.getDeviceList();
        ArrayList<String> devices = new ArrayList<>();
        for (Map.Entry<String, UsbDevice> set :
                deviceList.entrySet()) {

            // Printing all elements of a Map
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                String s = set.getValue().getProductName();
                String temp = set.getValue().getDeviceName();
                temp = temp.substring(temp.length()-7,temp.length()-4);
                if(!(s + "_" + temp).contains("eGalaxTouch")){
                    if (!(s + "_" + temp).contains("null_")) {
                        for(int i =0;i<devices.size();i++){
                            for(int j=0;j<devices.get(i).length();j++){
                                if((int)devices.get(i).charAt(j)==0){
                                    String locTemp = devices.get(i);
                                    locTemp = locTemp.substring(0,j) + locTemp.substring(j+1);
                                    devices.remove(i);
                                    devices.add(locTemp);
                                }
                            }
                        }
                        devices.add(s + "_" + temp);
                    } else {
                        devices.add("printer_" + temp);
                    }
                }
            }
        }
        System.out.println(devices);
        return devices;
    }

    private void linkPrinters(ArrayList<String> printersList){
        UsbManager manager = (UsbManager) getSystemService(Context.USB_SERVICE);
        HashMap<String, UsbDevice> deviceList = manager.getDeviceList();
        for (Map.Entry<String, UsbDevice> set :
                deviceList.entrySet()) {
            for (String s:
                    printersList) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    String temp = set.getValue().getDeviceName();
                    temp = temp.substring(temp.length()-7,temp.length()-4);
                    if(temp.equals("001")){
                        String portNum = set.getValue().getDeviceName().substring(set.getValue().getDeviceName().length()-3);
                        if(!portNum.equals("005")){
                            continue;
                        }
                    }
                    if(Objects.equals(s, temp)){
                        printersMap.put(s,set.getValue());
                    }
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    private void openCash(){
        try{
            Intent intent = new Intent("android.intent.action.CASHBOX");
            intent.putExtra("cashbox_open", true);
            sendBroadcast(intent);
        }catch (Exception e){
            e.printStackTrace();
        }
    }


    ///////////////////////////////////////////////////////////////////////////

    @SuppressLint("SdCardPath")
    private void createCopy(String path) throws IOException {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            try(OutputStream os = Files.newOutputStream(new File("/data/user/0/com.example.magicposbeta1/logo.jpg").toPath())) {


                Files.copy(Paths.get(path), os);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
    /////////////////////////////////////////////////////////////////////////
    private int usbWrite(byte[] writeBuffer, int offsetSize, int writeSize, int waitTime,UsbDeviceConnection usbDeviceConnection){
        int writed = 0;
        int copySize = 0;
        int allTransferSize = 0;

        int write;
        for(byte[] data = null; writeSize - writed - offsetSize > 0; allTransferSize += write) {
            int num = writeSize - writed - offsetSize;
            int writeTrueSize;
            if (num < 10240) {
                writeTrueSize = num;
                data = new byte[num];
            } else {
                writeTrueSize = 10240;
                if (data == null) {
                    data = new byte[writeTrueSize];
                }
            }

            System.arraycopy(writeBuffer, writed + offsetSize, data, 0, writeTrueSize);
            copySize += writeTrueSize;
            writed = copySize;
            write = usbDeviceConnection.bulkTransfer(endpoint, data, data.length, waitTime);
            Logger.i("write size" + write);
            if (write == -1) {
                Logger.e("传输失败");
                return -1;
            }
        }

        if (allTransferSize == writeSize - offsetSize) {
            Logger.i("已经全部传输完成 " + allTransferSize);
        } else {
            Logger.e("usb 数据传输缺失 已经传输" + allTransferSize + " 传输总数" + (writeSize - offsetSize));
        }

        return allTransferSize;
    }
    private UsbDeviceConnection setPrinter(String printerName) throws Exception {
        UsbDeviceConnection connection;

        UsbDevice device = printersMap.get(printerName);
        if(device==null){
            System.out.println("printerName : "+printerName);
            throw new Exception("الطابعة "+printerName+" غير متاحة حاليا");
        }
        System.out.println(device);

        UsbInterface intf = device.getInterface(0);
        endpoint = intf.getEndpoint(0);
        boolean forceClaim = true;
        connection = connectedPrinters.get(printerName);
        assert connection != null;
        connection.claimInterface(intf, forceClaim);
        return connection;
    }


    private String getPrinterPort(String printerName){
        if(printerName==null){
            return "";
        }
        printerName = printerName.substring(printerName.lastIndexOf("_")+1);
        return printerName;
    }
}


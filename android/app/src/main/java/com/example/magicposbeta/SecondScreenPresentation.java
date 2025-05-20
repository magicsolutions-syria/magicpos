package com.example.magicposbeta;
import android.app.Presentation;
import android.content.Context;
import android.os.Bundle;
import android.os.Looper;
import android.view.Display;
import android.widget.TextView;

public class SecondScreenPresentation extends Presentation {

    private TextView textView1;
    private TextView textView2;

    public SecondScreenPresentation(Context outerContext, Display display) {
        super(outerContext, display);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second_screen);

        // Initialize the TextViews
        textView1 = findViewById(R.id.textView1);
        textView2 = findViewById(R.id.textView2);
    }

    // Methods to update TextViews
    public void updateLabel1(String value) {
        textView1.post(() -> textView1.setText(value));
    }

    public void updateLabel2(String value) {
        textView2.post(() -> textView2.setText(value));
    }

}

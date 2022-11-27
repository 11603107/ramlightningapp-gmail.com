public class StopTrigerr {
    public static boolean run = true;
    
    public static boolean runonce(){
        if(run == true){
            run = false;
            return false;
        }else
        {
            return run;
        }
    }

}
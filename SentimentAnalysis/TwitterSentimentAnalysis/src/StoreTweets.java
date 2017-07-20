

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import javax.servlet.AsyncContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class StoreTweets
 */
@WebServlet(urlPatterns="/StoreTweets",asyncSupported=true)
public class StoreTweets extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StoreTweets() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String query = request.getParameter("hashtag");
		AsyncContext context = request.startAsync();
		
		//Queue<AsyncContext> jobQueue = new ConcurrentLinkedQueue<>();
		Executor executor = Executors.newFixedThreadPool(1);
		
		executor.execute(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				exec("/home/bijoyan/static_tweets.py",query,response);
			}
		});
		
	}
	
	
	private static void exec(String client,String query,HttpServletResponse response){
		ProcessBuilder pb = new ProcessBuilder("./spark-submit", client,query);
		pb.directory(new File("/home/bijoyan/Documents/Programs/spark-2.1.1-bin-hadoop2.7/bin"));
		Map<String, String> env = pb.environment();
		env.put("JAVA_HOME", "/home/bijoyan/Documents/Programs/jdk1.8.0_131");
		env.put("HADOOP_CONF_DIR", "/home/bijoyan/Documents/Hadoop/conf");
		env.put("CONDA_HOME", "/home/bijoyan/anaconda3");
		env.put("PYSPARK_DRIVER_PYTHON", "/home/bijoyan/anaconda3/bin/ipython");
		env.put("PYSPARK_PYTHON", "/home/bijoyan/anaconda3/bin/python3.6");
		Process p1;
		try {
			p1 = pb.start();
			StringBuffer sb = new StringBuffer();
		new Thread() {
			public void run() {
				InputStream in = p1.getInputStream();
				BufferedReader br = new BufferedReader(new InputStreamReader(in));
				String line;
				try {
					while ((line=br.readLine()) != null)
						sb.append(line+"<br>");
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					response.getWriter().println(sb.toString());
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					p1.waitFor();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}.start();
		
//		new Thread() {
//			public void run() {
//				InputStream in = p1.getErrorStream();
//				int ch;
//				try {
//					while ((ch = in.read()) != -1)
//				//		System.out.print((char)ch);
//						System.out.print((char)ch);
//				} catch (IOException e1) {
//					// TODO Auto-generated catch block
//					e1.printStackTrace();
//				}
//				try {
//					p1.waitFor();
//				} catch (InterruptedException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//			}
//		}.start();

		} catch (IOException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
	}

}

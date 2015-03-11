/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 *
 * @author g3t2
 */
package sloca.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import static sloca.controller.FileUpload.BUFFER;
import sloca.model.BootStrapManager;

/**
 *
 * to process updating of files
 */
public class fileUpdate extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods to process updating files
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {

            //Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();

            //Configure a repository to ensure a secure temp location
            //is used
            ServletContext servletContext
                    = this.getServletConfig().getServletContext();
            File repository = (File) servletContext.getAttribute(
                    "javax.servlet.context.tempdir");

            //Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            //Parse the reqeust
            List<FileItem> items = upload.parseRequest(request);
            //Process the uploaded items
            Iterator<FileItem> iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = iter.next();

                if (!item.isFormField()) {
                    InputStream is = item.getInputStream();

                    ZipInputStream zis
                            = new ZipInputStream(
                                    new BufferedInputStream(is));
                    ZipEntry ze;

                    while ((ze = zis.getNextEntry()) != null) {
                        String filePath
                                = repository + File.separator + ze.getName();
                        if (ze.getName().equals("demographics.csv")
                                | ze.getName().equals("location.csv")) {
                            // out.println("entered print if<br/>");
                            int count;
                            byte data[] = new byte[BUFFER];
                            FileOutputStream fos
                                    = new FileOutputStream(filePath);
                            BufferedOutputStream bos
                                    = new BufferedOutputStream(fos, BUFFER);
                            while ((count = zis.read(data, 0, BUFFER))
                                    != -1) {
                                bos.write(data, 0, count);
                            }
                            bos.flush();
                            bos.close();
                        }
                    }
                    zis.close();
                }
            }

            File[] files = new File(repository.toString()).listFiles();

            boolean isDemoInserted = false;
            boolean isLocInserted = false;

            boolean isDemoValidFile = false;
            boolean isLocValidFile = false;
            //check if zip files contain the any of the 3 data files
            for (File file : files) {

                String fileName = file.getName();
                if (fileName.contains("demographics.csv")) {
                    isDemoValidFile = true;
                } else if (fileName.contains("location.csv")) {
                    isLocValidFile = true;
                }
            }
            //if uploaded folder does not contain the files, it will go back to bootstrap.jsp
            if (!isDemoValidFile && !isLocValidFile) {

                request.setAttribute("fileUploadError", "Invalid .zip file");
                RequestDispatcher rd = request.getRequestDispatcher("adminDisplay.jsp");
                rd.forward(request, response);
                return;
            }
            //while all the files are not inserted
            BootStrapManager bm = new BootStrapManager();
            for (File file : files) {
                String fileName = file.getName();
                String filePath = repository + File.separator + fileName;
                //out.println("</br>" + filePath);
                BufferedReader br = null;
                try {
                    br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
                    br.readLine();
                    String line = null;
                    if (!isDemoInserted && fileName.contains("demographics.csv")) {
                        bm.updateDemo(filePath);
                        isDemoInserted = true;

                    }

                    if (!isLocInserted && fileName.contains("location.csv")) {
                        bm.updateLoc(filePath);
                        isLocInserted = true;
                    }

                    br.close();
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } finally {
                    if (br != null) {
                        br.close();
                    }
                }

                file.delete();
            }

//            out.println(
//                    "Size of Demographics errors: " + BootStrapManager.demoErrorList.size());
//            out.println(
//                    "Size of Location Lookup errors: " + BootStrapManager.locLookUpErrorList.size());
//            out.println(
//                    "Size of Location errors: " + BootStrapManager.locErrorList.size());
            response.sendRedirect("updateResults.jsp");
        } catch (FileUploadException e) {
            out.println("gone case");
        } finally {
            out.close();

        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

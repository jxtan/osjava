/*
 * Copyright (c) 2003, Henri Yandell
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or 
 * without modification, are permitted provided that the 
 * following conditions are met:
 * 
 * + Redistributions of source code must retain the above copyright notice, 
 *   this list of conditions and the following disclaimer.
 * 
 * + Redistributions in binary form must reproduce the above copyright notice, 
 *   this list of conditions and the following disclaimer in the documentation 
 *   and/or other materials provided with the distribution.
 * 
 * + Neither the name of Simple-JNDI nor the names of its contributors 
 *   may be used to endorse or promote products derived from this software 
 *   without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

/// TODO: Refactor this out
package org.osjava.jndi.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;

import java.util.Map;

public class PropertiesParser implements Parser {

    public synchronized void parse(InputStream in, Map map) throws IOException {
        try {
            BufferedReader reader = new BufferedReader( new InputStreamReader(in) );
            String line = "";
            String nextLine = null;
            while( (line = reader.readLine()) != null) {

                // we may already be on a multi-line statement.
                if(nextLine != null) {
                    line = nextLine + line;
                    nextLine = null;
                }

                line = line.trim();
                if(line.endsWith("\\")) {
                    nextLine = line;
                    continue;
                }

                int idx = line.indexOf('#');
                // remove comment
                if(idx != -1) {
                    line = line.substring(0,idx);
                }
                // split equals sign
                idx = line.indexOf('=');
                if(idx != -1) {
                    String key = line.substring(0, idx);
                    String value = line.substring(idx+1);
if(org.osjava.jndi.PropertiesContext.DEBUG) System.err.println("[PROPERTIES]Loading property: "+key+"="+value);
                    map.put(key, value);
                } else {
                    // blank line, or just a bad line
                    // we ignore it
                }
            }
            reader.close();
        } catch(IOException ioe) {
            ioe.printStackTrace();
        }
    }

}
 /******************************************************************************
 * libpixmpas.c: A Pixmap Lib for XdTV
 *******************************************************************************
 * $Id: lib-pixmaps.c,v 1.8 2006/06/11 11:08:09 pingus77 Exp $
 *****************************************************************************
 * Copyright (C) 2005 Nico
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
 *****************************************************************************/

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xmd.h>
#include <X11/keysym.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xatom.h>
#include <X11/Shell.h>
#include <X11/Xaw/XawInit.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Scrollbar.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Label.h>
#include <X11/xpm.h>

#include "all_pixmaps_headers.h"

static  Pixmap icon_pixmap, icon_shapemask;

void 
create_main_action_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , main_mainactions_xpm	   , &icon_pixmap ,  &icon_shapemask , NULL);
	 XtVaSetValues(c_main_actions, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , main_channelsoptions_xpm	   ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_channel_options, XtNbitmap, icon_pixmap, NULL); 
	 XpmCreatePixmapFromData(display, *d , main_openx11options_xpm	   ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_x11paramswin, XtNbitmap, icon_pixmap, NULL);	 
	 XpmCreatePixmapFromData(display, *d , main_openpluginoptions_xpm  ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_pluginwin, XtNbitmap, icon_pixmap, NULL); 	 
	 XpmCreatePixmapFromData(display, *d , main_openchanneleditor_xpm  ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_editorwin, XtNbitmap, icon_pixmap, NULL); 	 
	 XpmCreatePixmapFromData(display, *d , main_openmozaicchannels_xpm ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_chanwin, XtNbitmap, icon_pixmap, NULL);	 
	 XpmCreatePixmapFromData(display, *d , main_applysave_xpm	   ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_applysave, XtNbitmap, icon_pixmap, NULL); 	 
	 XpmCreatePixmapFromData(display, *d , main_quit_xpm		   ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_quit, XtNbitmap, icon_pixmap, NULL);   
}

// Editor
void 
create_editor_common_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , 	editor_RC_xpm       	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_rc, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_scantv_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_scantv, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_move_up_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_move_up, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_move_down_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_move_down, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_shortcuts_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_shortcuts, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_openmain_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_openmain, XtNbitmap, icon_pixmap, NULL);  
	 XpmCreatePixmapFromData(display, *d , 	editor_add_xpm	    	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_add, XtNbitmap, icon_pixmap, NULL);  
	 XpmCreatePixmapFromData(display, *d , 	editor_delete_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_delete, XtNbitmap, icon_pixmap, NULL);  
	 XpmCreatePixmapFromData(display, *d , 	editor_update_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_chan_update, XtNbitmap, icon_pixmap, NULL);  
	 XpmCreatePixmapFromData(display, *d , 	editor_save_xpm     	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_save, XtNbitmap, icon_pixmap, NULL);  
	 XpmCreatePixmapFromData(display, *d , 	editor_close_xpm    	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(last_command, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_channelnum_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(label_channelnum, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_choosehotkey_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(label_choosehotkey, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , 	editor_stationname_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(label_stationname, XtNbitmap, icon_pixmap, NULL);  
	
}

void 
create_editor_off_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , 	editor_fullscan_off_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_fullscan, XtNbitmap, icon_pixmap, NULL);
}

void 
create_editor_on_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , 	editor_fullscan_on_xpm   	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_fullscan, XtNbitmap, icon_pixmap, NULL);
}
void 
create_editor_dvb_pixmap (Display *display, Drawable* d) {

// DVB!!!!!!!!!!!!!!!!!!!!!!!!!!!
	 XpmCreatePixmapFromData(display, *d , 	editor_opendvbinit_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_chan_opendvbinit, XtNbitmap, icon_pixmap, NULL);  
}

// DVB!!!!!!!!!!!!!!!!!!!!!!!!!!!
void 
create_dvbinit_common_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , dvbinit_label_xpm       ,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_dvbinit_label, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , dvbinit_close_xpm       ,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_dvbinit_close, XtNbitmap, icon_pixmap, NULL);
	
}

void 
create_dvbinit_on_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , dvbinit_action_on_xpm       ,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_dvbinit_action, XtNbitmap, icon_pixmap, NULL);
	
}

void 
create_dvbinit_off_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , dvbinit_action_off_xpm       ,&icon_pixmap ,  &icon_shapemask , NULL );
  	 XtVaSetValues(c_dvbinit_action, XtNbitmap, icon_pixmap, NULL);
	
}
// END DVB !!!!!!!!!!!!!!!!!!!!!

void 
create_divx_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d ,video_filefmt_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_filefmt, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_choosecodec_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxvideocodec, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_codecaopt_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_codecaopt, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_videooptions_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxsize, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , video_otheroptions_xpm		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxdisplay, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_pathavi_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxpath, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_openaudiooptions_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxaudioopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_openstreamingoptions_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxstreamopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_openmainoptions_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues( c_divxopenmain, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_applysave_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxsave, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_browse_xpm 			,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxpath_selector, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_schedule_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxschedule, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,video_preview_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxplayer, XtNbitmap, icon_pixmap, NULL);
}

void 
create_xvid_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d ,xvid_me_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_me, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,xvid_profset_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_profset, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,xvid_quantizers_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_quantizers, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,xvid_otherset_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_otherset, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,xvid_videoopen_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_videoopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,xvid_quit_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_xvid_quit, XtNbitmap, icon_pixmap, NULL);
}

void 
create_ffmpeg_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d ,ffmpeg_me_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_me, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,ffmpeg_masking_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_masking, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,ffmpeg_quantizers_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_quantizers, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,ffmpeg_otherset_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_otherset, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,ffmpeg_videoopen_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_videoopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,ffmpeg_quit_xpm 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_ffmpeg_quit, XtNbitmap, icon_pixmap, NULL);
}

void 
create_divxaudio_pixmap (Display *display, Drawable* d) {
	
	 XpmCreatePixmapFromData(display, *d ,audio_audiooptions_xpm 		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxaudio, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,audio_mp3options_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxaudiomp3, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,audio_avoptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_divxaudiovideo, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,audio_openvideooptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_audiodivxopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,audio_openstreamingoptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_audiostreamopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , audio_openmainoptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_audioopenmain , XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,audio_applysave_xpm	 	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_audiosave, XtNbitmap, icon_pixmap, NULL);
}
void 
create_divxstream_common_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , stream_streamingoptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_stropts, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_choosehttpport_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_http_port, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_openmainoptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamopenmain, XtNbitmap, icon_pixmap, NULL);

	 XpmCreatePixmapFromData(display, *d ,stream_applysave_xpm ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamparamssave, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,stream_close_xpm ,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamparamsclose, XtNbitmap, icon_pixmap, NULL);
}

void 
create_divxstream_off_pixmap (Display *display, Drawable* d) {
	
	 XpmCreatePixmapFromData(display, *d , stream_startstreaming_off_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streaming, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_openvideooptions_off_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamdivxopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_openaudiooptions_off_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamaudioopen, XtNbitmap, icon_pixmap, NULL);

}

void 
create_divxstream_on_pixmap (Display *display, Drawable* d) {
	
	 XpmCreatePixmapFromData(display, *d , stream_startstreaming_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streaming, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_openvideooptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamdivxopen, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , stream_openaudiooptions_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streamaudioopen, XtNbitmap, icon_pixmap, NULL);

}

void 
create_divxstream_started_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , stream_startedstreaming_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streaming, XtNbitmap, icon_pixmap, NULL);

}

void 
create_divxstream_stopped_pixmap (Display *display, Drawable* d) {

	 XpmCreatePixmapFromData(display, *d , stream_stoppedstreaming_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_streaming, XtNbitmap, icon_pixmap, NULL);

}

void
create_fileselector_pixmap (Display *display, Drawable* d){

	 XpmCreatePixmapFromData(display, *d ,browse_file_xpm			,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(fileSelectorFilelabel, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,browse_folder_xpm			,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(fileSelectorDirlabel, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , browse_done_xpm			,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(fileSelectorDialogDone, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d , browse_cancel_xpm		,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(fileSelectorCancel, XtNbitmap, icon_pixmap, NULL);

}

void
create_fileselector_menu_pixmap (Display* disp_parent,Drawable* parent){
	
	 XpmCreatePixmapFromData(disp_parent, *parent ,browse_selector_xpm	,&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(*fileSelectorMenu, XtNbitmap, icon_pixmap, NULL);

}

void
create_alevt_pixmap (Display* display,Drawable* d){
	
	 XpmCreatePixmapFromData(display, *d,alevt_defaultpage_xpm,		&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_defaultpage, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,alevt_finetune_xpm,		&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_finetune, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,alevt_otheralevtparams_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_alevtparams, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,alevt_openmainoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_openalevt, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,alevt_startalevt_xpm,		&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_alevtaction, XtNbitmap, icon_pixmap, NULL);
	 XpmCreatePixmapFromData(display, *d ,alevt_applysave_xpm,		&icon_pixmap ,  &icon_shapemask , NULL );
	 XtVaSetValues(c_alevtparamssave, XtNbitmap, icon_pixmap, NULL);

}

void
create_grab_pixmap (Display* display,Drawable* d){
	
	XpmCreatePixmapFromData(display, *d ,grab_applysave_xpm ,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_grabquit, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,grab_graboptions_xpm ,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_grablabel, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,grab_grabimage_xpm ,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_grabpath, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,grab_browse_xpm ,		&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_grabpath_selector, XtNbitmap, icon_pixmap, NULL);

}

void
create_xosd_pixmap (Display* display,Drawable* d){
	
	XpmCreatePixmapFromData(display, *d ,xosd_openmainoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_xosdopenmain, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_commonxosdoptions_xpm,&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_xosd, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_mainxosdoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_mainxosd, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_vtxxosdoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_vtx, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_updmainxosd_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_test_main_xosd, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_updvtxxosd_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_test_vtx_xosd, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,xosd_applysave_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_xosdparamssave, XtNbitmap, icon_pixmap, NULL);

}

void
create_plugin_pixmap (Display* display,Drawable* d){
	
	XpmCreatePixmapFromData(display, *d ,plugin_quit_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_plugquit, XtNbitmap, icon_pixmap, NULL);
}

void
create_x11_pixmap (Display* display,Drawable* d){
	
	XpmCreatePixmapFromData(display, *d ,x11_x11options_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_x11, XtNbitmap, icon_pixmap, NULL);
	XpmCreatePixmapFromData(display, *d ,x11_wmoffby_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_wmoffby, XtNbitmap, icon_pixmap, NULL); 
	XpmCreatePixmapFromData(display, *d ,x11_pixsize_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_pixmaps_size, XtNbitmap, icon_pixmap, NULL);   
	XpmCreatePixmapFromData(display, *d ,x11_xvcolorkeyinfo_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_xv_info, XtNbitmap, icon_pixmap, NULL);  
	XpmCreatePixmapFromData(display, *d ,x11_capwidthheight_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_gframes, XtNbitmap, icon_pixmap, NULL);    
	XpmCreatePixmapFromData(display, *d ,x11_chooseblackborder_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_blackborders, XtNbitmap, icon_pixmap, NULL);    
	XpmCreatePixmapFromData(display, *d ,x11_openmainoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_x11openmain, XtNbitmap, icon_pixmap, NULL);        
	XpmCreatePixmapFromData(display, *d ,x11_applysave_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(c_x11paramssave, XtNbitmap, icon_pixmap, NULL);   
}

void
create_popup_pixmap (Display* display,Drawable* d){
	XpmCreatePixmapFromData(display, *d ,popup_infos_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(errorPopdown, XtNbitmap, icon_pixmap, NULL);   
}
	
void
create_help_pixmap (Display* display,Drawable* d){

	XpmCreatePixmapFromData(display, *d ,popup_help_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
	XtVaSetValues(popup_ok, XtNbitmap, icon_pixmap, NULL);   
}
	
void
create_subtitle_pixmap (Display* display,Drawable* d){

  XpmCreatePixmapFromData(display, *d ,sub_pagenum_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
  XtVaSetValues(c_subpagenum, XtNbitmap, icon_pixmap, NULL);   
  XpmCreatePixmapFromData(display, *d ,sub_openmainoptions_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
  XtVaSetValues(c_subopenmain, XtNbitmap, icon_pixmap, NULL);    
  XpmCreatePixmapFromData(display, *d ,sub_applysave_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
  XtVaSetValues(c_subsave, XtNbitmap, icon_pixmap, NULL);
  XpmCreatePixmapFromData(display, *d ,sub_startsub_xpm,	&icon_pixmap ,  &icon_shapemask , NULL );
  XtVaSetValues(c_subtitles, XtNbitmap, icon_pixmap, NULL);   
	
}
